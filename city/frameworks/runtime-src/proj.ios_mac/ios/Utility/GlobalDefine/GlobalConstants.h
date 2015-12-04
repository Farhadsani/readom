//
//  GlobalConstants.h
//  
//
//  Created by hf on 13-7-10.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

//#import "Reachability.h"
//#import "ReachabilityIOSMac.h"

/*******************************客户端控制开关**********************************/

/*
 打开该宏定义表示：所有资源都直接从 Bundle 下读取
 (特别注意：插件模块和换肤模块正常运行必须要屏蔽该宏定义)
 */
//#define __READFROMBUNDLE__
/*---------------------------------------------------------------------------*/

/*
 打开该宏定义表示：所有的资源都先在Bundle目录下寻找，找到就返回，没有找到就到Document目录下找，还找不到就请求Service服务器
 */
#define __READFROMBUNDLEATFIRST__

/*
 打开该宏定义表示：HTML资源都在储存在Document目录的“根目录”下
 */
//#define __HTML_LOCATION_IN_ROOT_PATH__
/*---------------------------------------------------------------------------*/

/*
 打开该宏定义表示：开启启动请求接口
 */
//#define __ENDPOINT_SERVICE_OK__
/*---------------------------------------------------------------------------*/


/*
 打开该宏定义表示：错误提示中增加显示错误码
 */
//#define __SHOW_ERROR_CODE__
/*---------------------------------------------------------------------------*/

/*
 Document目录下没有资源时，优先读取Bundle根目录，如果屏蔽该宏定义则不读Bundle，直接去请求服务器（该宏定义主要用于本地页面调试）
 */
#define __GET_RESOURCE_FROM_BUNDLE_WHEN_DOCUMENT_NOT_EXITS__

/*
 打开该宏定义：表示在程序第一次启动时会初始化本地页面数据，否则不初始化
 */
//#define __INITIALIZE_SWITCH_AT_APP_STARTUP__



//启用远程推送服务
//#define __ENABLE_REMOTE_PUSH_NOTIFICATION__

//打开用户向导，当用户首次启动应用的时候。
//#define __ENABLE_GUID_PAGES_WHILE_APP_LAUNCH__

//启用轮询用户登录状态
//#define __ENABLE_POLLING_USER_STATUS__1
///************************************End*************************************/
//

//#define kIsCurrentNetStatusOnline [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO

#define k_RELEASE_SAFELY(__POINTER) { if(__POINTER) {[__POINTER release]; __POINTER = nil; }}
#define k_INVALIDATE_TIMER(__TIMER) { if(__TIMER) {[__TIMER invalidate]; __TIMER = nil; }}

#define APPLICATION ([[UIApplication sharedApplication] delegate])

#define DegreesToRadians(x) ((x) * M_PI / 180.0) //角度

#define k_KeyboardHeight (216) //键盘高度

#define rgb(r,g,b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue: (b) / 255.0 alpha:1]
#define rgba(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue: (b) / 255.0 alpha:(r)]
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)      //iphone:320   iPad:768
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)    //iphone5:568   iphone4:480  iPad:1024

#define mainBGColor @"#f5f5f5"//浅灰色


//#define darkZongSeColor rgb(165, 141, 113) //深棕色
#define darkZongSeColor rgba(93, 73, 61, 0.8) //深棕色
//#define midZongSeColor rgb(222, 178, 100) //棕色
#define midZongSeColor rgb(230, 190, 120) //棕色
#define lightZongSeBGColor rgb(194, 179, 159) //浅棕色
#define minlightZongSeBGColor rgb(230, 228, 210) //淡棕色

#define lightgray_color @"#f5f5f5"//浅灰色

#define darkgray_color @"#333333"//深灰 tabbar颜色

#define gray_color [UIColor grayColor]//灰
#define clear_color [UIColor clearColor]//

//#define blueLight_color @"#00b5e0"
#define blueLight_color @"#1eb6de"


#define orange_color rgb(251, 107, 11)

