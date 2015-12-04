//
//  ToolFunction_ios.m
//  qmap
//
//  Created by 石头人6号机 on 15/4/22.
//
//

#include "ToolFunction.h"

#include <string>

#import <Foundation/Foundation.h>
#import "MobClick.h"
#include "FMLayerWebView.h"

#import "IIViewDeckController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "BuddyViewController.h"
#import "MessageController.h"
#import "SendMsgController.h"
#import "UserBaseInfoController.h"
#import "UserDetailController.h"
#import "CalloutViewController.h"
#import "CollectViewController.h"
#import "BuddyStatusViewController.h"
#import "FirstViewController.h"
#import "AppController.h"

#import "UserManager.h"
#import "FirstViewController.h"
#import "SightDetailViewController.h"
#import "SocialIndexViewController.h"
#import "ConsumeIndexViewController.h"
#import "SlideNavigationViewController.h"
#import "CocosMapIndexRootViewController.h"

#import "ShoppingListViewController.h"

#import "StoreViewController.h"

#import "MyStoreViewController.h"

@interface Test : NSObject

- (void)test;

@end

@implementation Test

- (void)test
{
    printf("test");
}

@end



CUserManager* CUserManager::getInstance()
{
    CUserManager* userManager = new CUserManager();
    userManager->autorelease();
    return userManager;
}
long CUserManager::userid()
{
//    long userid = [UserManager sharedInstance].brief.userid;
//    NSString strID = [@(userid) stringValue];
    
    return [UserManager sharedInstance].brief.userid;
//    return [strID UTF8String];
}

long CUserManager::role()
{
    if ([UserManager sharedInstance].brief.role) {
        return (long)([UserManager sharedInstance].brief.role);
    }
    else{
        return 0;
    }
}

std::string CUserManager::name()
{
    NSString *str = nil;
    if ([UserManager sharedInstance].brief.name && [[UserManager sharedInstance].brief.name isKindOfClass:[NSString class]]) {
        str = [UserManager sharedInstance].brief.name;
    }
    if(str == nil){
        str = @"";
    }
    return [str UTF8String];
}

std::string CUserManager::zone()
{
    NSString *str = nil;
    if ([UserManager sharedInstance].brief.name && [[UserManager sharedInstance].brief.name isKindOfClass:[NSString class]]) {
        str = [UserManager sharedInstance].brief.name;
    }
    if(str == nil){
        str = @"";
    }
    return [str UTF8String];
}
std::string CUserManager::intro()
{
    NSString *str = nil;
    if ([UserManager sharedInstance].brief.intro && [[UserManager sharedInstance].brief.intro isKindOfClass:[NSString class]]) {
        str = [UserManager sharedInstance].brief.intro;
    }
    if(str == nil){
        str = @"";
    }
    return [str UTF8String];
}
std::string CUserManager::imglink()
{
    if ([UserManager sharedInstance].brief.imglink && [[UserManager sharedInstance].brief.imglink isKindOfClass:[NSString class]]){
        return [((NSString *)[UserManager sharedInstance].brief.imglink) UTF8String];
    }
    return [@"" UTF8String];
}
std::string CUserManager::thumblink()
{
    NSString *str = nil;
    if ([UserManager sharedInstance].brief.thumblink && [[UserManager sharedInstance].brief.thumblink isKindOfClass:[NSString class]]){
        str = ((NSString *)[UserManager sharedInstance].brief.thumblink);
    }
    if(str == nil){
        str = @"";
    }
    return [str UTF8String];
}
int CUserManager::userLoginStatus()
{
    return [UserManager sharedInstance].userLoginStatus;
}

std::string getSSID()
{
    Test* test = [[Test alloc] init];
    [test test];
    
    NSString* strSSID =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    std::string ssid = [strSSID UTF8String];
    
//    std::string a("-------> ssid");
    return ssid;
}

std::string getAppName()
{
    return "citystate";
}

std::string getSSID_Check()
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ssid_check = [defaults stringForKey:@"SHITOUREN_UD_SSID_CHECK"];
    if (ssid_check == nil)
    {
        ssid_check = @"";
    }
    return [ssid_check UTF8String];
}

std::string getSSID_Verify()
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ssid_verify = [defaults stringForKey:@"SHITOUREN_UD_SSID_VERIFY"];
    if (ssid_verify == nil)
    {
        ssid_verify = @"";
    }
    return [ssid_verify UTF8String];
}

