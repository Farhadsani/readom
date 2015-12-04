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

#import "TopicController.h"
#import "LoginViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"

@implementation AppController
@synthesize window = window;
@synthesize iosNavController = iosNavController;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:@"554b373f67e58e75240006bb" reportPolicy:BATCH channelId:@"App Store"];
    [MobClick setCrashReportEnabled:YES];
    //ss
    [UMSocialData setAppKey:@"554b373f67e58e75240006bb"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"城市达人 - 城市新玩法";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"城市达人 - 城市新玩法";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.shitouren.com/homepage/share.html";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.shitouren.com/homepage/share.html";
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx5c76639ea9ec637f" appSecret:@"e02fb07ae99004070c5a7a0498fccd82" url:@"http://www.shitouren.com"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();

    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                     pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                     depthFormat: cocos2d::GLViewImpl::_depthFormat
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];

    [eaglView setMultipleTouchEnabled:YES];
    
    // Use RootViewController manage CCEAGLView
    cocosViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    cocosViewController.wantsFullScreenLayout = YES;
    cocosViewController.view = eaglView;
    [cocosViewController.navigationController setNavigationBarHidden:YES animated:NO];
    
//    //用隐藏TabBar实现切换
//    iosNavController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
//    //a.初始化一个tabBar控制器
//    tb = [[UITabBarController alloc] init];
//    tb.viewControllers=@[cocosViewController,iosNavController];
//    tb.tabBar.hidden = YES;
//    //设置控制器为Window的根控制器
//    window.rootViewController=tb;
    

    TopicController* vc = [[TopicController alloc] init];
    //    [viewDeckController toggleTopViewAnimated:YES];
    //    UINavigationController *nav = (UINavigationController*)(viewDeckController.centerController);
    //现在用push而不是present将视图压栈
//    [iosNavController pushViewController:vc animated:NO];
    
    //用viewDeck实现切换
    iosNavController = [[SlideNavigationViewController alloc] initWithRootViewController:vc];
    
    viewDeckController =  [[IIViewDeckController alloc] initWithCenterViewController:iosNavController topViewController:cocosViewController bottomViewController:nil];
    viewDeckController.topSize = 0.0;
    viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    viewDeckController.panningMode = IIViewDeckNoPanning;
    viewDeckController.shadowEnabled = NO;
    //    /* To adjust speed of open/close animations, set either of these two properties. */
    viewDeckController.openSlideAnimationDuration = 0.2f;
    viewDeckController.closeSlideAnimationDuration = 0.2f;
    window.rootViewController = viewDeckController;
    viewDeckController.view.backgroundColor = [UIColor clearColor];
    
    [window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
//    [viewDeckController toggleTopViewAnimated:NO];

    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    [MobClick checkUpdate];
    [[IQKeyboardManager sharedManager]setEnable:YES];

    app->run();
    return YES;
}


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
    return  [UMSocialSnsService handleOpenURL:url];
}

@end

