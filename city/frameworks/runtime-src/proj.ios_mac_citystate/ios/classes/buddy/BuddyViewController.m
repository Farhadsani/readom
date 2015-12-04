//
//  BuddyViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

/*
 *【出访】界面
 *功能：查看[粉丝]、[关注]、[广场]的用户信息。
 *关注好友、取消关注好友、粉丝好友、查看好友个人空间
 *
 */
#import "BuddyViewController.h"
#import "MJRefresh.h"
#import "CocosManager.h"
#import "CocosViewController.h"
#import "UserBaseItem.h"
#import "UserBaseInfoController.h"
#import "SearchViewController.h"

@interface BuddyViewController ()<UISearchBarDelegate>{
    UIView * userBuddyView;
    BuddyManager *buddyManager;
    
    UINavigationItem *_selfNavigationItem;
    SearchViewController *_searchVC;
}
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

@implementation BuddyViewController
@synthesize buddyManager = buddyManager;
- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"关注", @"粉丝"];
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

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfollow]) {
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
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfans]) {
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
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        NSNumber *index = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"index"];
        BuddyItem *item =  _tableArr[[index integerValue]];
        if (self.requestfansList == self.tableArr) {
            item.type = 2;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[index integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            BuddyItem *item =  _tableArr[[index integerValue]];
            item.type = 0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[index integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [MessageView showMessageView:@"已取消关注" delayTime:2.0];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        NSNumber *index = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"index"];
        BuddyItem *item =  _tableArr[[index integerValue]];
        item.type = 3;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[index integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [MessageView showMessageView:@"已关注" delayTime:2.0];
    }
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.selectedUrl]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"没有相关好友",
                                k_ListCount:num(self.tableArr.count),
                                }];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfollow]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfans]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        NSLog(@"取消用户失败");
        
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        NSLog(@"关注用户失败");
        
    }
    
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.selectedUrl]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"没有相关好友",
                                k_ListCount:num(self.tableArr.count),
                                }];
        });
    }
}

- (void)setUserData:(long)userID :(NSString*) name :(NSString*)intro : (NSString*)zonename : (NSString*)thumblink : (NSString*)imglink{
    
    buddyManager.mainUser.userid = userID;
    buddyManager.mainUser.name = name;
    buddyManager.mainUser.intro = intro;
    buddyManager.mainUser.zone = zonename;
    buddyManager.mainUser.thumblink = thumblink;
    buddyManager.mainUser.imglink = imglink;
}

- (NSArray *)dicts2Models:(NSArray *)dicts
{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in dicts){
        BuddyItem *buddyItem = [[BuddyItem alloc] init];
        buddyItem.userid = [dict[@"userid"] integerValue];
        buddyItem.imglink = dict[@"imglink"];
        buddyItem.name = dict[@"name"];
        buddyItem.intro = dict[@"intro"];
        buddyItem.type = [dict[@"type"]longValue];
        [models addObject:buddyItem];
    }
    return models;
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self showTipView:@{k_ToView:self.tableView,
                        k_ShowMsg:@"没有相关动态",
                        k_ListCount:num(self.tableArr.count),
                        }];
    
    return self.tableArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuddyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyCell"];
    if (cell == nil) {
        cell = [[BuddyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BuddyCell"];
    }
    CGFloat h = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.frame = CGRectMake(0, 0, tableView.width, h);
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    if (_tableArr != nil)
    {
        BuddyItem * item = [_tableArr objectAtExistIndex:indexPath.row];
        cell.delegate = self;
        [cell start:item : indexPath.row];
    }
    UIView *line1 = [cell viewWithTag:9999];
    UIView *line2 = [cell viewWithTag:9998];
    [line1 removeFromSuperview];
    [line2 removeFromSuperview];
    if (indexPath.row == (_tableArr.count ==0 ) ) {
        UIView * line =  [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Height:@0.5,
                                            V_BGColor:k_defaultLineColor,
                                            }];
        line.tag = 9999;
        [cell.contentView addSubview:line];
    }
    if (_tableArr.count -1 == indexPath.row ) {
        UIView * line =  [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Margin_Top:@50,
                                            V_Height:@0.5,
                                            V_BGColor:k_defaultLineColor,
                                            }];
        line.tag = 9998;
        [cell.contentView addSubview:line];
    }
    return cell;
}

