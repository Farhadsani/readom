//
//  ConsumeIndexViewController.m
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import "ConsumeIndexViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "StoreSimpleIntro.h"
#import "StoreSimpleCell.h"
#import "AreaStreetView.h"
#import "StoreViewController.h"

@interface ConsumeIndexViewController () <UITableViewDataSource, UITableViewDelegate, AreaStreetViewDelegate, StoreSimpleCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *storeSimpleIntroArr;
@property (nonatomic, strong) AreaStreetView *areaStreetView;
@property (nonatomic, assign) Boolean showing;
@property (nonatomic, weak) UIView *barItem;
@end

@implementation ConsumeIndexViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
}

#pragma mark - action
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (NSMutableArray *)storeSimpleIntroArr
{
    if (!_storeSimpleIntroArr) {
        _storeSimpleIntroArr = [NSMutableArray array];
    }
    return _storeSimpleIntroArr;
}

- (void)loadMore
{
    if (self.storeSimpleIntroArr.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.storeSimpleIntroArr.count limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params;
    if (self.streetid.length > 0) {
        params = @{@"categoryid": @(self.categoryid),
                  @"areaid": str(self.areaid),
                  @"streetid":self.streetid,
                  @"begin": @(begin),
                  @"limit": @(limit)
                  };
    } else {
        params = @{@"categoryid": @(self.categoryid),
                   @"areaid": str(self.areaid),
                   @"begin": @(begin),
                   @"limit": @(limit)
                   };
    }
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.storeSimpleIntroArr removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self.storeSimpleIntroArr addObjectsFromArray:[StoreSimpleIntro objectArrayWithKeyValuesArray:[result objectOutForKey:@"res"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"该区域暂无店铺",
                            k_ListCount:num(self.storeSimpleIntroArr.count),
                            }];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"该区域暂无店铺",
                            k_ListCount:num(self.storeSimpleIntroArr.count),
                            }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeSimpleIntroArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreSimpleCell *storeSimpleCell = [StoreSimpleCell cellForTableView:tableView];
    storeSimpleCell.storeSimpleIntro = self.storeSimpleIntroArr[indexPath.row];
    storeSimpleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [storeSimpleCell setupCell];
    storeSimpleCell.indexPath = indexPath;
    storeSimpleCell.delegate = self;
    return storeSimpleCell;
}

#pragma mark - StoreSimpleCellDelegate
- (void)didClickCell:(StoreSimpleCell *)cell
{
    StoreViewController *store = [[StoreViewController alloc] init];
    StoreSimpleIntro *storeSimpleIntro = self.storeSimpleIntroArr[cell.indexPath.row];
    store.userid = storeSimpleIntro.userid;
    store.title = storeSimpleIntro.name;
    [self.navigationController pushViewController:store animated:YES];
}

#pragma mark - AreaStreetViewDelegate
- (void)areaStreetView:(AreaStreetView *)areaStreetView didSelectItem:(AreaStreetItem *)areaStreetItem
{
    self.streetid = areaStreetItem.streetid;
    [self loadNew];
}

- (void)areaStreetViewHide:(AreaStreetView *)areaStreetView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.barItem.transform = CGAffineTransformIdentity;
    }];
    self.showing = !self.showing;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_store__simple_cell_height;
}

#pragma mark - action such as: click touch tap slip ...

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [self.areaStreetView hide];
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
    [self backToMapIndex:0];
}

- (void)clickRightItem:(id)sender{
    UIImageView *view = ((UIButton *)sender).imageView;
    self.barItem = view;
    if (self.showing) {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
        [self.areaStreetView hide];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformRotate(view.transform, M_PI);
            
        }];
        [self.areaStreetView show];
    }
    self.showing = !self.showing;
}

#pragma mark - init & dealloc
- (void)setupMainView
{
    [self setupRightBackButtonItem:nil img:@"consumeindex_more" del:self sel:@selector(clickRightItem:)];
    
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
    
    AreaStreetView *areaStreetView = [AreaStreetView areaStreetViewWithAreaId:self.areaid];
    self.areaStreetView = areaStreetView;
    areaStreetView.frame = CGRectMake(0, 64, self.contentView.width, 200);
    areaStreetView.delegate = self;
}
@end
