#import "WXApi.h"

@interface WXLoginInfo : NSObject
@property (copy,atomic) NSString *nickName;
@property (copy,atomic) NSString *headUrl;
@property (copy,atomic) NSString *openId;
@property (copy,atomic) NSString *unionId;
@end

@interface WXLogin : NSObject
/**
 *  设置单例模式
 */
+ (instancetype)sharedInstance;
@property(strong, nonatomic) UIViewController *delegate;
/**
 *  向微信发送结构体消息
 */
- (void)sendAuthRequest:(UIViewController*)pDelegate;
/**
 *  通过code换取access_token
 */
- (void)getAccess_TokenWithCode:(NSString *)code;

@end