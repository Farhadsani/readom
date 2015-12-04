//
//  SysMsgViewController.m
//  qmap
//
//  Created by hf on 15/9/1.
//
//

/*
 *【消息】--->[系统消息]界面
 *功能：查看系统消息
 */

#import "SysMsgViewController.h"
#import "MJRefresh.h"
#import "SysMsgCell.h"

@interface SysMsgViewController ()

@property (nonatomic, retain) UITableView * listTableView;
@property (nonatomic, retain) NSMutableArray * list;

@end

@implementation SysMsgViewController

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
    SysMsgCell * cell = [[[SysMsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SysCell" data:[_list objectAtExistIndex:indexPath.row]] autorelease];
    return [cell calHeightOfCell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SysMsgCell * cell = (SysMsgCell*)[tableView dequeueReusableCellWithIdentifier:@"SysCell"];
//    if (cell == nil) {
        SysMsgCell * cell = [[[SysMsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SysCell" data:[_list objectAtExistIndex:indexPath.row]] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
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
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_system]) {
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
                                k_ShowMsg:@"暂无系统通知~",
                                k_ListCount:num([_list count]),
                                }];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_system_del]){
        [self showMessageView:@"系统通知已全部删除" delayTime:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_system]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [_listTableView headerEndRefreshing];
        } else {
            [_listTableView footerEndRefreshing];
        }
        
        [self showTipView:@{k_ToView:_listTableView,
                            k_ShowMsg:@"暂无系统通知~",
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
    [self requestMyMsgBegin:_list.count+1 limit:LIMIT];
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
    NSDictionary * d = @{k_r_url:k_api_message_system,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)deleteData:(id)sender{
    [self showConfirmSelectedView:@[@"删除所有消息", @"取消"] SEL:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}
- (void)clickSelectedItem:(UIButton *)button{
    [self hiddenSelectedView];
    if ([button.titleLabel.text isEqualToString:@"删除所有消息"]) {
        [self requestDelete];
    }
}
- (void)requestDelete{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid]
                              };
    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_message_system_del,
                         k_r_delegate:self,
                         k_r_postData:dict,
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

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark
@end
