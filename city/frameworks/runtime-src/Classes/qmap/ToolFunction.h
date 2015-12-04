//
//  ToolFunction.h
//  qmap
//
//  Created by 石头人6号机 on 15/4/22.
//
//
#include <string>
#include "cocos2d.h"
#ifndef qmap_ToolFunction_h
#define qmap_ToolFunction_h

std::string getSSID();
std::string getSSID_Check();
std::string getSSID_Verify();
void ymOnEvent(std::string eventName);
std::string getRequestHeader();
std::string getAppVersion();
std::string getAppName();

class CUserManager :public cocos2d::Ref
{
public:
    static CUserManager *getInstance();
    long userid();
    long role();
    std::string name();
    std::string zone();
    std::string intro();
    std::string imglink();
    std::string thumblink();
    
    int userLoginStatus();
};

void showWebView(std::string strUrl);

//typedef void(*CocosCallback)(int ret);
//void userLogin(CocosCallback& callback );

//登陆 login
typedef std::function<void(int , long , std::string , std::string , std::string , std::string, std::string )> LOGINCALLBACK;
void userLogin(int autoLogin, LOGINCALLBACK f);

//关于 about
typedef std::function<void(int)> ABOUTCALLBACK;
void openAbout(ABOUTCALLBACK f);

//发现 话题 topic
typedef std::function<void()> TOPICCALLBACK;
void openTopic(long topicID, TOPICCALLBACK f);

//出访 buddy
typedef std::function<void(int userID)> BUDDYCALLBACK;
void openBuddy(long userID, std::string,std::string,std::string,std::string,std::string , BUDDYCALLBACK f);

//邮箱，查看自己的邮件
typedef std::function<void()> MAILCALLBACK;
void openMail(MAILCALLBACK f);

//邮箱，发送邮件 给userID发送消息
typedef std::function<void()> SENDMAILCALLBACK;
void openSendmail(long userID, SENDMAILCALLBACK f);

//个人详情，detail
typedef std::function<void()> DETAILCALLBACK;
void openDetail(long userID, DETAILCALLBACK f);

//收藏，collect
typedef std::function<void()> COLLECTCALLBACK;
void openCollect(long userID, COLLECTCALLBACK f);

//好友动态
typedef std::function<void()> FRIENDTRENDCALLBACK;
void openFriendTrend(long userID, FRIENDTRENDCALLBACK f);

//个人中心，usercenter
typedef std::function<void(std::string,std::string)> USERCENTERCALLBACK;
void openUsercenter(long , std::string,std::string,std::string,std::string,std::string , USERCENTERCALLBACK f);

//喊话，speak, 返回喊的三句话
typedef std::function<void(std::string speak1, std::string speak2, std::string speak3)> SPEAKCALLBACK;
void openSpeak(SPEAKCALLBACK f);


//刷新用户中心，当oc或android界面需要打开（不是返回）lua中的小岛主界面时，调用
typedef std::function<void(long , std::string , std::string , std::string , std::string, std::string )> USERHOMECALLBACK;
void openUserHome(USERHOMECALLBACK f);

//刷新用户中心的数据
typedef std::function<void(long )> REFRESHUSERHOMECALLBACK;
void refreshUserHome(REFRESHUSERHOMECALLBACK f);

//返回UserHome
typedef std::function<void(long)> BACKTOUSERHOMECALLBACK;
void registBackToUserHome(BACKTOUSERHOMECALLBACK f);

void goback();

//打开地图
typedef std::function<void(int, std::string)> MAPCALLBACK;
void openMap(MAPCALLBACK f);

//打开景点介绍
typedef std::function<void()> SIGHTINTROCALLBACK;
void openSightIntro(long, std::string, std::string, SIGHTINTROCALLBACK f);

//打开景点/片区指数筛选
typedef std::function<void()> CATEGORYCALLBACK;
void openCategory(long, long, std::string, CATEGORYCALLBACK f);

//当脚本由好友用户中心直接返回到自己的用户中心时将调用此函数通知原生程序
typedef std::function<void()> ONMAINPAGECALLBACK;
void onMainPage(ONMAINPAGECALLBACK f);

//当场景脚本中场景加载完毕后，通知原生代码
void sceneLoadOver(std::string name);

//用户点击了热气球，hotball
typedef std::function<void()> HOTBALLCALLBACK;
void openHotBall(long userID, HOTBALLCALLBACK f);

void toolFunction_register(lua_State *L);

#endif