#define green_color rgb(147, 205, 86)

#define red_color @"#fe4c4c"
#define darkblack_color @"#131313"//暗黑色

#define borderDefaultColor @"#a5a5a5" //灰

#define white_color @"#ffffff"//白色
#define black_color @"#000000" //黑色

#define textColor_normal @"#131313"//暗黑色
#define textColor_unselected @"#a5a5a5"//灰

#define slightGrayColor rgb(242, 242, 242) //按钮点击效果背景颜色
#define slightGrayColor2 rgb(200, 200, 200) //
#define slightGrayColor3 rgb(182, 183, 184) //

//#define k_fontFamilyName @"TimesNewRomanPS-ItalicMT"
//#define k_font_Kaiti_GB2312 @"kaiti_GB2312"
#define k_default_fontSize 14.0                 //默认字体大小
//#define k_fontColor [UIColor blackColor]
//#define k_font [UIFont fontWithName:@"" size:15.0]
//#define k_font_system [UIFont systemFontOfSize:15.0]
//#define k_font_boldSystem [UIFont boldSystemFontOfSize:@"" size:15.0]

#define k_fontName_Number_Thin @"HelveticaNeue-Thin"//极细体
#define k_fontName_Number_Light @"HelveticaNeue-Light"//较细体
#define k_fontName_Number_Medium @"HelveticaNeue-Medium"//粗体

#define k_fontName_FZXY @"FZY1JW--GB1-0" //方正细圆
#define k_fontName_FZZY @"FZY3JW--GB1-0" //方正准圆

#define k_SYS_VERSION [[UIDevice currentDevice] systemVersion]
#define k_NO_LESS_THAN_IOS(x) ([k_SYS_VERSION floatValue] >= x)
#define k_isIphone4s (kScreenHeight < 568)
#define k_SCREEN_SIZE_HEIGHT_480 ((kScreenHeight==480) ? YES:NO)

// default status bar height
#define k_DEFAULT_STATUS_BAR_HEIGHT  20

// default navigation bar
#define k_DEFAULT_NAVIGATION_BAR_HEIGHT 44.0
#define k_IOS7_NAVIGATION_BAR_HEIGHT 64.0

// default bottom bar
#define k_DEFAULT_BOTTOM_BAR_HEIGHT 49.0 //50.0

#define kPublicLeftMenuWidth (kScreenWidth-60)

#define k_PickViewTopToolBarHeight 40 //顶部的工具栏高度
#define k_PickViewBottomBarHeight 30 //底部的说明栏高度
#define k_PickViewHeight 160 //UIPickView的高度

//设备操作系统版本号（floatValue）
#define kDeviceSystemVersion [k_SYS_VERSION floatValue]

#define k_buttonIndex_cancel 0
#define k_buttonIndex_btn1 1
#define k_buttonIndex_btn2 2


#define k_TokenId @"tokenId"
#define k_shouldUpdateTokenIdFlag @"shouldUpdateTokenId"    //0：不需要更新Token、1：需要更新Token、2：推送token失败，需要继续更新Token


#define k_loginstatus @"loginstatus"
#define k_RanderStatus @"RanderStatus"
#define k_applicationDidEnterBackgroundTime @"applicationDidEnterBackgroundTime"    //记录程序进入后台的时间
#define k_hasEverLaunch @"hasEverLaunch"        //标识是否是第一次启动

#define k_pageSize @"pageSize"  //每页的条数
#define k_pageIdx @"pageIdx"    //当前页码


#define k_OrdersNotifysPlist @"OrdersNotifys.plist"        //Document文档中，储存远程通知的订单(储存对象为推送过来的订单消息)
#define k_MessagesNotifysPlist @"MessagesNotifys.plist"    //Document文档中，储存远程通知的消息(储存对象为推送过来的消息)，注意：消息可能包含订单的消息


#define _Map_Default_longitude_ 113.332357  //经度
#define _Map_Default_latitude_ 23.128108    //纬度

