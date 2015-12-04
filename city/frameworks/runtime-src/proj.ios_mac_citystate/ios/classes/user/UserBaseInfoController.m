//
//  UserBaseInfoController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

/*
 *[基本资料]页面
 *功能：显示用户的名称、个人简介
 * 登出帐号 功能
 */

#import "UserBaseInfoController.h"
#import "UserManager.h"
#import "UIViewController+Addtion.h"
#import "EditCalloutViewController.h"
#import "MapSearchViewController.h"
#import "MapLocationViewController.h"

#import "NetWorkManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define MaxPhotosCount 5    //图片限制
#define NumInSection 4      //一排有几个图片
#define Space 10
#define PictureItemWidth ((kScreenWidth - (NumInSection+1)*Space) / NumInSection) //一张图片所占位置的大小
#define PictureItemHeight PictureItemWidth


#define k_cell_head_height 35
#define k_cell_row_height 50

@interface UserBaseInfoController ()<UITableViewDataSource,UITableViewDelegate,PassCalloutValueDelegate, MapLocationVCDelegate>{
    UIView * mainSection;
    
    UIScrollView * pictureBoardView;
    UIButton * addTitleButton;
    UICollectionView * uiThumbColl;
    
    NSMutableArray          *urls;
    NSMutableArray          *thumbs;
    NSMutableArray          *HDImages;
    
    int                     numInSection;               //一排有几个图片
    int                     postImgLimit;               //图片限制
}

@property (nonatomic, weak) UIButton * userIcon;        //用户头像
@property (nonatomic, weak) UIView * modifyView;        //修改头像

@property (nonatomic, weak) UIButton * logoutBtn;       //退出登录按钮
@property (nonatomic, weak) UILabel * fansLab;          //粉丝统计
@property (nonatomic, weak) UILabel * followLab;        //关注统计

@property (nonatomic, strong) UIImage * changedUserLogo; //临时保存用户修改的头像

@property (nonatomic, assign) int index;
@property (nonatomic, strong) UserBriefItem *   userBriefItem;
@property (nonatomic, strong) UITableView *     baseTabView;
@property (nonatomic, strong) NSMutableArray *  baseArray;
@property (nonatomic) BOOL editEnable;                  //当前页面是否可以编辑

@property (nonatomic) BOOL storePicturesChanged;        //判断商家相册是否发生修改

@property (nonatomic, assign) int imagePickTag;

@end

@implementation UserBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本资料";
    self.baseArray = [NSMutableArray array];
    
    self.storePicturesChanged = NO;
    
    if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
        self.userBriefItem = [UserManager sharedInstance].brief;
        self.editEnable = YES;
        [self setLogoutButton];
    }
    else{
        self.editEnable = NO;
    }
    
    [self setupMainView];
    
    [self requestGetUser];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self isStoreUser]) {
        [uiThumbColl reloadData];
        [self refresh];
    }
}

- (void)didChangeStoreCategory:(NSArray *)categorys{
    [UserManager sharedInstance].brief.categories = categorys;
    self.userBriefItem.categories = categorys;
    [[NSUserDefaults standardUserDefaults] setObject:[UserManager sharedInstance].brief.categories forKey:@"SHITOUREN_UD_CATEGORIES"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_baseTabView reloadData];
}

#pragma mark - PassCalloutValueDelegate
- (void)VC:(EditCalloutViewController *)vc passCalloutValue:(NSString *)value{
    InfoLog(@"%@  value:%@", vc.titleName, value);
    if (vc.titleName) {
        if ([vc.postKey isEqualToString:@"name"]) {
            self.userBriefItem.name = value;
        }else if ([vc.postKey isEqualToString:@"intro"]){
            self.userBriefItem.intro = value;
        }else if ([vc.postKey isEqualToString:@"address"]){
            self.userBriefItem.address = value;
        }else if ([vc.postKey isEqualToString:@"hobby"]){
            self.userBriefItem.hobby = value;
        }else if([vc.postKey isEqualToString:@"phone"]){
            self.userBriefItem.phone = value;
        }else if([vc.postKey isEqualToString:@"music"]){
            self.userBriefItem.music = value;
        }else if([vc.postKey isEqualToString:@"telephone"]){
            self.userBriefItem.telephone = value;
        }
        if (self.editEnable) {
            [[UserManager sharedInstance] updateUserData:self.userBriefItem];
        }
        [self.baseTabView reloadData];
    }
}

//#pragma mark MapLocationVCDelegate
//- (void)VC:(MapLocationViewController *)cell didSelectedLocation:(BMKPoiInfo *)poiInfo{
//    self.userBriefItem.address = poiInfo.address;
//    if (self.editEnable) {
//        [[UserManager sharedInstance] updateUserData:self.userBriefItem];
//    }
//    [_baseTabView reloadData];
//}

#pragma mark StreetListInAreaVCDelegate
- (void)VC:(StreetListInAreaViewController *)cell didSelectedLocation:(BMKPoiInfo *)poiInfo streetInfo:(AreaStreetItem *)streetItem{
    self.userBriefItem.address = poiInfo.address;
    if (self.editEnable) {
        [[UserManager sharedInstance] updateUserData:self.userBriefItem];
    }
    [_baseTabView reloadData];
}

