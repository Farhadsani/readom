/*
 *[绑定手机号]页面
 *
 */
#import "RegisterViewController.h"
#import "UserManager.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"

#define k_MaxTime2 60

@interface RegisterViewController (){
    UITextField * userNameInputField;
    UITextField * passwordInputField;
    UITextField * varCodeTextField;
    
    UIButton * registerButton;
    UIImageView * userLogo;
    
    UIButton * timeButton;
    NSInteger count;
    NSTimer * leaseTimer;
}

@property(nonatomic, retain) UIView * registerView;

@end

@implementation RegisterViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    
    count = k_MaxTime2;
    
    [self setupMainView];
}

#pragma mark - delegate (CallBack)


#pragma mark request delegate callback

#pragma mark other delegate callback

- (void)didLoginSuccess:(NSDictionary *)result{
    [self popToMainController:nil];
    
}

//发送注册验证码成功
- (void)didSendSmsSuccess:(NSDictionary *)result{
    [self beginTimer];
    [self showMessageView:@"验证码已发送到您的手机" delayTime:3.0];
}

- (void)didSendSmsError:(NSError *)error{
    [self stopTimer];
    
    timeButton.userInteractionEnabled = YES;
    timeButton.selected = YES;
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
    
    if (![NSString isEmptyString:userNameInputField.text]) {
        if (![leaseTimer isValid]) {
            timeButton.userInteractionEnabled = YES;
            timeButton.selected = YES;
        }
    }
    else{
        timeButton.userInteractionEnabled = NO;
        timeButton.selected = NO;
    }
    
    if (![NSString isEmptyString:userNameInputField.text] && ![NSString isEmptyString:passwordInputField.text] && ![NSString isEmptyString:varCodeTextField.text]) {
        registerButton.userInteractionEnabled = YES;
        registerButton.selected = YES;
    }
    else{
        registerButton.userInteractionEnabled = NO;
        registerButton.selected = NO;
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

- (void)popToMainController:(id)sender{
    [self.view endEditing:YES];
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            [(LoginViewController *)vc clickLeftBackButtonItem:nil];
            break;
        }
    }
}

#pragma mark request method

- (void)requestRigister:(UIButton *)sender{
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
    
    if ([NSString isEmptyString:varCodeTextField.text]) {
        [self baseShowBotHud:NSLocalizedString(@"请输入验证码", @"")];
        return;
    }
    
    if (![[NetworkManager sharedInstance]hasNetwork]) {
        [self baseShowBotHud:@"没有网络连接"];
        return;
    }
    
    [UserManager sharedInstance].delegate = self;
    [[UserManager sharedInstance] signupWithPhone:userNameInputField.text passwd:passwordInputField.text verify:varCodeTextField.text WXLoginInfo:self.loginInfo];
}

- (void)getVerCode{
    NSString *phoneRegex = @"^1[358][0-9]{9}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isPhoneValid = [phonePredicate evaluateWithObject:userNameInputField.text];
    if (!isPhoneValid){
        [self baseShowBotHud:NSLocalizedString(@"请输入正确的手机号", @"")];
        [userNameInputField becomeFirstResponder];
        return;
    } else {
        [UserManager sharedInstance].delegate = self;
        [[UserManager sharedInstance] signupVerify:userNameInputField.text];
    }
}

#pragma mark - init & dealloc

