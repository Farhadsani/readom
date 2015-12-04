//
//  StateNearbyViewController.m
//  citystate
//
//  Created by hf on 15/10/10.
//
//

#import "StateNearbyViewController.h"
#import "BuddyStatusCell.h"
#import "AFNetworking.h"
#import "TagItem.h"
#import "BuddyStatusNoteItemFrame.h"
#import "MJRefresh.h"
#import "BuddyItem.h"
#import "CocosViewController.h"
#import "BuddyStatusCommentsViewController.h"

@interface StateNearbyViewController ()<UITableViewDataSource, UITableViewDelegate, BuddyStatusCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *buddyStatusNoteItemFrame;
@end

@implementation StateNearbyViewController
- (NSMutableArray *)buddyStatusNoteItemFrame
{
    if (!_buddyStatusNoteItemFrame) {
        _buddyStatusNoteItemFrame = [NSMutableArray array];
    }
    return _buddyStatusNoteItemFrame;
}

#pragma mark - life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMainView];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_nearby_list]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.buddyStatusNoteItemFrame removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self handle:dict];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_nearby_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"附近没有相关动态",
                            k_ListCount:num(self.buddyStatusNoteItemFrame.count),
                            }];
    }
}

- (void)handle:(NSDictionary *)dict
{
    NSArray *res = [dict objectForKey:@"res"];
    for (NSDictionary *itemDict in res){
        BuddyStatusNoteItem *item = [[BuddyStatusNoteItem alloc] init];
        item.feedid = [[itemDict objectForKey:@"feedid"] longValue];
        item.ctime = [itemDict objectForKey:@"ctime"];
        item.liked = [[itemDict objectForKey:@"liked"] boolValue];
        item.like_count = [[itemDict objectForKey:@"likecount"] intValue];
        item.commented = [[itemDict objectForKey:@"commented"] boolValue];
        item.comments_count = [[itemDict objectForKey:@"commentscount"] intValue];
        item.content = [itemDict objectForKey:@"content"];
        
        NSArray *imgArr = [itemDict objectForKey:@"imglink"];
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
        user.type = [[userDic objectForKey:@"type"] intValue];

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
        [self.buddyStatusNoteItemFrame addObject:noteItemFrame];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [self showTipView:@{k_ToView:self.tableView,
                        k_ShowMsg:@"附近没有相关动态",
                        k_ListCount:num([self.buddyStatusNoteItemFrame count]),
                        }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buddyStatusNoteItemFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusCell *cell = [BuddyStatusCell cellForTableView:tableView];
    BuddyStatusNoteItemFrame *noteItemFrame = self.buddyStatusNoteItemFrame[indexPath.row];
    cell.noteItemFrame = noteItemFrame;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusNoteItemFrame *noteItemFrame = self.buddyStatusNoteItemFrame[indexPath.row];
    return noteItemFrame.cellHeight;
}

#pragma mark - BuddyStatusCellDelegate
- (void)buddyStatusCell:(BuddyStatusCell *)cell userIconBtnDidOnClick:(UIButton *)button
{
    BuddyStatusUser *user = cell.noteItemFrame.noteItem.user;
    
    BuddyItem *buddyItem = [BuddyItem buddyItemWithBuddyStatusUser:user];
    //跳转到有Cocos个人中心页面，需要先调用该函数刷新数据
    [self toCocos:buddyItem.userid :buddyItem.name :buddyItem.intro :buddyItem.zone :buddyItem.thumblink :buddyItem.imglink];
    //再push到viewController
    CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
    vc.userid = user.userid;
    vc.buddyItem = buddyItem;
    [[CocosManager shared] addCocosMapView:vc];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - init & dealloc
- (void)setupMainView
{
    self.title = @"附近动态";
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}

- (void)buddyStatusCellrequestComment:(NSInteger)feedid
{
    BuddyStatusCommentsViewController *buddyStatusCommentsViewController = [[BuddyStatusCommentsViewController alloc] init];
    buddyStatusCommentsViewController.feedid = feedid;
    buddyStatusCommentsViewController.backBlk = ^(long fid) {
        for (int i = 0; i < self.buddyStatusNoteItemFrame.count; i++) {
            BuddyStatusNoteItem *item = ((BuddyStatusNoteItemFrame *)(self.buddyStatusNoteItemFrame[i])).noteItem;
            if (item.feedid == fid) {
                item.commented = YES;
                item.comments_count++;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    };
    [self.navigationController pushViewController:buddyStatusCommentsViewController animated:YES];
}

#pragma mark - other method
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if (self.buddyStatusNoteItemFrame.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.buddyStatusNoteItemFrame.count limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"begin": @(begin),
                              @"limit": @(limit),
                              @"lat":  @([UserManager sharedInstance].pt.latitude),
                              @"lng": @([UserManager sharedInstance].pt.longitude),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_feed_nearby_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}
@end
