#import "WXLogin.h"
#import "UserBaseItem.h"
#import "UserSsItem.h"
#import "UserBriefItem.h"
#import "UserDetailItem.h"

typedef enum UserLoginStatus{
    Lstatus_isInLogining = 0,
    Lstatus_loginSuccess,
    Lstatus_loginFailed,
    Lstatus_loginOut,
}UserLoginStatus;

#define k_encryptCode @"Sk4Ys7sPTx+gT5ssPHXV4ieKwPMKB0czjb+2rVfICMo="

@protocol LoginDelegate;

@interface UserManager : NSObject
{
    int index;
//    NSArray *callouts;
}
//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(UserManager);

@property (assign, atomic) long             userid;
@property (copy, atomic) UserBaseItem       *base;
@property (copy, atomic) UserSsItem         *ss;
@property (copy, atomic) UserBriefItem      *brief;
@property (copy, atomic) UserDetailItem     *detail;
//@property (strong, atomic) NSMutableArray     *callouts;
@property (copy, atomic) NSString           *callout1;
@property (copy, atomic) NSString           *callout2;
@property (copy, atomic) NSString           *callout3;

@property (nonatomic, retain) NSMutableDictionary *user_dict;//保存用户的所有信息

@property(nonatomic, assign) id<LoginDelegate> delegate;
@property (nonatomic) UserLoginStatus userLoginStatus;

+ (UserManager*)sharedInstance;

- (BOOL)isCurrentUser:(long)userId;
- (BOOL)hasLogin;
- (void)saveCallouts:(NSDictionary *)res;

//检查登录（如果未登录默认自动跳转到登录界面）
- (BOOL)tryCheckLogin:(id)vc delegate:(id<LoginDelegate>)del info:(NSDictionary *)inf CallBack:(void (^)(int ret))loginCallBack;

//更新用户数据
- (void)updateUserData:(NSDictionary *)inf;

-(BOOL)validate:(void (^)(int ret)) loginCallback;
//-(BOOL)signinWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd;
//-(BOOL)signinWithWXLoginInfo:(WXLoginInfo *)pWXLoginInfo;
//-(BOOL)signupVerify:(NSString *)pPhone;
//-(BOOL)signupWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd verify:(NSString *)pVerify WXLoginInfo:(WXLoginInfo *)pWXLoginInfo;
-(void)signout;

-(void)signinWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd;
-(void)signinWithWXLoginInfo:(WXLoginInfo *)pWXLoginInfo;
-(void)signupVerify:(NSString *)pPhone;
-(void)signupWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd verify:(NSString *)pVerify WXLoginInfo:(WXLoginInfo *)pWXLoginInfo;



- (NSDictionary *)getDictCookies:(NSDictionary *)privateCookies flag:(BOOL)isAdd;
- (NSArray *)getRequestCookies:(NSDictionary *)privateCookies flag:(BOOL)isAdd;



@end


#pragma mark -
#pragma mark LoginDelegate

@protocol LoginDelegate <NSObject>

@optional

- (void)didLoginSuccess:(NSDictionary *)result;
- (void)didLoginError:(NSError *)error;

//发送注册验证码成功
- (void)didSendSmsSuccess:(NSDictionary *)result;
- (void)didSendSmsError:(NSError *)error;

@end

