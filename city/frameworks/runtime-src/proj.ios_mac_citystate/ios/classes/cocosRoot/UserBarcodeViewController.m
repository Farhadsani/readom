//
//  UserBarcodeViewController.m
//  citystate
//
//  Created by hf on 15/10/10.
//
//

#import "UserBarcodeViewController.h"
#import "MySeanViewController.h"
#import "UIImageView+WebCache.h"
#import "BusinessSeanViewController.h"

#define zongSeBGColor   rgb(100, 76, 67) //textCorol
@interface UserBarcodeViewController ()

@property(nonatomic, retain) UIView * barcodeView;
@property(nonatomic ,retain) UIImageView * qrView;
@property (nonatomic, strong) UserBriefItem *userBriefItem;

@end

@implementation UserBarcodeViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userBriefItem = [UserManager sharedInstance].brief;
    if ([[UserManager sharedInstance] isStoreUser:self.userBriefItem] == YES) {
        [self setupRightBackButtonItem:@"订单号" img:nil del:self sel:@selector(orderIDtButtonItem:)];
        }else{
        [self setupRightBackButtonItem:@"" img:@"more_bg" del:self sel:@selector(clickRightButtonItem:)];
    }
    
    [self checkLoginStatus];
}

#pragma mark - request
- (void)requetBarcode{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid]
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_qrcode,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_qrcode]) {
        NSDictionary *res = result[@"res"];
        NSString * imglink = res[@"imglink"];
        [self.qrView  sd_setImageWithURL:[NSURL URLWithString:imglink] placeholderImage:[UIImage imageNamed:@"res/user/0.png"]];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_update]) {
        NSLog(@"生成二维码失败");
        if (error.code == 3 && [error.domain containsString:@"需要登录"]) {
            
        }
    }
}

