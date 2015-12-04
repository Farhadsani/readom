#import "AppController+WXLogin.h"
#import "LoggerClient.h"
#import "WXLogin.h"

@implementation AppController (WXLogin)

/**
 *  微信登录的调用方法，获取code
 */
- (void)WXLogin:(UIViewController*)pDelegate
{
    [[WXLogin sharedInstance] sendAuthRequest:pDelegate];
}

-(void) onReq:(BaseReq*)req
{
    Log(@"onReq");
}

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
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0) {
        NSString *code = aresp.code;
        [[WXLogin sharedInstance] getAccess_TokenWithCode:code];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

@end