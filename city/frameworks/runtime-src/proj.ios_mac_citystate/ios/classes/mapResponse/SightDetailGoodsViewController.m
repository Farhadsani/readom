//
//  SightDetailGoodsViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/20.
//
//

#import "SightDetailGoodsViewController.h"
#import "SightDetailGoodsCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "SightDetailGoods.h"

@interface SightDetailGoodsViewController () <UITableViewDataSource, UITableViewDelegate, SightDetailGoodsCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *sightDetailGoodsArr;
@end

@implementation SightDetailGoodsViewController
- (NSMutableArray *)sightDetailGoodsArr
{
    if (!_sightDetailGoodsArr) {
        _sightDetailGoodsArr = [NSMutableArray array];
    }
    return _sightDetailGoodsArr;
}

- (void)viewDidLoad
{
//    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - action
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if (self.sightDetailGoodsArr.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.sightDetailGoodsArr.count limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"sightid":@(self.areaid),
                              @"begin": @(begin),
                              @"limit": @(limit)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_goods_special,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_goods_special]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.sightDetailGoodsArr removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self.sightDetailGoodsArr addObjectsFromArray:[SightDetailGoods objectArrayWithKeyValuesArray:[result objectOutForKey:@"res"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"该景点暂无特卖劵",
                            k_ListCount:num(self.sightDetailGoodsArr.count),
                            }];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_goods_special]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"该景点暂无特卖劵",
                            k_ListCount:num(self.sightDetailGoodsArr.count),
                            }];
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sightDetailGoodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SightDetailGoodsCell *cell = [SightDetailGoodsCell cellForTableView:tableView];
    cell.sightDetailGoods = self.sightDetailGoodsArr[indexPath.row];
    cell.delegate = self.parentViewController;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SightDetailGoodsCellHight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = self.view.bounds;
    self.tableView.frame = self.contentView.bounds;
}
@end