- (void)checkLoginStatus{
    if ([[UserManager sharedInstance] hasLogin]) {
        [self goNext];
    }
    else{
        [self setupMainView];
        [[ExceptionEngine shared] alertTitle:nil message:@"使用此功能需要登录！" delegate:self tag:-13 cancelBtn:@"取消" btn1:@"登录" btn2:nil];
//        [[UserManager sharedInstance] tryCheckLogin:self delegate:nil info:nil CallBack:^(int ret) {
//            [self goNext];
//        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
    if (alertView.tag == -13 && buttonIndex == k_buttonIndex_btn1) {
        [[UserManager sharedInstance] tryCheckLogin:self delegate:nil info:nil CallBack:^(int ret) {
            [self goNext];
        }];
    }
    else if (alertView.tag == -13 && buttonIndex == k_buttonIndex_cancel) {
        [self back];
    }
}

- (void)goNext{
    [self setupMainView];
    [self requetBarcode];
}

- (void)didLoginSuccessInLoginVC:(NSDictionary *)result{
    InfoLog(@"");
    [self goNext];
}
- (void)didLoginErrorInLoginVC:(NSError *)error{
    InfoLog(@"");
    [self back];
}

- (void)back{
    [self clickLeftBarButtonItem];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate (CallBack)
- (void)orderIDtButtonItem:(UIButton *)sender{
    BusinessSeanViewController * vc = [[BusinessSeanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}


#pragma mark request delegate

#pragma mark other delegate

#pragma mark - action such as: click touch tap slip ...
- (void)clickRightButtonItem:(id)sender {
    [self showConfirmSelectedView:@[@"保存到相册",@"扫描二维码",@"确定"] action:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    
    if ([(UIView *)sender tag] == 0) {
        UIImageWriteToSavedPhotosAlbum(self.qrView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }else{
        MySeanViewController * msVC = [[[MySeanViewController alloc]init]autorelease];
        [self.navigationController pushViewController:msVC animated:YES];
    }
}
//保存图片
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存失败" ;
    }else{
        msg = @"保存成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片"
                                                    message:msg
                                                   delegate:self
                                                cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)sacnButAction:(UIButton *)sender{
    MySeanViewController * msVC = [[[MySeanViewController alloc]init]autorelease];
    [self.navigationController pushViewController:msVC animated:YES];
}

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    self.barcodeView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                            V_BGColor:k_defaultViewControllerBGColor,
                                            }];
    [self.contentView addSubview:_barcodeView];
    
    CGFloat half_hei = kScreenHeight * 3 / 5;
    CGFloat hei_1 = half_hei; //
    CGFloat margin = 40;
    
    UIView * bgView = [UIView view_sub:@{V_Parent_View:self.barcodeView,
                                         V_Height:strFloat(hei_1),
                                         V_Margin_Top:strFloat(margin),
                                         V_Over_Flow_X:num(OverFlowXCenter),
                                         V_Margin_Left:strFloat(margin),
                                         V_Margin_Right:strFloat(margin),
                                         V_BGColor:white_color,
                                         V_Border_Color:k_defaultLineColor,
                                         V_Border_Width:@0.5,
                                         V_Border_Radius:@5,
                                         }];
    [_barcodeView addSubview:bgView];
    
    CGFloat aHeight = bgView.height * 41/50;
    UIView * aView = [UIView view_sub:@{V_Parent_View:bgView,
                                        V_Over_Flow_X:num(OverFlowXCenter),
                                        V_Height:strFloat(aHeight),
                                        V_BGColor:yello_color,
                                        }];
    [bgView addSubview:aView];
    
    CGFloat left =  25;
    
    CGFloat qrHeight = aView.height * 13/20;
    
    self.qrView = [UIView imageView:@{V_Parent_View:aView,
                                               V_Margin_Top:strFloat(margin),
                                               V_Margin_Left:strFloat(left),
                                               V_Margin_Right:strFloat(left),
                                               V_Height:strFloat(qrHeight),
                                               V_Over_Flow_X:num(OverFlowXCenter),
                                               }];
    [aView addSubview:self.qrView];
    
    UILabel * addLab = [UIView label:@{V_Parent_View:aView,
                                       V_Last_View:self.qrView,
                                       V_Over_Flow_X:num(OverFlowXCenter),
                                       V_Margin_Top:@10,
                                       V_Font_Family:k_fontName_FZZY,
                                       V_TextAlign:num(TextAlignCenter),
                                       V_Font_Size:num(14),
                                       V_Height:@20,
                                       V_Text:@"扫一扫加我",
                                       V_Color:zongSeBGColor,
                                       }];
    
    [aView addSubview:addLab];
    
    CGFloat logo = 45;
    UIImageView * userLogo1 = [UIView imageView:@{V_Parent_View:bgView,
                                                  V_Last_View:aView,
                                                  V_Margin_Top:@8,
                                                  V_Width:strFloat(logo),
                                                  V_Height:strFloat(logo),
                                                  V_Margin_Left:@8,
                                                  V_BGColor:white_color,
                                                  V_Border_Radius:strFloat(logo / 2.0),
//                                                     V_Img:[[UserManager sharedInstance] getUserHeadLogo:self.userid brifItem:_userBriefItem],
                                                  V_ContentMode:num(ModeAspectFill),
                                                  }];
    userLogo1.clipsToBounds = YES;
    UIImage * img = [[UserManager sharedInstance] getUserHeadLogo:[UserManager sharedInstance].userid brifItem:_userBriefItem];
    userLogo1.image = img;
    [bgView addSubview:userLogo1];
    
    NSString * text = [UserManager sharedInstance].brief.name;
    if (!text) {
        text = @"";
    }
    UILabel * name = [UIView label:@{V_Parent_View:bgView,
                                         V_Last_View:aView,
                                         V_Left_View:userLogo1,
                                         V_Margin_Left:@5,
                                         V_Margin_Right:@5,
                                         V_Margin_Top:@10,
                                         V_Font_Family:k_fontName_FZZY,
                                         V_Font_Size:num(14),
                                         V_Height:@20,
                                         V_Text:text,
                                         V_Color:zongSeBGColor,
                                         }];
    [bgView addSubview:name];
    
    text = [UserManager sharedInstance].brief.intro;
    if (!text) {
        text = @"";
    }
    UILabel * content = [UIView label:@{V_Parent_View:bgView,
                                        V_Last_View:name,
                                        V_Left_View:userLogo1,
                                        V_Margin_Left:@5,
//                                        V_Margin_Top:@5,
                                        V_Color:k_defaultTextColor,
                                        V_Font_Size:num(10),
                                        V_Height:@20,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Text:text,
                                        V_Color:zongSeBGColor,
                                        V_Alpha:@0.5,
                                        }];
    [bgView addSubview:content];
    if (text.length == 0 ){
        CGFloat nameW = self.contentView.width - userLogo1.width -10;
        name.frame = CGRectMake(userLogo1.width + 10, aView.height +20, nameW, 20);
    }
    
    CGFloat scanHeight = _barcodeView.height * 20/25;
    UIButton * scanBut = [UIView button:@{V_Parent_View:self.barcodeView,
                                          V_Margin_Top:strFloat(scanHeight),
                                          V_Over_Flow_X:num(OverFlowXCenter),
                                          V_Img:@"sca_bg",
                                          V_Img_C:@"sca_bg",
                                          V_Width:@50,
                                          V_Height:@50,
                                          V_SEL:selStr(@selector(sacnButAction:)),
                                          V_Delegate:self,
                                          }];
    [_barcodeView addSubview:scanBut];
    
    UILabel * scanLab  = [UIView label:@{V_Parent_View:self.barcodeView,
                                         V_Last_View:scanBut,
                                         V_Margin_Top:@10,
                                         V_Over_Flow_X:num(OverFlowXCenter),
                                         V_Font_Size:num(14),
                                         V_TextAlign:num(TextAlignCenter),
                                         V_Height:@20,
                                         V_Font_Family:k_fontName_FZZY,
                                         V_Text:@"扫一扫有惊喜",
                                         V_Color:zongSeBGColor,
                                         }];
    [_barcodeView addSubview:scanLab];

}

- (void)dealloc{
    [super dealloc];
    [_barcodeView release];
}

#pragma mark - other method
#pragma mark


@end
