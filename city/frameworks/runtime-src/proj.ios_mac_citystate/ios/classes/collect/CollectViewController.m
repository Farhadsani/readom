//
//  CollectViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/6.
//
//

/*
 *【个人动态】界面
 *功能：展示【个人动态】列表、查看话题
 * 编辑内容：隐藏、显示
 */

#import "CollectViewController.h"
#import "PersonalTopicViewController.h"
#import "MJRefresh.h"
#import "TitleBar.h"
#import "TagItem.h"
#import "BuddyStatusCommentsViewController.h"
#import "BuddyItem.h"
#import "CocosViewController.h"

@interface CollectViewController ()<TitleBarDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, strong) TitleBar *titleBar;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UserBriefItem *userBriefItem;
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, copy) NSString *selectedUrl;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, strong) NSMutableArray *requestFollowList;
@property (nonatomic, strong) NSMutableArray *requestfansList;
@end

@implementation CollectViewController
- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"个人", @"已赞"];
    }
    return _titles;
}

- (NSMutableArray *)requestFollowList{
    if (!_requestFollowList) {
        _requestFollowList = [NSMutableArray array];
    }
    return _requestFollowList;
}

- (NSMutableArray *)requestfansList{
    if (!_requestfansList) {
        _requestfansList =[NSMutableArray array];
    }
    return _requestfansList;
}

#pragma mark - life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupMainView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cellUserZone:(NSNotification *)notification{
    CollectCell *cell = notification.userInfo[@"cell"];
    CollectItem *item = cell.dataItem;
    BuddyItem *buddyItem = [[BuddyItem alloc] init];
    buddyItem.userid = item.userid;
    if (![[UserManager sharedInstance] isCurrentUser:item.userid]) {
        buddyItem.imglink = item.imglink;
        buddyItem.name =  item.name;
        buddyItem.intro = item.name;
        buddyItem.type = item.type;
        
        [self toCocos:buddyItem.userid :buddyItem.name:buddyItem.intro :buddyItem.zone :buddyItem.imglink :buddyItem.imglink ];
        CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
        vc.userid = buddyItem.userid;
        vc.buddyItem = buddyItem;
        [[CocosManager shared] addCocosMapView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_user_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.requestFollowList removeAllObjects];
        }
        else {
            [self.tableView footerEndRefreshing];
        }
        [self.requestFollowList addObjectsFromArray:[self dicts2Models:dicts]];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.requestfansList removeAllObjects];
        }
        else {
            [self.tableView footerEndRefreshing];
        }
        [self.requestfansList addObjectsFromArray:[self dicts2Models:dicts]];
    }
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.selectedUrl]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"没有相关动态",
                                k_ListCount:num(self.tableArr.count),
                                }];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_user_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        NSLog(@"获取关注用户动态失败");
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        NSLog(@"获取粉丝用户动态失败");
    }
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.selectedUrl]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"没有相关动态",
                                k_ListCount:num(self.tableArr.count),
                                }];
        });
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self showTipView:@{k_ToView:self.tableView,
                        k_ShowMsg:@"没有相关动态",
                        k_ListCount:num(self.tableArr.count),
                        }];
    return self.tableArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell"];
    
    cell.contentView.backgroundColor = [UIColor color:k_defaultViewControllerBGColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userid = self.userid;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor color:white_color];
    
    cell.canEdit = NO;
    cell.delegate = self;
    CollectItem * item = [_tableArr objectAtExistIndex:indexPath.row];
    [cell setupUI:item frmae:CGRectZero];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CollectCell cellHeightWith:_tableArr[indexPath.row]];
}

#pragma mark - TitleBarDelegate
- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index{
    if (index == 0) {
        self.tableArr = self.requestFollowList;
        self.selectedUrl = k_api_feed_user_list;
    } else if (index == 1) {
        self.tableArr = self.requestfansList;
        self.selectedUrl = k_api_feed_like_list;
    }
    if (self.tableArr.count != 0) {
        [self.tableView reloadData];
    } else {
        [self loadNew];
    }
}

