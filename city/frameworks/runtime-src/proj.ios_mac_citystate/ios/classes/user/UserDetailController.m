//
//  UserDetailController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

/*
 *[个人详情]页面
 *功能：显示个人一些基本资料（性别、性取向、情感状况、星座）
 * 编辑基本资料
 */

#import "UserDetailController.h"
#import "UIViewController+Addtion.h"
#import "UserManager.h"
#import "UserBaseInfoEditController.h"
#import "SettingViewController.h"
#import "ChangePasswordViewController.h"
#import "UserBaseInfoController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface UserDetailController ()<PassCalloutValueDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic) int row;          //记录当前选择的是哪个cell
@property (nonatomic) int i;            //记录弹出选择项中选择的序号
@property (nonatomic) BOOL editEnable;  //当前页面是否可以编辑

@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, retain) UIImageView * iconBlurView;
@property (nonatomic, weak) UILabel *userName;
@property (nonatomic, weak) UILabel *userIntro;

@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *sexOTArray;
@property (nonatomic, strong) NSArray *loveArray;
@property (nonatomic, strong) NSArray *horoArray;
@property (nonatomic, strong) NSArray *signArray;

@property (nonatomic, assign) int index;
@property (nonatomic, strong) UserDetailItem *userDetailItem;
@property (nonatomic, strong) UserBriefItem *userBriefItem;
@end

@implementation UserDetailController

- (void)variableInit{
    [super variableInit];
    self.row = -1;
    self.i = -1;
    self.editEnable = YES;
}

- (void)viewDidLoad{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    [self initData];
    
//    [self setupMainView];
    
    [self requestUserInfoIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

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

- (void)requestUserInfoIfNeeded{
//    if (!self.editEnable || [self shouldRequestUserInf]) {
        NSDictionary * params = @{@"userid": @(self.userid)};
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
//        [self setupMainView];
//    }
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeTagCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"placeTagCell"];
    }
    [cell.contentView removeAllSubviews];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.editEnable) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, 30),
                                                 V_Img:@"buddystatus_arrow",
                                                 V_ContentMode:num(ModeCenter),
                                                 }];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15.0];
    cell.textLabel.textColor = [UIColor color:k_defaultLightTextColor];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_%d.png", (int)indexPath.row+1]];
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = _userDetailItem.sex;
        }
            break;
        case 1:{
            cell.textLabel.text = @"性取向";
            cell.detailTextLabel.text = _userDetailItem.sexot;
        }
            break;
        case 2:{
            cell.textLabel.text = @"情感状况";
            cell.detailTextLabel.text = _userDetailItem.love;
        }
            break;
        case 3:{
            cell.textLabel.text = @"黄道十二宫";
            cell.detailTextLabel.text = _userDetailItem.horo;
        }
            break;
        case 4:{
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = _userBriefItem.intro;
        }
            break;
        default:
            break;
    }
    cell.detailTextLabel.font = [UIFont fontWithName:k_fontName_FZZY size:16.0];
    cell.detailTextLabel.textColor = [UIColor color:k_defaultTextColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [self cellClick:indexPath];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        NSDictionary *res = result[@"res"];
        if (self.editEnable) {
            [[UserManager sharedInstance] updateUserData:res];
            self.userBriefItem = [UserManager sharedInstance].brief;
            self.userDetailItem = [UserManager sharedInstance].detail;
        }
        else{
            UserBriefItem *userBriefItem = [[UserBriefItem alloc] init];
            userBriefItem = [UserBriefItem objectWithKeyValues:res];
            self.userBriefItem = userBriefItem;
            [[UserManager sharedInstance] updateUserData:self.userBriefItem];
            
            UserDetailItem *userDetaiItem = [[UserDetailItem alloc] init];
            userDetaiItem = [UserDetailItem objectWithKeyValues:res];
            self.userDetailItem = userDetaiItem;
        }
        
        [self setupMainView];
        
//        [_tableView reloadData];
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatedetail]) {
//        NSDictionary *params = [req.data_dict objectOutForKey:k_r_postData][@"params"];
        
        if (self.row >= 0 && self.i >= 0) {
            switch (self.row) {
                case 0:{
                    self.userDetailItem.sex = [_sexArray objectAtIndex:self.i];
                }
                    break;
                case 1:{
                    self.userDetailItem.sexot = [_sexOTArray objectAtIndex:self.i];
                }
                    break;
                case 2:{
                    self.userDetailItem.love = [_loveArray objectAtIndex:self.i];
                }
                    break;
                case 3:{
                    NSString * value = [_horoArray objectAtIndex:self.i];
                    if ([value containsString:@"("]) {
                        value = [value substringToIndex:[value rangeOfString:@"("].location];
                    }
                    self.userDetailItem.horo = value;
                }
                    break;
                default:
                    break;
            }
        }
        
        if (self.editEnable) {
            [[UserManager sharedInstance] updateUserData:self.userDetailItem];
        }
        
        [_tableView reloadData];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        NSLog(@"更新用户详情错误");
        [self setupMainView];
    }
}