#pragma mark - request delegate

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signout]) {
        [self showMessageView:@"您已退出登录!" delayTime:2.0];
        
        [[UserManager sharedInstance] signout];
        
        [self backAndRefresh];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        NSDictionary *res = result[@"res"];
        if (self.editEnable) {
            [[UserManager sharedInstance] updateUserData:res];
            self.userBriefItem = [UserManager sharedInstance].brief;
        }
        else{
            NSMutableDictionary * ms = [NSMutableDictionary dictionaryWithDictionary:res];
            if ([res objectForKey:@"role"]) {
                [ms setObject:[NSNumber numberWithInt:[res objectForKey:@"role"]] forKey:@"role"];
            }
            UserBriefItem *userBriefItem = [[UserBriefItem alloc] init];
            userBriefItem = [UserBriefItem objectWithKeyValues:res];
            self.userBriefItem = userBriefItem;
        }
        [self setupMainView];
        [self requestFansNum];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getbuddycount]){
        NSDictionary * res = result[@"res"];
        if (self.userBriefItem) {
            self.userBriefItem.fans = (int)[res[@"fans"] integerValue];
            self.userBriefItem.follow = (int)[res[@"follow"] integerValue];
        }
        self.fansLab.text = [NSString stringWithFormat:@"%d", (int)[res[@"fans"] integerValue]];
        self.followLab.text = [NSString stringWithFormat:@"%d", (int)[res[@"follow"] integerValue]];
        if (self.editEnable) {
            [[UserManager sharedInstance] updateUserData:res];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatehead]) {
        [[LoadingView shared] hideLoading];
        [MessageView showMessageView:@"保存成功" delayTime:2.0];
        
        if ([req.data_dict objectOutForKey:k_r_attchData]) {
            NSArray * arr = [req.data_dict objectOutForKey:k_r_attchData];
            if ([NSArray isNotEmpty:arr] && [[arr objectAtExistIndex:0] isKindOfClass:[UIImage class]]) {
                [self.userIcon setImage:(UIImage *)[arr objectAtExistIndex:0] forState:UIControlStateNormal];
            }
        }
        
        if (self.editEnable && [result objectForKey:@"res"] && [[result objectForKey:@"res"] isKindOfClass:[NSDictionary class]] && [[result objectForKey:@"res"] objectForKey:@"imglink"]) {
            [[UserManager sharedInstance] updateUserImageUrl:[[result objectForKey:@"res"] objectForKey:@"imglink"]];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_updateimgs]) {
        [[LoadingView shared] hideLoading];
        [MessageView showMessageView:@"保存成功" delayTime:2.0];
        
        [self doBack];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatehead] ||
        [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_updateimgs]) {
        [MessageView showMessageView:@"保存失败，请检查网络后重新上传" delayTime:3.0];
        [[LoadingView shared] hideLoading];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        
    }
}

#pragma mark - request method

- (BOOL)shouldRequestUserInf{
//    if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
//        if (![[UserManager sharedInstance] isStoreUser:[UserManager sharedInstance].brief]) {
//            if ([NSString isEmptyString:[UserManager sharedInstance].base.phone]) {
//                return YES;
//            }
//            if (![UserManager sharedInstance].userid || [UserManager sharedInstance].userid == 0) {
//                return YES;
//            }
//        }
//    }
    return NO;
}

