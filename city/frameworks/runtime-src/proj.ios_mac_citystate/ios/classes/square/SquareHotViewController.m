//
//  SquareHotViewController.m
//  citystate
//
//  Created by 石头人工作室 on 15/10/22.
//
//

#import "SquareHotViewController.h"
#import "MJRefresh.h"
#import "BuddyStatusCell.h"
#import "TagItem.h"

@interface SquareHotViewController () <UITableViewDataSource, UITableViewDelegate, BuddyStatusCellDelegate>
@property (nonatomic, assign) int netIndex;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, retain) NSMutableArray *noteItemFrames;
@end

@implementation SquareHotViewController

- (void)variableInit{
    [super variableInit];
//    _netAddr = @[k_api_user_feed_buddy, k_api_user_feed_buddy];
    
    self.hasLeftNavBackButton = NO;
    _noteItemFrames = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor redColor];
//    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat space = (self.hidTabbarBar)?0:49;
    tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-space-40-64);
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - action
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if (_noteItemFrames.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:_noteItemFrames.count+1 limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    long userid = 20000017;
    NSDictionary * params = @{@"userid":@(userid),
                              @"begin": @(begin),
                              @"limit": @(limit)
                              };
    NSDictionary * dict = @{@"idx":str((++self.netIndex)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_buddy,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    //    [SquareDataManager allHotNoteItemFrames];
    if ( ((NSNumber*)[req.data_dict objectOutForKey:k_r_postData][@"params"][@"userid"]).intValue == 20000017) {
        //    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_buddy]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [_noteItemFrames removeAllObjects ];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self handle:dict CurIndex:0];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_buddy]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"没有找到热门的信息",
                            k_ListCount:num([_noteItemFrames count]),
                            }];
    }
}

- (void)handle:(NSDictionary *)dict CurIndex:(int)index
{
    //    [SquareDataManager allHotNoteItemFrames];
    NSArray *res = [dict objectForKey:@"res"];
    for (NSDictionary *itemDict in res){
        BuddyStatusNoteItem *item = [[BuddyStatusNoteItem alloc] init];
        item.feedid = [[itemDict objectForKey:@"feedid"] longValue];
        item.ctime = [itemDict objectForKey:@"ctime"];
        item.liked = [[itemDict objectForKey:@"liked"] boolValue];
        item.like_count = [[itemDict objectForKey:@"like_count"] intValue];
        item.commented = [[itemDict objectForKey:@"commented"] boolValue];
        item.comments_count = [[itemDict objectForKey:@"comments_count"] intValue];
        item.content = [itemDict objectForKey:@"content"];
        
        
        NSArray *imgArr = [itemDict objectForKey:@"imgs"];
        NSMutableArray *imgs = [NSMutableArray array];
        for (NSString *img in imgArr) {
            [imgs addObject:img];
        }
        item.imgs = [imgs copy];
        
        NSDictionary *userDic = [itemDict objectForKey:@"user"];
        BuddyStatusUser *user = [[BuddyStatusUser alloc] init];
        user.userid = [[userDic objectForKey:@"userid"] longValue];
        user.name = [userDic objectForKey:@"name"];
        user.intro = [userDic objectForKey:@"intro"];
        user.imglink = [userDic objectForKey:@"imglink"];
        user.thumblink = [userDic objectForKey:@"thumblink"];
        item.user = user;
        NSArray *tagArr = [itemDict objectForKey:@"tags"];
        NSMutableArray *tags = [NSMutableArray array];
        for (NSString *tagOne in tagArr) {
            TagItem *tagItem = [[TagItem alloc] init];
            tagItem.text = tagOne;
            [tags addObject:tagItem];
        }
        item.tags = tags;
        
        NSArray *placeArr = [itemDict objectForKey:@"place"];
        NSMutableArray *places = [NSMutableArray array];
        for (NSString *placeOne in placeArr) {
            TagItem *placeItem = [[TagItem alloc] init];
            placeItem.text = placeOne;
            [places addObject:placeItem];
        }
        item.place = places;
        
        BuddyStatusNoteItemFrame *noteItemFrame = [[BuddyStatusNoteItemFrame alloc] init];
        noteItemFrame.noteItem = item;
        [_noteItemFrames addObject:noteItemFrame];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_noteItemFrames.count > 0) {
            [self.tableView reloadData];
        } else {
        }
    });
    
    [self showTipView:@{k_ToView:self.tableView,
                        k_ShowMsg:@"没有好友真可怕~\n您可以在主页“出访”中关注您喜欢的",
                        k_ListCount:num([_noteItemFrames count]),
                        }];
    
    
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noteItemFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    BuddyStatusCell *cell = [BuddyStatusCell cellForTableView:tableView];
    BuddyStatusNoteItemFrame *noteItemFrame = _noteItemFrames[indexPath.row];
    cell.noteItemFrame = noteItemFrame;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusNoteItemFrame *noteItemFrame = _noteItemFrames[indexPath.row];
    return noteItemFrame.cellHeight;
}

#pragma mark - BuddyStatusCellDelegate
- (void)buddyStatusCell:(BuddyStatusCell *)cell userIconBtnDidOnClick:(UIButton *)button
{
    BuddyStatusUser *user = cell.noteItemFrame.noteItem.user;
    [self baseDeckBack];
    [self toCocos:user.userid :user.name :user.intro :nil :user.thumblink :user.imglink ];
}

@end
