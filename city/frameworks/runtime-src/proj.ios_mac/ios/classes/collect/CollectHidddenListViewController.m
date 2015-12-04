//
//  CollectHidddenListViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/6.
//
//

/*
 *【隐藏动态】界面
 *功能：展示隐藏动态列表
 *取消隐藏动态
*/

#import "CollectHidddenListViewController.h"
#import "PersonalTopicViewController.h"

@interface CollectHidddenListViewController () {
    
}

@property (assign, atomic)    int index;
@property (nonatomic, retain) UITableView * listTableView;
@property (nonatomic, retain) NSMutableArray * collectCellList;//需要取消隐藏的列表

@end

@implementation CollectHidddenListViewController

#pragma mark - life Cycle
- (void)variableInit{
    [super variableInit];
    _index = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"隐藏动态";
    
    [self setupMainView];
    
    [self requestList];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hiddenSelectedView];
}

#pragma mark - delegate (CallBack)

#pragma mark CollectCellDelegate

- (void)beginSelectedCollectCell:(CollectCell *)CollectCell{
    if (!_collectCellList) {
        self.collectCellList = [[NSMutableArray alloc] init];
    }
    if (CollectCell.uiBtnSelect.selected) {
        if (![_collectCellList containsObject:CollectCell]) {
            [_collectCellList addNonEmptyObject:CollectCell];
        }
    }
    else{
        if ([_collectCellList containsObject:CollectCell]) {
            [_collectCellList removeObject:CollectCell];
        }
    }
    
    NSArray * arr = @[@"取消隐藏",@"取消"];
    _listTableView.frame = CGRectMake(_listTableView.x, _listTableView.y, _listTableView.width, kScreenHeight-64-60*[arr count]);
    
    [self showConfirmSelectedView:arr SEL:@selector(clickSelectedItem:) hasBackColor:NO clickBackDismiss:NO animation:YES];
}

- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    _listTableView.frame = CGRectMake(_listTableView.x, _listTableView.y, _listTableView.width, kScreenHeight-64);
    
    if ([(UIView *)sender tag] == 0) {
        if ([NSArray isNotEmpty:_collectCellList]) {
            [self requestCancelCollect];
        }
    }
    else if ([(UIView *)sender tag] == 1){
        if ([NSArray isNotEmpty:_collectCellList]) {
            for (CollectCell * cell in _collectCellList) {
                cell.uiBtnSelect.selected = NO;
            }
        }
    }
}

- (void)requestCancelCollect
{
    InfoLog(@"");
    
    NSArray *arr = [_collectCellList valueForKeyPath:@"dataItem.feedID"];
    
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"feedid":arr,
                              @"hide":@0,
                              };
    NSDictionary * dict = @{@"idx":str(1),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_hide_set,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark request
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_list]) {
        NSArray * res = [result objectOutForKey:@"res"];
        if (res) {
            [self.data_dict setNonEmptyObject:res forKey:@"res"];
            [_listTableView reloadData];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_hide_set]) {
        NSMutableArray * list = [[NSMutableArray alloc] initWithArray:[self.data_dict objectOutForKey:@"res"]];
        for (CollectCell * cell in _collectCellList) {
            for (NSDictionary *dict in [self.data_dict objectOutForKey:@"res"]) {
                if ([dict[@"feedid"] intValue] == cell.dataItem.feedID.intValue) {
                    [list removeObject:dict];
                }
            }
        }
        
        [self.data_dict setObject:list forKey:@"res"];
        [list release];
        
        NSMutableArray * tmp = [[NSMutableArray alloc] init];
        for (CollectCell * cell in _collectCellList) {
            [tmp addNonEmptyObject:cell.indexPath];
        }
        [_listTableView deleteRowsAtIndexPaths:tmp withRowAnimation:UITableViewRowAnimationFade];
        [_listTableView reloadData];
        [tmp release];
        
        [_collectCellList removeAllObjects];
        
        [[Cache shared] setNeedRefreshData:3 value:1];
    }
    
    [self showTipView:@{k_ToView:_listTableView,
                        k_ShowMsg:@"没有隐藏的内容了~",
                        k_ListCount:num([self.data_dict[@"res"] count]),
                        }];
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_list]) {
        InfoLog(@"error:%@", error);
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_hide_set]) {
        
    }
    
    [self showTipView:@{k_ToView:_listTableView,
                        k_ShowMsg:@"出错了，请重新尝试~",
                        k_ListCount:num([self.data_dict[@"res"] count]),
                        }];
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectCell *cell = (CollectCell*)[tableView dequeueReusableCellWithIdentifier:@"CollectCell"];
    if (cell == nil) {
        cell = [[[CollectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CollectCell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
//    else{
//        return cell;
//    }
    
    [cell.contentView removeAllSubviews];
    CGFloat h = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor color:clear_color];
    
    CollectItem * item = [[CollectItem alloc] initWithData:[[self.data_dict objectOutForKey:@"res"] objectAtExistIndex:indexPath.row]];
    cell.canEdit = YES;
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

#pragma mark - action such as: click touch tap slip ...

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUserData:(long)userID{
    userid = userID;
}

- (void)requestList{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"begin":@0,
                              @"limit":@20,
                              @"hide":@1,
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_list,
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
}

#pragma mark - other method
- (void)baseBack:(id)sender{
//    [self getOff];
    [self baseDeckAndNavBack];
    if( callback ){
        callback( 0 );
    }
}

@end
