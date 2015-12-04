//
//  MyStoreGoodsEditViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/30.
//
//

#import "MyStoreGoodsEditViewController.h"
#import "MyStoreGoodsEditCell.h"
#import "MyStoreGoodsSelectImgView.h"
#import "ZYQAssetPickerController.h"
#import "MyStoreGoodsEditNameRuleViewController.h"
#import "MyStoreGoodsEditDayViewController.h"
#import "MyStoreGoodsEditTimeViewController.h"
#import "MyStoreGoodsEditPriceViewController.h"

@interface MyStoreGoodsEditViewController () <UITableViewDataSource, UITableViewDelegate, MyStoreGoodsSelectImgViewDelegate, UIActionSheetDelegate, ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *descArr;
@property (nonatomic, weak) MyStoreGoodsSelectImgView *myStoreGoodsSelectImgView;
@end

@implementation MyStoreGoodsEditViewController
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"特卖券描述", @"有效期", @"使用时间", @"使用规则", @"价格(单位元)"];
    }
    return _titleArr;
}

- (NSMutableArray *)descArr
{
    if (!_descArr) {
        _descArr = [NSMutableArray arrayWithCapacity:5];
    }
    _descArr[0] = [self nillStr:self.storeGoodsDetail.name];
    NSString *str1 = [self.storeGoodsDetail.startdate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *str2 = [self.storeGoodsDetail.enddate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    _descArr[1] = self.storeGoodsDetail.startdate.length == 0 ? @"" : [NSString stringWithFormat:@"%@-%@", str1, str2];
    _descArr[2] = self.storeGoodsDetail.starttime.length == 0 ? @"" : [NSString stringWithFormat:@"%@-%@", self.storeGoodsDetail.starttime, self.storeGoodsDetail.endtime];
    _descArr[3] = [self nillStr:self.storeGoodsDetail.rule];
    _descArr[4] = [self nillStr:self.storeGoodsDetail.price];
    return _descArr;
}

- (NSString *)nillStr:(NSString *)str
{
    return str.length == 0 ? @"" : str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRightBackButtonItem:@"保存" img:nil del:self sel:@selector(clickRightItem:)];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    MyStoreGoodsSelectImgView *tableHeaderView = [MyStoreGoodsSelectImgView myStoreGoodsSelectImgView];
    self.myStoreGoodsSelectImgView = tableHeaderView;
    self.tableView.tableHeaderView = tableHeaderView;
    tableHeaderView.delegate = self;
    tableHeaderView.storeGoodsDetail = self.storeGoodsDetail;
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    CGRect frame = tableViewFooterView.frame;
    frame.size.height = 0.6;
    tableViewFooterView.frame = frame;
    tableViewFooterView.backgroundColor = lightgray_color;
    tableView.tableFooterView = tableViewFooterView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStoreGoodsEditCell *cell = [MyStoreGoodsEditCell cellForTableView:tableView];
    cell.title = self.titleArr[indexPath.row];
    cell.desc = self.descArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyStoreGoodsEditNameRuleViewController *myStoreGoodsEditNameRuleViewController = [[MyStoreGoodsEditNameRuleViewController alloc] init];
        myStoreGoodsEditNameRuleViewController.title = @"特卖券描述";
        myStoreGoodsEditNameRuleViewController.defaultValue = self.storeGoodsDetail.name;
        myStoreGoodsEditNameRuleViewController.changeValue = ^(NSString *newValue){
            self.storeGoodsDetail.name = newValue;
        };
        [self.navigationController pushViewController:myStoreGoodsEditNameRuleViewController animated:YES];
    } else if (indexPath.row == 1) {
        MyStoreGoodsEditDayViewController *myStoreGoodsEditDayViewController = [[MyStoreGoodsEditDayViewController alloc] init];
        myStoreGoodsEditDayViewController.storeGoodsDetail = self.storeGoodsDetail;
        myStoreGoodsEditDayViewController.title = @"有效期";
        [self.navigationController pushViewController:myStoreGoodsEditDayViewController animated:YES];
    } else if (indexPath.row == 2) {
        MyStoreGoodsEditTimeViewController *myStoreGoodsEditTimeViewController = [[MyStoreGoodsEditTimeViewController alloc] init];
        myStoreGoodsEditTimeViewController.storeGoodsDetail = self.storeGoodsDetail;
        myStoreGoodsEditTimeViewController.title = @"使用时间";
        [self.navigationController pushViewController:myStoreGoodsEditTimeViewController animated:YES];
    } else if (indexPath.row == 3) {
        MyStoreGoodsEditNameRuleViewController *myStoreGoodsEditNameRuleViewController = [[MyStoreGoodsEditNameRuleViewController alloc] init];
        myStoreGoodsEditNameRuleViewController.title = @"使用规则";
        myStoreGoodsEditNameRuleViewController.defaultValue = self.storeGoodsDetail.rule;
        myStoreGoodsEditNameRuleViewController.changeValue = ^(NSString *newValue){
            self.storeGoodsDetail.rule = newValue;
        };
        [self.navigationController pushViewController:myStoreGoodsEditNameRuleViewController animated:YES];
    } else if (indexPath.row == 4) {
        MyStoreGoodsEditPriceViewController *myStoreGoodsEditPriceViewController = [[MyStoreGoodsEditPriceViewController alloc] init];
        myStoreGoodsEditPriceViewController.storeGoodsDetail = self.storeGoodsDetail;
        [self.navigationController pushViewController:myStoreGoodsEditPriceViewController animated:YES];
    }
}

