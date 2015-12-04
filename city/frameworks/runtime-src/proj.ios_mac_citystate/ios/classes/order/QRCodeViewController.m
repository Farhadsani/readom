//
//  QRCodeViewController.m
//  citystate
//
//  Created by 石头人工作室 on 15/11/3.
//
//

#import "QRCodeViewController.h"
#import "UIImageView+WebCache.h"

#define zongSeBGColor   rgb(100, 76, 67) //textCorol

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

//@synthesize QRcodeURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    
    [self setupMainView];
}

- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    CGFloat half_hei = kScreenHeight / 2;
    CGFloat hei_1 = half_hei; //
    CGFloat margin = 40;
    UIView * bgView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                         V_BGColor:white_color,
                                         V_Border_Color:k_defaultLineColor,
                                         V_Border_Width:@0.5,
                                         V_Border_Radius:@5,
                                         }];
    [self.contentView addSubview:bgView];
    
    UIView * bgQRView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                         V_Height:strFloat(hei_1),
                                         V_Margin_Top:strFloat(hei_1/4),
                                         V_Over_Flow_X:num(OverFlowXCenter),
                                         V_Margin_Left:strFloat(margin),
                                         V_Margin_Right:strFloat(margin),
                                         V_BGColor:yello_color,
                                         V_Border_Color:k_defaultLineColor,
                                         V_Border_Width:@0.5,
                                         V_Border_Radius:@5,
                                         }];
    bgQRView.layer.cornerRadius = 10;
    bgQRView.clipsToBounds = YES;
    [self.contentView addSubview:bgQRView];
    
    if (![NSString isEmptyString:_passwd]) {
        UILabel * lab = [UIView label:@{V_Parent_View:bgView,
                                        V_Text:[NSString stringWithFormat:@"%@", _passwd],
                                        V_TextAlign:num(TextAlignCenter),
                                        V_Height:strFloat(bgQRView.height),
                                        V_Font_Family:k_defaultFontName,
                                        V_Font_Size:@15,
                                        V_Color:k_defaultTextColor,
                                        }];
        [bgView addSubview:lab];
    }
    
    
    CGFloat left =  25;
    
//    CGFloat qrHeight = bgQRView.height * 13/20;
    CGFloat qrHeight = bgQRView.width - left*2;
    
    UIImageView* qrImage = [UIView imageView:@{V_Parent_View:bgQRView,
                                      V_Margin_Top:strFloat(margin),
                                      V_Margin_Left:strFloat(left),
                                      V_Margin_Right:strFloat(left),
                                      V_Height:strFloat(qrHeight),
                                      V_Over_Flow_X:num(OverFlowXCenter),
//                                      V_ContentMode:num(ModeAspectFill) ,
                                      }];
//    UIImage * aimage = [UIImage imageNamed:@"res/user/0.png"];
//    [self.qrView setImage:aimage];
    [qrImage sd_setImageWithURL:[NSURL URLWithString:_QRcodeURL]];
    [bgQRView addSubview:qrImage];

    
//    UIImageView* qrImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/4, kScreenWidth/3, kScreenWidth/2, kScreenWidth/2)];
    
    
//    [self.contentView addSubview:qrImage];
    
    UILabel * tip = [UIView label:@{V_Parent_View:bgQRView,
                                       V_Last_View:qrImage,
                                       V_Over_Flow_X:num(OverFlowXCenter),
                                       V_Margin_Top:@10,
                                       V_Font_Family:k_fontName_FZZY,
                                       V_TextAlign:num(TextAlignCenter),
                                       V_Font_Size:num(14),
                                       V_Height:@20,
                                       V_Text:@"扫一扫收款",
                                       V_Color:zongSeBGColor,
                                       }];
    [bgQRView addSubview:tip];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
