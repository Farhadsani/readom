//
//  ShoppingListViewController.m
//  citystate
//
//  Created by 石头人工作室 on 15/11/2.
//
//

#import "ShoppingListViewController.h"
#import "StoreGoodsDetail.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "GoodsShoppingCell.h"

@interface ShoppingListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *shoppingLists;
@end

@implementation ShoppingListViewController
- (NSMutableArray *)shoppingLists
{
    if (!_shoppingLists) {
        _shoppingLists = [NSMutableArray array];
    }
    return _shoppingLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买记录";
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - action
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if (self.shoppingLists.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.shoppingLists.count limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"userid":@(self.userid),
                              @"begin": @(begin),
                              @"limit": @(limit)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_order_user_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_user_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.shoppingLists removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self.shoppingLists addObjectsFromArray:[StoreGoodsDetail objectArrayWithKeyValuesArray:result[@"res"]]];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"暂无购买记录",
                                k_ShowImgName:@"store_noshoppinglist",
                                k_ListCount:num(self.shoppingLists.count),
                                }];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_user_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"暂无购买记录",
                                k_ShowImgName:@"store_noshoppinglist",
                                k_ListCount:num(self.shoppingLists.count),
                                }];
        });
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoppingLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsShoppingCell *cell = [GoodsShoppingCell cellForTableView:tableView];
    cell.storeGoodsDetail = self.shoppingLists[indexPath.row];
    if (self.shoppingLists.count == 1) {
        [cell setTimelineStr:@"timeline_3"];
    } else if (self.shoppingLists.count == 2) {
        if (indexPath.row == 0) {
            [cell setTimelineStr:@"timeline_1"];
        } else {
            [cell setTimelineStr:@"timeline_3"];
        }
    } else {
        if (indexPath.row == 0) {
            [cell setTimelineStr:@"timeline_1"];
        } else if(indexPath.row == (self.shoppingLists.count - 1)) {
            [cell setTimelineStr:@"timeline_3"];
        } else {
            [cell setTimelineStr:@"timeline_2"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}
@end
