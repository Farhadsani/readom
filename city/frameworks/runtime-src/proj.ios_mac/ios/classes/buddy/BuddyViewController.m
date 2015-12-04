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
#import "BuddyTopButton.h"

@interface BuddyViewController (){
    UIView * userBuddyView;
    
    UIView  *buddyViewContainer;
    UIImageView *userImage;
    UILabel *userName;
    UILabel *zone;
    
    BuddyTopButton * fansButton;
    BuddyTopButton * followButton;
    BuddyTopButton * ortherButton;
    
    BuddyManager *buddyManager;
}

@property (nonatomic) int selectedIndex;

@end



//void refreshUserCenterCallback(long userID, NSString *name, NSString *intro, NSString *zone, NSString *thumblink, NSString *imglink);

@implementation BuddyViewController

@synthesize listView;

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"出访";
    self.selectedIndex = 1;
    
    [buddyManager requestfrendDataBegin:0 limit:LIMIT];
    
    [self setupMainView];
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate callback

#pragma mark other delegate callback

- (void)setUserData:(long)userID :(NSString*) name :(NSString*)intro : (NSString*)zonename : (NSString*)thumblink : (NSString*)imglink{
    buddyManager.mainUser.userid = userID;
    buddyManager.mainUser.name = name;
    buddyManager.mainUser.intro = intro;
    buddyManager.mainUser.zone = zonename;
    buddyManager.mainUser.thumblink = thumblink;
    buddyManager.mainUser.imglink = imglink;
}

- (void)endRefresh:(NSDictionary *)data_dict{
    NSNumber *begin = [data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
    if (begin.intValue == 0) { // 下拉刷新
        [self.listView.tableView headerEndRefreshing];
    } else {
        [self.listView.tableView footerEndRefreshing];
    }
}
//delegate 刷新数据
- (void)didGetResult:(NSString *)type error:(NSError *)error reqData:(NSDictionary *)data_dict{
    if (data_dict) {
        [self endRefresh:data_dict];
    }
    
    if (!error) {
        InfoLog(@"%@", type);
        if ([buddyManager getBuddyShowType] != OnlySquare) {
            if ([type isEqualToString:@"fans"]){
                if (fansButton.selected) {
                    [listView refreshData:1];
                }
            }
            else if ([type isEqualToString:@"follow"]) {
                if (followButton.selected) {
                    [listView refreshData:2];
                }
            }
            else if ([type isEqualToString:@"square"]){
                if (ortherButton.selected) {
                    [listView refreshData:3];
                }
                else{
                    if ([buddyManager getBuddyShowType] == OnlySquare) {
                        [listView refreshData:3];
                    }
                }
            }
        }
        else{
            if ([type isEqualToString:@"square"]){
                [listView refreshData:3];
            }
        }
    }
    
    [self showTip:self.selectedIndex];
}
- (void)didAddFollow:(NSString *)userId result:(NSDictionary *)result error:(NSError *)error from:(id)cell{
    if (error == nil) {
        if (cell && [cell isKindOfClass:[BuddyCell class]]) {
            [cell doAfterHandelFollow:YES result:result];
            [MessageView showMessageView:@"已加入关注" delayTime:2.0];
        }
    }
}
- (void)didRemoveFollow:(NSString *)userId result:(NSDictionary *)result error:(NSError *)error from:(id)cell{
    if (error == nil) {
        if (cell && [cell isKindOfClass:[BuddyCell class]]) {
            [MessageView showMessageView:@"已取消关注" delayTime:2.0];
            if (self.selectedIndex == 3) {
                [cell doAfterHandelFollow:NO result:result];
            }
            else{
                [self.listView.tableView headerBeginRefreshing];
                [[Cache shared] setNeedRefreshData:1 value:1];
            }
        }
    }
}
- (void)didGetbuddycount:(NSString *)userId result:(NSDictionary *)result error:(NSError *)error{
    if (!error) {
        NSDictionary * res = [result objectOutForKey:@"res"];
        if ([NSDictionary isNotEmpty:res]) {
            [self updateUserBuddyView:[[res objectOutForKey:@"fans"] integerValue] followCount:[[res objectOutForKey:@"follow"] integerValue]];
        }
        else{
            [self updateUserBuddyView:0 followCount:0];
        }
    }
    else{
        [self updateUserBuddyView:0 followCount:0];
    }
}

#pragma mark - action such as: click touch tap slip ...
- (void)onTouch:(id)sender{
    BuddyTopButton *button = (BuddyTopButton *)sender;
    int index = (int)button.tag;
    InfoLog(@"当前点击了按钮 %d", index);
    
    self.selectedIndex = index;
    
    if (!button.selected) {
        [fansButton selected:NO];
        [followButton selected:NO];
        [ortherButton selected:NO];
        [button selected:YES];
        [listView refreshData:self.selectedIndex];
    }
    
    [self doOnTouch:index];
}

- (void)doOnTouch:(int)index{
    if (![NSArray isNotEmpty:[buddyManager getTableData:self.selectedIndex]]) {
        [self.listView.tableView headerBeginRefreshing];
    }
    else if (self.selectedIndex == 2 &&
             [[Cache shared] isNeedRefreshData:0 removeFlag:YES] &&
             [[UserManager sharedInstance] isCurrentUser:buddyManager.mainUser.userid])
    {
        [buddyManager requestGetbuddycount:buddyManager.mainUser.userid];
        [self.listView.tableView headerBeginRefreshing];
    }
    else if (self.selectedIndex == 3 &&
             [[Cache shared] isNeedRefreshData:1 removeFlag:YES])
    {
        [self.listView.tableView headerBeginRefreshing];
    }
    
    [self showTip:self.selectedIndex];
}

//查看别人的个人中心
- (void)selectItem:(NSInteger) index{
    InfoLog(@"select item........%d", (int)index);
    BuddyItem *item = [buddyManager getBoddyItem:index];
    [self baseDeckBack];
    [self toCocos:item.userid :item.name :item.intro :item.zone :item.thumblink :item.imglink ];
}

//添加关注
-(void)onRelationShip:(long)index{
    InfoLog(@"relationship........");
    
    if ([[UserManager sharedInstance] isCurrentUser:buddyManager.mainUser.userid]) {
        NSInteger count = followButton.num;
        if (count >= 0) {
            count++;
        }
        else{
            count = 1;
        }
        [followButton num:count];
    }
    
    [[Cache shared] setNeedRefreshData:0 value:1];
}

//取消关注
-(void)onUnRelationShip:(long)index{
    InfoLog(@"relationship........");
    
    if ([[UserManager sharedInstance] isCurrentUser:buddyManager.mainUser.userid]) {
        NSInteger count = followButton.num;
        if (count > 0) {
            count--;
        }
        else{
            count = 0;
        }
        [followButton num:count];
    }
    
    [[Cache shared] setNeedRefreshData:0 value:1];
}

#pragma mark - request method

#pragma mark - init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        buddyManager = [[BuddyManager alloc] init];
        buddyManager.delegate = self;
    }
    return self;
}

