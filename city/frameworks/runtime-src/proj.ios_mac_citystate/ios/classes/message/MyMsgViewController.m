//
//  MyMsgViewController.m
//  qmap
//
//  Created by hf on 15/9/1.
//
//


/*
 *【消息】--->[我的消息]界面
 *功能：查看我的消息
 */
#import "MyMsgViewController.h"
#import "MJRefresh.h"
#import "MsgCell.h"
#import "BuddyItem.h"
#import "CocosViewController.h"

@interface MyMsgViewController ()

@property (nonatomic, retain) NSMutableArray * list;
@property (nonatomic ,retain) BuddyItem *buddyItem;

@end

@implementation MyMsgViewController

- (void)variableInit{
    [super variableInit];
    self.list = [[[NSMutableArray alloc] init] autorelease];
}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRightBackButtonItem:nil img:@"msg_5" del:self sel:@selector(deleteData:)];
    
    [self setupMainView];
}

#pragma mark - delegate (CallBack)

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if (_list) {
        return [_list count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgCell"];
    if (cell == nil) {
        cell = [[[MsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MsgCell" data:[_list objectAtExistIndex:indexPath.row]] autorelease];
    }
    return [cell calHeightOfCell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell * cell = [[[MsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MsgCell" data:[_list objectAtExistIndex:indexPath.row]] autorelease];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

#pragma mark request delegate callback

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_user]) {
        NSArray * res = [result objectOutForKey:@"res"];
        if (res) {
            NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
            if (begin.intValue == 0) { // 下拉刷新
                [_list removeAllObjects];
                [_listTableView headerEndRefreshing];
            } else {
                [_listTableView footerEndRefreshing];
            }
            
            [self.list addObjectsFromArray:res];
            [_listTableView reloadData];
            
            [self showTipView:@{k_ToView:_listTableView,
                                k_ShowMsg:@"您好像没有消息哦~",
                                k_ListCount:num([_list count]),
                                }];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_user_del]){
        [self showMessageView:@"您的消息已全部删除" delayTime:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_user]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [_listTableView headerEndRefreshing];
        } else {
            [_listTableView footerEndRefreshing];
        }
        
        [self showTipView:@{k_ToView:_listTableView,
                            k_ShowMsg:@"您好像没有消息哦~",
                            k_ListCount:num([_list count]),
                            }];
    }
}

#pragma mark other delegate callback

#pragma mark - action such as: click touch tap slip ...
- (void)loadNew{
    [self requestMyMsgBegin:0 limit:LIMIT];
}

- (void)loadMore{
    if (_list.count == 0) {
        [_listTableView footerEndRefreshing];
        return;
    }
    [self requestMyMsgBegin:_list.count limit:LIMIT];
}

#pragma mark - request method

- (void)requestMyMsgBegin:(long)begin limit:(long)limit{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"begin":@(begin),
                              @"limit":@(limit),
                              };
    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_message_user,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}


#pragma mark - init & dealloc
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    CGFloat space = (self.hidTabbarBar)?0:49;
    self.listTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-space-40-64)] autorelease];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.backgroundColor = [UIColor color:milky_color];
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [_listTableView setSectionIndexColor:[UIColor clearColor]];
    [_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_listTableView setSeparatorColor:[UIColor color:darkGary_color]];
    _listTableView.scrollEnabled = YES;
    [self.view addSubview:_listTableView];
    
    // 增加下拉刷新、上拉加载更多
    [_listTableView addHeaderWithTarget:self action:@selector(loadNew)];
    [_listTableView addFooterWithTarget:self action:@selector(loadMore)];
    [_listTableView headerBeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellDelete:) name:@"MsgCellDelete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cellUserZone:) name:@"MsgCellUserZone" object:nil];
}

- (void)dealloc{
    [super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cellDelete:(NSNotification *)notification
{
    MsgCell *cell = notification.userInfo[@"cell"];
    NSIndexPath *indexPath = [self.listTableView indexPathForCell:cell];
    [self.list removeObjectAtIndex:indexPath.row];
    if (indexPath) {
        if (self.list.count < 3) {
            [self.listTableView reloadData];
        }
        else{
            [self.listTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else{
        [self.listTableView reloadData];
    }
    [self showTipView:@{k_ToView:_listTableView,
                        k_ShowMsg:@"好像没有消息哦~",
                        k_ListCount:num([_list count]),
                        }];
}
- (void)cellUserZone:(NSNotification *)notification{
    MsgCell *cell = notification.userInfo[@"cell"];
    NSDictionary *dict = cell.data_dict[@"user"];
    BuddyItem *buddyItem = [[BuddyItem alloc] init];
    buddyItem.userid = [dict[@"userid"] integerValue];
    buddyItem.imglink = dict[@"imglink"];
    buddyItem.name = dict[@"name"];
    buddyItem.intro = dict[@"intro"];
    buddyItem.type = [dict[@"type"]longValue];

    [self toCocos:buddyItem.userid :buddyItem.name:buddyItem.intro :buddyItem.zone :buddyItem.imglink :buddyItem.imglink ];
    CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
    vc.userid = buddyItem.userid;
    vc.buddyItem = buddyItem;
    [[CocosManager shared] addCocosMapView:vc];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - other method
#pragma mark

@end
