//
//  NewMobleLoginViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/12/21.
//
//

#import "NewMobleLoginViewController.h"
#import "UserManager.h"
#import "NetworkManager.h"
#import "LoggerClient.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "AppController.h"
#import "RegisterViewController.h"

@interface NewMobleLoginViewController () <UITextFieldDelegate,LoginDelegate>
{
    UITextField * userNameInputField;
    UITextField * passwordInputField;
}

@property(nonatomic, retain) UIView * mobleloginView;

@end

@implementation NewMobleLoginViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButtonItem:@"" img:@"left_w_bg" action:@selector(clickLeftBackButtonItem:)];
    
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//- (void)clickLeftBackButtonItem:(UIButton *)sender{
//    [super clickLeftBarButtonItem];
//    
//    [self.view endEditing:YES];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)clickLeftBackButtonItem:(UIButton *)sender{
    InfoLog(@"");
    [super clickLeftBarButtonItem];
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    if ([self.data_dict objectOutForKey:@"from"] && [[self.data_dict objectOutForKey:@"from"] isEqualToString:@"endpoint"]) {
        //        if ([[UserManager sharedInstance] hasLogin]){
        //            loginCallback(1);
        //        }
        //        else {
        //            loginCallback(0);
        //        }
    }
    else{
        [self baseBack:nil];
    }
    
    if ([[UserManager sharedInstance] hasLogin]) {
        [self backUserHome:0];
        if (self.loginVCDelegate && [self.loginVCDelegate respondsToSelector:@selector(didLoginSuccessInLoginVC:)]) {
            [self.loginVCDelegate didLoginSuccessInLoginVC:[Cache shared].user_dict];
        }
    }
    else{
        if (self.loginVCDelegate && [self.loginVCDelegate respondsToSelector:@selector(didLoginErrorInLoginVC:)]) {
            [self.loginVCDelegate didLoginErrorInLoginVC:nil];
        }
    }
}


#pragma mark - delegate (CallBack)

#pragma mark request delegate callback

#pragma mark other delegate callback

- (void)textFieldDidEndEditing:(MHTextField *)textField notify:(NSNotification *)notify{
    if ([textField isEqual:userNameInputField]) {
        InfoLog(@"tel:%@", textField.text);
    }
    else if ([textField isEqual:passwordInputField]) {
        InfoLog(@"psw:%@", textField.text);
    }
}

- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
    
}

#pragma mark - action such as: click touch tap slip ...

-(void)textFieldGoToNextField:(id)sender{
    if( sender == userNameInputField ){
        [sender resignFirstResponder];
        [passwordInputField becomeFirstResponder];
    }
    else if(sender == passwordInputField){
        [sender resignFirstResponder];
    }
}

#pragma mark request method

- (void)requestLogin:(UIButton *)sender{
    InfoLog(@"");
    
    if (userNameInputField.text.length == 0) {
        [self showMessageView:@"请输入11位手机号" delayTime:2.0];
        [userNameInputField becomeFirstResponder];
        return;
    }
    
    NSString *phoneRegex = @"^1[358][0-9]{9}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isPhoneValid = [phonePredicate evaluateWithObject:userNameInputField.text];
    if (!isPhoneValid){
        [self showMessageView:@"请输入正确的手机号" delayTime:2.0];
        return;
    }
    
    NSString *uiPasswdRegex = @"^\\S{6,20}$";
    NSPredicate *uiPasswdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", uiPasswdRegex];
    BOOL isuiPasswdValid = [uiPasswdPredicate evaluateWithObject:passwordInputField.text];
    //密码验证
    if (!isuiPasswdValid) {
        [self showMessageView:@"请使用6~20位的密码" delayTime:2.0];
        [passwordInputField becomeFirstResponder];
        return;
    }
    
    if (![[NetworkManager sharedInstance] hasNetwork]) {
        [self showMessageView:@"没有网络连接" delayTime:2.0];
        return;
    }
    
    [self.view endEditing:YES];
    
    [UserManager sharedInstance].delegate = self;
    [[UserManager sharedInstance] signinWithPhone:userNameInputField.text passwd:passwordInputField.text];
}

#pragma mark - init & dealloc

- (void)setupMainView{
    self.mobleloginView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                               V_Height:strFloat(self.contentView.height),
                                               V_BGColor:yello_color,
                                               }];
    [self.contentView addSubview:_mobleloginView];
    
    UIColor * textColor = [UIColor color:white_color];
    
    CGFloat marginLeft = 35;
    CGFloat lineHeight = 40;
    CGFloat spaceTop = 30;
    
