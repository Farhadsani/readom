#import <AppController.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppController (WXLogin) <WXApiDelegate,UIApplicationDelegate>

- (void)WXLogin:(UIViewController*)pDelegate;

- (void)sendWechatPay:(NSDictionary *)orderInfo callback:(UIViewController*)pDelegate;

@end
