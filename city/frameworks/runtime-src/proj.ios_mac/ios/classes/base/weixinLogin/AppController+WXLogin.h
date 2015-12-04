#import <AppController.h>
#import "WXApi.h"

@interface AppController (WXLogin) <WXApiDelegate,UIApplicationDelegate>
- (void)WXLogin:(UIViewController*)pDelegate;
@end