- (void)requestGetUser{
//    if (!self.editEnable || [self shouldRequestUserInf]) {
        NSDictionary * params = @{@"userid":@(self.userid)
                                  };
        NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = @{k_r_url:k_api_user_getuser,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
//    }
//    else{
//        //[self setupMainView];
//        [self requestFansNum];
//    }
}
- (void)requestFansNum{
    NSDictionary * params = @{@"userid": @(self.userid)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_getbuddycount,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - action

- (void)logoutBtnOnClick:(UIButton *)button{
    [self showConfirmSelectedView:@[@"退出登录", @"取消"] action:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

- (void)clickSelectedItem:(UIButton *)button{
    [self hiddenSelectedView];
    if ([button.titleLabel.text isEqualToString:@"退出登录"]) {
        InfoLog(@"退出登录。。。");
        
        NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",self.userid],
                                  };
        NSDictionary * dict = @{@"idx":str(0),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = @{k_r_url:k_api_user_signout,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
    }
}

#pragma mark -

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    if (self.storePicturesChanged) {
        [self checkPostStorePintures];
    }
    else{
        [self doBack];
    }
}

- (void)doBack{
    [super clickLeftBarButtonItem];
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}

- (void)modifyIcon:(UIButton *)sender
{
    if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
        numInSection = NumInSection;
        postImgLimit = 1;
        [self showImagePicker:UserLogo_picker];
    } else {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.userBriefItem.imglink]; // 图片路径
        photo.srcImageView = sender.imageView;
        
        MJPhotoBrowser * browser = [[MJPhotoBrowser alloc]init];
        browser.currentPhotoIndex = 0;
        browser.photos = @[photo];
        [browser show];
    }
}

- (void)backAndRefresh{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        if ([self isStoreUser]) {
            return 3;
        }else {
            return 2;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return k_cell_row_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return k_cell_head_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self getHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalloutViewCell"];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.editEnable) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, k_cell_head_height),
                                                 V_Img:@"buddystatus_arrow",
                                                 V_ContentMode:num(ModeCenter),
                                                 }];
    }
    
    UIView * vi = [self getRowViewInSection:indexPath.section row:indexPath.row];
    if (vi) {
        [cell.contentView addSubview:vi];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if (!self.editEnable) {
        return;
    }
    
    if ([self isStoreUser] && indexPath.section == 1 && indexPath.row == 2) {
        EditStoreCategoryViewController *editStoreCategoryViewController = [[EditStoreCategoryViewController alloc] init];
        editStoreCategoryViewController.userid = self.userid;
        editStoreCategoryViewController.title = @"店铺分类";
        editStoreCategoryViewController.delegate = self;
        [self.navigationController pushViewController:editStoreCategoryViewController animated:YES];
    }
    else if ([self isStoreUser] && indexPath.section == 1 && indexPath.row == 0) {
        [self setCocosPause];
        MapLocationViewController* vc = [[MapLocationViewController alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        EditCalloutViewController * vc = [[EditCalloutViewController alloc]init];
        vc.userid = self.userid;
        NSArray * texts = [self getTextsWithSection:indexPath.section row:indexPath.row];
        if (texts.count >= 3) {
            vc.titleName = [texts objectAtIndex:0];
            vc.placeHolder = [NSString stringWithFormat:@"输入%@", vc.titleName];
            vc.defaultText = [texts objectAtIndex:1];
            vc.postKey = [texts objectAtIndex:2];
            
            if ([self isStoreUser]) {
                if (indexPath.section == 0) {
                    vc.postUrl = k_api_user_updatebrief;
                }
                else if (indexPath.section == 1) {
                    vc.postUrl = k_api_store_manage_updatebrief;
                }
            }
            else{
                if (indexPath.section == 0) {
                    vc.postUrl = k_api_user_updatebrief;
                }
                else if (indexPath.section == 1) {
                    vc.postUrl = k_api_user_updateother;
                }
            }
        }
        vc.passValueDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - view init
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    CGFloat bgH = self.contentView.height * 1/5;
    UIView * bgView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                         V_Width:strFloat(self.contentView.width),
                                         V_Height:strFloat(bgH),
                                         V_BGColor:white_color,
                                         V_Border_Color:k_defaultLineColor,
                                         V_Border_Width:@0.5,
                                         }];
    [self.contentView addSubview:bgView];
    
    CGFloat iconWH = 72;
    self.userIcon = [UIView button:@{V_Parent_View:bgView,
                                     V_Over_Flow_X:num(OverFlowXCenter),
                                     V_Over_Flow_Y:num(OverFlowYCenter),
                                     V_Margin_Top:@10,
                                     V_Width:strFloat(iconWH),
                                     V_Height:strFloat(iconWH),
                                     V_Border_Radius:strFloat(iconWH /2),
                                     V_SEL:selStr(@selector(modifyIcon:)),
                                     V_Delegate:self,
                                     V_Border_Color:k_defaultLineColor,
                                     V_Border_Width:@0.5,
                                     V_Border_Radius:strFloat(iconWH/2.0),
                                     V_Img:[[UserManager sharedInstance] getUserHeadLogo:self.userid brifItem:_userBriefItem],
                                     }];
    [bgView addSubview:_userIcon];
//    self.userIcon.userInteractionEnabled = self.editEnable;
    
    self.modifyView = [UIView button:@{V_Parent_View:_userIcon,
                                       V_Width:@16,
                                       V_Height:@16,
                                       V_Margin_Left:strFloat(_userIcon.width * 2/3),
                                       V_Margin_Top:strFloat(_userIcon.height * 2/3),
                                       V_BGImg:@"Modify_bg",
                                       }];
    [_userIcon addSubview:_modifyView];
    self.modifyView.hidden = !self.editEnable;
    
    CGFloat buttonW = (self.contentView.width - _userIcon.width)/2;
    UIView * lBtn = [UIView view_sub:@{V_Parent_View:bgView,
                                       V_Width:strFloat(buttonW),
                                       V_BGColor:white_color,
                                       }];
    [bgView addSubview:lBtn];
    
    
    CGFloat btnWH = 50;
    UIView * fView = [UIView view_sub:@{V_Parent_View:lBtn,
                                        V_Width:strFloat(btnWH),
                                        V_Height:strFloat(btnWH),
                                        V_Over_Flow_X:num(OverFlowXCenter),
                                        V_Over_Flow_Y:num(OverFlowYCenter),
                                        V_BGImg:@"fans_bg",
                                        }];
    [lBtn addSubview:fView];
    
    self.fansLab = [UIView label:@{V_Parent_View:fView,
                                   V_Width:strFloat(btnWH),
                                   V_Height:@20,
                                   V_Over_Flow_X:num(OverFlowXCenter),
                                   V_Over_Flow_Y:num(OverFlowYCenter),
                                   V_Font_Family:k_fontName_FZXY,
                                   V_Color:k_defaultTextColor,
                                   V_TextAlign:num(TextAlignCenter),
                                   }];
    if (self.userBriefItem) {
        self.fansLab.text = [NSString stringWithFormat:@"%d", (int)self.userBriefItem.fans];
    }
    [fView addSubview:_fansLab];
    
    UILabel * fansLal = [UIView label:@{V_Parent_View:lBtn,
                                        V_Last_View:fView,
                                        V_Text:@"粉丝",
                                        V_Color:k_defaultTextColor,
                                        V_Alpha:@0.5,
                                        V_Height:@20,
                                        V_Font_Family:k_fontName_FZXY,
                                        V_Font_Size:@11,
                                        V_TextAlign:num(TextAlignCenter),
                                        }];
    [lBtn addSubview:fansLal];
    
    UIView * rBtn = [UIView view_sub:@{V_Parent_View:bgView,
                                       V_Width:strFloat(buttonW),
                                       V_Left_View:_userIcon,
                                       V_BGColor:white_color,
                                       }];
    [bgView addSubview:rBtn];
    
    UIView * flView = [UIView view_sub:@{V_Parent_View:rBtn,
                                         V_Width:strFloat(btnWH),
                                         V_Height:strFloat(btnWH),
                                         V_Over_Flow_X:num(OverFlowXCenter),
                                         V_Over_Flow_Y:num(OverFlowYCenter),
                                         V_BGImg:@"fans_bg",
                                         }];
    [rBtn addSubview:flView];
    
    self.followLab = [UIView label:@{V_Parent_View:flView,
                                     V_Width:strFloat(btnWH),
                                     V_Height:@20,
                                     V_Over_Flow_X:num(OverFlowXCenter),
                                     V_Over_Flow_Y:num(OverFlowYCenter),
                                     V_Font_Family:k_fontName_FZXY,
                                     V_Color:k_defaultTextColor,
                                     V_TextAlign:num(TextAlignCenter),
                                     }];
    if (self.userBriefItem) {
        self.followLab.text = [NSString stringWithFormat:@"%d", (int)self.userBriefItem.follow];
    }
    [flView addSubview:_followLab];
    
    
    UILabel * followLal = [UIView label:@{V_Parent_View:rBtn,
                                          V_Last_View:flView,
                                          V_Text:@"关注",
                                          V_Color:k_defaultTextColor,
                                          V_Alpha:@0.5,
                                          V_Font_Family:k_fontName_FZXY,
                                          V_Font_Size:@11,
                                          V_Height:@20,
                                          V_TextAlign:num(TextAlignCenter),
                                          }];
    [rBtn addSubview:followLal];
    
    CGFloat tabH = 2*k_cell_head_height + 4*k_cell_row_height;
    if ([self isStoreUser]) {
        tabH = tabH + k_cell_row_height;
    }
    self.baseTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, bgView.height, self.contentView.width, tabH) style:UITableViewStylePlain];
    _baseTabView.backgroundColor = [UIColor color:clear_color];
    _baseTabView.scrollEnabled = NO;
    _baseTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTabView.separatorColor = [UIColor clearColor];
    _baseTabView.delegate = self;
    _baseTabView.userInteractionEnabled = self.editEnable;
    _baseTabView.dataSource = self;
    [self.contentView addSubview:_baseTabView];
    
    if (!urls) {
        urls = [[NSMutableArray alloc] init];
    }
    [urls removeAllObjects];
    if (!thumbs) {
        thumbs = [[NSMutableArray alloc] init];
    }
    [thumbs removeAllObjects];
    if (!HDImages) {
        HDImages = [[NSMutableArray alloc] init];
    }
    [HDImages removeAllObjects];
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width, _baseTabView.y+_baseTabView.height+20);
    
    UIView * head2 = [self getHeaderInSection:2];
    if (head2) {
        head2.frame = CGRectMake(head2.x, _baseTabView.y+_baseTabView.height, head2.width, head2.height);
        [self.contentView addSubview:head2];
        [self loadPhotoThumbView:head2];
    }
}

