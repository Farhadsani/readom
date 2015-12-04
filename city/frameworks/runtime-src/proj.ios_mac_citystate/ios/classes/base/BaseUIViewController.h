#import "FXLabel.h"
#import "MBProgressHUD.h"

typedef void(*CocosCallback)(int ret);
typedef void(*ToCocosCallback)(long , NSString* , NSString* , NSString* , NSString*, NSString*);
typedef void(*ToMapCallback)(int , NSString*);
typedef void(*BackUserHomeCallback)(long);

typedef void(*ToUserHomeCallback)(long , NSString* , NSString* , NSString* , NSString*, NSString*);
typedef void(*RefreshUserHomeCallback)(long);

static ToCocosCallback toCocosCallback;
static ToMapCallback toMapCallback;
static BackUserHomeCallback  backUserHomeCallback;
static ToUserHomeCallback toUserHomeCallback;
static RefreshUserHomeCallback refreshUserHomeCallback;

@interface BaseUIViewController : UIViewController <MBProgressHUDDelegate,UIActionSheetDelegate> {
    UIImageView             *baseNavBarHairlineImageView;
    MBProgressHUD           *baseHud;
    CocosCallback           callback;
}
@property (nonatomic, assign) long userid;

#pragma mark - 基本设置
- (void)setUserData:(long)userID;

- (void)setCocosPause;
- (void)setCocosResume;

- (void)setCocosCallback:(CocosCallback)pCocosCallback;
- (void)baseShowTopHud:(NSString *)text;
- (void)baseShowMidHud:(NSString *)text;
- (void)baseShowBotHud:(NSString *)text;
- (void)baseShowMidHudAllways:(NSString *)text;
- (void)baseHideMidHud;
- (void)baseDeckAndNavBack;
- (void)baseDeckBack;
- (void)baseNavBack;
- (void)baseBack:(id)sender;
- (void)toCocos : (long) userID
                : (NSString *)name
                : (NSString *)intro
                : (NSString *)zone
                : (NSString *)thumblink
                : (NSString *)imglink;

typedef enum MapIndexType{
    MapIndexType_sight = 0,     //景点（默认情况, 点击全部情况)
    MapIndexType_social = 1,    //社交指数
    MapIndexType_hotTag = 2,    //热门标签
    MapIndexType_consume = 3,   //消费指数
}MapIndexType;

/*
 *（正向）跳转到有Cocos地图页面，需要先调用该函数
 * 返回地图时，如果需要刷新地图数据需要传参数（如果不需要刷新地图，则参数为nil）
 *
 *@params:indexType：指数类型（景点、社交指数、热门标签、消费指数）
 *@params:indexId：指数的Id
 *
 *@define:indexType = 0 ：景点（默认情况，点击全部情况，此时indexId=nil）
 *        indexType = 1 ：社交指数
 *        indexType = 2 ：热门标签
 *        indexType = 3 ：消费指数
 *
 *@return:nil
 */
- (void)toMap:(MapIndexType)indexType indexId:(NSString *)indexId;

//（反向）返回到个人中心页面
// 参数为当前用户的ID,如果当前页面为oc页面，该参数为0，否则取当前ID
- (void)backUserHome:(long)userID;

//（反向）返回到地图必须调用该回调，通知已经返回，通知地图恢复地图的原状态
- (void)backToMapIndex:(long)userID;
- (void)refreshUserHome:(long)userID;
+ (void)setToCocosCallback:(ToCocosCallback)pToCocosCallback;
+ (void)setToMapCallback:(ToMapCallback)pToMapCallback;

+ (void)setBackUserHome:(BackUserHomeCallback) pBackUserHomeCallback;

+ (void)setToUserHome:(ToUserHomeCallback) pToUserHomeCallback;
+ (void)setRefreshUserHome:(RefreshUserHomeCallback) pRefreshUserHomeCallback;

@end
