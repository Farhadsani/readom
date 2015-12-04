#import "AppController+WXLogin+Pay.h"
#import "LoggerClient.h"
#import "WXLogin.h"
#import "PaySuccessViewController.h"


@implementation AppController (WXLogin)

/**
 *  微信登录的调用方法，获取code
 */
- (void)WXLogin:(UIViewController*)pDelegate
{
    [[WXLogin sharedInstance] sendAuthRequest:pDelegate];
}

#pragma mark - 微信支付
//============================================================
// V3&V4支付流程实现
// 注意:参数配置请查看服务器端Demo
// 更新时间：2015年3月3日
// 负责人：李启波（marcyli）
//============================================================
- (void)sendWechatPay:(NSDictionary *)orderInfo callback:(UIViewController*)pDelegate
{
    //向微信注册
    BOOL succ = [WXApi registerApp:WXAppID withDescription:@"demo 2.0"];
    if (succ) {
        PayReq *request = [[[PayReq alloc] init] autorelease];
        request.partnerId = orderInfo[@"partnerid"];
        request.prepayId= orderInfo[@"prepayid"];
        request.package = orderInfo[@"package"];
        request.nonceStr= orderInfo[@"noncestr"];
        request.timeStamp= [orderInfo[@"timestamp"] unsignedIntValue];
        request.sign= orderInfo[@"sign"];
        [[Cache shared].cache_dict setValue:orderInfo[@"orderid"] forKey:WeiXinPayOrderId];
        [WXApi sendReq:request];
      
//        //从服务器获取支付参数，服务端自定义处理逻辑和格式
//        //订单标题
//        NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
//        //订单金额，单位（元）
//        NSString *ORDER_PRICE   = orderInfo[@""];
//        //订单号
//        NSString *ORDER_ID   = @"订单号";
//        
//        //根据服务器端编码确定是否转码
//        NSStringEncoding enc;
//        //if UTF8编码
//        //enc = NSUTF8StringEncoding;
//        //if GBK编码
//        enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
//                               [NSString stringWithFormat:@"%@%@", k_EXTERN_ENDPOINT_SERVER_URL, k_api_order_pay],
//                               [ORDER_ID stringByAddingPercentEscapesUsingEncoding:enc],
//                               [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
//                               ORDER_PRICE];
//        
//        //解析服务端返回json数据
//        NSError *error;
//        //加载一个NSURL对象
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        //将请求的url数据放到NSData对象中
//        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        if ( response != nil) {
//            NSMutableDictionary *dict = NULL;
//            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//            dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//            
//            InfoLog(@"url:%@",urlString);
//            if(dict != nil){
//                NSMutableString *retcode = [dict objectForKey:@"retcode"];
//                if (retcode.intValue == 0){
//                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                    
//                    //调起微信支付
//                    PayReq* req             = [[[PayReq alloc] init]autorelease];
//                    req.openID              = [dict objectForKey:@"appid"];
//                    req.partnerId           = [dict objectForKey:@"partnerid"];
//                    req.prepayId            = [dict objectForKey:@"prepayid"];
//                    req.nonceStr            = [dict objectForKey:@"noncestr"];
//                    req.timeStamp           = stamp.intValue;
//                    req.package             = [dict objectForKey:@"package"];
//                    req.sign                = [dict objectForKey:@"sign"];
//                    [WXApi sendReq:req];
//                    //日志输出
//                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//                }else{
//                    [self alert:nil msg:[dict objectForKey:@"retmsg"]];
//                }
//            }else{
//                [self alert:nil msg:@"服务器返回错误，未获取到json对象"];
//            }
//        }else{
//            [self alert:nil msg:@"服务器返回错误"];
//        }
    }
}

#pragma mark - 微信回调
/**
 *  授权回调时用
 */
- (void)onResp:(BaseResp *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if (resp && [resp isKindOfClass:[SendAuthResp class]]) {
        //微信授权登录
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) {
            NSString *code = aresp.code;
            [[WXLogin sharedInstance] getAccess_TokenWithCode:code];
        }
    }
    else if (resp && [resp isKindOfClass:[PayResp class]]) {
        //微信支付
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                 [self jumpToPaySuccessPage:[NSString postDictionaryWithString:response.returnKey] payType:WeichatPay];
                break;
            default:
                [self alert:nil msg:@"支付发生错误，请重新支付！"];
                break;
        }
    }
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options{
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

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg{
    [[ExceptionEngine shared] alertTitle:title message:msg delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
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

@end