- (void)setLogoutButton{
    self.logoutBtn = [UIButton button:@{V_Width:@44,
                                        V_Height:@44,
                                        V_Margin_Right:@10,
                                        V_HorizontalAlign:num(HorizontalRight),
                                        V_Delegate:self,
                                        V_Img:@"out",
                                        V_Font_Family:k_fontName_FZXY,
                                        V_SEL:selStr(@selector(logoutBtnOnClick:)),
                                        }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutBtn];
}

- (void)setUserBriefItem:(UserBriefItem *)userBriefItem{
    _userBriefItem = userBriefItem;
    UIImage * img = [[UserManager sharedInstance] getUserHeadLogo:userBriefItem.userid brifItem:userBriefItem];
    [self.userIcon setImage:img forState:UIControlStateNormal];
}

- (void)saveAndPostUserIconImage:(UIImage *)img{
    if (img) {
        self.changedUserLogo = img;
//        [self.userIcon setImage:img forState:UIControlStateNormal];
        [[ExceptionEngine shared] alertTitle:nil message:@"是否确定更新头像？" delegate:self tag:33 cancelBtn:@"否" btn1:@"更新" btn2:nil];
    }
}

#pragma mark - other functions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
    if (alertView.tag == 33) {
        if (buttonIndex == k_buttonIndex_btn1) {
            [self postUserHeadLogo:self.changedUserLogo];
        }
    }
    else if (alertView.tag == 34) {
        if (buttonIndex == k_buttonIndex_btn1) {
            [self postStorePictures];
        }
        else{
            [self doBack];
        }
    }
}