- (void)setupMainView{
    switch ([buddyManager getBuddyShowType]) {
        case OnlySquare:{
            self.selectedIndex = 3;
            [self setupView_OnlySquare];
        }
            break;
        case FanAndFollow:{
            self.selectedIndex = 1;
            [self setupView_FanAndFollow];
        }
            break;
        case FanAndFollowAndSquare:{
            self.selectedIndex = 1;
            [self setupView_FanAndFollowAndSquare];
        }
            break;
            
        default:
            break;
    }
    
    [self resetRefreshHeaderAndFooter:self.selectedIndex];
}

- (void)setupView_FanAndFollowAndSquare{
    [self updateUserBuddyView:0 followCount:0];
    [self initListView:CGRectMake(0, userBuddyView.y+userBuddyView.height, self.contentView.width, self.contentView.height-userBuddyView.y-userBuddyView.height-10)];
}

- (void)setupView_FanAndFollow{
    [self updateUserBuddyView:0 followCount:0];
    [self initListView:CGRectMake(0, userBuddyView.y+userBuddyView.height, self.contentView.width, self.contentView.height-userBuddyView.y-userBuddyView.height-10)];
}

- (void)setupView_OnlySquare{
    [self initListView:CGRectMake(0, 10, self.contentView.width, self.contentView.height-20)];
}
//更新好友列表
- (void)updateUserBuddyView:(NSInteger)fansCount followCount:(NSInteger)followCount{
    if ([buddyManager getBuddyShowType] == OnlySquare) {
        return;
    }
    CGFloat btnHeight = 35;
    CGFloat top = 30;
    if (!userBuddyView) {
        userBuddyView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                           V_Margin:edgeStr(10, top, 5, top),
                                           V_Height:strFloat(2*top+btnHeight),
                                           }];
        [self.contentView addSubview:userBuddyView];
    }
    [userBuddyView removeAllSubviews];
    
    CGFloat btnWidth = 0;
    CGFloat numWidth = 0;
    
    CGFloat wd = [@"粉丝" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}].width;
    CGFloat numWid1 = [str(fansCount) sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}].width;
    CGFloat numWid2 = [str(followCount) sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}].width;
    CGFloat numWid3 = 0;
    
    btnWidth = (numWid1 > numWid2) ? numWid1 : numWid2;
    btnWidth = (btnWidth > numWid3) ? btnWidth : numWid3;
    
    numWidth = btnWidth;
    
    btnWidth += wd;
    btnWidth += 20;
    
    CGFloat space = (userBuddyView.width - 3*btnWidth ) /4.0;
    if ([buddyManager getBuddyShowType] == FanAndFollow) {
        space = (userBuddyView.width - 2*btnWidth ) /3.0;
    }
    
    fansButton = [[BuddyTopButton alloc] initWithFrame:CGRectMake(space, userImage.y+userImage.height, btnWidth, btnHeight) title:@"粉丝" number:fansCount tag:1];
    [fansButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    [userBuddyView addSubview:fansButton];
    [fansButton release];
    
    followButton = [[BuddyTopButton alloc] initWithFrame:CGRectMake(space*2+btnWidth, fansButton.y, btnWidth, btnHeight) title:@"关注" number:followCount tag:2];
    [followButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    [userBuddyView addSubview:followButton];
    [followButton release];
    
    if ([buddyManager getBuddyShowType] == FanAndFollowAndSquare) {
        ortherButton = [[BuddyTopButton alloc] initWithFrame:CGRectMake(space*3+btnWidth*2, fansButton.y, btnWidth, btnHeight) title:@"广场" number:0 tag:3];
        [ortherButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
        [userBuddyView addSubview:ortherButton];
        [ortherButton release];
    }
    
    switch (self.selectedIndex) {
        case 1:{
            [fansButton selected:YES];
        }
            break;
        case 2:{
            [followButton selected:YES];
        }
            break;
        case 3:{
            [ortherButton selected:YES];
        }
            break;
            
        default:
            break;
    }
    
    [self.contentView resetFrameHeightOfView:userBuddyView];
}

- (void)initListView:(CGRect)frame{
    if (listView) {
        return;
    }
    
    listView = [[BuddyListView alloc] initWithFrame:frame];
    [listView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    listView.delegate = self;
    listView.buddyManager = buddyManager;
    [listView refreshData:self.selectedIndex];
    
    [self.contentView addSubview:listView];
    
    [listView release];
}

- (void)resetRefreshHeaderAndFooter:(NSInteger)index{
    [listView.tableView removeHeader];
    [listView.tableView removeFooter];
    
    // 增加下拉刷新、上拉加载更多
    [listView.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [listView.tableView addFooterWithTarget:self action:@selector(loadMore)];
}

- (void)loadNew{
    [buddyManager requestData:self.selectedIndex userid:buddyManager.mainUser.userid begin:0 limit:LIMIT];
}

- (void)loadMore{
    if (![NSArray isNotEmpty:[buddyManager getTableData:self.selectedIndex]]) {
        [self.listView.tableView footerEndRefreshing];
        return;
    }
    [buddyManager requestData:self.selectedIndex userid:buddyManager.mainUser.userid begin:[buddyManager getTableData:self.selectedIndex].count+1 limit:LIMIT];
}

- (void)dealloc{
    if (buddyManager) {
        [buddyManager release];
    }
    [super dealloc];
}

#pragma mark - other method
#pragma mark

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if( callback ){
//        callback( 1 );
//    }
}

- (void)showTip:(NSInteger)tag{
    NSString * msg = @"";
    switch (tag) {
        case 1:{//粉丝
            msg = @"还没有粉丝喔~";
        }
            break;
        case 2:{//关注
            msg = @"还没有关注其他人，快去广场看看吧~";
        }
            break;
        case 3:{//广场
            msg = @"广场上很冷清啊~";
        }
            break;
            
        default:
            break;
    }
    if (![NSString isEmptyString:msg]) {
        [self showTipView:@{k_ToView:listView,
                            k_ShowMsg:msg,
                            k_ListCount:num([[buddyManager getTableData:(int)tag] count]),
                            }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
