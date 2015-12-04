#import "WXLogin.h"
#import "UserBaseItem.h"
#import "UserSsItem.h"
#import "UserBriefItem.h"
#import "UserDetailItem.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件


typedef enum UserLoginStatus{
    Lstatus_isInLogining = 0,
    Lstatus_loginSuccess,
    Lstatus_loginFailed,
    Lstatus_loginOut,
}UserLoginStatus;

typedef enum UserRoleType{
    Role_Normal = 0,    //普通用户
    Role_Store          //商家用户
}UserRoleType;

#define k_encryptCode @"Sk4Ys7sPTx+gT5ssPHXV4ieKwPMKB0czjb+2rVfICMo="

@protocol LoginDelegate;

@interface UserManager : NSObject <BMKGeoCodeSearchDelegate>
{
    int index;
}
//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(UserManager);

@property(nonatomic, retain) NSString * serverCity;//当前服务城市

@property (assign, atomic) long             userid;
@property (copy, atomic) UserBaseItem       *base;
@property (copy, atomic) UserSsItem         *ss;
@property (copy, atomic) UserBriefItem      *brief;
@property (copy, atomic) UserDetailItem     *detail;
@property (copy, atomic) NSString           *callout1;
@property (copy, atomic) NSString           *callout2;
@property (copy, atomic) NSString           *callout3;

@property (nonatomic, retain) NSMutableDictionary *user_dict;//保存用户的所有信息

@property (nonatomic, assign) id<LoginDelegate> delegate;
@property (nonatomic) UserLoginStatus userLoginStatus;
@property (nonatomic) UserRoleType userRole;            //用户类型（普通用户、商家用户）

@property(nonatomic, assign) CLLocationCoordinate2D pt; //记录用户当前地理位置的经纬度
@property(nonatomic, retain) NSString * city;           //用户当前地理位置所在的城市
@property(nonatomic, retain) NSString * address;        //记录用户当前地理位置

@property(nonatomic, retain) BMKGeoCodeSearch * geoCodeSearch;


+ (UserManager*)sharedInstance;

//初始化当前服务的城市
- (void)initServerCity:(NSString *)cityName;

- (BOOL)isCurrentUser:(long)userId;
- (BOOL)hasLogin;
- (void)saveCallouts:(NSDictionary *)res;

- (BOOL)isStoreUser:(UserBriefItem *)item;

#pragma mark - 获取用户的头像
//获取当前登录用户的头像
- (UIImage *)getCurrentLoginHeadLogo;

//获取指定用户的头像
- (UIImage*)getUserHeadLogo:(long)userid brifItem:(UserBriefItem *)item;

//获取指定用户的头像(没有默认值)
- (UIImage *)getRealLogoImageFromBrifItem:(UserBriefItem *)item;

//更改用户头像
#pragma mark - 检查登录
//检查登录（如果未登录默认自动跳转到登录界面）
- (BOOL)tryCheckLogin:(id)vc delegate:(id<LoginDelegate>)del info:(NSDictionary *)inf CallBack:(void (^)(int ret))loginCallBack;

#pragma mark - 更新用户数据
//登录成功或成功修改用户信息后调用 - 更新用户数据
- (void)updateUserData:(id)inf;
- (void)updateUserImageUrl:(NSString *)url;

//成功退出登录后调用
- (void)signout;

#pragma mark -

- (BOOL)validate:(void (^)(int ret)) loginCallback;

//获取用户信息
- (BOOL)UserID:(long)userid getUserInfo:(void (^)(NSDictionary* info)) callback;

- (void)signinWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd;
- (void)signinWithWXLoginInfo:(WXLoginInfo *)pWXLoginInfo;
- (void)signupVerify:(NSString *)pPhone;
- (void)signupWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd verify:(NSString *)pVerify WXLoginInfo:(WXLoginInfo *)pWXLoginInfo;


- (NSDictionary *)getDictCookies:(NSDictionary *)privateCookies flag:(BOOL)isAdd;
- (NSArray *)getRequestCookies:(NSDictionary *)privateCookies flag:(BOOL)isAdd;


- (void)updateUserLocation:(BMKUserLocation *)userLocation;
- (void)updateUserLocationPt:(CLLocationCoordinate2D)pt;

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

