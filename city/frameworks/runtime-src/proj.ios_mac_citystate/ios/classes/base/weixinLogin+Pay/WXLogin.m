

#import "WXLogin.h"
#import "LoggerClient.h"
#import "LoginViewController.h"

@interface WXLogin()
@property WXLoginInfo *loginInfo;
@end

@implementation WXLogin
@synthesize delegate;
/**
 *  设计单例模式，只创建一次token
 */
+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return  instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [WXApi registerApp:WXAppID];
    }
    return self;
}

- (void)sendAuthRequest:(UIViewController*)pDelegate
{
    self.delegate = pDelegate;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base"; //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    req.state = @"SHITOUREN";  //用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

/**
 *  通过code来获取用户的access_token
 */
- (void)getAccess_TokenWithCode:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAppID, WXAppSecret, code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                Log(@"access_token: %@",[dict objectForKey:@"access_token"]);
                if (!self.loginInfo) {
                    self.loginInfo = [[WXLoginInfo alloc] init];
                }
                self.loginInfo.openId = [dict objectForKey:@"openid"];
                [self getUserInfoWithToken:[dict objectForKey:@"access_token"] OpenID:@"openid"];
            }
        });
    });
}

/**
 *  通过token来获取用户的个人信息
 */
- (void)getUserInfoWithToken:(NSString *)token OpenID:(NSString *)openid
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token, openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.loginInfo.nickName = [dict objectForKey:@"nickname"];
                self.loginInfo.headUrl = [dict objectForKey:@"headimgurl"];
                self.loginInfo.openId = [dict objectForKey:@"openid"];
                self.loginInfo.unionId = [dict objectForKey:@"unionid"];
                Log(@"type: weixin");
                Log(@"nickname: %@",self.loginInfo.nickName);
                Log(@"headurl: %@",self.loginInfo.headUrl);
                Log(@"openid: %@",self.loginInfo.openId);
                Log(@"unionid: %@",self.loginInfo.unionId);
                if( delegate ){
                    [(LoginViewController*)(delegate) wxCallback:self.loginInfo];
                }
            }
        });
    });
}

@end
@implementation WXLoginInfo
@end
