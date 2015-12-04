//
//  PaySuccessViewController.m
//  citystate
//
//  Created by hf on 15/11/16.
//
//

#import "PaySuccessViewController.h"
#import "QRCodeViewController.h"
#import "StoreViewController.h"
#import "CocosMapIndexRootViewController.h"
#import "OrdersViewController.h"

#define Space 10

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)variableInit{
    [super variableInit];
    if (!_infoFromPayCalllback) {
        _infoFromPayCalllback = [[NSMutableDictionary alloc] init];
    }
    [_infoFromPayCalllback removeAllObjects];
    
    if (!_orderInfo) {
        _orderInfo = [[NSMutableDictionary alloc] init];
    }
    
    _payType = 0;
}

- (void)viewDidLoad {
    self.navbarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = NO;
    [super viewDidLoad];
    self.title = @"交易详情";
    [self requestConfirmPayResult];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [self clickLeftBarButtonItem];
//    [self.navigationController popViewControllerAnimated:YES];
    BOOL isIn = NO;
    NSArray * vcs = self.navigationController.viewControllers;
    if ([NSArray isNotEmpty:vcs]) {
        for (UIViewController * vc in vcs) {
            if ([vc isKindOfClass:[StoreViewController class]] ||
                [vc isKindOfClass:[CocosMapIndexRootViewController class]] ||
                [vc isKindOfClass:[OrdersViewController class]]) {
                isIn = YES;
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    
    if (!isIn) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - request delegate

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_detail]) {

        if ([NSDictionary isNotEmpty:[result objectForKey:@"res"]]) {
            if ([[result objectForKey:@"res"] objectForKey:@"order"]) {
                self.orderIntro = [OrderIntro objectWithKeyValues:[[result objectForKey:@"res"] objectForKey:@"order"]];
            }
        }
        
        [self setupMainView:result];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_detail]) {
        
    }
}

#pragma mark - request action

- (void)requestConfirmPayResult{
    
    NSString *orderid;
    
    if (self.payType == AliPay) {
        orderid = [[Cache shared].cache_dict objectForKey:ZhiFuBaoPayOrderId];
    } else {
        orderid = [[Cache shared].cache_dict objectForKey:WeiXinPayOrderId];
    }

//    NSDictionary * params = @{@"orderid": @(6074873173914952199)//@([orderid longLongValue]),
//                              };
    NSDictionary * params = @{@"orderid": @([orderid longLongValue]),
                              };    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_order_detail,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - view init

- (void)setupMainView:(NSDictionary *)result{
    [self.contentView removeAllSubviews];
    
    UIButton * btnTop = [UIView button:@{V_Parent_View:self.contentView,
                                         V_Width:@100,
                                         V_Height:@50,
                                         V_Over_Flow_X:num(OverFlowXCenter),
                                         V_Title:@" 支付成功!",
                                         V_Color:rgb(63, 205, 16),
                                         V_Img:@"zhifuchenggong",
                                         V_Font_Family:k_defaultFontName,
                                         V_Font_Size:@18,
                                         }];
    [self.contentView addSubview:btnTop];
    
    UIView * section1 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                           V_Last_View:btnTop,
                                           V_Height:@100,
                                           V_Border_Color:k_defaultLineColor,
                                           V_Border_Width:@0.5,
                                           }];
    [self.contentView addSubview:section1];
    [self createSection1:section1];
    
    UIView * section2 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                           V_Last_View:section1,
                                           V_Margin_Top:@10,
                                           V_Height:@150,
                                           V_Border_Color:k_defaultLineColor,
                                           V_Border_Width:@0.5,
                                           }];
    [self.contentView addSubview:section2];
    [self createSection2:section2];
    section2.backgroundColor = [UIColor whiteColor];
    section1.backgroundColor = [UIColor whiteColor];
    
    self.contentView.contentSize = CGSizeMake(self.contentView.contentSize.width, section2.y+section2.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = self.navbarHidden;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = self.navbarHidden;
}

