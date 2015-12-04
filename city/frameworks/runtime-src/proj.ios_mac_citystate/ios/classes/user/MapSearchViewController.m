//
//  MapSearchViewController.m
//  citystate
//
//  Created by 石头人工作室 on 15/11/4.
//
//

#import "MapSearchViewController.h"
#import "CTSearchBox.h"

//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#define k_cell_head_height 35
#define k_cell_row_height 50

//@interface AddrInfo : NSObject
//
//@end

@interface MapSearchViewController ()<BMKMapViewDelegate, BMKSuggestionSearchDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CTSearchBoxDelegate>
@property(nonatomic, strong) BMKMapView*  mapView;
@property(nonatomic, strong) BMKSuggestionSearch* searcher;
@property(nonatomic, strong) UIView *searchView;
@property(nonatomic, strong) UITableView *searchTable;
@property(nonatomic, strong) UITextField *textView;
@property(nonatomic, strong) CTSearchBox *searchBar;

@property(nonatomic, strong) NSArray *keyList;
@property(nonatomic, strong) NSArray *districtList;
@property(nonatomic, strong) NSArray *cityList;
@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家地址";
    
    
    
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    self.view = _mapView;
    
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_searchView];
    
    _searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _searchTable.delegate = self;
    _searchTable.dataSource = self;
    [_searchView addSubview:_searchTable];
    
//    _textView = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    [_textView setBackgroundColor:UIColorFromRGB(0x00ff00, 1.0f)];
//    [_textView setBorderStyle:UITextBorderStyleRoundedRect];
//    _textView.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    _searchBar = [[CTSearchBox alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;

    
//    [_searchView addSubview:_searchBar];
//    [self.view addSubview:_searchBar];
//    [_searchView addSubview:_textView];
    
    //初始化检索对象
    _searcher = [[BMKSuggestionSearch alloc]init];
    _searcher.delegate = self;
    [self search:@"中关村"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//    [self setCocosResume];
    
    _searcher.delegate = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
//    [super dealloc];
//    if (_mapView) {
//        _mapView = nil;
//    }
}

- (void)search :(NSString *)keyWord{
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = @"北京";
    option.keyword  = keyWord;
    BOOL flag = [_searcher suggestionSearch:option];
//        [option release];
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }

}

- (void) setSearchControllerHidden:(BOOL)hidden {
//    NSInteger height = hidden ? 0: 180;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
    
//    NSString *strText = _searchBar.text;
//    [self search:strText];
    
//    [_searchController.view setFrame:CGRectMake(30, 36, 200, height)];
//    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理常结果
        NSLog(@"搜索到结果。。。");
        _keyList = result.keyList;
        _districtList = result.districtList;
        _cityList = result.cityList;
        [_searchTable reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@".....1");
    return _keyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@".....2");
    return k_cell_row_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@".....3");
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalloutViewCell"];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _keyList[indexPath.row];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 25)];
    [cell addSubview:label];
    NSString *strInfo =[ NSString stringWithFormat:@"%@-%@",_cityList[indexPath.row] , _districtList[indexPath.row] ];
    label.text = strInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1 && indexPath.row == 2) {
//        EditStoreCategoryViewController *editStoreCategoryViewController = [[EditStoreCategoryViewController alloc] init];
//        editStoreCategoryViewController.title = @"店铺分类";
//        [self.navigationController pushViewController:editStoreCategoryViewController animated:YES];
//    }
//    else if (indexPath.section == 1 && indexPath.row == 0) {
//        //        cocos2d::Director::getInstance()->pause();
//        //        [s_sharedApplication applicationDidBecomeActive :nil];
//        [self setCocosPause];
//        MapSearchViewController* vc = [[MapSearchViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        
//        EditCalloutViewController * vc = [[EditCalloutViewController alloc]init];
//        NSArray * texts = [self getTextsWithSection:indexPath.section row:indexPath.row];
//        if (texts.count >= 3) {
//            vc.titleName = [texts objectAtIndex:0];
//            vc.placeHolder = [NSString stringWithFormat:@"输入%@", vc.titleName];
//            vc.defaultText = [texts objectAtIndex:1];
//            vc.postKey = [texts objectAtIndex:2];
//            vc.postUrl = k_api_user_updatebrief;
//        }
//        vc.passValueDelegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

////搜索框中的内容发生改变时 回调（即要搜索的内容改变）
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    NSLog(@"changed");
//    if (_searchBar.text.length == 0) {
//        [self setSearchControllerHidden:YES]; //控制下拉列表的隐现
//    }else{
//        [self setSearchControllerHidden:NO];
//        
//    }
//}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    NSLog(@"did end");
////    searchBar.showsCancelButton = NO;
//    
//}
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    searchBar.showsCancelButton = YES;
//    for(id cc in [searchBar subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消"  forState:UIControlStateNormal];
//        }
//    }
//    NSLog(@"shuould begin");
//    return YES;
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    searchBar.text = @"";
//    NSLog(@"did begin");
//}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"search clicked");
//    
//    NSString *strText = _searchBar.text;
//    [self search:strText];
//}

- (void)searchBar:(CTSearchBox *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"1111");
}

//- (BOOL)searchBar:(CTSearchBox *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"2222");
//    return NO;
//}

- (void)searchBarSearchButtonClicked:(CTSearchBox *)searchBar
{
    NSString *strText = [_searchBar getSearchContent];
    NSLog(@"3333,%@", strText);
    [self search:strText];
}

- (void)searchBarCancelButtonClicked:(CTSearchBox *)searchBar
{
    NSLog(@"4444");
}


@end
