#import <AppController.h>
#import "WXApi.h"

#import <AlipaySDK/AlipaySDK.h>

@interface AppController (pay) <WXApiDelegate,UIApplicationDelegate>

- (void)sendAliPay:(NSDictionary *)orderInfo signedStr:(NSString *)signedString callback:(UIViewController*)pDelegate;

@end
