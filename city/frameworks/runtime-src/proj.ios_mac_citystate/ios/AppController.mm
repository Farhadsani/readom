/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "AppController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "MobClick.h"
#import "IQKeyboardManager.h"
#import "SlideNavigationViewController.h"

#import "FirstViewController.h"
#import "LoginViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

#import "CocosManager.h"

#import <AlipaySDK/AlipaySDK.h>

#import "PaySuccessViewController.h"
#import "MessageController.h"

//JPush推送
#import "APService.h"

#import "WNXTopWindow.h"


////APP端签名相关头文件
//#import "payRequsestHandler.h"

@interface AppController ()
@property (nonatomic, assign) int index;
@end


BMKMapManager* _mapManager;


@implementation AppController
@synthesize window = window;
@synthesize eaglView = eaglView;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"kOP2RRyB554tKFqNtMTrCX9w" generalDelegate:self];
    if (!ret) {
        InfoLog(@"manager start failed!");
    }
    
    for (NSHTTPCookie * cookie in [[UserManager sharedInstance] getRequestCookies:nil flag:YES]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        NSLog(@"cookie%@", cookie);
    }
    
    [WNXTopWindow show];
    
    [[UserManager sharedInstance] initServerCity:@"太原"];    //初始化服务城市
    
    NSString *version = [Device appBundleShortVersion];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:@"5629bd6c67e58e8d6f001d98" reportPolicy:BATCH channelId:@"App Store"];
    [MobClick setCrashReportEnabled:YES];
    
    [UMSocialData setAppKey:@"5629bd6c67e58e8d6f001d98"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"城邦";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"城邦";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.shitouren.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.shitouren.com";
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxcee6a0851b3ea57f" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.shitouren.com"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104998708" appKey:@"ZQUBKES7eXLOcqio" url:@"http://www.shitouren.com"];
    
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    //    [APService setDebugMode];//测试时建议调用此API，了解更多的调试信息
    [APService setLogOFF];//发布时建议调用此API，用来屏蔽日志信息，节省性能消耗
    [APService crashLogON];//如果需要统计Log信息，调用该接口。当你需要自己收集错误信息时，切记不要调用该接口
    
    //收取JPush自定义消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    eaglView = [[CCEAGLView viewWithFrame: [window bounds]
                              pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                              depthFormat: cocos2d::GLViewImpl::_depthFormat
                       preserveBackbuffer: NO
                               sharegroup: nil
                            multiSampling: NO
                          numberOfSamples: 0 ] retain];
    [eaglView setMultipleTouchEnabled:YES];
    
    self.lastSelectedIndexOfTabBarController = 0;
    
    _FirstViewController = [[FirstViewController alloc] init];
    window.rootViewController = _FirstViewController;
    
    [window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    [MobClick checkUpdate];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    app->run();
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    InfoLog(@"获取JPush自定义消息：%@", userInfo);
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [APService registerDeviceToken:deviceToken];
    NSString * registrationID = [APService registrationID];
    InfoLog(@"获取JPush的注册ID:%@", registrationID);
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[Cache shared].user_dict setNonEmptyObject:deviceTokenStr forKey:@"deviceToken"];
    
    if (![NSString isEmptyString:registrationID]) {
        [[Cache shared].user_dict setNonEmptyObject:registrationID forKey:k_registrationID];
        //需求上传registrationID到我们的后台与用户ID绑定
        [self registerRegistrationIDToUser:registrationID];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    InfoLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0){
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    // App 收到推送的通知
    [self application:application handelRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // App 收到推送的通知
    [APService handleRemoteNotification:userInfo];
    [self application:application handelRemoteNotification:userInfo];
}
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    InfoLog(@"接收本地通知啦！！！");
//    [APService showLocalNotificationAtFront:notification identifierKey:nil];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::Director::getInstance()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::Director::getInstance()->resume();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
     cocos2d::Director::getInstance()->purgeCachedData();
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    InfoLog(@"open url:===%@", url);
    InfoLog(@"absoluteString:===%@", url.absoluteString);
    return [UMSocialSnsService handleOpenURL:url];
}

- (UIViewController *)getVisibleViewController{
    id v = self.FirstViewController.tabBarController.selectedViewController;
    if ([v isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)v).visibleViewController;
    }
    else{
        return v;
    }
}