- (BOOL)isStoreUser{
    if (self.userBriefItem && self.userBriefItem.role && self.userBriefItem.role == Role_Store) {
        return YES;
    }
    else{
        return NO;
    }
}

- (UIView *)getHeaderInSection:(NSInteger)index{
    NSString * text = nil;
    switch (index) {
        case 0:{
            text = ([self isStoreUser]) ? @"商家资料" : @"小岛资料";
        }
            break;
        case 1:{
            text = @"其他资料";
        }
            break;
        case 2:{
            text = ([self isStoreUser]) ? @"主页相册" : @"";
        }
            break;
            
        default:
            break;
    }
    
    if (text) {
        UIView * section_0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.baseTabView.width, k_cell_head_height)];
        section_0.backgroundColor = [UIColor color:k_defaultViewControllerBGColor];
        
        UILabel * label1 = [UILabel label:@{V_Width:strFloat(self.contentView.width),
                                            V_Height:strFloat(section_0.height),
                                            V_Margin_Left:@10,
                                            V_BGColor:clear_color,
                                            V_Text:text,
                                            V_Color:darkGary_color,
                                            V_Font_Family:k_fontName_FZXY,
                                            V_Font_Size:@15,
                                            }];
        [section_0 addSubview:label1];
        
        NSDictionary * commonCss = @{V_Parent_View:section_0,
                                     V_Height:@0.5,
                                     V_BGColor:k_defaultLineColor,
                                     };
        UIView * line = [UIView view_sub:@{V_Common_Style:commonCss,
                                           V_Margin_Top:@0.5,
                                           }];
        [section_0 addSubview:line];
        line = [UIView view_sub:@{V_Common_Style:commonCss,
                                  V_Margin_Bottom:strFloat((index == 2)?0.5:1),
                                  V_Over_Flow_Y:num(OverFlowBottom),
                                  }];
        [section_0 addSubview:line];
        
        return section_0;
    }
    return nil;
}

- (NSArray *)getTextsWithSection:(NSInteger)section row:(NSInteger)row{
    NSString * text_left = nil;
    NSString * text_right = nil;
    NSString * key = nil;
    switch (section) {
        case 0:{
            if (row == 0) {
                text_left = ([self isStoreUser]) ? @"店铺名称" : @"小岛昵称";
                text_right = ([self isStoreUser]) ? self.userBriefItem.name : self.userBriefItem.name;
                if (!text_right) {
                    text_right = @"";
                }
                key = ([self isStoreUser]) ? @"name" : @"name";
           }
            else if (row == 1) {
                text_left = ([self isStoreUser]) ? @"店铺简介" : @"小岛简介";
                text_right = (self.userBriefItem.intro) ? self.userBriefItem.intro : @"";
                key = @"intro";
            }
        }
            break;
        case 1:{
            if (row == 0) {
                text_left = ([self isStoreUser]) ? @"商家地址" : @"兴趣爱好";
                text_right = ([self isStoreUser]) ? self.userBriefItem.address : self.userBriefItem.hobby;
                if (!text_right) {
                    text_right = @"";
                }
                key = ([self isStoreUser]) ? @"address" : @"hobby";
            }
            else if (row == 1) {
                text_left = ([self isStoreUser]) ? @"联系方式" : @"喜欢的音乐";
                text_right = ([self isStoreUser]) ? self.userBriefItem.telephone : self.userBriefItem.music;
                if (!text_right) {
                    text_right = @"";
                }
                key = ([self isStoreUser]) ? @"telephone" : @"music";
            }
            else if (row == 2) {
                text_left = ([self isStoreUser]) ? @"店铺分类" : @"";
                if ([self isStoreUser]) {
                    if ([NSArray isNotEmpty:self.userBriefItem.categories]) {
                        NSMutableString * ms = [NSMutableString string];
                        for (NSDictionary * dic in self.userBriefItem.categories) {
                            if ([dic objectOutForKey:@"cname"]) {
                                [ms appendFormat:@"%@ ", [dic objectOutForKey:@"cname"]];
                            }
                        }
                        text_right = ms;
                    }
                }
                else{
                    text_right = self.userBriefItem.music;
                }
                
                if (!text_right) {
                    text_right = @"";
                }
                key = ([self isStoreUser]) ? @"category" : @"";
            }
        }
            break;
            
        default:
            break;
    }
    if (text_left && text_right && key) {
        return @[text_left, text_right, key];
    }
    return @[];
}