#pragma mark - MyStoreGoodsSelectImgViewDelegate
- (void)myStoreGoodsSelectImgViewAddBtnDidOnClik:(MyStoreGoodsSelectImgView *)view
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if (buttonIndex == 0) {
        [self selectPhotosFromLib];
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor clearColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)selectPhotosFromLib
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (![[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            return YES;
        } else {
            return NO;
        }
    }];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i = 0; i < assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        self.myStoreGoodsSelectImgView.image = [UIImage scaleAndRotateImage:tempImg andMaxImageHeight:800];
        //获取图片裁剪的图
        UIImage *thumb = [UIImage scaleAndRotateImage:tempImg andMinImageWidth:68];
        self.myStoreGoodsSelectImgView.thumb = thumb;
        // 清空原有图片
        self.storeGoodsDetail.imglink = @"";
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString*)kUTTypeImage] ) {
        if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            //获取照片的原图
            UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
            self.myStoreGoodsSelectImgView.image = [UIImage scaleAndRotateImage:original andMaxImageHeight:800];
            //获取图片裁剪的图
            UIImage *thumb = [UIImage scaleAndRotateImage:original andMinImageWidth:68];
            self.myStoreGoodsSelectImgView.thumb = thumb;
            // 清空原有图片
            self.storeGoodsDetail.imglink = @"";
            }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (Boolean)checkValue:(NSString *)str
{
    return str.length == 0;
}

- (void)clickRightItem:(id)sender
{
    if ([self checkValue:self.storeGoodsDetail.name] || [self checkValue:self.storeGoodsDetail.oprice] || [self checkValue:self.storeGoodsDetail.price] || [self checkValue:self.storeGoodsDetail.startdate] || [self checkValue:self.storeGoodsDetail.enddate] || [self checkValue:self.storeGoodsDetail.starttime] || [self checkValue:self.storeGoodsDetail.endtime] || [self checkValue:self.storeGoodsDetail.rule]) {
        [self showMessageView:@"请添加完整信息!"  delayTime:3.0];
        return;
    }
    NSDictionary * params = @{@"goodsid":@(self.storeGoodsDetail.goodsid),
                              @"name":self.storeGoodsDetail.name,
                              @"oprice":self.storeGoodsDetail.oprice,
                              @"price":self.storeGoodsDetail.price,
                              @"startdate":self.storeGoodsDetail.startdate,
                              @"enddate":self.storeGoodsDetail.enddate,
                              @"starttime":self.storeGoodsDetail.starttime,
                              @"endtime":self.storeGoodsDetail.endtime,
                              @"rule":self.storeGoodsDetail.rule,
                              @"holidaysvalidate":@(self.storeGoodsDetail.holidaysvalidate)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    if (self.myStoreGoodsSelectImgView.image != nil) {
        NSDictionary * d = @{k_r_url:self.url,
                             k_r_reqApiType:num(AFReqApi),
                             k_r_delegate:self,
                             k_r_postData:dict,
                             k_r_attchData:self.myStoreGoodsSelectImgView.image,
                             };
        [[ReqEngine shared] tryRequest:d];
    }  else if (self.storeGoodsDetail.imglink.length > 0) {
        NSDictionary * d = @{k_r_url:self.url,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
    } else {
        [self showMessageView:@"请添加一张图片!"  delayTime:3.0];
    }
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.url]) {
        if (self.back) {
            self.back(self.storeGoodsDetail);
        }
        if (self.addBackBlock) {
            self.addBackBlock(self.storeGoodsDetail);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.url]) {
        InfoLog(@"error:%@", error);
    }
}
@end
