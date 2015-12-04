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

@interface CollectViewController ()
@property (assign, atomic)    int index;
@property (nonatomic, assign) long userid;
@property (nonatomic, retain) UITableView * listTableView;
@property (nonatomic, retain) NSMutableArray * collectCellList;//需要取消隐藏的列表
@end

@implementation CollectViewController

#pragma mark - life Cycle
- (void)variableInit{
    [super variableInit];
    _index = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人动态";
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        [self setupRightBackButtonItem:nil img:@"collect_6.png" del:self sel:@selector(onEdit:)];
    }
    
    [[Cache shared] isNeedRefreshData:3 removeFlag:YES];
    
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[Cache shared] isNeedRefreshData:3 removeFlag:YES]) {
        [_listTableView headerBeginRefreshing];
    }
}

#pragma mark - delegate (CallBack)

#pragma mark CollectCellDelegate

- (void)didHiddenCollectCell:(CollectCell *)CollectCell{
    NSMutableArray * list = [[NSMutableArray alloc] initWithArray:[self.data_dict objectOutForKey:@"res"]];
    if ([NSArray isNotEmpty:list] && [list count] > CollectCell.indexPath.row) {
        [self showMessageView:@"此内容已隐藏" delayTime:2.0];
        [list removeObjectAtIndex:CollectCell.indexPath.row];
        [self.data_dict setObject:list forKey:@"res"];
        [_listTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:CollectCell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_listTableView reloadData];
    }
    [list release];
}

#pragma mark CollectHidddenListVCDelegate


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([self.data_dict objectOutForKey:@"res"]) {
        return [[self.data_dict objectOutForKey:@"res"] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CollectCell * cell = (CollectCell*)[tableView dequeueReusableCellWithIdentifier:@"CollectCell"];
//    if (cell == nil) {
        CollectCell * cell = [[[CollectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CollectCell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.userid = self.userid;
//    }
    
//    [cell.contentView removeAllSubviews];
    CGFloat h = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor color:clear_color];
    CollectItem * item = [[CollectItem alloc] initWithData:[[self.data_dict objectOutForKey:@"res"] objectAtExistIndex:indexPath.row]];
    cell.canEdit = NO;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell setupUI:item frmae:CGRectMake(0, 0, kScreenWidth, h)];
    [item release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if (cell && [cell isKindOfClass:[CollectCell class]]) {
        PersonalTopicViewController* vc = [[[PersonalTopicViewController alloc] init] autorelease];
        [vc.data_dict setNonEmptyObject:(CollectCell *)cell forKey:@"CollectCell"];
        if ([(CollectCell *)cell getOpType:((CollectCell *)cell).dataItem] != topic_like) {
            [vc.data_dict setNonEmptyObject:@"note_like" forKey:@"from"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark request
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_list]) {
        NSArray * res = [result objectOutForKey:@"res"];
        if (res) {
            NSMutableArray *arr = [NSMutableArray array];
            
            NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
            if (begin.intValue == 0) { // 下拉刷新
                [_listTableView headerEndRefreshing];
                [arr addObjectsFromArray:res];
            } else {
                [_listTableView footerEndRefreshing];
                [arr addObjectsFromArray:self.data_dict[@"res"]];
                [arr addObjectsFromArray:res];
            }
            
            [self.data_dict setNonEmptyObject:arr forKey:@"res"];
            
            [_listTableView reloadData];
        }
        
        [self showTipView:@{k_ToView:_listTableView,
                            k_ShowMsg:@"暂无动态噢~",
                            k_ListCount:num([self.data_dict[@"res"] count]),
                            }];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_list]) {
        [self endRefresh:req.data_dict];
        
        [self showTipView:@{k_ToView:_listTableView,
                            k_ShowMsg:@"出错了，请重新尝试~",
                            k_ListCount:num([self.data_dict[@"res"] count]),
                            }];
    }
}

- (void)endRefresh:(NSDictionary *)data_dict{
    NSNumber *begin = [data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
    if (begin.intValue == 0) { // 下拉刷新
        [_listTableView headerEndRefreshing];
    } else {
        [_listTableView footerEndRefreshing];
    }
}

#pragma mark - action such as: click touch tap slip ...

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self baseBack:nil];
}

- (void)setUserData:(long)userID
{
    self.userid = userID;
}

- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    NSArray *res = (NSArray *)self.data_dict[@"res"];
    if (res.count == 0) {
        [_listTableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:res.count+1 limit:LIMIT];
}

//请求数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"userid":@(self.userid),
                              @"begin":@(begin),
                              @"limit":@(limit),
                              @"hide":@0,
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - init & dealloc
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    self.listTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)] autorelease];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.backgroundColor = [UIColor color:clear_color];
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [_listTableView setSectionIndexColor:[UIColor clearColor]];
    [_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_listTableView setSeparatorColor:[UIColor color:lightgray_color]];
    _listTableView.scrollEnabled = YES;
    [self.contentView addSubview:_listTableView];
    
    // 增加下拉刷新、上拉加载更多
    [_listTableView addHeaderWithTarget:self action:@selector(loadNew)];
    [_listTableView addFooterWithTarget:self action:@selector(loadMore)];
    [_listTableView headerBeginRefreshing];
}

#pragma mark - other method
#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if( callback ){
//        callback( 0 );
//    }
}

- (void)onEdit:(id)sender{
    InfoLog(@".............");
    
    [self showConfirmSelectedView:@[@"编辑隐藏内容",@"取消"] SEL:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    
    if ([(UIView *)sender tag] == 0) {
        CollectHidddenListViewController* vc = [[[CollectHidddenListViewController alloc] init] autorelease];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