void ymOnEvent(std::string eventName){
//    NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
    
//    [MobClick event:@"guilin" attributes:dict];
    NSString* name = [NSString stringWithFormat:@"%s", eventName.c_str()];
    [MobClick event:name];

}

std::string getRequestHeader()
{
    return [[NSString stringWithFormat:@"User-Agent:%@", k_User_Agent] UTF8String];
}

std::string getAppVersion()
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [version UTF8String];
//    return "2.1.1";
}

void toIOS(UIViewController *vc)
{
    InfoLog(@"");
    //ctrol现在是UITabBarController
    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
    [sVC.navigationController pushViewController:vc animated:YES];
}

void closeWebViewCallBack()
{
}

void showWebView( std::string strUrl)
{
    FMLayerWebView* web = FMLayerWebView::create();
    web->setPosition(Vec2(0,0));
    
    auto scene = Director::getInstance()->getRunningScene();
    scene->addChild(web);
//    web->setCallBack();
    web->openURL(strUrl);
}


LOGINCALLBACK loginCallback_c;
void loginCallback(int ret)
{
    long userID = [UserManager sharedInstance].brief.userid;
    NSString *name = [UserManager sharedInstance].brief.name;
    NSString *intro = [UserManager sharedInstance].brief.intro;
    NSString *zone = [UserManager sharedInstance].brief.name;
//    NSData *data = [UserManager sharedInstance].brief.thumbdata;
    NSString *thumblink = @"";
    NSString *imglink = @"";
    
    if ([UserManager sharedInstance].brief.imglink && [[UserManager sharedInstance].brief.imglink isKindOfClass:[NSString class]]) {
        thumblink = [UserManager sharedInstance].brief.imglink;
        imglink = [UserManager sharedInstance].brief.imglink;
    }
    else{
        if ([UserManager sharedInstance].brief.thumblink && [[UserManager sharedInstance].brief.thumblink isKindOfClass:[NSString class]]){
            thumblink = (NSString *)[UserManager sharedInstance].brief.thumblink;
        }
    }
    
//    if ([UserManager sharedInstance].brief.headurl && [[UserManager sharedInstance].brief.headurl isKindOfClass:[NSString class]]) {
//        thumblink = [UserManager sharedInstance].brief.headurl;
//        imglink = [UserManager sharedInstance].brief.headurl;
//    }
//    else{
//        if ([UserManager sharedInstance].brief.thumblink && [[UserManager sharedInstance].brief.thumblink isKindOfClass:[NSString class]]){
//            thumblink = (NSString *)[UserManager sharedInstance].brief.thumblink;
//        }
//    }
    
    if(name == nil) {name = @""; }
    if(intro == nil) {intro = @""; }
    if(zone == nil) {zone = @""; }
    if(thumblink == nil) {thumblink = @""; }
    if(imglink == nil) {imglink = @""; }
    loginCallback_c(ret, userID, [name UTF8String], [intro UTF8String], [zone UTF8String], [thumblink UTF8String], [imglink UTF8String]);
}