#pragma mark - action
- (void)setUserBriefItem:(UserBriefItem *)userBriefItem{
    _userBriefItem = userBriefItem;
    UIImage * srcImg = [[UserManager sharedInstance] getUserHeadLogo:userBriefItem.userid brifItem:userBriefItem];
    self.userIcon.image = srcImg;
    [self applyBlurShadowWithImage:srcImg];
    self.userName.text = userBriefItem.name;
    self.userIntro.text = userBriefItem.intro;
}

- (void)cellClick:(NSIndexPath *)indexPath{
    self.row = (int)indexPath.row;
    NSMutableArray * arr = [NSMutableArray array];
    __block NSString *defaultSelected = @"";
    switch (indexPath.row) {
        case 0:
            [arr addObjectsFromArray:self.sexArray];
            defaultSelected = [UserManager sharedInstance].detail.sex;
            break;
        case 1:
            [arr addObjectsFromArray:self.sexOTArray];
            defaultSelected = [UserManager sharedInstance].detail.sexot;
            break;
        case 2:
            [arr addObjectsFromArray:self.loveArray];
            defaultSelected = [UserManager sharedInstance].detail.love;
            break;
        case 3:
            [arr addObjectsFromArray:self.horoArray];
            [self.horoArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
                if ([str hasPrefix:[UserManager sharedInstance].detail.horo]) {
                    defaultSelected = str;
                    stop = YES;
                }
            }];
            break;
//        case 4:
//            [self jumpToUserBaseEditViewController];
//            break;
        default:
            break;
    }
    if (indexPath.row != 4) {
        [arr addObject:@"取消"];
        [self showConfirmSelectedView:arr defaultSelected:defaultSelected action:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
    }
}

- (void)jumpToUserBaseEditViewController{
    self.navigationController.navigationBarHidden = NO;
    
    UserBaseInfoEditController * userVC = [[UserBaseInfoEditController alloc]init];
    NSString * userSign = self.userBriefItem.intro;
    userVC.signText = userSign;
    userVC.passValueDelegate = self;
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)passCalloutValue:(NSString *)value{
    if (self.row == 4) {
        if (value) {
            self.userBriefItem.intro = value;
            if (self.editEnable) {
                [[UserManager sharedInstance] updateUserData:@{@"intro":self.userBriefItem.intro}];//更新数据
            }
            [_tableView reloadData];
        }
    }
}