- (UIView *)getRowViewInSection:(NSInteger)section row:(NSInteger)row{
    NSString * text_left = nil;
    NSString * text_right = nil;
    NSArray * texts = [self getTextsWithSection:section row:row];
    if (texts.count >= 2) {
        text_left = [texts objectAtIndex:0];
        text_right = [texts objectAtIndex:1];
    }
    
    if (text_left && text_right) {
        UIView * section_0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.baseTabView.width, k_cell_row_height)];
        section_0.backgroundColor = [UIColor color:white_color];
        NSDictionary * commonStyle = @{V_Parent_View:section_0,
                                       V_Font_Family:k_fontName_FZZY,
                                       V_Height:strFloat(section_0.height),
                                       };
        UILabel * labLeft = [UIView label:@{V_Margin_Left:@20,
                                            V_Width:strFloat(section_0.width/4.0 -10),
                                            V_Font_Size:@14,
                                            V_Color:k_defaultLightTextColor,
                                            V_Text:text_left,
                                            V_Common_Style:commonStyle,
                                            }];
        [section_0 addSubview:labLeft];
        
        UILabel * labRight = [UIView label:@{V_Left_View:labLeft,
                                             V_Margin_Left:@10,
                                             V_Margin_Right:@20,
                                             V_Font_Size:@16,
                                             V_Color:k_defaultTextColor,
                                             V_Text:text_right,
                                             V_Common_Style:commonStyle,
                                             }];
        [section_0 addSubview:labRight];
        
        if (row == 0) {
            [section_0 addSubview:[UIView view_sub:@{V_Parent_View:section_0,
                                                     V_Left_View:labLeft,
                                                     V_Over_Flow_Y:num(OverFlowBottom),
                                                     V_Height:@0.5,
                                                     V_BGColor:k_defaultLineColor,
                                                     }]];
        }
        
        return section_0;
    }
    
    return nil;
}

#pragma mark - 商家店铺相册View

- (void)refresh{
    [self updateAddTitleButtonStatus];
    
    int cellWidth = (self.contentView.width-10*2-numInSection*10)/numInSection;
    cellWidth = PictureItemHeight+Space;
    uiThumbColl.frame = CGRectMake(uiThumbColl.x, uiThumbColl.y, uiThumbColl.width, (thumbs.count/numInSection+1)*(cellWidth));
    
    pictureBoardView.frame = CGRectMake(pictureBoardView.x, pictureBoardView.y, pictureBoardView.width, uiThumbColl.height+Space/2);
    
    mainSection.frame = CGRectMake(mainSection.x, mainSection.y, mainSection.width, pictureBoardView.y+pictureBoardView.height);
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width, mainSection.y+mainSection.height+20);
}

- (void)loadPhotoThumbView:(UIView *)lv{
    if (![self isStoreUser]) {
        return;
    }
    
    numInSection = NumInSection;
    postImgLimit = MaxPhotosCount;
    
    CGFloat top = 0;
    mainSection = [UIView view_sub:@{V_Parent_View:self.contentView,
                                     V_Last_View:lv,
                                     V_Margin_Top:strFloat(top),
                                     V_Height:strFloat(200),
                                     V_Border_Color:k_defaultLineColor,
                                     V_Border_Width:@0.5,
                                     V_BGColor:white_color,
                                     }];
    [self.contentView addSubview:mainSection];
    
    top = Space;
    pictureBoardView = [UIView scrollView:@{V_Parent_View:mainSection,
                                            V_Margin_Top:strFloat(top),
                                            V_Height:strFloat(PictureItemHeight+2*Space),
                                            }];
    [mainSection addSubview:pictureBoardView];
    
    if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
        
        NSArray * imglinks = self.userBriefItem.photothumb;
        if ([NSArray isNotEmpty:imglinks]) {
            //初始化
            int i = 0;
            for (NSString * imgLink in imglinks) {
                if ([NSString isEmptyString:imgLink]) {
                    continue;
                }
                
                UIImage* original = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgLink]]];
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeImageToSavedPhotosAlbum:original.CGImage orientation:(ALAssetOrientation)[original imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
                    if ([urls count] <= [imglinks count]) {
                        [urls addObject:assetURL];
                    }
                }];
                
                if ([urls count] <= [imglinks count]) {
                    int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
                    int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
                    UIImage *thumb = [UIImage scaleAndRotateImage:original andMinImageWidth:cellWidth];
                    [thumbs addObject:thumb];
                    
                    [HDImages addObject:original];
                }
                
                i++;
                if (i >= MaxPhotosCount) {
                    break;
                }
            }
            //初始化End
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        uiThumbColl = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, pictureBoardView.width, PictureItemHeight+2*Space) collectionViewLayout:flowLayout];
        [uiThumbColl setBackgroundColor:[UIColor color:clear_color]];
        uiThumbColl.dataSource = self;
        uiThumbColl.delegate = self;
        [uiThumbColl registerClass:[PostThumbCell class] forCellWithReuseIdentifier:@"PostThumbCell"];
        [pictureBoardView addSubview:uiThumbColl];
    }
    else{
        [self loadStorePhotosViewToView:pictureBoardView];
        mainSection.frame = CGRectMake(mainSection.x, mainSection.y, mainSection.width, pictureBoardView.y+pictureBoardView.height);
    }
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width, mainSection.y+mainSection.height+20);
}

