//
//  StreetListInAreaViewController.m
//  citystate
//
//  Created by hf on 15/11/17.
//
//

#import "StreetListInAreaViewController.h"

@interface StreetListInAreaViewController (){
    UIView * rightNavView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray * streetList;
@property (nonatomic, retain) NSIndexPath * selectedIndexPath;

@end

#define k_cell_height 45

@implementation StreetListInAreaViewController

- (void)variableInit{
    [super variableInit];
    self.streetList = [[[NSMutableArray alloc] init] autorelease];
}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightNavView = [self setupRightBackButtonItem:@"完成" img:nil del:self sel:@selector(requestUpdateUserAddress)];
    rightNavView.userInteractionEnabled = NO;
    rightNavView.alpha = 0.5;
    
    [self setupMainView];
    
    [self requestStreetListInArea];
}

#pragma mark - delegate (CallBack)

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_streetList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return k_cell_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"streetCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"streetCell"];
    }
    CGFloat h = [self tableView:tableView heightForRowAtIndexPath:indexPath];
//    [cell.contentView removeAllSubviews];
    cell.frame = CGRectMake(0, 0, tableView.width, h);
    
    AreaStreetItem * item = [_streetList objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[AreaStreetItem class]]) {
        cell.textLabel.text = item.name;
        cell.textLabel.font = [UIFont fontWithName:k_defaultFontName size:15.0];
        cell.textLabel.textColor = k_defaultTextColor;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if (_selectedIndexPath) {
        [[tableView cellForRowAtIndexPath:_selectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [tableView cellForRowAtIndexPath:_selectedIndexPath].accessoryView = [UIView imageView:@{V_Parent_View:cell.contentView,
                                                 V_Frame:rectStr(0, 0, 0, 0),
                                                 V_Img:@"",
                                                 V_ContentMode:num(ModeCenter),
                                                 }];
        [_selectedIndexPath release];
        _selectedIndexPath = nil;
    }
    _selectedIndexPath = [indexPath retain];
    [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [tableView cellForRowAtIndexPath:_selectedIndexPath].accessoryView = [UIView imageView:@{V_Parent_View:cell.contentView,
                                             V_Frame:rectStr(0, 0, 20, 20),
                                             V_Img:@"selectedIcon",
                                             V_ContentMode:num(ModeCenter),
                                             }];
    
    AreaStreetItem * item = [_streetList objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[AreaStreetItem class]]) {
        self.streetItem = item;
        
        rightNavView.userInteractionEnabled = YES;
        rightNavView.alpha = 1;
    }
}

#pragma mark request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_street_list]) {
        NSArray * res = [result objectOutForKey:@"res"];
        
        if (!_streetList) {
            self.streetList = [[[NSMutableArray alloc] init] autorelease];
        }
        [_streetList removeAllObjects];
        
        for (NSDictionary * inf in res) {
            AreaStreetItem * item = [[[AreaStreetItem alloc] init] autorelease];
            item = [AreaStreetItem objectWithKeyValues:inf];
            [_streetList addObject:item];
//            [item release];
        }
        [self reloadTableData];
        
        [self showTipView:@{k_ToView:self.contentView,
                            k_ShowMsg:@"数据发生错误（没有找到街道）~",
                            k_ListCount:num(self.streetList.count),
                            }];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_updatebrief]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(VC:didSelectedLocation:streetInfo:)]) {
            [self.delegate VC:self didSelectedLocation:self.selectePoi streetInfo:self.streetItem];
        }
        
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController * vc = [self.navigationController.viewControllers objectAtExistIndex:index-2];
        if (vc) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_street_list]) {
        [self showTipView:@{k_ToView:self.contentView,
                            k_ShowMsg:@"网络发生错误啦~",
                            k_ListCount:num(self.streetList.count),
                            }];
    }
}

#pragma mark other delegate

#pragma mark - action such as: click touch tap slip ...

#pragma mark - request method

- (void)requestStreetListInArea{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"lat":strDouble(self.selectePoi.pt.latitude),
                              @"lng":strDouble(self.selectePoi.pt.longitude),
                              };
    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_street_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)requestUpdateUserAddress{
    if (self.selectePoi && self.streetItem) {
        NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                                  @"address":self.selectePoi.address,
                                  @"lat":strDouble(self.selectePoi.pt.latitude),
                                  @"lng":strDouble(self.selectePoi.pt.longitude),
                                  @"streetid":self.streetItem.streetid,
                                  };
        NSDictionary * dict = @{@"idx":str(0),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = @{k_r_url:k_api_store_manage_updatebrief,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
    }
    else{
        [self showMessageView:@"请选择街道后再提交" delayTime:3.0];
    }
}

#pragma mark - init & dealloc
- (void)setupMainView{
    if (!_streetList) {
        self.streetList = [[[NSMutableArray alloc] init] autorelease];
    }
    
    CGFloat y = 5;
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, y, self.contentView.width, self.contentView.height-y) style:UITableViewStylePlain] autorelease];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setSeparatorColor:[UIColor color:k_defaultLineColor]];
    [_tableView setBackgroundColor:[UIColor color:clear_color]];
    [self.contentView addSubview:_tableView];
}

- (void)reloadTableData{
    CGFloat y = _tableView.y;
    if (_streetList.count*k_cell_height >= self.contentView.height-y) {
        _tableView.frame = CGRectMake(_tableView.x, _tableView.y, _tableView.width, self.contentView.height-y);
    }
    else{
        _tableView.frame = CGRectMake(_tableView.x, _tableView.y, _tableView.width, _streetList.count*k_cell_height);
    }
    
    [_tableView reloadData];
}


- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark

@end