#pragma mark - view init
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    CGFloat iconBlurHeight = self.contentView.height * 9/25;
    //头像模糊背景图片
    self.iconBlurView = [UIView imageView:@{V_Parent_View:self.contentView,
                                            V_Height:str(iconBlurHeight),
                                            V_ContentMode:num(ModeAspectFill),
                                            }];
    [self.contentView addSubview:_iconBlurView];
    _iconBlurView.clipsToBounds = YES;
    UIImage * srcImg = [[UserManager sharedInstance] getUserHeadLogo:self.userBriefItem.userid brifItem:self.userBriefItem];
    [self applyBlurShadowWithImage:srcImg];
    self.iconBlurView.userInteractionEnabled = YES;
    
    CGFloat iconWidth = 80;
    self.userIcon = [UIView imageView:@{V_Parent_View:_iconBlurView,
                                        V_Frame:rectStr((_iconBlurView.width-iconWidth)/2.0, (_iconBlurView.height-iconWidth)/2.0-10, iconWidth, iconWidth),
                                        V_Img:srcImg,
                                        V_ContentMode:num(ModeAspectFill),
                                        V_Border_Radius:strFloat(iconWidth/2.0),
                                                     }];
    [_iconBlurView addSubview:_userIcon];
    _userIcon.clipsToBounds = YES;
    self.userIcon.userInteractionEnabled = YES;
    [self.userIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserIcon)]];
    
    self.userName = [UIView label:@{V_Parent_View:_iconBlurView,
                                    V_Last_View:_userIcon,
                                    V_Height:@40,
                                    V_Font_Family:k_defaultFontName,
                                    V_Font_Size:@15,
                                    V_Color:white_color,
                                    V_TextAlign:num(TextAlignCenter),
                                    }];
    [_iconBlurView addSubview:self.userName];
    
    self.userIntro = [UIView label:@{V_Parent_View:_iconBlurView,
                                     V_Last_View:_userName,
                                     V_Height:@16,
                                     V_Font_Family:k_defaultFontName,
                                     V_Font_Size:@13,
                                     V_Color:white_color,
                                     V_TextAlign:num(TextAlignCenter),
                                     }];
    [_iconBlurView addSubview:self.userIntro];
    
    CGFloat tableHeight = 0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _iconBlurView.y+_iconBlurView.height, self.contentView.width, tableHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setBackgroundColor:[UIColor color:clear_color]];
    [self.contentView addSubview:_tableView];
    _tableView.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    _tableView.layer.borderWidth = 0.5;
    _tableView.userInteractionEnabled = self.editEnable;
    _tableView.scrollEnabled = NO;
    
    CGFloat cellHeight = [self tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    tableHeight = cellHeight*[self tableView:_tableView numberOfRowsInSection:0];
    if (tableHeight > self.contentView.height-_iconBlurView.y-_iconBlurView.height) {
        cellHeight = self.contentView.height-_iconBlurView.y-_iconBlurView.height;
        _tableView.scrollEnabled = YES;
    }
    self.tableView.frame = CGRectMake(_tableView.x, _tableView.y, _tableView.width, tableHeight);
    
    [self setNavButtonItems];
}

- (void)tapUserIcon
{
    if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
        
    } else {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.userBriefItem.imglink]; // 图片路径
        photo.srcImageView = self.userIcon;
        
        MJPhotoBrowser * browser = [[MJPhotoBrowser alloc]init];
        browser.currentPhotoIndex = 0;
        browser.photos = @[photo];
        [browser show];
    }
}

- (void)setNavButtonItems{
    CGFloat backWH = 40;
    UIButton * backBtn = [UIView button:@{V_Parent_View:self.contentView,
                                          V_Margin_Top:@25,
                                          V_Width:strFloat(backWH+5),
                                          V_Height:strFloat(backWH),
                                          V_Delegate:self,
                                          V_Img:@"left_back",
                                          V_SEL:selStr(@selector(clickLeftBackButtonItem:)),
                                          }];
    [self.contentView addSubview:backBtn];
    
    if (self.editEnable) {
        UIButton * settingBtn = [UIView button:@{V_Parent_View:self.contentView,
                                                 V_Over_Flow_X:num(OverFlowRight),
                                                 V_Margin_Top:@25,
                                                 V_Width:strFloat(backWH+5),
                                                 V_Height:strFloat(backWH),
                                                 V_Delegate:self,
                                                 V_Img:@"shezhitubiao",
                                                 V_SEL:selStr(@selector(clickRightSettingButtonItem:)),
                                                 }];
        [self.contentView addSubview:settingBtn];
    }
}

