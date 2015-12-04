//
//  MapLocationViewController.m
//  citystate
//
//  Created by hf on 15/10/19.
//
//

#import "MapLocationViewController.h"
#import "CTSearchBox.h"

#define k_cell_height 55

@interface MapLocationViewController () <BMKPoiSearchDelegate, MHTextFieldDelegate, BMKGeoCodeSearchDelegate, CTSearchBoxDelegate>{
    UITextField * searchKeyField;
    UIButton * cancelSearchButton;
    CTSearchBox *searchBar;
}

@property (nonatomic, assign) int index;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray * placeList;

@property (nonatomic, retain) BMKPoiSearch * searcher;
@property (nonatomic, retain) BMKGeoCodeSearch * geoCodeSearch;

@end

@implementation MapLocationViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    
    searchBar = [[CTSearchBox alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索你的位置";
    searchBar.cancelBtnName = @"下一步";
    searchBar.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44);
    self.navigationItem.titleView = searchBar;
    
    [self setupMainView];
    [self initPoiSearchServer];
    
    [self surroundQuery];//初始化：周边查询
}

- (void)viewWillDisappear:(BOOL)animated{
    _searcher.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    _searcher.delegate = self;
    [super viewWillAppear:animated];
}

#pragma mark - delegate (CallBack)

#pragma mark MHTextFieldDelegate