void userLogin(int autoLogin, LOGINCALLBACK f)
{
    loginCallback_c = f;
    CCLOG("开始自动登录，。。。。。");
    [UserManager sharedInstance].userLoginStatus = Lstatus_isInLogining;
    
    if(autoLogin == 2) {   //直接显示登录界面
        [UserManager sharedInstance].userLoginStatus = Lstatus_loginFailed;
        LoginViewController *vc = [[LoginViewController alloc] init];
        [vc setCocosCallback:loginCallback];
        toIOS(vc);
        [vc release];
    }
    else {  // 判断是否登录
        [[UserManager sharedInstance] validate: ^(int ret){
            if(ret == 1){  // 登陆成功
                CCLOG("自动登录的结果：%d 成功", ret);

                [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
                loginCallback(ret);
            }
            else {
                CCLOG("自动登录的结果：%d 失败", ret);
                [UserManager sharedInstance].userLoginStatus = Lstatus_loginFailed;
                if(autoLogin == 1)  //显示登录界面
                {
                    LoginViewController *vc = [[LoginViewController alloc] init];
                    [vc setCocosCallback:loginCallback];
                    toIOS(vc);
                    [vc release];
                }
            }
        }];
    }
}

ABOUTCALLBACK aboutCallback_c;
void aboutCallback(int ret)
{
    aboutCallback_c(ret);
}
void openAbout(ABOUTCALLBACK f)
{
    AboutViewController* vc = [[AboutViewController alloc] init];
    aboutCallback_c = f;
    [vc setCocosCallback:aboutCallback];
    toIOS(vc);
    [vc release];
}

//话题
TOPICCALLBACK topicCallback_c;
void topicCallback(int)
{
    topicCallback_c();
}
//当topicID为0时，进入发现主页，大于0时，该值为话题的ID，进入改话题的详情
void openTopic(long topicID, TOPICCALLBACK f)
{
//    UITabBarController * tabbarVC = (UITabBarController *)(([[UIApplication sharedApplication] delegate])).window.rootViewController;
//    [tabbarVC setSelectedIndex:1];
//    [tabbarVC.selectedViewController hideTabBar:NO animation:YES];
//    [(AppController *)APPLICATION hiddenCocosView];
    
//    FirstViewController * deckVC1 = ((AppController *)([[UIApplication sharedApplication] delegate])).FirstViewController;

//    FirstViewController * deckVC = [[FirstViewController alloc] init];
//    topicCallback_c = f;
//    deckVC.lastSelectedIndexOfTabBarController = ((AppController *)(APPLICATION)).lastSelectedIndexOfTabBarController;
//    [deckVC setCocosCallback:topicCallback];
//    toIOS(deckVC);
//    [deckVC release];
}

//出访
BUDDYCALLBACK buddyCallback_c;
void buddyCallback(int ret)
{
    InfoLog(@"");
    buddyCallback_c(ret);
}
void openBuddy(long userID, std::string name, std::string intro, std::string zone, std::string thumblink, std::string imglink, BUDDYCALLBACK f)
{
    BuddyViewController* vc = [[BuddyViewController alloc] init];
//    NSString *name_ns = [NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding];
//    NSString *intro_ns = [NSString stringWithCString:intro.c_str() encoding:NSUTF8StringEncoding];
//    NSString *zone_ns = [NSString stringWithCString:zone.c_str() encoding:NSUTF8StringEncoding];
//    NSString *thumblink_ns = [NSString stringWithCString:thumblink.c_str() encoding:NSUTF8StringEncoding];
//    NSString *imglink_ns = [NSString stringWithCString:imglink.c_str() encoding:NSUTF8StringEncoding];
    [vc setUserid:userID];
//    [vc setUserData:userID : name_ns: intro_ns :zone_ns: thumblink_ns: imglink_ns];
    buddyCallback_c = f;
    [vc setCocosCallback:buddyCallback];
    toIOS(vc);
    [vc release];
}

MAILCALLBACK mailCallback_c;
void mailCallback(int ret)
{
    mailCallback_c();
}
void openMail(MAILCALLBACK f)
{
    mailCallback_c = f;
    MessageController *vc = [[MessageController alloc]init];
    [vc setCocosCallback:mailCallback];
    toIOS(vc);
    [vc release];
}

//邮箱，发送邮件 给userID发送消息
SENDMAILCALLBACK sendMailCallback_c;
void sendMailCallback(int ret)
{
    sendMailCallback_c();
}
void openSendmail(long userID, SENDMAILCALLBACK f)
{
    sendMailCallback_c = f;
    SendMsgController *vc = [[SendMsgController alloc]init];
    vc.userid = userID;
    [vc setCocosCallback:sendMailCallback];
    toIOS(vc);
    [vc release];
}

//个人详情，detail
DETAILCALLBACK detailCallback_c;
void detailCallback(int ret)
{
    
    detailCallback_c();
}
void openDetail(long userID, DETAILCALLBACK f)
{
    if ([[UserManager sharedInstance] isCurrentUser:userID] && [[UserManager sharedInstance] isStoreUser:[UserManager sharedInstance].brief]) {
        detailCallback_c = f;
        MyStoreViewController *vc = [[MyStoreViewController alloc] init];
        [vc setUserData:userID];
        [vc setCocosCallback:detailCallback];
        toIOS(vc);
        [vc release];
    }
    else{
        [[UserManager sharedInstance] UserID:userID getUserInfo:^(NSDictionary *info) {
            BOOL isStore = NO;
            if(info && info.count > 0 && [info objectOutForKey:@"role"] && [[info objectOutForKey:@"role"] integerValue] == Role_Store){
                isStore = YES;
            }
            if (isStore) {
                detailCallback_c = f;
//                MyStoreViewController *vc = [[MyStoreViewController alloc] init];
                StoreViewController *vc = [[StoreViewController alloc] init];
                [vc setUserData:userID];
                [vc setCocosCallback:detailCallback];
                toIOS(vc);
                [vc release];
            }
            else{
                detailCallback_c = f;
                UserDetailController *vc = [[UserDetailController alloc]init];
                [vc setUserData:userID];
                [vc setCocosCallback:detailCallback];
                toIOS(vc);
                [vc release];
            }
        }];
    }
}

//收藏，collect
COLLECTCALLBACK collectCallback_c;
void collectCallback(int ret)
{
    collectCallback_c();
}
void openCollect(long userID, COLLECTCALLBACK f)
{
    collectCallback_c = f;
    CollectViewController *vc = [[CollectViewController alloc]init];
    [vc setUserData:userID];
    [vc setCocosCallback:collectCallback];
    toIOS(vc);
    [vc release];
}

//好友动态
FRIENDTRENDCALLBACK friendTrendCallback_c;
void friendTrendCallback(int ret)
{
    friendTrendCallback_c();
}
void openFriendTrend(long userID, FRIENDTRENDCALLBACK f)
{
    friendTrendCallback_c = f;
    //一下补充好友动态的控制器
    BuddyStatusViewController *vc = [[BuddyStatusViewController alloc]init];
    [vc setUserData:userID];
    [vc setCocosCallback:friendTrendCallback];
    toIOS(vc);
    [vc release];
}

//个人中心，usercenter  打开基本资料界面
USERCENTERCALLBACK userCenterCallback_c;
void usercenterCallback(int ret)
{
    NSString *intro = [UserManager sharedInstance].brief.intro;
    NSString *zone = [UserManager sharedInstance].brief.name;
    userCenterCallback_c([intro UTF8String], [zone UTF8String]);
}
void openUsercenter(long userID, std::string name ,std::string intro,std::string zone ,std::string thumblink,std::string imglink, USERCENTERCALLBACK f)
{
    userCenterCallback_c = f;
    UserBaseInfoController *vc = [[UserBaseInfoController alloc]init];
    [vc setUserData:userID];
    [vc setCocosCallback:usercenterCallback];
    toIOS(vc);
    [vc release];
}

//喊话，speak, 返回喊的三句话
SPEAKCALLBACK speakCallback_c;
void speakCallback(int ret)
{
    NSString *str1 = [UserManager sharedInstance].callout1;
    NSString *str2 = [UserManager sharedInstance].callout2;
    NSString *str3 = [UserManager sharedInstance].callout3;
    str1 = str1 != nil ? str1 : @"";
    str2 = str2 != nil ? str2 : @"";
    str3 = str3 != nil ? str3 : @"";
    speakCallback_c([str1 UTF8String], [str2 UTF8String], [str3 UTF8String]);
}
void openSpeak(SPEAKCALLBACK f)
{
    speakCallback_c = f;
    CalloutViewController* vc = [[CalloutViewController alloc] init];
    [vc setCocosCallback:speakCallback];
    toIOS(vc);
    [vc release];
}

//打开个人中心用户中心，当oc界面需要打开lua中的小岛主界面时，调用
USERHOMECALLBACK userHomeCallback_c;
void userHomeCallback(long userID, NSString *name, NSString *intro, NSString *zone, NSString *thumblink, NSString *imglink)
{
    InfoLog(@"打开个人中心");
    if(userHomeCallback_c)
    {
        if(name == nil) {name = @""; }
        if(intro == nil) {intro = @""; }
        if(zone == nil) {zone = @""; }
        if(thumblink == nil) {thumblink = @""; }
        if(imglink == nil) {imglink = @""; }
        userHomeCallback_c(userID, [name UTF8String], [intro UTF8String], [zone UTF8String], [thumblink UTF8String], [imglink UTF8String]);
    }
}
void openUserHome(USERHOMECALLBACK f)
{
    InfoLog(@"");
    userHomeCallback_c = f;
    [BaseUIViewController setToUserHome : userHomeCallback];
}

//刷新小岛数据
REFRESHUSERHOMECALLBACK refreshUserHomeCallback_c;
void refreshUserHomeCallback_1(long userID)    //加_1是为了避免重名
{
    InfoLog(@"刷新个人中心");
    if (refreshUserHomeCallback_c) {
        refreshUserHomeCallback_c(userID);
    }
}
void refreshUserHome(REFRESHUSERHOMECALLBACK f)
{
    refreshUserHomeCallback_c = f;
    [BaseUIViewController setRefreshUserHome:refreshUserHomeCallback_1];
}

BACKTOUSERHOMECALLBACK backToUserHomeCallback_c;
void backToUserHomeCallback(long userID)
{
    InfoLog(@"");
    if(backToUserHomeCallback_c)
    {
        backToUserHomeCallback_c(userID);
    }
}
void registBackToUserHome(BACKTOUSERHOMECALLBACK f)
{
    InfoLog(@"");
    backToUserHomeCallback_c = f;
    [BaseUIViewController setBackUserHome:backToUserHomeCallback];
}

void goback()
{
    InfoLog(@"");
    //ctrol现在是UITabBarController
    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
    if (sVC.navigationController) {
        [sVC.navigationController popViewControllerAnimated:YES];
    }
    else{
        [sVC dismissViewControllerAnimated:YES completion:nil];
    }
}

MAPCALLBACK mapCallback_c;
void mapCallback(int categoryType, NSString* categoryID)
{
    if (categoryID == nil) {
        categoryID = @"";
    }
    InfoLog(@"");
    if(mapCallback_c)
    {
        mapCallback_c(categoryType, [categoryID UTF8String]);
    }
}
void openMap(MAPCALLBACK f)
{
    InfoLog(@"");
    mapCallback_c = f;
    [BaseUIViewController setToMapCallback : mapCallback];
}

//关闭景点介绍后需要调用下面的回调函数
SIGHTINTROCALLBACK sightIntroCallback_c;
void sightIntroCallback(int)   //打开景点介绍后的回调函数
{
    if(sightIntroCallback_c)
    {
        sightIntroCallback_c();
    }
}

//打开景点介绍
//sightID：景点id
//sightName：景点名称
//sightDescs：景点所包含的所有数据
void openSightIntro(long sightID, std::string sightName, std::string sightDescs, SIGHTINTROCALLBACK f)
{
    SightDetailViewController * vc = [[[SightDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [vc.data_dict setNonEmptyObject:@(sightID) forKey:k_sightID];
    [vc.data_dict setNonEmptyObject:[NSString stringWithCString:sightName.c_str() encoding:NSUTF8StringEncoding] forKey:k_sightName];
    [vc.data_dict setNonEmptyObject:[NSString stringWithCString:sightDescs.c_str() encoding:NSUTF8StringEncoding] forKey:k_sightDescs];
    sightIntroCallback_c = f;
    [vc setCocosCallback:sightIntroCallback];
    CocosMapIndexRootViewController * sVC = (CocosMapIndexRootViewController *)[(AppController *)APPLICATION getVisibleViewController];
    [sVC showSightDetailView:vc];
    
    //sightDescs  是景点的介绍的描述，json字符串,如下：
    //"[{\"content\":\"4月-10月\",\"descid\":1},{\"content\":\"淡季(12-3月):07:00-21:30\\r\\n旺季(4-11月):06:30-21:30\",\"descid\":2},{\"content\":\"1-2小时\",\"descid\":3},{\"content\":\"象鼻山、水月洞、普贤塔、象眼岩\",\"descid\":4},{\"content\":\"山像一头站在江边伸鼻豪饮漓江甘泉的巨象\",\"descid\":5},{\"content\":\"桂林市城徽，桂林山水的象征\",\"descid\":6},{\"content\":\"75元\\/人\",\"descid\":7}]"
    //content:介绍的内容，descid:为介绍的标示，该标示对应图标和标题，标题如下：1 = "最美季节", 2 = "开放时间", 3 = "游览时间", 4 = "主要看点", 5 = "大家印象", 6 = "推荐理由", 7 = "门票价格", 8 = "游览Tips", 9 = "交通线路"
}

//关闭片区信息后需要调用下面的回调函数
CATEGORYCALLBACK categoryCallback_c;
void categoryCallback(int)
{
    if(categoryCallback_c)
    {
        categoryCallback_c();
    }
}

//打开指数/片区指数筛选
//sightID：片区id
//categoryID：选择的指数id
void openCategory(long sightID, long categoryType, std::string categoryID, CATEGORYCALLBACK f)
{
    NSInteger ID = [[NSString stringWithCString:categoryID.c_str() encoding:NSUTF8StringEncoding] integerValue];
    
    if (ID != 0) {
        NSArray *socailArr = [[Cache shared].cache_dict valueForKey:SocialCategoryIds];
        NSArray *consumeArr = [[Cache shared].cache_dict valueForKey:ConsumeCategoryIds];
        NSArray *tagArr = [[Cache shared].cache_dict valueForKey:HotTagsCategoryIds];
        
        if ([socailArr containsObject:@(ID)] || [tagArr containsObject:@(ID)]) {
            SocialIndexViewController *socialIndexViewController = [[SocialIndexViewController alloc] init];
            socialIndexViewController.areaid = sightID;
            if (categoryType == 1) {
                NSArray *socialKey = [[Cache shared].cache_dict valueForKey:SocialKey];
                for (NSDictionary *d in socialKey) {
                    if ([d[@"categoryid"] intValue] == ID) {
                        socialIndexViewController.title = d[@"cname"];
                        break ;
                    }
                }
                socialIndexViewController.categoryid = ID;
            } else {
                NSArray *hotTagsKey = [[Cache shared].cache_dict valueForKey:HotTagsKey];
                for (NSDictionary *d in hotTagsKey) {
                    if ([d[@"tagid"] intValue] == ID) {
                        socialIndexViewController.title = d[@"name"];
                        break ;
                    }
                }
                socialIndexViewController.tagid = ID;
            }
            UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
            [sVC.navigationController pushViewController:socialIndexViewController animated:YES];
        } else if ([consumeArr containsObject:@(ID)]) {
            ConsumeIndexViewController *consumeIndexViewController = [[ConsumeIndexViewController alloc] init];
            NSArray *consumeKey = [[Cache shared].cache_dict valueForKey:ConsumeKey];
            for (NSDictionary *d in consumeKey) {
                if ([d[@"categoryid"] intValue] == ID) {
                    consumeIndexViewController.title = d[@"cname"];
                    break ;
                }
            }
            consumeIndexViewController.areaid = sightID;
            consumeIndexViewController.categoryid = ID;
            consumeIndexViewController.streetid = 0;
            UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
            [sVC.navigationController pushViewController:consumeIndexViewController animated:YES];
        }
    }
}

//当脚本由好友用户中心直接返回到自己的用户中心时将调用此函数通知原生程序,
//当原生程序操作完毕后，调用回调
ONMAINPAGECALLBACK onMainPageCallback_c;
void onMainPageCallback()
{
    if(onMainPageCallback_c)
    {
        onMainPageCallback_c();
    }
}
void onMainPage(ONMAINPAGECALLBACK f)
{
    NSLog(@"脚本中直接调用了回到自己的个人中心，原生程序处理完毕后，调用onMainPageCallback");
    onMainPageCallback_c = f;
    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
    if (sVC.navigationController) {
        [sVC.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [sVC dismissViewControllerAnimated:YES completion:nil];
    }
}

//当场景脚本中场景加载完毕后，通知ios
//参数 name :加载的场景名称  "citymap":地图场景， "userhome":用户中心 "loading":加载
void sceneLoadOver(std::string name)
{
    NSString * namestr = [NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding];
    if ([namestr isEqualToString:@"citymap"]) {
        //地图场景已经加载完毕，通知OC
        [[(AppController *)APPLICATION FirstViewController] showTabBarAndNavBar];
    }
}

//用户点击了热气球，hotball
HOTBALLCALLBACK hotBallCallback_c;
void hotBallCallback(int)
{
    if (hotBallCallback_c) {
        hotBallCallback_c();
    }
}
void openHotBall(long userID, HOTBALLCALLBACK f)
{
    if ([[UserManager sharedInstance] isCurrentUser:userID] && [[UserManager sharedInstance] isStoreUser:[UserManager sharedInstance].brief]) {
        hotBallCallback_c = f;
//        StoreViewController *vc = [[StoreViewController alloc] init];
        MyStoreViewController *vc = [[MyStoreViewController alloc] init];
        [vc setUserData:userID];
        [vc setCocosCallback:detailCallback];
        toIOS(vc);
        [vc release];
    }
    else{
        [[UserManager sharedInstance] UserID:userID getUserInfo:^(NSDictionary *info) {
            BOOL isStore = NO;
            if(info && info.count > 0 && [info objectOutForKey:@"role"] && [[info objectOutForKey:@"role"] integerValue] == Role_Store){
                isStore = YES;
            }
            if (isStore) {
                hotBallCallback_c = f;
                
                StoreViewController *vc = [[StoreViewController alloc] init];
                
                
//                MyStoreViewController *vc = [[MyStoreViewController alloc] init];
                [vc setUserData:userID];
                [vc setCocosCallback:detailCallback];
                toIOS(vc);
                [vc release];
            }
            else{
                hotBallCallback_c = f;
                ShoppingListViewController *vc = [[ShoppingListViewController alloc] init];
                [vc setUserData:userID];
                [vc setCocosCallback:hotBallCallback];
                toIOS(vc);
                [vc release];
            }
        }];
    }
}

