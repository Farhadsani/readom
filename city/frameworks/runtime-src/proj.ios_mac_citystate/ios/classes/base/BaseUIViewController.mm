#import "BaseUIViewController.h"
#import "AppDelegate.h"
#import "LoggerClient.h"
#import "IIViewDeckController.h"
/*
 *所有Controller的父类
 *
 */
@implementation BaseUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.userid = 0;
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        self.userid = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    baseHud = [[MBProgressHUD alloc] initWithView:self.view];
    baseHud.mode = MBProgressHUDModeText;
    baseHud.removeFromSuperViewOnHide = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    baseNavBarHairlineImageView = [self baseFindHairlineImageViewUnder:self.navigationController.navigationBar];
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];  //设置背景
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    baseNavBarHairlineImageView.hidden = NO;
    
    CGRect frame = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.frame = CGRectMake(frame.origin.x, 0, frame.size.width, 64);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    baseNavBarHairlineImageView.hidden = NO;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIImageView *)baseFindHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self baseFindHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//停止cocos的一切活动
-(void)setCocosPause
{
//    cocos2d::Director::getInstance()->pause();
////    cocos2d::Application::sharedApplication()->applicationDidEnterBackground();
//    cocos2d::Application::getInstance()->applicationDidEnterBackground();
    cocos2d::Director::getInstance()->stopAnimation();
    cocos2d::Director::getInstance()->pause();
    
//    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
//    SimpleAudioEngine::getInstance()->pauseAllEffects();
    
    cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
}
//重启cocos的一切活动
-(void)setCocosResume
{
    cocos2d::Director::getInstance()->resume();
    cocos2d::Director::getInstance()->startAnimation();
    
//    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
//    SimpleAudioEngine::getInstance()->resumeAllEffects();
    
    cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");
}

#pragma mark - 基本设置
- (void)setUserData:(long)userID{
    self.userid = userID;
}

- (void)setCocosCallback:(CocosCallback)pCocosCallback {
    callback = pCocosCallback;
}

- (void)baseShowTopHud:(NSString *)text {
    baseHud.yOffset = -180.0f;
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
    [baseHud hide:YES afterDelay:1.5];
}

- (void)baseShowMidHud:(NSString *)text {
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
    [baseHud hide:YES afterDelay:1.5];
}

- (void)baseShowBotHud:(NSString *)text {
    baseHud.yOffset = 180.0f;
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
    [baseHud hide:YES afterDelay:1.5];
}

- (void)baseShowMidHudAllways:(NSString *)text
{
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
}

- (void)baseHideMidHud
{
    [baseHud hide:YES];
}

- (void)baseDeckAndNavBack {
    //ctrol现在是UITabBarController
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [[LoadingView shared] hideLoading];
}

- (void)baseDeckBack {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)baseNavBack {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)baseBack:(id)sender
{
    [self.view endEditing:YES];
    [self baseNavBack];
}

//（正向）跳转到有Cocos个人中心页面，需要先调用该函数刷新数据
- (void)toCocos : (long) userID
                : (NSString *) name
                : (NSString *) intro
                : (NSString *) zone
                : (NSString *) thumblink
                : (NSString *) imglink
{
    [CocosManager shared].viewType = CocosView_UserCenter;
//    if(toCocosCallback)
//    {
//        InfoLog(@"【【【{userID}】】】:%ld  name:%@", userID, name);
//        toCocosCallback(userID, name, intro, zone, thumblink, imglink);
//    }
    if (toUserHomeCallback) {
        InfoLog(@"toCocos【【【{userID}】】】:%ld  name:%@", userID, name);
        toUserHomeCallback(userID, name, intro, zone, thumblink, imglink);
    }
}

//（反向）返回到个人中心页面
// 参数为当前用户的ID,如果当前页面为oc页面，该参数为0，否则取当前ID
- (void)backUserHome:(long)userID
{
    [CocosManager shared].viewType = CocosView_UserCenter;
    if (toUserHomeCallback)
    {
        InfoLog(@"backUserHome【【【{userID}】】】:%ld", userID);
        toUserHomeCallback(userID, @"", @"", @"", @"", @"");
//        if (userID && [[UserManager sharedInstance] isCurrentUser:userID]) {
//            InfoLog(@"【【【{userID}】】】:%ld", (long)0);
//            backUserHomeCallback(0);
//        }
//        else{
//            InfoLog(@"【【【{userID}】】】:%ld", (userID)?userID:0);
//            backUserHomeCallback((userID)?userID:0);
//        }
    }
}

//（正向）跳转到有Cocos地图页面，需要先调用该函数
- (void)toMap:(MapIndexType)indexType indexId:(NSString *)indexId
{
    [CocosManager shared].viewType = CocosView_Map;
    if (toMapCallback)
    {
        toMapCallback(indexType, indexId);
    }
}

//（反向）返回到地图必须调用该回调，通知已经返回，通知地图恢复地图的原状态
- (void)backToMapIndex:(long)userID
{
    InfoLog(@"【【【{userID}】】】:%ld", userID);
    [CocosManager shared].viewType = CocosView_Map;
//    if (backUserHomeCallback && userID != 0)
//    {
//        backUserHomeCallback(userID);
//    }
    if (callback) {
        callback(0);
    }
}

- (void)refreshUserHome:(long)userID
{
    InfoLog(@"刷新个人中心【【【{userID}】】】:%ld", userID);
    if (refreshUserHomeCallback) {
        refreshUserHomeCallback(userID);
    }
}

+ (void)setToCocosCallback:(ToCocosCallback)pToCocosCallback
{
    toCocosCallback = pToCocosCallback;
}

+ (void)setToMapCallback:(ToMapCallback)pToMapCallback
{
    toMapCallback = pToMapCallback;
}

+ (void)setBackUserHome:(BackUserHomeCallback) pBackUserHomeCallback
{
    backUserHomeCallback = pBackUserHomeCallback;
}

//打开小岛
+ (void)setToUserHome:(ToUserHomeCallback)pToUserHomeCallback
{
    toUserHomeCallback = pToUserHomeCallback;
}

//刷新小岛
+ (void)setRefreshUserHome:(RefreshUserHomeCallback)pRefreshUserHomeCallback
{
    refreshUserHomeCallback = pRefreshUserHomeCallback;
}

@end
