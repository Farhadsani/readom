//
//  OrdersViewController.m
//  citystate
//
//  Created by hf on 15/10/15.
//
//

#import "OrdersViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "OrderIntro.h"
#import "OrderDetailViewController.h"
#import "OrderNoPayedDetailViewController.h"
#import "StorePayMoneyViewController.h"

@interface OrdersViewController ()

@property (nonatomic, assign) int index;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray * ordersList;

@end

@implementation OrdersViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - delegate (CallBack)

#pragma mark OrderCommentVCDelegate
- (void)OrderCommentViewController:(OrderCommentViewController *)vc data:(OrderIntro*)orderIntro{
    NSMutableDictionary * ms = [[NSMutableDictionary alloc] init];
    NSInteger i = -1;
    for (NSDictionary * orderInf in self.ordersList) {
        if ([[orderInf objectOutForKey:@"orderid"] longLongValue] == orderIntro.orderid) {
            [ms setNonEmptyValuesForKeysWithDictionary:orderInf];
            
            if (orderIntro.commented) {
                [ms setNonEmptyValue:(orderIntro.commented)?@1:@0 forKey:@"commented"];
            }
            if (orderIntro.rated) {
                [ms setNonEmptyValue:(orderIntro.rated)?@1:@0 forKey:@"rated"];
            }
            
            i = [self.ordersList indexOfObject:orderInf];
            break;
        }
    }
    
    if (i >= 0) {
        [self.ordersList replaceObjectAtIndex:i withObject:ms];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [ms release];
}

#pragma mark request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.ordersList removeAllObjects];
        }
        else{
            [self.tableView footerEndRefreshing];
        }
        
        [self.ordersList addObjectsFromArray:[result objectForKey:@"res"]];
        [self.tableView reloadData];
        
        [self showTipView:@{k_ToView:_tableView,
                            k_ShowMsg:@"您还没有订单记录哦~",
                            k_ListCount:num([self.ordersList count]),
                            }];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        [self showTipView:@{k_ToView:_tableView,
                            k_ShowMsg:@"网络出错了~",
                            k_ListCount:num([self.ordersList count]),
                            }];
    }
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_ordersList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return k_order_cell_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [OrderCell cellForTableView:tableView];
    cell.orderIntro = [OrderIntro objectWithKeyValues:[self.ordersList objectAtExistIndex:indexPath.row]];
    cell.delegate = self;
    [cell setupCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell * cell = (OrderCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if (cell.orderIntro.payed) {
        OrderDetailViewController * vc = [[OrderDetailViewController alloc] init];
        vc.orderIntro = cell.orderIntro;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else{
        OrderNoPayedDetailViewController * vc = [[OrderNoPayedDetailViewController alloc] init];
        vc.orderIntro = cell.orderIntro;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

#pragma mark OrderCellDelegate
- (void)didClickComment:(OrderCell *)cell{
    OrderCommentViewController * vc = [[OrderCommentViewController alloc] init];
    vc.orderIntro = cell.orderIntro;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)didClickPay:(OrderCell *)cell{
    StorePayMoneyViewController * vc = [[StorePayMoneyViewController alloc] init];
    OrderIntro *orderIntro = cell.orderIntro;
    GoodsOrder *goodsOrder = [[GoodsOrder alloc] init];
    goodsOrder.goodsid = orderIntro.goodsid;
    goodsOrder.name = orderIntro.goodsname;
    goodsOrder.price = orderIntro.price;
    goodsOrder.phone = [UserManager sharedInstance].base.phone;
    goodsOrder.count = 1;
    CGFloat totalPrice = [orderIntro.price floatValue] * orderIntro.goodscount;
    NSString *totalPriceStr = [NSString stringWithFormat:@"￥%.2f", totalPrice];
    goodsOrder.totalPrice = totalPriceStr;
    vc.goodsOrder = goodsOrder;
    vc.orderid = cell.orderIntro.orderid;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - action such as: click touch tap slip ...

- (void)loadNew{
    [self setDataWithBegin:0 limit:20];
}

- (void)loadMore{
    if (self.ordersList.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.ordersList.count limit:20];
}

#pragma mark request method
// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit{
    NSDictionary * params = @{@"begin": @(begin),
                              @"limit": @(limit)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_order_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - init & dealloc
- (void)setupMainView{
    if (!_ordersList) {
        self.ordersList = [[[NSMutableArray alloc] init] autorelease];
    }
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain] autorelease];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor color:clear_color]];
    [self.contentView addSubview:_tableView];
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    
    [self setDataWithBegin:0 limit:20];
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark
@end
