//
//  StoreViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import "StoreViewController.h"
#import "StoreIntro.h"
#import "StoreCommentFrame.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "StoreSectionView.h"
#import "StoreGoodsCell.h"
#import "StoreCommentCell.h"
#import "StoreDetailCell.h"
#import "StoreGoodsDetailViewController.h"
#import "StoreNoCommentView.h"
#import "StoreViewNavBar.h"
#import "CocosUserCenterRootViewController.h"
#import "CocosViewController.h"

#define StoreSectionViewH 36

@interface StoreViewController () <UITableViewDataSource, UITableViewDelegate, StoreViewNavBarDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) StoreIntro *storeIntro;
@property (nonatomic, strong) NSMutableArray *storeCommentFrames;
@property (nonatomic, weak) StoreViewNavBar *storeViewNavBar;
@end

@implementation StoreViewController
- (NSMutableArray *)storeCommentFrames
{
    if (!_storeCommentFrames) {
        _storeCommentFrames = [NSMutableArray array];
    }
    return _storeCommentFrames;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView setBackgroundColor:[UIColor color:clear_color]];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self setData];
    [self setDataWithBegin:0 limit:LIMIT];
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableViewFooterView;
    
    StoreViewNavBar *storeViewNavBar = [StoreViewNavBar storeViewNavBarWithTitle:self.title];
    [self.view insertSubview:storeViewNavBar aboveSubview:self.contentView];
    self.storeViewNavBar = storeViewNavBar;
    [self.storeViewNavBar setBgViewAlpha:0];
    storeViewNavBar.frame = CGRectZero;
    storeViewNavBar.delegate = self;
}

#pragma mark - StoreViewNavBarDelegate
- (void)storeViewNavBar:(StoreViewNavBar *)navBar backBtnDidOnClick:(UIButton *)btn
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        id vc = [self.navigationController.viewControllers objectAtExistIndex:index-1];
        if (vc) {
            if ([vc isKindOfClass:[CocosUserCenterRootViewController class]] || [vc isKindOfClass:[CocosViewController class]]) {
                [self backUserHome:0];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadMore
{
    if (self.storeCommentFrames.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.storeCommentFrames.count limit:LIMIT];
}

// 获取网络数据
- (void)setData
{
    NSDictionary * params = @{@"userid": @(self.userid)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_intro,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"begin": @(begin),
                              @"limit": @(limit),
                              @"userid": @(self.userid)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_comment_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_intro]) {
        self.storeIntro = [StoreIntro objectWithKeyValues:[result objectOutForKey:@"res"]];
        [self.storeViewNavBar setTitle:(self.storeIntro.storename)?self.storeIntro.storename:self.storeIntro.name];
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_comment_list]) {
        NSArray *storeComments = [StoreComment objectArrayWithKeyValuesArray:[result objectOutForKey:@"res"]];
        for (StoreComment *storeComment in storeComments) {
            StoreCommentFrame *storeCommentFrame = [[StoreCommentFrame alloc] init];
            storeCommentFrame.storeComment = storeComment;
            [self.storeCommentFrames addObject:storeCommentFrame];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_intro]) {
        
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_comment_list]) {
        [self.tableView footerEndRefreshing];
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.storeIntro.goodscount;
    } else {
        return self.storeCommentFrames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StoreDetailCell *cell = [StoreDetailCell cellForTableView:tableView];
        cell.storeIntro = self.storeIntro;
        return cell;
    } else if (indexPath.section == 1) {
        StoreGoodsCell *cell = [StoreGoodsCell cellForTableView:tableView];
        cell.storeGoods = self.storeIntro.goods[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        StoreCommentCell *cell = [StoreCommentCell cellForTableView:tableView];
        cell.storeCommentFrame = self.storeCommentFrames[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return StoreGoodsCellHight;
    } else if (indexPath.section == 2) {
        StoreCommentFrame *storeCommentFrame = self.storeCommentFrames[indexPath.row];
        return storeCommentFrame.cellHight;
    } else {
        return StoreDetailCellHight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.storeIntro.goodscount != 0) {
            return StoreSectionViewH;
        } else {
            return 0;
        }
    } else if (section == 2) {
        return StoreSectionViewH;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 && self.storeCommentFrames.count == 0) {
        return 60;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StoreSectionView *storeSectionView = [[StoreSectionView alloc] init];
    if (section == 1) {
        storeSectionView.string = [NSString stringWithFormat:@"     特卖(%d)", self.storeIntro.goodscount];
    } else if (section == 2) {
        storeSectionView.string = [NSString stringWithFormat:@"     评价(%d)", self.storeIntro.commentscount];
    }
    return storeSectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2 && self.storeIntro.commentscount == 0) {
        return [[StoreNoCommentView alloc] init];
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        StoreGoodsDetailViewController *storeGoodsDetailViewController = [[StoreGoodsDetailViewController alloc] init];
        storeGoodsDetailViewController.userid = self.storeIntro.userid;
        StoreGoods *storeGoods = self.storeIntro.goods[indexPath.row];
        storeGoodsDetailViewController.goodsid = storeGoods.goodsid;
        
        [self.navigationController pushViewController:storeGoodsDetailViewController animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = StoreSectionViewH;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        [self.storeViewNavBar setBgViewAlpha:0];
    } else {
        CGFloat alpha = 1 - ((120 - offset)/120);
        [self.storeViewNavBar setBgViewAlpha:alpha];
    }
}
@end
