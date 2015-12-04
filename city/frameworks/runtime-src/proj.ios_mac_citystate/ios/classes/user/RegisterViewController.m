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
//    self.title = @"绑定手机号";
    [self setupLeftBackButtonItem:@"" img:@"left_w_bg" action:@selector(clickLeftBackButtonItem:)];
    
    count = k_MaxTime2;
    
    [self setupMainView];
}

#pragma mark - delegate (CallBack)


#pragma mark request delegate callback

#pragma mark 登录成功（成功绑定手机号） callback

- (void)didLoginSuccess:(NSDictionary *)result{
    InfoLog(@"");
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
        [self showMessageView:@"请使用6~20位的密码" delayTime:2.0];
        [passwordInputField becomeFirstResponder];
        passwordInputField.text = nil;
        return;
    }
    
    if ([NSString isEmptyString:varCodeTextField.text]) {
        [self showMessageView:@"请输入验证码" delayTime:2.0];
        return;
    }
    
    if (![[NetworkManager sharedInstance]hasNetwork]) {
        [self showMessageView:@"没有网络连接" delayTime:2.0];
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
        [self showMessageView:@"请输入正确的手机号" delayTime:2.0];
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
                                             V_BGColor:yello_color,
                                             }];
    [self.contentView addSubview:_registerView];
    
    UIColor * textColor = [UIColor color:white_color];
    
    CGFloat hei = 50;
    if (k_isIphone4s) {
        hei = 30;
    }
    
    UILabel * bLabel = [UIView label:@{V_Parent_View:_registerView,
                                       V_TextAlign:num(TextAlignCenter),
                                       V_Height:strFloat(hei),
                                       V_Color:textColor,
                                       V_Font_Family:k_fontName_FZZY,
                                       V_Font_Weight:num(FontWeightBold),
                                       V_Font_Size:@20,
                                       V_Text:@"绑定手机号",
                                       }];
    [self.registerView addSubview:bLabel];
    
    CGFloat marginLeft = 35;
    CGFloat lineHeight = 40;
    CGFloat spaceTop = 30;
    CGFloat top = 10;
    
    UILabel * country = [UIView label:@{V_Parent_View:_registerView,
                                        V_Last_View:bLabel,
                                        V_Margin_Top:strFloat(top),
                                        V_Margin_Left:strFloat(marginLeft+10),
                                        V_Height:strFloat(lineHeight),
                                        V_Color:textColor,
                                        V_Font_Size:@16,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Text:@"国家和地区",
                                        }];
    [self.registerView addSubview:country];
    
    UILabel * city = [UIView label:@{V_Parent_View:_registerView,
                                     V_Last_View:bLabel,
                                     V_Margin_Top:strFloat(top),
                                     V_Margin_Right:strFloat(marginLeft+10),
                                     V_Color:textColor,
                                     V_Font_Size:@16,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Text:@"中国",
                                     V_TextAlign:num(TextAlignRight),
                                     }];
    [self.registerView addSubview:city];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:_registerView,
                                        V_Last_View:country,
                                        V_Margin_Top:@-8,
                                        V_Margin_Top:strFloat(country.y - 5),
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_BGColor:textColor,
                                        }];
    [_registerView addSubview:line1];
    
    UILabel * cityNum = [UIView label:@{V_Parent_View:_registerView,
                                        V_Last_View:line1,
                                        V_Margin_Left:strFloat(marginLeft+10),
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
    [_registerView addSubview:cityNum];
    
    UIView * li = [UIView view_sub:@{V_Parent_View:cityNum,
                                     V_BGColor:textColor,
                                     V_Width:@1,
                                     V_Height:strFloat(cityNum.height - 7),
                                     V_Margin_Top:@-1,
                                     V_Margin_Left:strFloat(cityNum.width - 15),
                                     }];
    [cityNum addSubview:li];
    
    CGFloat filed = 35;
    
    userNameInputField = [UIView textFiled:@{V_Parent_View:_registerView,
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
    [_registerView addSubview:userNameInputField];
    [userNameInputField addTarget:self action:@selector(textFieldGoToNextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * line = [UIView view_sub:@{V_Parent_View:_registerView,
                                       V_Last_View:cityNum,
                                       V_Margin_Top:@-8,
                                       V_Margin_Right:strFloat(marginLeft),
                                       V_Margin_Left:strFloat(marginLeft),
                                       V_Height:@1,
                                       V_BGColor:textColor,
                                       }];
    [_registerView addSubview:line];

    
    passwordInputField = [UIView textFiled:@{V_Parent_View:_registerView,
                                             V_Last_View:line,
                                             V_Margin_Left:strFloat(marginLeft),
                                             V_Height:strFloat(filed),
                                             V_Margin_Right:strFloat(marginLeft),
                                             V_Margin_Top:strFloat(spaceTop-8),
                                             V_Font_Size:num(17),
                                             V_Color:textColor,
                                             V_tintColor:textColor,
                                             V_PlaceHoldTextColor:[UIColor colorWithWhite:1.0 alpha:0.5],
                                             V_Tag:@21,
                                             V_Delegate:self,
                                             V_Font_Family:k_fontName_FZZY,
                                             V_IsSecurity:num(SecurityYES),
                                             V_Placeholder:@"请输入密码，至少6位",
                                             }];
    [_registerView addSubview:passwordInputField];
    [passwordInputField addTarget:self action:@selector(textFieldGoToNextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * line3 = [UIView view_sub:@{V_Parent_View:_registerView,
                                        V_Last_View:passwordInputField,
                                        V_Margin_Top:@-4,
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_BGColor:textColor,
                                        }];
    [_registerView addSubview:line3];
    
    CGFloat butHeight = 45;

    timeButton = [UIView button:@{V_Parent_View:_registerView,
                                  V_Last_View:line3,
                                  V_Height:numFloat(butHeight/ 2.0),
                                  V_Width:numFloat(80),
                                  V_Margin_Top:strFloat(spaceTop),
                                  V_Margin_Right:strFloat(marginLeft + 10),
                                  V_Over_Flow_X:num(OverFlowRight),
                                  V_BGColor:white_color,
//                                  V_BGImg_S:white_color,
                                  V_Color:yello_color,
                                  V_Color_S:yello_color,
                                  V_Font_Size:num(12),
                                  V_Tag:@2,
                                  V_Border_Radius:strFloat(butHeight/4.0),
                                  V_Selected:num(SelectedNO),
                                  V_Click_Enable:num(Click_No),
                                  V_Delegate:self,
                                  V_Font_Family:k_fontName_FZZY,
                                  V_SEL:selStr(@selector(getVerCode)),
                                  V_Title:@"发送验证码",
                                  V_Title_S:@"发送验证码",
                                  }];
    [_registerView addSubview:timeButton];
    
    
    varCodeTextField = [UIView textFiled:@{V_Parent_View:_registerView,
                                                V_Last_View:line3,
                                                V_Width:@150,
                                                V_Margin_Top:strFloat(spaceTop-8),
                                                V_Margin_Left:strFloat(marginLeft),
                                                V_Margin_Right:strFloat(marginLeft),
                                                V_Height:@40,
                                                V_Font_Size:num(17),
                                                V_Color:textColor,
                                                V_tintColor:textColor,
                                                V_PlaceHoldTextColor:[UIColor colorWithWhite:1.0 alpha:0.5],
                                                V_Delegate:self,
                                                V_KeyboardType:num(Number),
                                                V_Font_Weight:num(FontWeightBold),
                                                V_Font_Family:k_fontName_FZZY,
                                                V_Placeholder:@"请输入验证码"}];
    [self.registerView addSubview:varCodeTextField];
    [varCodeTextField addTarget:self action:@selector(textFieldGoToNextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * line4 = [UIView view_sub:@{V_Parent_View:_registerView,
                                        V_Last_View:varCodeTextField,
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_Margin_Top:@-4,
                                        V_BGColor:textColor,
                                        }];
    [self.registerView addSubview:line4];
    
    
    lineHeight = 55;
    UIButton* loginButton = [UIView button:@{V_Parent_View:_registerView,
                                             V_Last_View:line4,
                                             V_Height:numFloat(lineHeight),
                                             V_Margin_Top:@50,
                                             V_Margin_Left:numFloat(marginLeft),
                                             V_Margin_Right:numFloat(marginLeft),
                                             V_Color:white_color,
                                             V_Font_Size:num(18),
                                             V_Font_Weight:num(FontWeightBold),
                                             V_Font_Family:k_fontName_FZZY,
                                             V_Border_Radius:strFloat(lineHeight/2.0),
                                             V_Border_Color:textColor,
                                             V_Border_Width:@1,
                                             V_Delegate:self,
                                             V_SEL:selStr(@selector(requestRigister:)),
                                             V_Title:@"确定"}];
    [self.registerView addSubview:loginButton];
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