- (void)clickToQRCode:(id)sender{
    UIControl *ctrl = (UIControl *)sender;
    int t = (int)ctrl.tag;
    NSDictionary * info = self.orderIntro.code[t];
    NSString *  passwd = [info objectOutForKey:@"passwd"];
    id used = [info objectOutForKey:@"used"];
    NSString * qrcode = [info objectOutForKey:@"qrcode"];
    NSLog(@"%@..%@ ..  %@", passwd, used, qrcode);
    
    QRCodeViewController *vc = [[QRCodeViewController alloc]init];
    vc.orderIntro = self.orderIntro;
    vc.QRcodeURL = qrcode;
    vc.passwd = passwd;
    vc.used = ([strObj(used) integerValue] == 0) ? NO : YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)createSection1:(UIView *)section{
    UILabel * storeName = [UIView label:@{V_Parent_View:section,
                                          V_Over_Flow_X:num(OverFlowXCenter),
                                          V_Width:@200,
                                          V_Height:@70,
                                          V_Text:_orderIntro.storename,
                                          V_Color:k_defaultTextColor,
                                          V_Font_Family:k_defaultFontName,
                                          V_Font_Size:@17,
                                          V_TextAlign:num(TextAlignCenter),
                                          }];
    [section addSubview:storeName];
    
    UIView * lab1 = [UIView view_sub:@{V_Parent_View:section,
                                       V_Last_View:storeName,
                                       V_Margin_Left:strFloat(Space),
                                       V_Margin_Right:strFloat(Space),
                                       V_Height:@0.5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [section addSubview:lab1];
    
    UIView * section3 = [UIView view_sub:@{V_Parent_View:section,
                                           V_Last_View:lab1,
                                           V_Height:@90,
                                           }];
    [section addSubview:section3];
    [self createSection_3:section3];
    
    [self resetFrameHeightOfView:section];
}

- (void)createSection2:(UIView *)section{
    [self createSection_4:section];
}

- (void)dealloc{
    self.infoFromPayCalllback = nil;
    self.orderInfo = nil;
    [super dealloc];
}


#pragma mark - other method
#pragma mark
- (void)createSection_3:(UIView *)section{
    CGFloat lineHeight = 25;
    CGFloat x = Space;
    UIView * lab1 = [UIView label:@{V_Parent_View:section,
                                    V_Height:strFloat(lineHeight),
                                    V_Margin_Left:strFloat(x),
                                    V_Margin_Top:@5,
                                    V_Text:_orderIntro.goodsname,
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultLightTextColor,
                                    }];
    [section addSubview:lab1];
    
    lab1 = [UIView view_sub:@{V_Parent_View:section,
                              V_Last_View:lab1,
                              V_Margin_Left:strFloat(x),
                              V_Margin_Right:strFloat(x),
                              V_Margin_Top:@5,
                              V_Height:@0.5,
                              V_BGColor:k_defaultLineColor,
                              }];
    [section addSubview:lab1];
    
    lineHeight = 41;
    if ([NSArray isNotEmpty:self.orderIntro.code]) {
        CGFloat y = lab1.y +lab1.height;
        CGFloat w = 0;
        int index = 0;
        for (NSDictionary * info in self.orderIntro.code) {
            //            y = y+lab1.height;
            if (index == 0) {
                //                y+=10;
            }
            w = section.width - 2*x;
            NSString *  passwd = [info objectOutForKey:@"passwd"];
            id used = [info objectOutForKey:@"used"];
            BOOL hasUsed = NO;
            if (used && [used integerValue] != 0) {
                hasUsed = YES;
            }
            
            UIView* ctrol = [UIView control:@{V_Parent_View:section,
                                              V_Margin_Top:strFloat(y),
                                              V_Margin_Left:strFloat(Space),
                                              V_Height:strFloat(lineHeight),
                                              V_BGColor:white_color,
                                              V_Delegate:self,
                                              V_SEL:selStr(@selector(clickToQRCode:)),
                                              }];
            [ctrol setTag:index];
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"codecell"];
            cell.frame = CGRectMake(0, 0, w, lineHeight);
            if (hasUsed) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, 30),
                                                         V_Img:@"buddystatus_arrow",
                                                         V_ContentMode:num(ModeCenter),
                                                         }];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            
            lab1 = [self View:cell
                        frame:CGRectMake(0, (lineHeight-25)/2, w-15, 25)
                         with:[NSString stringWithFormat:@"密码%d：", index+1] :passwd :nil :nil :(hasUsed)?@"已使用":@"未使用"];
            
            [ctrol addSubview:cell];
            [section addSubview:ctrol];
            index++;
            y = y + lineHeight;
        }
        if (index == 1) {
            [self resetFrameHeightOfView:section];
            section.frame = CGRectMake(section.x, section.y, section.width, section.height-20);
            return;
        }
        else{
            [self resetFrameHeightOfView:section];
            section.frame = CGRectMake(section.x, section.y, section.width, section.height-10);
            return;
        }
    }
    
    [self resetFrameHeightOfView:section];
}