- (void)textFieldDidBeginEditing:(MHTextField *)textField notify:(NSNotification *)notify{
    [self doBeginSearch];
}
- (void)textFieldDidEndEditing:(MHTextField *)textField notify:(NSNotification *)notify{
}
- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
    [self doFuzzyQuery:textField.text];
}
- (void)textFieldDidClickReturn:(MHTextField *)textField{
    [textField resignFirstResponder];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_placeList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return k_cell_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeTagCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"placeTagCell"];
    }
    CGFloat h = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    cell.frame = CGRectMake(0, 0, tableView.width, h);
    
    ///POI列表，成员是BMKPoiInfo
    if ([[_placeList objectAtIndex:indexPath.row] isKindOfClass:[BMKPoiInfo class]]) {
        UILabel * labName = [UIView label:@{V_Parent_View:cell.contentView,
                                            V_Height:numFloat(h/2.0),
                                            V_Margin_Left:@10,
                                            V_Margin_Top:@5,
                                            V_Color:k_defaultTextColor,
                                            V_Font_Family:k_defaultFontName,
                                            V_Font_Size:@16,
                                            V_Text:((BMKPoiInfo *)[_placeList objectAtIndex:indexPath.row]).name
                                            }];
        [cell.contentView addSubview:labName];
        
        UILabel * addName = [UIView label:@{V_Parent_View:cell.contentView,
                                            V_Last_View:labName,
                                            V_Margin_Left:@10,
                                            V_Height:numFloat(h/2.0-10),
                                            V_Font_Family:k_defaultFontName,
                                            V_Color:k_defaultLightTextColor,
                                            V_Font_Size:@13,
                                            V_Text:((BMKPoiInfo *)[_placeList objectAtIndex:indexPath.row]).address
                                            }];
        [cell.contentView addSubview:addName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    ///POI列表，成员是BMKPoiInfo
    BMKPoiInfo * poi = [_placeList objectAtIndex:indexPath.row];
    if ([poi isKindOfClass:[BMKPoiInfo class]]) {
        
        [searchBar resignTextField];
        
        self.selectePoi = poi;
        
        StreetListInAreaViewController * vc = [[StreetListInAreaViewController alloc] initWithNibName:nil bundle:nil];
        vc.title = @"详细街道";
        vc.selectePoi = self.selectePoi;
        if (self.delegate) {
            vc.delegate = self.delegate;
        }
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

#pragma mark PoiSearchDeleage
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
//        InfoLog(@"%@", poiResultList.poiInfoList);
        if ([NSArray isNotEmpty:poiResultList.poiInfoList]) {
            [_placeList removeAllObjects];
            [_placeList addObjectsFromArray:poiResultList.poiInfoList];
            [self reloadTableData];
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        //result.cityList;
        InfoLog(@"起始点有歧义");
    }
    else {
        InfoLog(@"抱歉，未找到结果");
    }
}

#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    InfoLog(@"address%@", result.address);
    
    if (result.address) {
        [UserManager sharedInstance].address = result.address;
    }
    if (result.addressDetail.city) {
        [UserManager sharedInstance].city = result.addressDetail.city;
    }
    
    [[LoadingView shared] hideLoading];
    if (error == BMK_SEARCH_NO_ERROR) {
        InfoLog(@"city:%@", result.addressDetail.city);
        if (result.poiList) {
            [_placeList removeAllObjects];
            [_placeList addObjectsFromArray:result.poiList];///地址周边POI信息，成员类型为BMKPoiInfo
            [self reloadTableData];
        }
    }
}

#pragma mark - action such as: click touch tap slip ...

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [searchBar resignTextField];
    [super clickLeftBarButtonItem];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark search method

- (void)cancelSearch:(UIButton *)sender{
    searchKeyField.text = @"";
    [searchKeyField resignFirstResponder];
    [searchBar resignTextField];
    [self doEndSearch];
    [self surroundQuery];//初始化：周边查询
}

- (void)doBeginSearch{
    if (cancelSearchButton.alpha >= 0.5) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchKeyField.frame = CGRectMake(searchKeyField.x, searchKeyField.y, searchKeyField.width - cancelSearchButton.width, searchKeyField.height);
        cancelSearchButton.frame = CGRectMake(cancelSearchButton.x - cancelSearchButton.width, cancelSearchButton.y, cancelSearchButton.width, cancelSearchButton.height);
        cancelSearchButton.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)doEndSearch{
    if (cancelSearchButton.alpha == 0) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchKeyField.frame = CGRectMake(searchKeyField.x, searchKeyField.y, searchKeyField.width + cancelSearchButton.width, searchKeyField.height);
        cancelSearchButton.frame = CGRectMake(cancelSearchButton.x + cancelSearchButton.width, cancelSearchButton.y, cancelSearchButton.width, cancelSearchButton.height);
        cancelSearchButton.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

//模糊查询list
- (void)doFuzzyQuery:(NSString *)key{
    if ([NSString isEmptyString:key]) {
        return;
    }
    
    //模糊查询
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 30;
    citySearchOption.city = [UserManager sharedInstance].city;
    citySearchOption.keyword = key;
    BOOL flag = [_searcher poiSearchInCity:citySearchOption];
    [citySearchOption release];
    if(!flag){
        InfoLog(@"模糊查询失败");
    }
}

- (void)surroundQuery{
    //周边查询
    if (![NSString isLocationInChina:[UserManager sharedInstance].pt]) {
        return;
    }
    
    [[LoadingView shared] showLoading:nil message:nil];
    
    [self createGeoCodeSearch];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = [UserManager sharedInstance].pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];//反向编码（经纬度转换成地理位置）
    
    [[LoadingView shared] showLoading:nil message:nil];
    
    [reverseGeocodeSearchOption release];
    
    if(!flag){
        NSLog(@"反geo检索发送失败");
        [[LoadingView shared] hideLoading];
    }
}

#pragma mark - init & dealloc
- (void)setupMainView{
    if (!_placeList) {
        self.placeList = [[[NSMutableArray alloc] init] autorelease];
    }
    
    CGFloat y = 5;
//    CGFloat lineHeight = k_cell_height;
    
//    UIView * back = [UIView view_sub:@{V_Parent_View:self.contentView,
//                                       V_Height:strFloat(lineHeight),
//                                       V_Margin_Top:strFloat(y),
//                                       V_BGColor:white_color,
//                                       }];
//    [self.contentView addSubview:back];
    
//    UIView * line = [UIView view_sub:@{V_Parent_View:back,
//                                       V_Margin_Top:strFloat(y),
//                                       V_Height:@0.5,
//                                       V_BGColor:k_defaultLineColor,
//                                       }];
//    [back addSubview:line];
    
//    searchKeyField = [UIView textFiled:@{V_Parent_View:back,
//                                         V_Last_View:line,
//                                         V_Margin_Left:strFloat(y),
//                                         V_Margin_Right:strFloat(y),
//                                         V_Placeholder:@"我的位置",
//                                         V_Font_Family:k_defaultFontName,
//                                         V_Font_Size:@16,
//                                         V_Color:k_defaultTextColor,
//                                         V_tintColor:k_defaultNavBGColor,
//                                         V_Delegate:self,
//                                         }];
//    [back addSubview:searchKeyField];
//    searchKeyField.clearButtonMode = UITextFieldViewModeNever;
    
//    cancelSearchButton = [UIView button:@{V_Parent_View:back,
//                                          V_Left_View:searchKeyField,
//                                          V_Last_View:line,
//                                          V_Margin_Left:@5,
//                                          V_Width:@60,
//                                          V_Img:@"chacha",
//                                          V_Font_Size:@14,
//                                          V_Color:k_defaultTextColor,
//                                          V_SEL:selStr(@selector(cancelSearch:)),
//                                          V_Delegate:self,
//                                          V_Alpha:@0,
//                                          }];
//    [back addSubview:cancelSearchButton];
//    cancelSearchButton.alpha = 0;
    
//    line = [UIView view_sub:@{V_Parent_View:back,
//                              V_Over_Flow_Y:num(OverFlowBottom),
//                              V_Height:@0.5,
//                              V_Margin_Left:@15,
//                              V_BGColor:k_defaultLineColor,
//                              }];
//    [back addSubview:line];
    
//    y = searchKeyField.y+searchKeyField.height+y;
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, y, self.contentView.width, self.contentView.height-y) style:UITableViewStylePlain] autorelease];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSeparatorColor:[UIColor color:k_defaultLineColor]];
    [_tableView setBackgroundColor:[UIColor color:clear_color]];
    [self.contentView addSubview:_tableView];
}

