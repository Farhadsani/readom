//
//  SocialIndexViewController.m
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import "SocialIndexViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "BuddyStatusUser.h"
#import "SocialIndexCell.h"
#import "CocosViewController.h"

@interface SocialIndexViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *buddyStatusUserArr;
@end

@implementation SocialIndexViewController

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

- (NSMutableArray *)buddyStatusUserArr
{
    if (!_buddyStatusUserArr) {
        _buddyStatusUserArr = [NSMutableArray array];
    }
    return _buddyStatusUserArr;
}

- (void)loadMore
{
    if (self.buddyStatusUserArr.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.buddyStatusUserArr.count limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params;
    if (self.categoryid == 0) {
        params = @{@"tagid":@(self.tagid),
                  @"areaid":@(self.areaid),
                  @"begin":@(begin),
                  @"limit":@(limit)
                  };
    } else {
        params = @{@"categoryid":@(self.categoryid),
                   @"areaid":@(self.areaid),
                   @"begin": @(begin),
                   @"limit": @(limit)
                   };
    }
   
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.buddyStatusUserArr removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self.buddyStatusUserArr addObjectsFromArray:[BuddyStatusUser objectArrayWithKeyValuesArray:[result objectOutForKey:@"res"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (self.buddyStatusUserArr.count == 0) {
                self.tableView.tableHeaderView.hidden = YES;
            } else {
                self.tableView.tableHeaderView.hidden = NO;
            }
        });
        
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"该景点暂无游客",
                            k_ListCount:num(self.buddyStatusUserArr.count),
                            }];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
        [self showTipView:@{k_ToView:self.tableView,
                            k_ShowMsg:@"该景点暂无游客",
                            k_ListCount:num(self.buddyStatusUserArr.count),
                            }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buddyStatusUserArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SocialIndexCell *cell = [SocialIndexCell cellForTableView:tableView];
    cell.buddyStatusUser = self.buddyStatusUserArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];

    UIView *line1 = [cell viewWithTag:9999];
    UIView *line2 = [cell viewWithTag:9998];
    [line1 removeFromSuperview];
    [line2 removeFromSuperview];
    if (indexPath.row == (_buddyStatusUserArr.count ==0 ) ) {
        UIView * line =  [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Height:@0.5,
                                            V_BGColor:k_defaultLineColor,
                                            }];
        line.tag = 9999;
        [cell.contentView addSubview:line];
    }
    if (indexPath.row == _buddyStatusUserArr.count -1 ) {
        UIView * line =  [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Margin_Top:@56,
                                            V_Height:@0.5,
                                            V_BGColor:k_defaultLineColor,
                                            }];
        line.tag = 9998;
        [cell.contentView addSubview:line];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SocialIndexCellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusUser *user = self.buddyStatusUserArr[indexPath.row];
    
    BuddyItem *buddyItem = [BuddyItem buddyItemWithBuddyStatusUser:user];
    //跳转到有Cocos个人中心页面，需要先调用该函数刷新数据
    [self toCocos:buddyItem.userid :buddyItem.name :buddyItem.intro :buddyItem.zone :buddyItem.thumblink :buddyItem.imglink];
    //再push到viewController
    CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
    vc.userid = user.userid;
    vc.buddyItem = buddyItem;
    [[CocosManager shared] addCocosMapView:vc];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action such as: click touch tap slip ...
- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
    [self backToMapIndex:0];
}

#pragma mark - init & dealloc
- (void)setupMainView
{
//    self.contentView.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.frame = CGRectMake(0, 10, self.contentView.width, self.contentView.height - 10);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    UIView *tableViewHeaderView = [[UIView alloc] init];
    CGRect frame = tableViewHeaderView.frame;
    frame.size.height = 0.6;
    tableViewHeaderView.frame = frame;
    tableViewHeaderView.backgroundColor = lightgray_color;
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableViewFooterView;
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}
@end