- (void)createSection_4:(UIView *)section{
    CGFloat lineHeight = 35;
    CGFloat x = Space;
    UIView * lab1 = [UIView label:@{V_Parent_View:section,
                                    V_Height:strFloat(lineHeight),
                                    V_Margin_Left:strFloat(x),
                                    V_Margin_Top:@5,
                                    V_Text:@"订单信息",
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultLightTextColor,
                                    }];
    [section addSubview:lab1];
    
    lab1 = [UIView view_sub:@{V_Parent_View:section,
                              V_Last_View:lab1,
                              V_Margin_Left:strFloat(x),
                              V_Margin_Right:strFloat(x),
                              V_Height:@0.5,
                              V_BGColor:k_defaultLineColor,
                              }];
    [section addSubview:lab1];
    
    lineHeight = 28;
    
    CGFloat y = lab1.y+lab1.height+5;
    CGFloat w = section.width - 2*x;
    int index = 0;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"订单号码：" :[NSString stringWithFormat:@"%lld",(_orderIntro.orderid)] :nil :nil :nil];
    
    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"付款时间：" :_orderIntro.ptime :nil :nil :nil];
    
    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"有效期：" :_orderIntro.dtime :nil :nil :nil];

    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"使用时间：" :_orderIntro.utime :nil :nil :nil];

    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"手机号码：" :_orderIntro.phone :nil :nil :nil];
    
    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"订单数量：" :[NSString stringWithFormat:@"%d",_orderIntro.goodscount] :@"          总价：" :[NSString stringWithFormat:@"¥%.2f",_orderIntro.goodscount*[_orderIntro.price floatValue]] :nil];
    
    [self resetFrameHeightOfView:section];
}

#pragma mark - other method
#pragma mark

- (UIView *)View:(UIView *)section frame:(CGRect)frame with:(NSString *)text1 :(NSString *)text2 :(NSString *)text3 :(NSString *)text4 :(NSString *)textRight{
    UIView * base = [UIView view_sub:@{V_Parent_View:section,
                                       V_BGColor:white_color,
                                       }];
    base.frame = frame;
    [section addSubview:base];
    
    CGFloat lineHeight = 25;
    CGFloat left = Space;
    
    CGFloat textWidth = [text1 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
    UIView * lab1 = [UIView label:@{V_Parent_View:base,
                                    V_Height:strFloat(lineHeight),
                                    V_Width:strFloat(textWidth),
                                    V_Text:text1,
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultLightTextColor,
                                    }];
    [base addSubview:lab1];
    
    if (text2) {
        textWidth = [text2 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:strFloat(textWidth),
                               V_Left_View:lab1,
                               V_Text:text2,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultTextColor,
                               }];
        [base addSubview:lab1];
    }
    
    if (text3) {
        textWidth = [text3 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:strFloat(textWidth),
                               V_Left_View:lab1,
                               V_Text:text3,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultLightTextColor,
                               }];
        [base addSubview:lab1];
    }
    
    if (text4) {
        if ([text4 containsString:@"¥"]) {
            NSString * unit = @"¥ ";
            textWidth = [unit stringSize:[UIFont systemFontOfSize:14.0]].width;
            lab1 = [UIView label:@{V_Parent_View:base,
                                   V_Height:strFloat(lineHeight),
                                   V_Width:strFloat(textWidth),
                                   V_Left_View:lab1,
                                   V_Text:unit,
                                   V_Font_Size:@14,
                                   V_Color:k_defaultTextColor,
                                   }];
            [base addSubview:lab1];
            text4 = [text4 stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        }
        
        textWidth = [text4 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:strFloat(textWidth),
                               V_Left_View:lab1,
                               V_Text:text4,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultTextColor,
                               }];
        [base addSubview:lab1];
    }
    
    if (textRight) {
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:@100,
                               V_Over_Flow_X:num(OverFlowRight),
                               V_Margin_Right:strFloat(left),
                               V_Text:textRight,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultLightTextColor,
                               V_TextAlign:num(TextAlignRight),
                               }];
        [base addSubview:lab1];
    }
    
    return base;
}
@end