//    CGFloat top = 80;
//    if (k_isIphone4s) {
//        top = 30;
//    }
    
    
    CGFloat half_hei = kScreenHeight/2.0 - 64;
    CGFloat hei_1 = half_hei/2.0 - 40; //你好，吕梁! 字样高度
    
    if (k_isIphone4s) {
        hei_1 -= 20;
    }
    
    NSString * text = @"你好";
    if (![NSString isEmptyString:[UserManager sharedInstance].serverCity]) {
        text = [NSString stringWithFormat:@"你好，%@", [UserManager sharedInstance].serverCity];
    }
    UILabel * helloLabel = [UIView label:@{V_Parent_View:_mobleloginView,
                                           V_Font_Size:@(28),
                                           V_Height:strFloat(hei_1),
                                           V_Color:textColor,
                                           V_Font_Weight:num(FontWeightBold),
                                           V_TextAlign:num(TextAlignCenter),
                                           V_Font_Family:k_fontName_FZZY,
                                           V_Text:text,
                                           }];
    [self.mobleloginView addSubview:helloLabel];

    
    UILabel * country = [UIView label:@{V_Parent_View:_mobleloginView,
                                        V_Margin_Top:strFloat(CGRectGetMaxY(helloLabel.frame)),
                                        V_Margin_Left:strFloat(marginLeft+10),
                                        V_Height:strFloat(lineHeight),
                                        V_Color:textColor,
                                        V_Font_Size:@15,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Text:@"国家和地区",
                                        }];
    [self.mobleloginView addSubview:country];
    
    UILabel * city = [UIView label:@{V_Parent_View:_mobleloginView,
                                     V_Margin_Top:strFloat(CGRectGetMaxY(helloLabel.frame) + 5),
                                     V_Margin_Right:strFloat(marginLeft+10),
                                     V_Color:textColor,
                                     V_Font_Size:@15,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Text:@"中国",
                                     V_TextAlign:num(TextAlignRight),
                                     }];
    [self.mobleloginView addSubview:city];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:_mobleloginView,
                                        V_Last_View:country,
                                        V_Margin_Top:@-8,
                                        V_Margin_Top:strFloat(country.y - 5),
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_BGColor:textColor,
                                        }];
    [_mobleloginView addSubview:line1];
    
    UILabel * cityNum = [UIView label:@{V_Parent_View:_mobleloginView,
                                        V_Last_View:line1,
                                        V_Margin_Left:strFloat(marginLeft+8),
                                        V_Height:strFloat(lineHeight),
                                        V_Margin_Top:strFloat(spaceTop - 12),
                                        V_Width:@90,
                                        V_Color:textColor,
                                        V_Font_Weight:num(FontWeightBold),
                                        V_Font_Size:@24,
                                        V_Font_Family:k_defaultFontName,
                                        V_Text:@"+86",
                                        V_TextAlign:num(TextAlignCenter),
                                        }];
    [self.mobleloginView addSubview:cityNum];
    
    UIView * li = [UIView view_sub:@{V_Parent_View:cityNum,
                                     V_BGColor:textColor,
                                     V_Width:@1,
                                     V_Height:strFloat(cityNum.height -7),
                                     V_Margin_Top:@-1,
                                     V_Margin_Left:strFloat(cityNum.width - 15),
                                     }];
    [cityNum addSubview:li];
    
    CGFloat filed = 35;
    
    userNameInputField = [UIView textFiled:@{V_Parent_View:_mobleloginView,
                                             V_Last_View:country,
                                             V_Left_View:li,
                                             V_Margin_Left:strFloat(li.width + 45),
                                             V_Height:strFloat(filed),
                                             V_Margin_Top:strFloat(spaceTop-17),
                                             V_Font_Size:num(17),
                                             V_LeftImageMarginLeft:strFloat(0),
                                             V_LeftTextMarginLeft:strFloat(0),
                                             V_Color:textColor,
                                             V_tintColor:textColor,
                                             V_PlaceHoldTextColor:[UIColor colorWithWhite:1.0 alpha:0.5],
                                             V_Tag:@20,
                                             V_Font_Family:k_fontName_FZZY,
                                             V_KeyboardType:num(Number),
                                             V_Delegate:self,
                                             V_Placeholder:@"请填写手机号码"}];
    [self.mobleloginView addSubview:userNameInputField];
    [userNameInputField addTarget:self action:@selector(textFieldGoToNextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * line = [UIView view_sub:@{V_Parent_View:_mobleloginView,
                                       V_Last_View:cityNum,
                                       V_Margin_Top:@-8,
                                       V_Margin_Left:strFloat(marginLeft),
                                       V_Margin_Right:strFloat(marginLeft),
                                       V_Height:@1,
                                       V_BGColor:textColor,
                                       }];
    [_mobleloginView addSubview:line];
    
    passwordInputField = [UIView textFiled:@{V_Parent_View:_mobleloginView,
                                             V_Last_View:line,
                                             V_Margin_Left:strFloat(marginLeft),
                                             V_Margin_Right:strFloat(marginLeft),
                                             V_Height:strFloat(filed),
                                             V_Margin_Top:strFloat(spaceTop-8),
                                             V_Font_Size:num(16),
                                             V_Color:textColor,
                                             V_tintColor:textColor,
                                             V_PlaceHoldTextColor:[UIColor colorWithWhite:1.0 alpha:0.5],
                                             V_Tag:@21,
                                             V_Delegate:self,
                                             V_Font_Family:k_fontName_FZZY,
                                             V_IsSecurity:num(SecurityYES),
                                             V_Placeholder:@"请输入密码，至少6位",
                                             }];
    [self.mobleloginView addSubview:passwordInputField];
    [passwordInputField addTarget:self action:@selector(textFieldGoToNextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * line3 = [UIView view_sub:@{V_Parent_View:_mobleloginView,
                                        V_Last_View:passwordInputField,
                                        V_Margin_Top:@-4,
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_BGColor:textColor,
                                        }];
    [_mobleloginView addSubview:line3];
    
    lineHeight = 55;
    UIButton* loginButton = [UIView button:@{V_Parent_View:_mobleloginView,
                                             V_Last_View:line3,
                                             V_Height:strFloat(lineHeight),
                                             V_Margin_Top:@50,
                                             V_Margin_Left:numFloat(marginLeft),
                                             V_Margin_Right:numFloat(marginLeft),
                                             V_Font_Size:num(15),
                                             V_Font_Weight:num(FontWeightBold),
                                             V_Font_Family:k_fontName_FZZY,
                                             V_Border_Radius:strFloat(lineHeight/2.0),
                                             V_Border_Color:white_color,
                                             V_Color:white_color,
                                             V_Border_Width:@1,
                                             V_Delegate:self,
                                             V_SEL:selStr(@selector(requestLogin:)),
                                             V_Title:@"立即登录"}];
    [self.mobleloginView addSubview:loginButton];
    
    
    
//    CGFloat half_hei = kScreenHeight/2.0 - 64;
//    CGFloat hei_1 = half_hei/2.0 - 30; //你好，吕梁! 字样高度
//
//    if (k_isIphone4s) {
//        hei_1 -= 20;
//        hei_2 = (half_hei/2.0 + 20) * 2 / 3;
//        hei_3 = (half_hei/2.0 + 20) * 1 / 3;
//    }
//    

//    
    CGFloat hei_2 = 60; //微信logo高度
    CGFloat hei_3 = 40; //微信登录字样高度
    
    text = @"  使用账号登录   ";
    UIFont * font = [UIFont fontWithName:k_fontName_FZXY size:13.0];
    CGFloat text_wid = [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat margin = 35;
    CGFloat lineWidth = (_mobleloginView.width - text_wid - margin *2) / 2.0;
    
    UIView * line4 = [UIView view_sub:@{V_Parent_View:_mobleloginView,
                                        V_Frame:rectStr(margin, CGRectGetMaxY(loginButton.frame) + 40, lineWidth, 0.5),
                                        V_BGColor:textColor,
                                        V_Alpha:@0.5,
                                        }];
    [_mobleloginView addSubview:line4];
    
    UILabel * cblogin = [UIView label:@{V_Parent_View:_mobleloginView,
                                        V_Frame:rectStr(line4.x+line4.width, line4.y-15, text_wid, 15*2),
                                        V_Font:font,
                                        V_Color:textColor,
                                        V_Alpha:@0.7,
                                        V_TextAlign:num(TextAlignCenter),
                                        V_Text:text,
                                        }];
    [_mobleloginView addSubview:cblogin];
    
    UIView * line5 = [UIView view_sub:@{V_Parent_View:_mobleloginView,
                                        V_Frame:rectStr(cblogin.x+cblogin.width, line4.y, line4.width, line4.height),
                                        V_BGColor:textColor,
                                        V_Alpha:@0.5,
                                        }];
    [_mobleloginView addSubview:line5];
    
    UIImageView * wxlog = [UIView imageView:@{V_Parent_View:_mobleloginView,
                                              V_Last_View:loginButton,
                                              V_Margin_Top:strFloat(60),
                                              V_Margin_Left:@((_mobleloginView.width - hei_2)/2.0),
                                              V_Width:@(hei_2),
                                              V_Height:@(hei_2),
                                              V_BGImg:@"logoWechat",
                                              V_ContentMode:num(ModeAspectFit),
                                              V_SEL:selStr(@selector(requestWXLogin:)),
                                              V_Delegate:self,
                                              }];
    [self.mobleloginView addSubview:wxlog];
    
    UIButton * wxloginButton = [UIView button:@{V_Parent_View:_mobleloginView,
                                                V_Last_View:wxlog,
                                                V_Height:@(hei_3),
                                                V_Margin_Top:@-10,
                                                V_Width:strFloat(wxlog.width),
                                                V_Over_Flow_X:num(OverFlowXCenter),
                                                V_Color:textColor,
                                                V_Font_Family:k_fontName_FZZY,
                                                V_Font_Weight:num(FontWeightBold),
                                                V_Font_Size:@(15),
                                                V_SEL:selStr(@selector(requestWXLogin:)),
                                                V_Delegate:self,
                                                V_Title:@"微信登录",
                                                }];
    [self.mobleloginView addSubview:wxloginButton];

    UIButton * loginErrorBtn = [UIView button:@{V_Parent_View:_mobleloginView,
                                                V_Height:numFloat(50),
                                                V_Width:strFloat(_mobleloginView.width/2.0),
                                                V_Over_Flow_X:num(OverFlowXCenter),
                                                V_Over_Flow_Y:num(OverFlowBottom),
                                                V_Color:textColor,
                                                V_Font_Size:num(13),
                                                V_Alpha:@0.7,
                                                V_Delegate:self,
                                                V_Font_Family:k_fontName_FZXY,
                                                V_SEL:selStr(@selector(hasQuestionWhenLogin:)),
                                                V_Title:@"登录遇到问题?",
                                                }];
    [self.mobleloginView addSubview:loginErrorBtn];
    
    UIView * line6 = [UIView view_sub:@{V_Parent_View:_mobleloginView,
                                        V_Next_View:loginErrorBtn,
                                        V_Over_Flow_Y:num(OverFlowBottom),
                                        V_Margin_Left:strFloat(margin),
                                        V_Margin_Right:strFloat(margin),
                                        V_Height:@0.5,
                                        V_BGColor:textColor,
                                        V_Alpha:@0.5,
                                        }];
    [_mobleloginView addSubview:line6];
}

-(void)requestWXLogin:(id)sender {
    //    [self.view endEditing:YES];
    
    AppController *delegate = (AppController *)[UIApplication sharedApplication].delegate;
    [delegate WXLogin:self];
}

- (void)jumpToAgreement{
    InfoLog(@"");
    [self openWebView:k_user_agreement_user localXml:nil title:k_user_agreement_user_title otherInfo:@{@"openType":@"push",@"hidNav":@"NO"}];
}

- (void)popToMainController:(id)sender{
    [self.view endEditing:YES];
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NewMobleLoginViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            [(NewMobleLoginViewController *)vc clickLeftBackButtonItem:nil];
            break;
        }
    }
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - delegate (CallBack)

#pragma mark 登录成功 callback

- (void)didLoginSuccess:(NSDictionary *)result{
    InfoLog(@"");
    if ([self.post_dict objectOutForKey:@"weixinLoginInfo"]) {
        //微信授权登录
        if (result && [NSString isEmptyString:[result objectOutForKey:@"phone"]]) {
            //未绑定手机号
            [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
            RegisterViewController *registerVC = [[[RegisterViewController alloc] init] autorelease];
            registerVC.loginInfo = (WXLoginInfo*)[self.post_dict objectOutForKey:@"weixinLoginInfo"];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
        else{
            //已经绑定手机号，直接登录
            [[UserManager sharedInstance] updateUserData:result];
//            [self clickLeftBackButtonItem:nil];
            [self popToMainController:nil];
        }
        
        [self.post_dict removeObjectForKey:@"weixinLoginInfo"];
    }
    else{
        [self clickLeftBackButtonItem:nil];
    }
}

#pragma mark 微信授权 callback

-(void)wxCallback:(WXLoginInfo*)pWXLoginInfo{
    //    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    //    WXLoginInfo *loginInfo = (WXLoginInfo*)(notification.object);
    //    registerVC.loginInfo = loginInfo;
    //    [[WXLogin sharedInstance].delegate.navigationController pushViewController:registerVC animated:YES];
    
    
    
    [self.post_dict setNonEmptyObject:pWXLoginInfo forKey:@"weixinLoginInfo"];
    
    [UserManager sharedInstance].delegate = self;
    [[UserManager sharedInstance] signinWithWXLoginInfo:pWXLoginInfo];
}

- (void)hasQuestionWhenLogin:(id)sender {
    [self showConfirmSelectedView:@[@"找回密码",@"取消"] action:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    
    if ([(UIView *)sender tag] == 0) {
        ResetPasswordViewController * vc = [[[ResetPasswordViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)baseBack:(id)sender{
    [self.view endEditing:YES];
    
    [self baseDeckBack];
    if( callback ){
        if (![[UserManager sharedInstance] hasLogin])   //没有登录，直接返回的BUG，临时解决
        {
            callback( 0 );
        }else{
            [self backUserHome:0];
        }
        InfoLog(@"有Cocos回调");
    }
    else{
        InfoLog(@"没有Cocos回调");
    }
}
@end