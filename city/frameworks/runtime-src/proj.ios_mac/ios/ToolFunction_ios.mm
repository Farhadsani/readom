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
#import "TopicController.h"


#import "UserManager.h"

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
    return [UserManager sharedInstance].brief.userid;
}

std::string CUserManager::name()
{
    return [[UserManager sharedInstance].brief.name UTF8String];
}

std::string CUserManager::zone()
{
    return [[UserManager sharedInstance].brief.zone UTF8String];
}
std::string CUserManager::intro()
{
    return [[UserManager sharedInstance].brief.intro UTF8String];
}
std::string CUserManager::imglink()
{
    return [[UserManager sharedInstance].brief.imglink UTF8String];
}
std::string CUserManager::thumblink()
{
    NSString *str = [UserManager sharedInstance].brief.thumblink;
    if(str == nil)
    {
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
    return "User-Agent:shitouren_qmap_ios";
}

std::string getAppVersion()
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [version UTF8String];
//    return "2.1.1";
}

void toIOS(UIViewController *vc)
{
    //    //ctrol现在是UITabBarController
    //    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //    //切换第二视图
    //    [ctrol setSelectedIndex:1];
    //    UINavigationController *nav = (UINavigationController*)([ctrol.childViewControllers objectAtIndex:1]);
    //    //现在用push而不是present将视图压栈
    //    [nav pushViewController:vc animated:NO];
    
    //ctrol现在是IIViewDeckController
    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //切换第二视图
    [ctrol toggleTopViewAnimated:YES];
    UINavigationController *nav = (UINavigationController*)(ctrol.centerController);
    //现在用push而不是present将视图压栈
    [nav pushViewController:vc animated:NO];
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
    NSString *zone = [UserManager sharedInstance].brief.zone;
//    NSData *data = [UserManager sharedInstance].brief.thumbdata;
    NSString *thumblink = [UserManager sharedInstance].brief.thumblink;
    NSString *imglink = [UserManager sharedInstance].brief.imglink;
    
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
    TopicController *vc = [[TopicController alloc] init];
    topicCallback_c = f;
    [vc setCocosCallback:topicCallback];
    toIOS(vc);
    [vc release];
}

//出访
BUDDYCALLBACK buddyCallback_c;
void buddyCallback(int ret)
{
    buddyCallback_c(ret);
}
void openBuddy(long userID, std::string name, std::string intro, std::string zone, std::string thumblink, std::string imglink, BUDDYCALLBACK f)
{
    BuddyViewController* vc = [[BuddyViewController alloc] init];
    NSString *name_ns = [NSString stringWithCString:name.c_str() encoding:NSUTF8StringEncoding];
    NSString *intro_ns = [NSString stringWithCString:intro.c_str() encoding:NSUTF8StringEncoding];
    NSString *zone_ns = [NSString stringWithCString:zone.c_str() encoding:NSUTF8StringEncoding];
    NSString *thumblink_ns = [NSString stringWithCString:thumblink.c_str() encoding:NSUTF8StringEncoding];
    NSString *imglink_ns = [NSString stringWithCString:imglink.c_str() encoding:NSUTF8StringEncoding];
    
    [vc setUserData:userID : name_ns: intro_ns :zone_ns: thumblink_ns: imglink_ns];
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
    [vc setUserInfo:userID];
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
    detailCallback_c = f;
    UserDetailController *vc = [[UserDetailController alloc]init];
    [vc setUserData:userID];
    [vc setCocosCallback:detailCallback];
    toIOS(vc);
    [vc release];
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
    NSString *zone = [UserManager sharedInstance].brief.zone;
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

//刷新用户中心，当oc界面需要打开（不是返回）lua中的小岛主界面时，调用
REFRESHUSERCENTERCALLBACK refreshUserCenterCallback_c;
void refreshUserCenterCallback(long userID, NSString *name, NSString *intro, NSString *zone, NSString *thumblink, NSString *imglink)
{
    if(refreshUserCenterCallback_c)
    {
        if(name == nil) {name = @""; }
        if(intro == nil) {intro = @""; }
        if(zone == nil) {zone = @""; }
        if(thumblink == nil) {thumblink = @""; }
        if(imglink == nil) {imglink = @""; }
        refreshUserCenterCallback_c(userID, [name UTF8String], [intro UTF8String], [zone UTF8String], [thumblink UTF8String], [imglink UTF8String]);
    }
}
void refreshUserCenter(REFRESHUSERCENTERCALLBACK f)
{
    refreshUserCenterCallback_c = f;
    [BaseUIViewController setToCocosCallback : refreshUserCenterCallback];
}

BACKTOUSERHOMECALLBACK backToUserHomeCallback_c;
void backToUserHomeCallback()
{
    if(backToUserHomeCallback_c)
    {
        backToUserHomeCallback_c(0);
    }
}
void registBackToUserHome(BACKTOUSERHOMECALLBACK f)
{
    backToUserHomeCallback_c = f;
    [BaseUIViewController setBackUserHome:backToUserHomeCallback];
}

void goback()
{
//    //ctrol现在是UITabBarController
//    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    //切换第二视图
//    [ctrol setSelectedIndex:1];
    
    //ctrol现在是IIViewDeckController
    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //切换第二视图
    [ctrol toggleTopViewAnimated:YES];
}

MAPCALLBACK mapCallback_c;
void mapCallback()
{
    if(mapCallback_c)
    {
        mapCallback_c();
    }
}
void openMap(MAPCALLBACK f)
{
    mapCallback_c = f;
    [BaseUIViewController setToMapCallback : mapCallback];
}