#pragma mark - init & dealloc
- (void)setupMainView{
    self.title = @"个人动态";
    
    TitleBar *titleBar = [TitleBar titleBarWithTitles:self.titles andShowCount:self.titles.count];
    self.titleBar = titleBar;
    [self.contentView addSubview:titleBar];
    titleBar.frame = CGRectMake(0, 0, self.view.width, 40);
    titleBar.delegate = self;
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame =  CGRectMake(0, 40, self.contentView.width, self.contentView.height- 40);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    [self.tableView registerClass:[CollectCell class] forCellReuseIdentifier:@"CollectCell"];
    self.selectedUrl = k_api_feed_user_list;
    self.tableArr = self.requestFollowList;
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentDidOnClick:) name:BuddyStatusToolBarCommentDidOnClick object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cellUserZone:) name:@"CollectCell" object:nil];
}
- (NSArray *)dicts2Models:(NSArray *)dicts
{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in dicts){
        CollectItem *collectItem = [[CollectItem alloc] init];
        collectItem.userid = [dict[@"userid"] integerValue];
        collectItem.imglink = dict[@"user"][@"imglink"];
        collectItem.name = dict[@"user"][@"name"];
        collectItem.imglinkArr = dict[@"imglink"];
        collectItem.type = [dict[@"user"][@"type"]longValue];
        collectItem.feedid = [dict[@"feedid"]integerValue];
        collectItem.ctime = dict[@"ctime"];
        NSArray *tagArr = [dict objectForKey:@"tags"];
        NSMutableArray *tags = [NSMutableArray array];
        for (NSString *tagOne in tagArr) {
            TagItem *tagItem = [[TagItem alloc] init];
            tagItem.text = tagOne;
            [tags addObject:tagItem];
        }
        collectItem.tags = tags;
        collectItem.content = dict[@"content"];
        collectItem.liked = [dict[@"liked"]longValue];
        collectItem.likecount = [dict[@"likecount"]longValue];
        collectItem.commented = [dict[@"commented"]longValue];
        collectItem.commentscount = [dict[@"commentscount"]longValue];
        collectItem.areaid = [dict[@"areaid"]longValue];
        NSArray *placeArr = [dict objectForKey:@"place"];
        NSMutableArray *places = [NSMutableArray array];
        for (NSString *placeOne in placeArr) {
            TagItem *placeItem = [[TagItem alloc] init];
            placeItem.text = placeOne;
            [places addObject:placeItem];
        }
        collectItem.place = places;
        [models addObject:collectItem];
    }
    return models;
}

#pragma mark - other method
- (void)loadNew{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore{
    if (self.tableArr.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.tableArr.count limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit{
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        self.userBriefItem = [UserManager sharedInstance].brief;
    }
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",self.userid],
                              @"begin": @(begin),
                              @"limit": @(limit),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:self.selectedUrl,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}
- (void)commentDidOnClick:(NSNotification *)notification
{
    if (self == self.navigationController.childViewControllers.lastObject) {
        long feeid = [notification.userInfo[BuddyStatusToolBarCommentDidOnClickFeedid] longValue];
        
        BuddyStatusCommentsViewController *buddyStatusCommentsViewController = [[BuddyStatusCommentsViewController alloc] init];
        buddyStatusCommentsViewController.feedid = feeid;
        buddyStatusCommentsViewController.backBlk = ^(long fid) {
            for (int i = 0; i < self.tableArr.count; i++) {
                CollectItem *item = self.tableArr[i];
                if (item.feedid == fid) {
                    item.commented = YES;
                    item.commentscount++;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                }
            }
        };
        [self.navigationController pushViewController:buddyStatusCommentsViewController animated:YES];
    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self backUserHome:0];
}

@end
