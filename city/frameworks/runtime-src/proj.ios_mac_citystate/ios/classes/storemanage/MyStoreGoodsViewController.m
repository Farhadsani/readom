//
//  MyStoreGoodsViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/29.
//
//

#import "MyStoreGoodsViewController.h"
#import "MyStoreGoodsCell.h"
#import "StoreGoodsDetail.h"
#import "MyStoreGoodsEditViewController.h"

@interface MyStoreGoodsViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL hasRequestd;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *storeGoodsDetails;
@end

@implementation MyStoreGoodsViewController
- (NSMutableArray *)storeGoodsDetails
{
    if (!_storeGoodsDetails) {
        _storeGoodsDetails = [NSMutableArray array];
    }
    return _storeGoodsDetails;
}

- (NSMutableArray *)rightBtns{
    NSMutableArray  *rightBtns = [NSMutableArray array];
    [rightBtns sw_addUtilityButtonWithColor:yello_color title:@"编辑"];
    [rightBtns sw_addUtilityButtonWithColor:darkRed_color title:@"删除"];
    return rightBtns;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestGoodsList];
}

- (void)requestGoodsList{
    if (self.hasRequestd) {
        return;
    }
    
    NSDictionary * params = @{@"userid":@(self.userid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_manage_goods,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.hasRequestd = NO;

    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    UIView *tableViewHeaderView = [[UIView alloc] init];
    CGRect frame = tableViewHeaderView.frame;
    frame.size.height = 0.6;
    tableViewHeaderView.frame = frame;
    tableViewHeaderView.backgroundColor = lightgray_color;
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    frame = tableViewFooterView.frame;
    frame.size.height = 60;
    tableViewFooterView.frame = frame;
    UIButton *button = [[UIButton alloc] init];
    [tableViewFooterView addSubview:button];
    frame.size.width = 140;
    button.frame = frame;
    [button setTitle:@"添加特卖" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:16];
    [button setTitleColor:k_defaultTextColor forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setImage:[UIImage imageNamed:@"storemanage_addgoods"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"storemanage_addgoods_sel"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addStoreGoodsBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc] init];
    frame = lineView.frame;
    frame.size.height = 0.6;
    frame.size.width = self.tableView.width;
    lineView.frame = frame;
    lineView.backgroundColor = lightgray_color;
    [tableViewFooterView addSubview:lineView];
    tableView.tableFooterView = tableViewFooterView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = self.view.bounds;
    self.tableView.frame = self.contentView.bounds;
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_goods]) {
        self.hasRequestd = YES;
        self.storeGoodsDetails = [StoreGoodsDetail objectArrayWithKeyValuesArray:result[@"res"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"暂无特卖劵",
                                k_ListCount:num(self.storeGoodsDetails.count),
                                }];
            if (self.storeGoodsDetails.count != 0) {
                self.tableView.tableHeaderView.hidden = NO;
            } else {
                self.tableView.tableHeaderView.hidden = YES;
            }
        });
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_goods_del]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"index"];

        [self.storeGoodsDetails removeObjectAtIndex:[begin integerValue]];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[begin integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_goods]) {
        InfoLog(@"error:%@", error);
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"暂无特卖劵",
                            k_ListCount:num(self.storeGoodsDetails.count),
                            }];
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_goods_del]) {
        InfoLog(@"error:%@", error);
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeGoodsDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStoreGoodsCell *cell = [MyStoreGoodsCell cellForTableView:tableView];
    cell.rightUtilityButtons = [self rightBtns];
    cell.delegate = self;
    cell.storeGoodsDetail = self.storeGoodsDetails[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MyStoreGoodsCellHight;
}

#pragma mark - SWTableViewCellDelegate
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (index == 0) {
        MyStoreGoodsEditViewController *myStoreGoodsEditViewController = [[MyStoreGoodsEditViewController alloc] init];
        myStoreGoodsEditViewController.storeGoodsDetail = [self.storeGoodsDetails[indexPath.row] copy];
        myStoreGoodsEditViewController.title = @"特卖编辑";
        myStoreGoodsEditViewController.url = k_api_store_manage_goods_edit;
        myStoreGoodsEditViewController.back = ^(StoreGoodsDetail *detail) {
            self.storeGoodsDetails[indexPath.row] = detail;
        };
        [self.navigationController pushViewController:myStoreGoodsEditViewController animated:YES];
    } else {
        StoreGoodsDetail *detail = self.storeGoodsDetails[indexPath.row];
        NSDictionary * params = @{@"goodsid":@(detail.goodsid),
                                  @"index": @(indexPath.row)
                                  };
        NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = @{k_r_url:k_api_store_manage_goods_del,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
    }
}

- (void)addStoreGoodsBtnDidOnClick:(UIButton *)btn
{
    MyStoreGoodsEditViewController *myStoreGoodsEditViewController = [[MyStoreGoodsEditViewController alloc] init];
    myStoreGoodsEditViewController.storeGoodsDetail = [[StoreGoodsDetail alloc] init];
    myStoreGoodsEditViewController.title = @"添加特卖";
    myStoreGoodsEditViewController.url = k_api_store_manage_goods_add;
    myStoreGoodsEditViewController.addBackBlock = ^(StoreGoodsDetail *detail) {
        self.hasRequestd = NO;
    };
    [self.navigationController pushViewController:myStoreGoodsEditViewController animated:YES];
}
@end