#pragma mark - BuddyStatusCellDelegate
-(void)tableView:(UITableView *)TableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[TableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    BuddyItem *item =  [_tableArr objectAtExistIndex:indexPath.row];
    if (item && item.userid && [[UserManager sharedInstance] isCurrentUser:item.userid]) {
        return;
    }
    //跳转到有Cocos个人中心页面，需要先调用该函数刷新数据
    [self toCocos:item.userid :item.name :item.intro :item.zone :item.thumblink :item.imglink ];
    
    //再push到viewController
    CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
    vc.userid = item.userid;
    vc.buddyItem = item;
    [[CocosManager shared] addCocosMapView:vc];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma cell的处理
- (void)BuddyCell:(BuddyCell *)cell onRelationShip:(long)index{
    InfoLog(@"listView  ..%ld", index);
    
    BuddyItem *item =  [_tableArr objectAtExistIndex:index];
    
    NSDictionary * params = @{@"userid":@(item.userid),
                              @"index":@(index),
                              };
    NSDictionary * dict = @{@"idx":params,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_follow,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
    
}

- (void)BuddyCell:(BuddyCell *)cell onUnRelationShip:(long)index{
    InfoLog(@"listView  ..%ld", index);
    
    BuddyItem *item =  [_tableArr objectAtExistIndex:index];
    NSDictionary * params = @{@"userid":@(item.userid),
                              @"index":@(index),
                              };
    NSDictionary * dict = @{@"idx":params,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_unfollow,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
    
}

#pragma mark - TitleBarDelegate
- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index{
    if (index == 0) {
        [self.requestfansList removeAllObjects];
        self.tableArr = self.requestFollowList;
        self.selectedUrl = k_api_user_getfollow;
    } else if (index == 1) {
        [self.requestFollowList removeAllObjects];
        self.tableArr = self.requestfansList;
        self.selectedUrl = k_api_user_getfans;
    }
    if (self.tableArr.count != 0) {
        [self.tableView reloadData];
    } else {
        [self loadNew];
    }
}


#pragma mark - init & dealloc
- (void)setupMainView{
    self.title = @"好友关系";
//    [self setupRightBackButtonItem:nil img:@"search_bar" del:self sel:@selector(searchAction:)];
    
    TitleBar *titleBar = [TitleBar titleBarWithTitles:self.titles andShowCount:self.titles.count];
    self.titleBar = titleBar;
    [self.contentView addSubview:titleBar];
    titleBar.frame = CGRectMake(0, 0, self.view.width, 40);
    titleBar.delegate = self;
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame =  CGRectMake(0, 40, self.contentView.width, self.contentView.height - 40);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    self.selectedUrl = k_api_user_getfollow;
    self.tableArr = self.requestFollowList;
    
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        self.userBriefItem = [UserManager sharedInstance].brief;
    }
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
    
    
}

#pragma mark - searchBar
- (void)searchAction:(UIButton *)button{
    self.navigationItem.hidesBackButton = YES;
    if (_selfNavigationItem == nil) {
        _selfNavigationItem = [[UINavigationItem alloc] init];
        [self itemCopy:self.navigationItem item2:_selfNavigationItem];
    }
    
    SearchViewController *vc = [[SearchViewController alloc] init];
    [vc setUserData:self.userid];
    _searchVC = vc;
    __block BuddyViewController *weakSelf = self;
    [vc setCancel:^{
        __strong BuddyViewController *strongSelf = weakSelf;
        [strongSelf itemCopy:strongSelf->_selfNavigationItem item2:strongSelf.navigationItem];
        [strongSelf->_searchVC.view removeFromSuperview];
    }];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [self.view addSubview:vc.view];
    self.hasLeftNavBackButton = YES;
    [self itemCopy:vc.navigationItem item2:self.navigationItem];
    self.navigationItem.leftBarButtonItem = nil;
    
}
- (void)itemCopy:(UINavigationItem *)item1 item2:(UINavigationItem *)item2 {
    item2.title = item1.title;
    
    item2.leftBarButtonItem = item1.leftBarButtonItem;
    item2.rightBarButtonItem = item1.rightBarButtonItem;
    item2.rightBarButtonItems = item1.rightBarButtonItems;
    item2.rightBarButtonItems = item1.rightBarButtonItems;
    item2.titleView = item1.titleView;
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
                              @"begin":@(begin),
                              @"limit":@(limit),
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

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self backUserHome:0];
}

#pragma init alloc
- (id)init {
    self = [super init];
    if (self) {
        buddyManager = [[BuddyManager alloc] init];
        buddyManager.delegate = self;
    }
    return self;
}


@end
