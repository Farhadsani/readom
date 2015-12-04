//
//  TopicController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/31.
//
//
/*
 *[话题]页面
 *功能：显示话题列表、进入地图
 */

#import "TopicController.h"
#import "TopicCell.h"
#import "TopicBanner.h"
#import "PersonalTopicViewController.h"
#import "CollectCell.h"
#import "UserBriefItem.h"
#import "MJRefresh.h"

@interface TopicController () <UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic, assign) long userid;
@property (nonatomic, strong) NSMutableArray *topicItems;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, weak) TopicBanner *topicBanner;
@end

@implementation TopicController
- (NSMutableArray *)topicItems
{
    if (!_topicItems) {
        _topicItems = [NSMutableArray array];
    }
    return _topicItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"话题";
    [self setupLeftBackButtonItem:nil img:@"topic_backhome.png" action:nil];
    [self setupRightBackButtonItem:nil img:@"topic_location.png" del:self sel:@selector(locationBtnOnClick)];
    
    [self setupTableView];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)locationBtnOnClick{
    [self showLoading];
    [self performSelector:@selector(jumpToMap) withObject:nil afterDelay:0.1];
}

- (void)jumpToMap{
    [self toMap];
    [self baseDeckAndNavBack];
    [self hidLoading];
}

- (void)showLoading{
    [[LoadingView shared] setIsFullScreen:YES];
    [[LoadingView shared] showLoading:@"2" message:@"正在加载地图..."];
}
- (void)hidLoading{
    [[LoadingView shared] hideLoading];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf1f1f1, 1.0f);
    
    float bannerHeight = self.contentView.frame.size.width / 2;
    TopicBanner *topicBanner = [[TopicBanner alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, bannerHeight)];
    self.topicBanner = topicBanner;
    tableView.tableHeaderView = topicBanner;
    topicBanner.delegate = self;
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}

- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if (self.topicItems.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.topicItems.count+1 limit:LIMIT];
}

/**
 *  获取网络数据（topic列表、topic热门）
 */
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"begin": @(begin),
                              @"limit": @(limit),
                              @"provid": @(0)};
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_topic_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
    
    params = @{@"provid": @(0)};
    d = @{k_r_url:k_api_topic_hot,
          k_r_delegate:self,
          k_r_postData:dict,
          k_r_loading:num(0),
          };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - 网络请求处理
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    NSArray *res = [result objectForKey:@"res"];
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.topicItems removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        for (NSDictionary * itemDict in res){
            TopicItem *item = [[TopicItem alloc] init];
            item.topicid = [[itemDict objectForKey:@"topicid"] longValue];
            item.title = [itemDict objectForKey:@"title"];
            item.summary = [itemDict objectForKey:@"summary"];
            item.hot = [[itemDict objectForKey:@"hot"] intValue];
            item.provid = [[itemDict objectForKey:@"provid"] intValue];
            item.cityid = [[itemDict objectForKey:@"cityid"] intValue];
            item.channel = [itemDict objectForKey:@"channel"];
            item.imglink = [itemDict objectForKey:@"imglink"];
            item.ctime = [itemDict objectForKey:@"ctime"];
            item.liked = [[itemDict objectForKey:@"liked"] boolValue];
            [self.topicItems addObject:item];
        }
        [self.tableView reloadData];
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_hot]) {
        self.topicBanner.dicts = res;
        [self.topicBanner openTimer];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }

        InfoLog(@"error:%@", error);
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_hot]) {
        InfoLog(@"error:%@", error);
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [TopicCell cellForTableView:tableView];
    cell.topicItem = self.topicItems[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicItem *topicItem = self.topicItems[indexPath.row];
    CollectItem *item = [[CollectItem alloc] init];
    item.topicID = [NSString stringWithFormat:@"%ld", topicItem.topicid];
    item.optype = @"topic_like";
    
    CollectCell *cell = [[CollectCell alloc] init];
    cell.dataItem = item;
    
    PersonalTopicViewController* vc = [[PersonalTopicViewController alloc] init];
    [vc.data_dict setNonEmptyObject:cell forKey:@"CollectCell"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 基本设置
- (void)setUserData:(long)userID
{
    self.userid = userID;
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender
{
    [[LoadingView shared] showLoading:@"2" message:@"正在加载个人中心..."];
    
    [self performSelector:@selector(jumpToCocos) withObject:nil afterDelay:0.1];
    
//    UserBriefItem *brief = [UserManager sharedInstance].brief;
//    [self toCocos:self.userid :brief.name :brief.intro :brief.zone :brief.thumblink :brief.imglink];
//    
//    [self baseDeckAndNavBack];
}

- (void)jumpToCocos
{
    UserBriefItem *brief = [UserManager sharedInstance].brief;
    [self toCocos:self.userid :brief.name :brief.intro :brief.zone :brief.thumblink :brief.imglink];
    [self baseDeckAndNavBack];
    [self hidLoading];
}

#pragma mark - TopicBannerDelegate
- (void)topicBanner:(TopicBanner *)banner didOnClick:(NSString *)topicID
{
    CollectItem *item = [[CollectItem alloc] init];
    item.topicID = topicID;
    item.optype = @"topic_like";
    
    CollectCell *cell = [[CollectCell alloc] init];
    cell.dataItem = item;
    
    PersonalTopicViewController* vc = [[PersonalTopicViewController alloc] init];
    [vc.data_dict setNonEmptyObject:cell forKey:@"CollectCell"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
