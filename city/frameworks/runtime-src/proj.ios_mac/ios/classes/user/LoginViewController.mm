/*
 *[登录]页面
 *功能：用户进行登录
 *获取微信登录
 */

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserManager.h"
#import "NetworkManager.h"
#import "LoggerClient.h"
#import "AppController+WXLogin.h"
#import "ResetPasswordViewController.h"

@interface LoginViewController (){
    UITextField * userNameInputField;
    UITextField * passwordInputField;
    UIButton * loginButton;
    UIImageView * userLogo;
}

@property(nonatomic, retain) UIView * loginView;

@end

@implementation LoginViewController


#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    InfoLog(@"");
    [self.view becomeFirstResponder];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
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
}

#pragma mark - delegate (CallBack)


#pragma mark request delegate callback

#pragma mark other delegate callback

- (void)didLoginSuccess:(NSDictionary *)result{
    if ([self.post_dict objectOutForKey:@"weixinLoginInfo"]) {
        //微信授权登录
        if (result && [NSString isEmptyString:[result objectOutForKey:@"phone"]]) {
            //未绑定手机号
            RegisterViewController *registerVC = [[[RegisterViewController alloc] init] autorelease];
            registerVC.loginInfo = (WXLoginInfo*)[self.post_dict objectOutForKey:@"weixinLoginInfo"];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
        else{
            //已经绑定手机号，直接登录
            [self clickLeftBackButtonItem:nil];
        }
        
        [self.post_dict removeObjectForKey:@"weixinLoginInfo"];
    }
    else{
        [self clickLeftBackButtonItem:nil];
    }    
}

-(void)wxCallback:(WXLoginInfo*)pWXLoginInfo{
//    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//    WXLoginInfo *loginInfo = (WXLoginInfo*)(notification.object);
//    registerVC.loginInfo = loginInfo;
//    [[WXLogin sharedInstance].delegate.navigationController pushViewController:registerVC animated:YES];
    
    
    
    [self.post_dict setNonEmptyObject:pWXLoginInfo forKey:@"weixinLoginInfo"];
    
    [UserManager sharedInstance].delegate = self;
    [[UserManager sharedInstance] signinWithWXLoginInfo:pWXLoginInfo];
}

- (void)textFieldDidEndEditing:(MHTextField *)textField notify:(NSNotification *)notify{
    if ([textField isEqual:userNameInputField]) {
        InfoLog(@"tel:%@", textField.text);
    }
    else if ([textField isEqual:passwordInputField]) {
        InfoLog(@"psw:%@", textField.text);
    }
}

- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
//    InfoLog(@"%@", textField);
    if (![NSString isEmptyString:userNameInputField.text] && ![NSString isEmptyString:passwordInputField.text]) {
        loginButton.userInteractionEnabled = YES;
        loginButton.selected = YES;
    }
    else{
        loginButton.userInteractionEnabled = NO;
        loginButton.selected = NO;
    }
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

-(void)requestWXLogin:(id)sender {
//    [self.view endEditing:YES];
    
    AppController *delegate = (AppController *)[UIApplication sharedApplication].delegate;
    [delegate WXLogin:self];
}

- (void)hasQuestionWhenLogin:(id)sender {
    [self showConfirmSelectedView:@[@"找回密码",@"取消"] SEL:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    
    if ([(UIView *)sender tag] == 0) {
        ResetPasswordViewController * vc = [[[ResetPasswordViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        vc.title = @"找回密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark request method

- (void)requestLogin:(UIButton *)sender{
    InfoLog(@"");
    [self.view endEditing:YES];
    
    NSString *phoneRegex = @"^1[358][0-9]{9}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isPhoneValid = [phonePredicate evaluateWithObject:userNameInputField.text];
    if (!isPhoneValid){
        [self baseShowBotHud:NSLocalizedString(@"请输入正确的手机号", @"")];
        [userNameInputField becomeFirstResponder];
        return;
    }
    
    NSString *uiPasswdRegex = @"^\\S{6,20}$";
    NSPredicate *uiPasswdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", uiPasswdRegex];
    BOOL isuiPasswdValid = [uiPasswdPredicate evaluateWithObject:passwordInputField.text];
    //密码验证
    if (!isuiPasswdValid) {
        [self baseShowBotHud:NSLocalizedString(@"请使用6~20位的密码", @"")];
        [passwordInputField becomeFirstResponder];
        passwordInputField.text = nil;
        return;
    }
    
    if (![[NetworkManager sharedInstance]hasNetwork]) {
        [self baseShowBotHud:@"没有网络连接"];
        return;
    }
    
    [UserManager sharedInstance].delegate = self;
    [[UserManager sharedInstance] signinWithPhone:userNameInputField.text passwd:passwordInputField.text];
}

#pragma mark - init & dealloc

- (void)setupMainView{
    self.loginView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                          V_BGColor:clear_color,
                                          }];
    [self.contentView addSubview:_loginView];
    
    CGFloat logoWidth = 80;
    userLogo = [UIView imageView:@{V_Parent_View:_loginView,
                                   V_Frame:rectStr((_loginView.width-logoWidth)/2.0, 20, logoWidth, logoWidth),
                                   V_Border_Radius:strFloat(logoWidth/2.0),
                                   V_Img:@"register-done-2-1",
                                   V_ContentMode:num(ModeAspectFill),
                                   V_BGColor:lightgray_color,
                                   }];
    [_loginView addSubview:userLogo];
    
    CGFloat margin = 30;
    userNameInputField = [UIView textFiled:@{V_Parent_View:_loginView,
                                             V_Last_View:userLogo,
                                             V_Margin_Top:strFloat(userLogo.y),
                                             V_Margin_Left:strFloat(margin),
                                             V_Margin_Right:strFloat(margin),
                                             V_Height:@40,
                                             V_Font_Size:num(14),
                                             V_LeftImageMarginLeft:strFloat(15),
                                             V_LeftTextMarginLeft:strFloat(15),
                                             V_Color:darkZongSeColor,
                                             V_tintColor:darkZongSeColor,
                                             V_LeftImage:@"login-4-1",
                                             V_Tag:@20,
                                             V_Font_Family:k_fontName_FZZY,
                                             V_KeyboardType:num(Number),
                                             V_Delegate:self,
                                             V_Placeholder:@"请输入手机号"}];
    [self.loginView addSubview:userNameInputField];
    [userNameInputField addTarget:self action:@selector(textFieldGoToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    margin += 20;
    UIView * line = [UIView view_sub:@{V_Parent_View:_loginView,
                                       V_Last_View:userNameInputField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Height:@0.5,
                                       V_BGColor:lightZongSeBGColor,
                                       }];
    [_loginView addSubview:line];
    
    passwordInputField = [UIView textFiled:@{V_Parent_View:_loginView,
                                             V_Last_View:line,
                                             V_Margin_Left:strFloat(userNameInputField.x),
                                             V_Margin_Right:strFloat(userNameInputField.x),
                                             V_Height:numFloat(40),
                                             V_Font_Size:num(14),
                                             V_LeftImageMarginLeft:strFloat(15),
                                             V_LeftTextMarginLeft:strFloat(15),
                                             V_Color:darkZongSeColor,
                                             V_tintColor:darkZongSeColor,
                                             V_LeftImage:@"login-5-1",
                                             V_Tag:@21,
                                             V_Delegate:self,
                                             V_Font_Family:k_fontName_FZZY,
                                             V_IsSecurity:num(SecurityYES),
                                             V_Placeholder:@"请输入密码"}];
    [self.loginView addSubview:passwordInputField];
    [passwordInputField addTarget:self action:@selector(textFieldGoToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    line = [UIView view_sub:@{V_Parent_View:_loginView,
                              V_Last_View:passwordInputField,
                              V_Margin_Left:strFloat(margin),
                              V_Margin_Right:strFloat(margin),
                              V_Height:@0.5,
                              V_BGColor:lightZongSeBGColor,
                              }];
    [_loginView addSubview:line];
    
    loginButton = [UIView button:@{V_Parent_View:_loginView,
                                   V_Last_View:passwordInputField,
                                   V_Height:numFloat(35),
                                   V_Margin_Top:numFloat(fit_H(40)),
                                   V_Margin_Left:numFloat(margin),
                                   V_Margin_Right:numFloat(margin),
                                   V_BGColor:slightGrayColor3,
                                   V_BGImg_S:green_color,
                                   V_Color:white_color,
                                   V_Font_Size:num(18),
                                   V_Font_Weight:num(FontWeightBold),
                                   V_Tag:@2,
                                   V_Border_Radius:@2,
                                   V_Selected:num(SelectedNO),
                                   V_Click_Enable:num(Click_No),
                                   V_Delegate:self,
                                   V_Font_Family:k_fontName_FZZY,
                                   V_SEL:selStr(@selector(requestLogin:)),
                                   V_Title:@"登 录"}];
    [self.loginView addSubview:loginButton];
    
    UIButton * loginErrorBtn = [UIView button:@{V_Parent_View:_loginView,
                                                V_Last_View:loginButton,
                                                V_Margin_Top:@10,
                                                V_Height:numFloat(30),
                                                V_Width:strFloat(_loginView.width/2.0),
                                                V_Over_Flow_X:num(OverFlowXCenter),
                                                V_Color:lightZongSeBGColor,
                                                V_Font_Size:num(15),
                                                V_Delegate:self,
                                                V_Font_Family:k_fontName_FZXY,
                                                V_SEL:selStr(@selector(hasQuestionWhenLogin:)),
                                                V_Title:@"登录遇到问题?",
                                                }];
    [self.loginView addSubview:loginErrorBtn];
    
    UILabel * lab = [UIView label:@{V_Parent_View:_loginView,
                                    V_Height:numFloat(16),
                                    V_Margin_Bottom:@60,
                                    V_Over_Flow_X:num(OverFlowXCenter),
                                    V_Over_Flow_Y:num(OverFlowBottom),
                                    V_Font_Size:@(14),
                                    V_Color:lightZongSeBGColor,
                                    V_Font_Family:k_fontName_FZXY,
                                    V_TextAlign:num(TextAlignCenter),
                                    V_Text:@"没有账号?",
                                    }];
    [_loginView addSubview:lab];
    
    UIButton * loginWithWeixin = [UIView button:@{V_Parent_View:_loginView,
                                                  V_Height:numFloat(28),
                                                  V_Width:strFloat(120),
                                                  V_Margin_Bottom:@30,
                                                  V_Over_Flow_X:num(OverFlowXCenter),
                                                  V_Over_Flow_Y:num(OverFlowBottom),
                                                  V_Color:white_color,
                                                  V_BGColor:midZongSeColor,
                                                  V_Border_Radius:@5,
                                                  V_Delegate:self,
                                                  V_Font_Family:k_fontName_FZXY,
                                                  V_Font_Size:@(15),
                                                  V_SEL:selStr(@selector(requestWXLogin:)),
                                                  V_Title:@"微信账号登录",
                                                  }];
    [self.loginView addSubview:loginWithWeixin];
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark
//-(void)nsSigninNeedSignup:(NSNotification *)notification {
//    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//    WXLoginInfo *loginInfo = (WXLoginInfo*)(notification.object);
//    registerVC.loginInfo = loginInfo;
//    [[WXLogin sharedInstance].delegate.navigationController pushViewController:registerVC animated:YES];
//}

- (void)baseBack:(id)sender{
    [self.view endEditing:YES];
    
    [self baseDeckBack];
    if( callback ){
        if (![[UserManager sharedInstance] hasLogin])   //没有登录，直接返回的BUG，临时解决
        {
            callback( 0 );
        }else
        {
            [self backUserHome];
//            callback( 1 );
        }
    }
}

@end