#define _Map_Min_longitude_of_china 73.30
#define _Map_Max_longitude_of_china 135.06

#define _Map_Min_latitude_of_china 3.50
#define _Map_Max_latitude_of_china 53.34

//#define k_LOCAL_CODE_TEST_MODEL     //本地测试标识，用测试代码
//#define k_LOCAL_REQUEST_TEST_MODEL     //本地请求测试模式标识

/****************************************************************/

//服务器接口地址
#define k_EXTERN_ENDPOINT_SERVER_URL            @"http://test.shitouren.com"    //测试地址
//#define k_EXTERN_ENDPOINT_SERVER_URL            @"http://www.shitouren.com"     //发布地址

/******* 接口（运行参数） ******/

#define k_api_user_signin               @"/api/user/signin"           //登录
#define k_api_user_signout              @"/api/user/signout"          //登出
#define k_api_user_validate             @"/api/user/validate"         //测试是否成功登录
#define k_api_user_signup               @"/api/user/signup"           //注册
#define k_api_user_findpwdverify        @"/api/user/findpwdverify"    //找回密码验证验证码
#define k_api_user_resetpwd             @"/api/user/resetpwd"         //重置密码
#define k_api_user_sendsms              @"/api/user/sendsms"          //发送验证码
#define k_api_user_getuser              @"/api/user/getuser"          //获取用户信息
#define k_api_user_updatedetail         @"/api/user/updatedetail"     //更新用户细节信息
#define k_api_user_updatebrief          @"/api/user/updatebrief"      //更新用户简介
#define k_api_user_add                  @"/api/feedback/add"          //用户反馈


#define k_api_shout_list                @"/api/shout/list"          //喊话列表


#define k_api_message_system            @"/api/message/system"
#define k_api_message_system_del        @"/api/message/system/del"
#define k_api_message_user              @"/api/message/user"
#define k_api_message_user_add          @"/api/message/user/add"
#define k_api_message_user_del          @"/api/message/user/del "
#define k_api_message_pet               @"/api/message/pet"
#define k_api_message_pet_add           @"/api/message/pet/add"
#define k_api_message_pet_del           @"/api/message/pet/del"
#define k_api_message_note_like         @"/api/message/note/like"


#define k_api_user_feed_list             @"/api/user/feed/list"
#define k_api_user_feed_hide_set         @"/api/user/feed/hide/set"
#define k_api_user_feed_buddy            @"/api/user/feed/buddy"    //查看用户的关注用户动态
#define k_api_note_like_post             @"/api/note/like/post"
#define k_api_note_like_del              @"/api/note/like/del"

#define k_api_topic_one                  @"/api/topic/one"
#define k_api_topic_list                 @"/api/topic/list"
#define k_api_topic_hot                  @"/api/topic/hot"
#define k_api_note_one                   @"/api/note/one"
#define k_api_note_list                  @"/api/note/list"

#define k_api_note_post                  @"/api/note/post"      //发表note


#define k_api_topic_like_post            @"/api/topic/like/post"    //收藏话题
#define k_api_topic_like_del             @"/api/topic/like/del"     //取消收藏话题

#define k_api_feedback_add              @"/api/feedback/add"

#define k_api_shout_update              @"/api/shout/update"        //喊话


#define k_api_user_square                @"/api/user/square"        //获取广场上用户
#define k_api_user_getfollow             @"/api/user/getfollow"     //获取关注的用户
#define k_api_user_getfans               @"/api/user/getfans"       //获取粉丝
#define k_api_user_follow                @"/api/user/follow"        //关注用户
#define k_api_user_unfollow              @"/api/user/unfollow"      //取消关注用户
#define k_api_user_getbuddycount         @"/api/user/getbuddycount" //获取用户关注粉丝统计


//接口字段
#define k_result            @"result"
#define k_msg               @"msg"



/* Model

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate callback

#pragma mark other delegate callback

#pragma mark - action such as: click touch tap slip ...

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{

}
 
- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark

*/