- (void)initData{
    self.sexArray = [[NSArray alloc] initWithObjects:@"女生", @"男生", @"性别自由切换", @"内心是女生", @"内心是男生", @"现在是女生啦", @"现在是男生啦", @"尚未明确的性别", @"保密", nil];
    self.sexOTArray = [[NSArray alloc] initWithObjects:@"异性恋", @"同志", @"女女", @"性别无关之爱", @"无欲望者", @"二禁恋(只爱二次元)", @"唯物主义", @"宠物恋", @"绝对自恋", @"保密", nil];
    self.loveArray = [[NSArray alloc] initWithObjects:@"单身待解救", @"疯狂找对象", @"疗伤中勿扰", @"备胎收集癖", @"备胎等上位", @"墙角有点松", @"不虐狗难受", @"你管得着吗", @"我是处女座", nil];
    self.horoArray = [[NSArray alloc] initWithObjects:@"白羊座(3.21-4.19)", @"金牛座(4.20-5.20)", @"双子座(5.21-6.21)", @"巨蟹座(6.22-7.22)", @"狮子座(7.23-8.22)", @"处女座(8.23-9.22)", @"天秤座(9.23-10.23)", @"天蝎座(10.24-11.22)", @"射手座(11.23-12.21)", @"摩羯座(12.22-1.19)", @"水瓶座(1.20-2.18)", @"双鱼座(2.19-3.20)", nil];
    
    if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
        self.userBriefItem = [UserManager sharedInstance].brief;
        self.userDetailItem = [UserManager sharedInstance].detail;
        self.editEnable = YES;
    }
    else{
        self.editEnable = NO;
    }
}

#pragma mark - other function

/**
 *  处理弹出对话框中的点击事件
 */
- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        return ;
    }
    
    self.i = (int)btn.tag;
    
    NSString * key = nil;
    switch (self.row) {
        case 0:
            key = @"sex";
            break;
        case 1:
            key = @"sexot";
            break;
        case 2:
            key = @"love";
            break;
        case 3:
            key = @"horo";
            break;
        default:
            break;
    }
    
    if (!key) {
        return;
    }
    
    NSString * value = btn.titleLabel.text;
    if (self.row == 3) {
        if ([value containsString:@"("]) {
            value = [value substringToIndex:[value rangeOfString:@"("].location];
        }
    }
    NSDictionary * params = @{key:value};
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_updatedetail,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - other method

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)clickRightSettingButtonItem:(UIButton *)sender{
    self.navigationController.navigationBarHidden = NO;
    self.userBriefItem = [UserManager sharedInstance].brief;
    if ([[UserManager sharedInstance] isStoreUser:self.userBriefItem] == YES) {
        UserBaseInfoController * baseVC = [[UserBaseInfoController alloc]init];
        [self.navigationController pushViewController:baseVC animated:YES];
    }else{
        SettingViewController * vc = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

//添加模糊效果
- (void)applyBlurShadowWithImage:(UIImage *)srcImg{
    self.iconBlurView.alpha = 1.f;
    self.iconBlurView.layer.contents = (id)srcImg.CGImage;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
        UIImage *blur = [srcImg rn_boxblurImageWithBlur:0.2 exclusionPath:nil];//数字在0-1之间，数值越大越模糊，约小越清晰
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.1;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.iconBlurView.layer addAnimation:transition forKey:nil];
            self.iconBlurView.layer.contents = (id)blur.CGImage;
        });
    });
}

@end