- (void)loadStorePhotosViewToView:(UIScrollView *)scrollView{
    NSArray * thumblink = self.userBriefItem.photothumb;
    if (!thumblink) {
        thumblink = self.userBriefItem.photolink;
    }
    if (![NSArray isNotEmpty:thumblink]) {
        UIView * lab = [UIView label:@{V_Parent_View:scrollView,
                                       V_Text:@"该商户还没有上传图册...",
                                       V_Font_Size:@15,
                                       V_Font_Family:k_defaultFontName,
                                       V_Color:k_defaultLightTextColor,
                                       V_TextAlign:num(TextAlignCenter),
                                       }];
        [scrollView addSubview:lab];
    }
    else{
        CGFloat width = (scrollView.width - Space*(NumInSection+1)) / NumInSection;
        CGFloat height = width;
        CGFloat x = Space;
        CGFloat y = Space;
        NSInteger i = 0;
        for (NSString * imgname in thumblink) {
            int lineIndex = (int)(i/NumInSection);
            CGFloat modf = fmodf(i, NumInSection);
            UIImageView * imgv = [UIView imageView:@{V_Parent_View:scrollView,
                                                     V_Frame:rectStr(x+modf*(width+Space), y+lineIndex*(height+Space), width, height),
                                                     V_ContentMode:num(ModeAspectFill),
                                                     V_Img:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgname]]],
                                                     V_Delegate:self,
                                                     V_Tag:str(i),
                                                     V_SEL:selStr(@selector(clickImage:)),
                                                     }];
            imgv.clipsToBounds = YES;
            [scrollView addSubview:imgv];
            
            ++i;
            
            scrollView.frame = CGRectMake(scrollView.x, scrollView.y, scrollView.width, imgv.y+imgv.height+Space);
        }
    }
}

- (void)clickImage:(UIView *)sender{
    InfoLog(@"tag:%d", (int)sender.tag);
}

- (void)updateAddTitleButtonStatus{
    if (![[UserManager sharedInstance] isCurrentUser:self.userid]) {
        return;
    }
    if (!addTitleButton && uiThumbColl) {
        addTitleButton = [UIView button:@{V_Parent_View:uiThumbColl,
                                          V_Frame:rectStr(PictureItemWidth+Space, 0, 80, uiThumbColl.height),
                                          V_Title:@"添加图片",
                                          V_Color:k_defaultLightTextColor,
                                          V_Font_Size:@16,
                                          V_Font_Family:k_fontName_FZZY,
                                          V_Tag:@90,
                                          V_Delegate:self,
                                          V_SEL:selStr(@selector(PTHCDadd)),
                                          }];
        [uiThumbColl addSubview:addTitleButton];
    }
    
    if (thumbs.count <= 0) {
        addTitleButton.hidden = NO;
    }
    else{
        addTitleButton.hidden = YES;
    }
}

#pragma mark -
#pragma mark ---UICollectionViewDataSource delegate---

//定义展示的Section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long left = thumbs.count-section*numInSection+1;
//    InfoLog(@"111 %d", left>numInSection?numInSection:left);
    return left>numInSection?numInSection:left;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    InfoLog(@"222 %d", thumbs.count/numInSection+1);
    return thumbs.count/numInSection+1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PostThumbCell";
    PostThumbCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
//    InfoLog(@"333 %d", indexPath.row);
    
    if( indexPath.section*numInSection+indexPath.row == thumbs.count ){
        [cell startBtn:self :indexPath];
    }else{
        [cell startImg:[thumbs objectAtExistIndex:(indexPath.section*numInSection+indexPath.row)] :indexPath];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.uiAddPhotoBtn.hidden = YES;
    }
    else{
        cell.uiAddPhotoBtn.hidden = NO;
    }
    
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(PictureItemWidth+Space/2, PictureItemHeight+Space/2);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(Space/2, Space/2, 0, Space/2);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark -
#pragma mark ---UICollectionViewDelegate delegate---

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -
#pragma mark ---PostThumbCellDelegate delegate---

- (void)PTHCDadd {
    numInSection = NumInSection;
    postImgLimit = MaxPhotosCount;
    if(thumbs.count >= postImgLimit ){
        return;
    }
    [self showImagePicker:StorePictures_picker];
}

- (void)showImagePicker:(ImagePickTag)tag{
    self.imagePickTag = tag;
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if( cameraAvailable && photoAvailable ) {
        InfoLog(@"支持拍照和相片库");
        [self showLoginSheet];
    }
    else if( cameraAvailable ) {
        InfoLog(@"仅支持拍照");
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor clearColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if( photoAvailable ) {
        InfoLog(@"仅支持相片库");
        [self selectPhotosFromLib];
    }
    else {
        InfoLog(@"都不支持");
    }
}

- (void)showLoginSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)PTHCDdelete:(NSIndexPath*)indexPath {
    self.storePicturesChanged = YES;
    [thumbs removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [urls removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [HDImages removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [uiThumbColl reloadData];
    [self refresh];
}

#pragma mark -
#pragma mark ---PostTagViewDelegate delegate---

- (void)PTVDreload {
    [self refresh];
}

#pragma mark -
#pragma mark ---UIActionSheetDelegate delegate---

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: {
            InfoLog(@"从相册选取");
            [self selectPhotosFromLib];
            break;
        }
        case 1: {
            InfoLog(@"拍照");
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.view.backgroundColor = [UIColor clearColor];
            UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
            picker.sourceType = sourcheType;
            picker.delegate = self;
            picker.allowsEditing = NO;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
    }
}

- (void)selectPhotosFromLib{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    if (self.imagePickTag == UserLogo_picker) {
        picker.maximumNumberOfSelection = 1;
    }
    else{
        picker.maximumNumberOfSelection = postImgLimit - urls.count;
    }
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        }
        else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if (self.imagePickTag == UserLogo_picker) {
        NSMutableArray * tmp = [NSMutableArray array];
        for (int i = 0; i < assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            //获取图片裁剪的图
            int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
            int cellWidth = maxWidth/2.0;
            UIImage * thumb = [UIImage scaleAndRotateImage:tempImg andMinImageWidth:cellWidth];
            [tmp addObject:thumb];
            [tmp addObject:asset.defaultRepresentation.url];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveAndPostUserIconImage:[tmp objectAtExistIndex:0]];
        });
    }
    else{
        for (int i = 0; i < assets.count; i++) {
            ALAsset * asset=assets[i];
            UIImage * tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            //获取图片裁剪的图
            int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
            int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
            UIImage * thumb = [UIImage scaleAndRotateImage:tempImg andMinImageWidth:cellWidth];
            [thumbs addObject:thumb];
            [urls addObject:asset.defaultRepresentation.url];
            
            [HDImages addObject:tempImg];
            
            self.storePicturesChanged = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [uiThumbColl reloadData];
        });
    }
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
}

