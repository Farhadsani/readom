#import "AppController+pay.h"
#import "PaySuccessViewController.h"
#import "Order.h"

@implementation AppController (pay)

#pragma mark - 支付宝支付

- (void)sendAliPay:(NSDictionary *)orderInfo signedStr:(NSString *)signedString callback:(UIViewController*)pDelegate{
    if (![NSDictionary isNotEmpty:orderInfo]) {
        return;
    }
    
    NSString *appScheme = k_alipay_appScheme;
    NSString *orderString = [orderInfo objectOutForKey:@"sstr"];
    [[Cache shared].cache_dict setValue:orderInfo[@"orderid"] forKey:ZhiFuBaoPayOrderId];

    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //支付宝客户端回调    客户端需要跳转到支付成功界面
        NSString * resultStatus = [resultDic objectOutForKey:@"resultStatus"];
        if (resultStatus && [resultStatus integerValue] == 9000) {
            [self jumpToPaySuccessPage:nil payType:AliPay];
        }
        else{
            [self alert:nil msg:@"支付发生错误，请重新支付！"];
        }
    }];
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg{
    [[ExceptionEngine shared] alertTitle:title message:msg delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [self handelUrl:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self handelUrl:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    return [self handelUrl:url];
}

- (BOOL)handelUrl:(NSURL *)url{
    InfoLog(@"open url:===%@", url);
    InfoLog(@"absoluteString:===%@", url.absoluteString);
    
    if ([url.absoluteString containsString:WXAppID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                InfoLog(@"11 result = %@",resultDic);
                [self handelALiResult:resultDic];
            }];
            
            return YES;
        }
        else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                InfoLog(@"22 result = %@",resultDic);
                [self handelALiResult:resultDic];
            }];
            
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - 处理支付宝支付后回调

- (void)handelALiResult:(NSDictionary *)resultDic{
    //支付宝客户端回调    客户端需要跳转到支付成功界面
    NSString * resultStatus = [resultDic objectOutForKey:@"resultStatus"];
    NSString * result = [resultDic objectOutForKey:@"result"];
    if (resultStatus && [resultStatus integerValue] == 9000 && result && [result length] > 0) {
        [self jumpToPaySuccessPage:[NSString postDictionaryWithString:result] payType:AliPay];
    }
    else{
        [[ExceptionEngine shared] alertTitle:nil message:@"支付发生错误，请重新支付！" delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
    }
}

- (void)jumpToPaySuccessPage:(NSDictionary *)payInfo payType:(PayType)type{
    
    UIViewController * topNav = [self getVisibleViewController];
    if (topNav) {
        PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc] initWithNibName:nil bundle:nil];
        [paySuccessVC.infoFromPayCalllback removeAllObjects];
        for (NSString * key in [payInfo allKeys]) {
            id value = [payInfo objectOutForKey:key];
            if (value && [value isKindOfClass:[NSString class]]) {
                [paySuccessVC.infoFromPayCalllback setObject:[value stringByReplacingOccurrencesOfString:@"\"" withString:@""] forKey:key];
            }
            else{
                if (value) {
                    [paySuccessVC.infoFromPayCalllback setObject:value forKey:key];
                }
            }
        }
        
        paySuccessVC.payType = type;
        [topNav.navigationController pushViewController:paySuccessVC animated:YES];
        [paySuccessVC release];
    }
}


@end