- (void)reloadTableData{
    if (_placeList.count > 0) {
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    else{
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    CGFloat y = searchKeyField.y+searchKeyField.height+y;
    if (_placeList.count*k_cell_height >= self.contentView.height-y) {
        _tableView.frame = CGRectMake(_tableView.x, _tableView.y, _tableView.width, self.contentView.height-y);
    }
    else{
        _tableView.frame = CGRectMake(_tableView.x, _tableView.y, _tableView.width, _placeList.count*k_cell_height);
    }
    
    [_tableView reloadData];
}

- (void)initPoiSearchServer{
    //初始化检索对象
    _searcher = [[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
}

- (void)createGeoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    }
    _geoCodeSearch.delegate = self;
}

- (void)dealloc{
    if (_searcher) {
        _searcher.delegate = nil;
        [_searcher release];
        _searcher = nil;
    }
    if (_geoCodeSearch) {
        _geoCodeSearch.delegate = nil;
        [_geoCodeSearch release];
        _geoCodeSearch = nil;
    }
    [super dealloc];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    InfoLog(@"");
    [searchBar resignTextField];
}

#pragma mark - other method
#pragma mark

- (void)searchBar:(CTSearchBox *)searchBar textDidChange:(NSString *)searchText
{
//    NSLog(@"1111");
    [self doFuzzyQuery:searchText];
}

//- (BOOL)searchBar:(CTSearchBox *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"2222");
//    return NO;
//}

- (void)searchBarSearchButtonClicked:(CTSearchBox *)searchBar
{
//    NSString *strText = [searchBar getSearchContent];
//    NSLog(@"3333");
//    [self search:strText];
}

- (void)searchBarCancelButtonClicked:(CTSearchBox *)searchBar
{
//    NSLog(@"4444");
}


@end
