//
//  MobleLoginViewController.m
//  citystate
//
//  Created by 小生 on 15/9/24.
//
//

#import "MobleLoginViewController.h"
#import "UserManager.h"
#import "NetworkManager.h"
#import "LoggerClient.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"

@interface MobleLoginViewController (){
    UITextField * userNameInputField;
    UITextField * passwordInputField;
}

@property(nonatomic, retain) UIView * mobleloginView;

@end

@implementation MobleLoginViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButtonItem:@"" img:@"left_w_bg" action:@selector(clickLeftBackButtonItem:)];
    
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate callback

#pragma mark other delegate callback

- (void)didLoginSuccess:(NSDictionary *)result{
    InfoLog(@"");
    [self popToMainController:nil];
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
                                               V_Height:strFloat(self.contentView.height + 49),
                                               V_BGColor:yello_color,
                                               }];
    [self.contentView addSubview:_mobleloginView];
    
    UIColor * textColor = [UIColor color:white_color];
    
    CGFloat marginLeft = 35;
    CGFloat lineHeight = 40;
    CGFloat spaceTop = 30;
    
    CGFloat top = 80;
    if (k_isIphone4s) {
        top = 30;
    }
    
    UILabel * country = [UIView label:@{V_Parent_View:_mobleloginView,
                                        V_Margin_Top:strFloat(top),
                                        V_Margin_Left:strFloat(marginLeft+10),
                                        V_Height:strFloat(lineHeight),
                                        V_Color:textColor,
                                        V_Font_Size:@15,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Text:@"国家和地区",
                                        }];
    [self.mobleloginView addSubview:country];
    
    UILabel * city = [UIView label:@{V_Parent_View:_mobleloginView,
                                     V_Margin_Top:strFloat(top),
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

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark



@end