- (void)setupMainView{
    self.registerView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                             V_BGColor:clear_color,
                                             }];
    [self.contentView addSubview:_registerView];
    
    CGFloat logoWidth = 70;
    userLogo = [UIView imageView:@{V_Parent_View:_registerView,
                                   V_Frame:rectStr((_registerView.width-logoWidth)/2.0, 20, logoWidth, logoWidth),
                                   V_Border_Radius:strFloat(logoWidth/2.0),
                                   V_Img:@"register-done-2-1",
                                   V_ContentMode:num(ModeAspectFill),
                                   V_BGColor:lightgray_color,
                                   }];
    [_registerView addSubview:userLogo];
    NSString * imglink = self.loginInfo.headUrl;
    if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
        [userLogo setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
    }
    else{
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
        if (img) {
            [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
            [userLogo setImage:img];
        }
    }
    
    UILabel * username = [UIView label:@{V_Parent_View:_registerView,
                                         V_Last_View:userLogo,
                                         V_Height:(self.loginInfo.nickName)?@25:@0,
                                         V_Font_Size:@14,
                                         V_Color:darkZongSeColor,
                                         V_Text:(self.loginInfo.nickName)?self.loginInfo.nickName:@"",
                                         V_TextAlign:num(TextAlignCenter),
                                         }];
    [_registerView addSubview:username];
    
    CGFloat margin = 20;
    userNameInputField = [UIView textFiled:@{V_Parent_View:_registerView,
                                             V_Last_View:username,
                                             V_Margin_Top:strFloat(10),
                                             V_Margin_Left:strFloat(margin),
                                             V_Margin_Right:strFloat(margin),
                                             V_Height:@40,
                                             V_Font_Size:num(14),
                                             V_Color:darkZongSeColor,
                                             V_tintColor:darkZongSeColor,
                                             V_KeyboardType:num(Number),
                                             V_Delegate:self,
                                             V_Font_Family:@"FZY1JW—-GB1-0",
                                             V_Placeholder:@"手机号",
                                             }];
    [self.registerView addSubview:userNameInputField];
    [userNameInputField addTarget:self action:@selector(textFieldGoToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    if(![NSString isEmptyString:[UserManager sharedInstance].base.phone]){
        userNameInputField.text = [UserManager sharedInstance].base.phone;
    }else{
        userNameInputField.placeholder = @"手机号";
    }
    
    UIView * line = [UIView view_sub:@{V_Parent_View:_registerView,
                                       V_Last_View:userNameInputField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Height:@0.5,
                                       V_BGColor:lightZongSeBGColor,
                                       }];
    [_registerView addSubview:line];
    
    passwordInputField = [UIView textFiled:@{V_Parent_View:_registerView,
                                             V_Last_View:line,
                                             V_Margin_Left:strFloat(userNameInputField.x),
                                             V_Margin_Right:strFloat(userNameInputField.x),
                                             V_Height:numFloat(40),
                                             V_Font_Size:num(14),
                                             V_Color:darkZongSeColor,
                                             V_tintColor:darkZongSeColor,
                                             V_Tag:@21,
                                             V_Delegate:self,
                                             V_Font_Family:@"FZY1JW—-GB1-0",
                                             V_IsSecurity:num(SecurityYES),
                                             V_Placeholder:@"密码"}];
    [self.registerView addSubview:passwordInputField];
    [passwordInputField addTarget:self action:@selector(textFieldGoToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    line = [UIView view_sub:@{V_Parent_View:_registerView,
                              V_Last_View:passwordInputField,
                              V_Margin_Left:strFloat(margin),
                              V_Margin_Right:strFloat(margin),
                              V_Height:@0.5,
                              V_BGColor:lightZongSeBGColor,
                              }];
    [_registerView addSubview:line];
    
    CGFloat timeButtonWidth = 100;
    varCodeTextField = [UIView textFiled:@{V_Parent_View:_registerView,
                                           V_Last_View:line,
                                           V_Margin_Left:strFloat(margin),
                                           V_Margin_Right:strFloat(timeButtonWidth+margin),
                                           V_Height:@40,
                                           V_Font_Size:num(14),
                                           V_Color:darkblack_color,
                                           V_tintColor:darkZongSeColor,
                                           V_Delegate:self,
                                           V_Font_Family:@"FZY1JW—-GB1-0",
                                           V_Placeholder:@"请输入验证码"}];
    [_registerView addSubview:varCodeTextField];
    [varCodeTextField addTarget:self action:@selector(textFieldGoToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    line = [UIView view_sub:@{V_Parent_View:_registerView,
                              V_Last_View:varCodeTextField,
                              V_Margin_Left:strFloat(margin),
                              V_Margin_Right:strFloat(margin),
                              V_Height:@0.5,
                              V_BGColor:lightZongSeBGColor,
                              }];
    [_registerView addSubview:line];
    
    timeButton = [UIView button:@{V_Parent_View:_registerView,
                                  V_Frame:rectStr(varCodeTextField.x+varCodeTextField.width, varCodeTextField.y+(varCodeTextField.height-26)/2.0, timeButtonWidth, 26),
                                  V_BGColor:minlightZongSeBGColor,
                                  V_BGImg_S:green_color,
                                  V_Color:darkZongSeColor,
                                  V_Color_S:white_color,
                                  V_Font_Size:num(10),
                                  V_Tag:@2,
                                  V_Border_Radius:@2,
                                  V_Selected:num(SelectedNO),
                                  V_Click_Enable:num(Click_No),
                                  V_Delegate:self,
                                  V_Font_Family:@"FZY1JW—-GB1-0",
                                  V_SEL:selStr(@selector(getVerCode)),
                                  V_Title:@"获取验证码",
                                  V_Title_S:@"获取验证码",
                                  }];
    [_registerView addSubview:timeButton];
    if(![NSString isEmptyString:[UserManager sharedInstance].base.phone]){
        timeButton.userInteractionEnabled = YES;
        timeButton.selected = YES;
    }
    
    line = [UIView view_sub:@{V_Parent_View:_registerView,
                              V_Last_View:passwordInputField,
                              V_Margin_Left:strFloat(margin),
                              V_Margin_Right:strFloat(margin),
                              V_Height:@0.5,
                              V_BGColor:lightZongSeBGColor,
                              }];
    [_registerView addSubview:line];
    
    registerButton = [UIView button:@{V_Parent_View:_registerView,
                                   V_Last_View:varCodeTextField,
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
                                   V_Font_Family:@"FZY1JW—-GB1-0",
                                   V_SEL:selStr(@selector(requestRigister:)),
                                   V_Title:@"确 定"}];
    [self.registerView addSubview:registerButton];
    
    UILabel * description = [UIView label:@{V_Parent_View:_registerView,
                                            V_Last_View:registerButton,
                                            V_Height:@40,
                                            V_Font_Size:@12,
                                            V_Color:lightZongSeBGColor,
                                            V_Text:@"注册代表您已经阅读并同意《用户协议》",
                                            V_NumberLines:@3,
                                            V_Font_Family:k_fontName_FZXY,
                                            V_TextAlign:num(TextAlignCenter),
                                            }];
    [_registerView addSubview:description];
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark
- (void)beginTimer{
    [self stopTimer];
    
    if (!leaseTimer) {
        leaseTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginCount:) userInfo:nil repeats:YES];
    }
}

- (void)beginCount:(NSTimer *)timer{
    count--;
    if (count <= 0) {
        timeButton.userInteractionEnabled = YES;
        timeButton.selected = YES;
        
        [self stopTimer];
    }
    else{
        timeButton.userInteractionEnabled = NO;
        timeButton.selected = NO;
        [timeButton setTitle:[NSString stringWithFormat:@"再次发送(%d)", (int)count] forState:UIControlStateNormal];
    }
}

- (void)stopTimer{
    if (leaseTimer) {
        [leaseTimer invalidate];
        leaseTimer = nil;
    }
    count = k_MaxTime2;
    [timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)baseBack:(id)sender{
    [self.view endEditing:YES];
    
    [self baseNavBack];
}

@end