#pragma mark - Map delegate

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //NSLog(@"heading is %@",userLocation.heading);
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [[UserManager sharedInstance] updateUserLocation:userLocation];
}

- (void)initLocationServer{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 20;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locService.allowsBackgroundLocationUpdates = YES;
    
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        InfoLog(@"联网成功");
    }
    else{
        InfoLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        InfoLog(@"授权成功");
        [self initLocationServer];
    }
    else {
        InfoLog(@"onGetPermissionState %d",iError);
    }
}

# pragma mark - 推送方面处理

- (void)application:(UIApplication *)application handelRemoteNotification:(NSDictionary *)userInfo{
    InfoLog(@"收到远程推送的通知：%@",userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    if (application.applicationState == UIApplicationStateInactive) {
        //App运行在前台，但是没有处理任何事件
        //先提示用户，再根据推送消息的类型不同，跳转到不同的界面
        [self handelRemoteInfo:userInfo];
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ||
             [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        //App运行在前台，并且在处理事件
        
        //TODO:提示用户推送消息
        //先提示用户，再根据推送消息的类型不同，跳转到不同的界面
//        [[ExceptionEngine shared] setInfo:(NSMutableDictionary *)userInfo];
//        NSString * title = [userInfo objectOutForKey:@"title"];
//        NSString * description = [userInfo objectOutForKey:@"description"];
//        [[ExceptionEngine shared] didShowErrorMessage:YES];
//        [[ExceptionEngine shared] alertTitle:title message:description delegate:self tag:231 cancelBtn:@"取消" btn1:@"查看" btn2:nil];
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        //App运行在后台，还在内存中，并且执行代码
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
    
    if (alertView.tag == 231) {
        if (buttonIndex == k_buttonIndex_btn1) {
            if ([ExceptionEngine shared].inf) {
                [self handelRemoteInfo:[ExceptionEngine shared].inf];
            }
        }
    }
    [[ExceptionEngine shared] resetInf];
}
//处理远程通知 - 推送消息的类型不同，跳转到不同的界面
- (void)handelRemoteInfo:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) {
        return;
    }
    
    //TODO:判断推送的消息类型，如果推送的消息是订单则跳转到订单详情界面（目前只有订单类型、个人消息类型）【如果是个人消息类型推送则跳转到用户消息界面】
    if ([inf[@"type"] integerValue] == 1) {
        [self autoJumpToOrderDetail:inf];
    }
    else if ([inf[@"type"] integerValue] == 2){
        [self autoJumpToUserMessageController:inf];
    }
}
- (void)autoJumpToOrderDetail:(NSDictionary *)inf{
    OrderDetailViewController * vc = [[[OrderDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.title = @"订单详情";
    OrderIntro *intro = [[OrderIntro alloc] init];
    intro.orderid = [inf[@"orderid"] longLongValue];
    vc.orderIntro = intro;
    
    UIViewController * rootvc = [self getVisibleViewController];
    if ([rootvc isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController *)rootvc).navigationBarHidden = NO;
        [(UINavigationController *)rootvc pushViewController:vc animated:YES];
    }
    else{
        rootvc.navigationController.navigationBarHidden = NO;
        [rootvc.navigationController pushViewController:vc animated:YES];
    }
}
- (void)autoJumpToUserMessageController:(NSDictionary *)inf{
    MessageController * vc = [[[MessageController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.title = @"订单详情";
    if ([NSDictionary isNotEmpty:inf]) {
        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:inf];
    }
    
    UIViewController * rootvc = [self getVisibleViewController];
    if ([rootvc isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController *)rootvc).navigationBarHidden = NO;
        [(UINavigationController *)rootvc pushViewController:vc animated:YES];
    }
    else{
        rootvc.navigationController.navigationBarHidden = NO;
        [rootvc.navigationController pushViewController:vc animated:YES];
    }
}

//TODO:需求上传registrationID到我们的后台与用户ID绑定
- (void)registerRegistrationIDToUser:(NSString *)registrationID
{
    
    NSDictionary * params = @{@"token":registrationID
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_device_token,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}


#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_device_token]) {
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_device_token]) {
    }
}
@end

