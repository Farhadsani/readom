//
//  StorePayMoneyViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import "StorePayMoneyViewController.h"
#import "PayMoneyView.h"
#import "PaySuccessViewController.h"

@interface StorePayMoneyViewController () <PayMoneyViewDelegate>
@property (nonatomic, weak) PayMoneyView *payMoneyView;
@end

@implementation StorePayMoneyViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userid = [UserManager sharedInstance].userid;
    
    self.title = @"收银台";
    
    PayMoneyView *payMoneyView = [PayMoneyView payMoneyView];
    [self.contentView addSubview:payMoneyView];
    CGRect frame = payMoneyView.frame;
    frame.size = CGSizeMake(self.contentView.width, 137);
    payMoneyView.frame = frame;
    payMoneyView.delegate = self;
    payMoneyView.goodsOrder = self.goodsOrder;
    
#ifdef k_SHOW_AGREEMENT_LINK_PAY
    UILabel * agreement = [UIView label:@{V_Parent_View:self.contentView,
                                          V_Over_Flow_Y:num(OverFlowBottom),
                                          V_Over_Flow_X:num(OverFlowXCenter),
                                          V_Height:@50,
                                          V_Text:[NSString stringWithFormat:@"购买即为已同意《%@》", k_user_agreement_pay_title],
                                          V_Font_Family:k_defaultFontName,
                                          V_Font_Size:@12,
                                          V_Color:gray_color,
                                          V_TextAlign:num(TextAlignCenter),
                                          V_Alpha:@0.6,
                                          V_Delegate:self,
                                          V_SEL:selStr(@selector(jumpToAgreement)),
                                          }];
    [self.contentView addSubview:agreement];
#endif
    
}

- (void)jumpToAgreement{
    InfoLog(@"");
    [self openWebView:k_user_agreement_pay localXml:nil title:k_user_agreement_pay_title otherInfo:@{@"openType":@"push",@"hidNav":@"NO"}];
}

#pragma mark - request delegate

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_create_order_to_pay]) {
        self.payMoneyView.userInteractionEnabled = YES;
        NSNumber *type = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"type"];
        NSDictionary * res = [result objectOutForKey:@"res"];
        AppController *delegate = (AppController *)[UIApplication sharedApplication].delegate;
        if ([type boolValue]) {
            //微信支付
            [delegate sendWechatPay:res callback:self];
        } else {
            //支付宝
            [delegate sendAliPay:res signedStr:nil callback:self];
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_create_order_to_pay]) {
        self.payMoneyView.userInteractionEnabled = YES;
//        [[ExceptionEngine shared] alertTitle:nil message:@"生成订单失败，请稍后再试！" delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
    }
}

#pragma mark - PayMoneyViewDelegate
- (void)payMoneyView:(PayMoneyView *)view zhifubaoPayBtnDidOnClick:(UIButton *)button{
    InfoLog(@"%s", __func__);
    [self requestCreateOrderToPay:AliPay];
}

- (void)payMoneyView:(PayMoneyView *)view weixinPayBtnDidOnClick:(UIButton *)button{
    InfoLog(@"%s", __func__);
    [self requestCreateOrderToPay:WeichatPay];
}

- (void)requestCreateOrderToPay:(PayType)type{
    
//    PaySuccessViewController *p = [[PaySuccessViewController alloc] init];
//    [self.navigationController pushViewController:p animated:YES];
//    return ;
    
    self.payMoneyView.userInteractionEnabled = NO;
    
    NSDictionary *params;
    if (self.orderid == 0) {
        params =  @{@"type":@((type == AliPay) ? 0 : 1),
                    @"goodsid":@(self.goodsOrder.goodsid),
                    @"goodscount":@(self.goodsOrder.count),
                    @"price":self.goodsOrder.price,
                };
    } else {
        params = @{@"type":@((type == AliPay) ? 0 : 1),
                   @"orderid":@(self.orderid),
                 };
    }
    
    
    NSDictionary * dict = @{@"idx":str(1),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    
    [[LoadingView shared] setIsFullScreen:YES];
    NSDictionary * d = @{k_r_url:k_api_create_order_to_pay,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}
@end