#pragma mark -
#pragma mark ---UIImagePickerController delegate---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage] ) {
        if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            //获取照片的原图
            UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
            
            if (self.imagePickTag == UserLogo_picker) {
                int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
                int cellWidth = maxWidth/2.0;
                UIImage *thumb = [UIImage scaleAndRotateImage:original andMinImageWidth:cellWidth];
                [self saveAndPostUserIconImage:thumb];
            }
            else{
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeImageToSavedPhotosAlbum:original.CGImage orientation:(ALAssetOrientation)[original imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
                    [urls addObject:assetURL];
                }];
                
                int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
                int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
                UIImage *thumb = [UIImage scaleAndRotateImage:original andMinImageWidth:cellWidth];
                [thumbs addObject:thumb];
                
                [uiThumbColl reloadData];
                
                [HDImages addObject:original];
                
                self.storePicturesChanged = YES;
            }
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -上传商家相册

- (void)checkPostStorePintures{
    if (self.storePicturesChanged) {
        [[ExceptionEngine shared] alertTitle:nil message:@"您已修改相册，是否更新？" delegate:self tag:34 cancelBtn:@"否" btn1:@"更新" btn2:nil];
    }
}

//上传商家相册(什么时候上传)
- (void)postStorePictures{
//    if (urls.count <= 0) {
//        [self showMessageView:@"请至少上传一张图片!"  delayTime:3.0];
//        return;
//    }
    
    [[LoadingView shared] setIsFullScreen:YES];
    [[LoadingView shared] showLoading:nil message:@"正在上传相册..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSDictionary * params = @{@"userid":strLong(self.userid),
                                  };
        NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = nil;
        
        if (HDImages.count > 0) {
//            // 获取出来图片
//            NSMutableArray *images = [NSMutableArray arrayWithCapacity:urls.count];
//            // NSMutableArray *imagesName = [NSMutableArray arrayWithCapacity:urls.count];
//            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//                for (NSURL *url in urls) {
//                    [library assetForURL:url resultBlock:^(ALAsset *asset) {
//                        // 使用asset来获取本地图片
//                        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//                        CGImageRef imgRef = [assetRep fullResolutionImage];
//                        UIImage *image = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
//                        image = [UIImage scaleAndRotateImage:image andMaxImageHeight:800];
//                        [images addObject:image];
//                        // [imagesName addObject:url.absoluteString]; // assets-library://asset/asset.JPG?id=D1AFC86A-59D3-4BA0-8C43-06064A57DFF0&ext=JPG
//                        if (images.count == urls.count) {
//                            dispatch_semaphore_signal(sema);
//                        }
//                    } failureBlock:^(NSError *error) {
//                        InfoLog(@"获取图片失败");
//                        dispatch_semaphore_signal(sema);
//                    }];
//                }
//            });
//            
//            // 使用信号量控制,获取所有的图片
//            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            d = @{k_r_url:k_api_store_manage_updateimgs,
                  k_r_reqApiType:num(AFReqApi),
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_attchData:HDImages,
                  k_r_loading:num(0),
                  };
        }
        else{
            d = @{k_r_url:k_api_store_manage_updateimgs,
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_loading:num(0),
                  };
        }
        
        [[ReqEngine shared] tryRequest:d];
    });
}

#pragma mark -上传用户头像

//上传用户头像
- (void)postUserHeadLogo:(UIImage *)img{
    if (!img) {
        [self showMessageView:@"请选择头像!"  delayTime:2.0];
        return;
    }
    
    [[LoadingView shared] setIsFullScreen:YES];
    [[LoadingView shared] showLoading:nil message:@"正在上传头像..."];
    
    NSDictionary * params = @{@"userid":strLong(self.userid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:([self isStoreUser]?k_api_user_updatehead:k_api_user_updatehead),
                         k_r_reqApiType:num(AFReqApi),
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_attchData:@[img],
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

@end
