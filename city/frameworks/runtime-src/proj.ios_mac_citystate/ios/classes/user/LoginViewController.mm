/*
 *[登录]页面
 *功能：用户进行登录
 *获取微信登录
 */

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NetworkManager.h"
#import "LoggerClient.h"
#import "AppController+WXLogin+Pay.h"
#import "AppController+pay.h"
#import "ResetPasswordViewController.h"
#import "MobleLoginViewController.h"
#import "RegisterViewController.h"
#import "ChangePasswordViewController.h"

@interface LoginViewController (){
    
}

@property(nonatomic, retain) UIView * loginView;

@end

@implementation LoginViewController


#pragma mark - life Cycle
- (void)viewDidLoad {
    self.navigationController.navigationBarHidden = NO;
    [super viewDidLoad];
    [self setupLeftBackButtonItem:@"" img:@"left_w_bg" action:@selector(clickLeftBackButtonItem:)];
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

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


-(void)requestWXLogin:(id)sender {
    //    [self.view endEditing:YES];
    
    AppController *delegate = (AppController *)[UIApplication sharedApplication].delegate;
    [delegate WXLogin:self];
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
            [self clickLeftBackButtonItem:nil];
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

- (void)mobleLogin:(id)sender {
    MobleLoginViewController * vc = [[[MobleLoginViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)setupMainView{
    self.loginView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                          V_BGColor:yello_color,
                                          }];
    [self.contentView addSubview:_loginView];
    
    UIColor * textColor = [UIColor color:white_color];
    
    CGFloat hei_2 = 80; //微信logo高度
    CGFloat hei_3 = 40; //微信登录字样高度
    
    CGFloat half_hei = kScreenHeight/2.0 - 64;
    CGFloat hei_1 = half_hei/2.0 - 30; //你好，吕梁! 字样高度
    
    if (k_isIphone4s) {
        hei_1 -= 20;
        hei_2 = (half_hei/2.0 + 20) * 2 / 3;
        hei_3 = (half_hei/2.0 + 20) * 1 / 3;
    }
    
    NSString * text = @"你好";
    if (![NSString isEmptyString:[UserManager sharedInstance].serverCity]) {
        text = [NSString stringWithFormat:@"你好，%@", [UserManager sharedInstance].serverCity];
    }
    UILabel * helloLabel = [UIView label:@{V_Parent_View:_loginView,
                                           V_Font_Size:@(28),
                                           V_Height:strFloat(hei_1),
                                           V_Color:textColor,
                                           V_Font_Weight:num(FontWeightBold),
                                           V_TextAlign:num(TextAlignCenter),
                                           V_Font_Family:k_fontName_FZZY,
                                           V_Text:text,
                                           }];
    [self.loginView addSubview:helloLabel];
    
    UIImageView * wxlog = [UIView imageView:@{V_Parent_View:_loginView,
                                              V_Last_View:helloLabel,
                                              V_Margin_Top:strFloat(helloLabel.y + 10),
                                              V_Margin_Left:@((_loginView.width - hei_2)/2.0),
                                              V_Width:@(hei_2),
                                              V_Height:@(hei_2),
                                              V_BGImg:@"logoWechat",
                                              V_ContentMode:num(ModeAspectFit),
                                              V_SEL:selStr(@selector(requestWXLogin:)),
                                              V_Delegate:self,
                                              }];
    [self.loginView addSubview:wxlog];
    
    UIButton * wxloginButton = [UIView button:@{V_Parent_View:_loginView,
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
    [self.loginView addSubview:wxloginButton];
    text = @"  使用账号登录  ";
    UIFont * font = [UIFont fontWithName:k_fontName_FZXY size:13.0];
    CGFloat text_wid = [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat margin = 35;
    CGFloat lineWidth = (_loginView.width - text_wid - margin *2) / 2.0;
    
    UIView * line = [UIView view_sub:@{V_Parent_View:_loginView,
                                       V_Frame:rectStr(margin, half_hei + 5, lineWidth, 0.5),
                                       V_BGColor:textColor,
                                       V_Alpha:@0.5,
                                       }];
    [_loginView addSubview:line];
    
    UILabel * cblogin = [UIView label:@{V_Parent_View:_loginView,
                                        V_Frame:rectStr(line.x+line.width, line.y-15, text_wid, 15*2),
                                        V_Font:font,
                                        V_Color:textColor,
                                        V_Alpha:@0.7,
                                        V_TextAlign:num(TextAlignCenter),
                                        V_Text:text,
                                        }];
    [_loginView addSubview:cblogin];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:_loginView,
                                        V_Frame:rectStr(cblogin.x+cblogin.width, line.y, line.width, line.height),
                                        V_Last_View:wxloginButton,
                                        V_BGColor:textColor,
                                        V_Alpha:@0.5,
                                        }];
    [_loginView addSubview:line1];
    
    CGFloat btnHeight = 50;
    UIButton * loginButton = [UIView button:@{V_Parent_View:_loginView,
                                              V_Last_View:cblogin,
                                              V_Height:numFloat(btnHeight),
                                              V_Margin_Top:@25,
                                              V_Margin_Left:numFloat(margin),
                                              V_Margin_Right:numFloat(margin),
                                              V_BGColor:textColor,
                                              V_Color:yello_color,
                                              V_Border_Radius:strFloat(btnHeight/2.0),
                                              V_Font_Family:k_fontName_FZZY,
                                              V_Font_Size:num(18),
                                              V_Delegate:self,
                                              V_SEL:selStr(@selector(mobleLogin:)),
                                              V_Title:@"通过手机号登录",
                                              }];
    [self.loginView addSubview:loginButton];
    
    
    
    UIButton * loginErrorBtn = [UIView button:@{V_Parent_View:_loginView,
                                                V_Height:numFloat(50),
                                                V_Width:strFloat(_loginView.width/2.0),
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
    [self.loginView addSubview:loginErrorBtn];
    
    UIView * line2 = [UIView view_sub:@{V_Parent_View:_loginView,
                                        V_Next_View:loginErrorBtn,
                                        V_Over_Flow_Y:num(OverFlowBottom),
                                        V_Margin_Left:strFloat(margin),
                                        V_Margin_Right:strFloat(margin),
                                        V_Height:@0.5,
                                        V_BGColor:textColor,
                                        V_Alpha:@0.5,
                                        }];
    [_loginView addSubview:line2];
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
