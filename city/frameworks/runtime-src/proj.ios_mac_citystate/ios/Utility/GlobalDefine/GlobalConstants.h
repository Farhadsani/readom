//
//  GlobalConstants.h
//  
//
//  Created by hf on 15-8-10.
//  Copyright (c) 2015年 shitouren. All rights reserved.
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
//#define __READFROMBUNDLEATFIRST__

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
 本地请求测试模式标识（用于本地接口调试）
 */
//#define k_LOCAL_REQUEST_TEST_MODEL

///************************************End*************************************/

//#define kIsCurrentNetStatusOnline [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO

#define k_RELEASE_SAFELY(__POINTER) { if(__POINTER) {[__POINTER release]; __POINTER = nil; }}
#define k_INVALIDATE_TIMER(__TIMER) { if(__TIMER) {[__TIMER invalidate]; __TIMER = nil; }}

#define DegreesToRadians(x) ((x) * M_PI / 180.0)        //角度

#define kScreenWidth    ([[UIScreen mainScreen] bounds].size.width)         //iphone:320   iPad:768
#define kScreenHeight   ([[UIScreen mainScreen] bounds].size.height)        //iphone5:568   iphone4:480  iPad:1024


/*---------------------------------------------------------------------------*/
//颜色

#define rgb(r,g,b)      [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue: (b) / 255.0 alpha:1]
#define rgba(r,g,b,a)   [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue: (b) / 255.0 alpha:(r)]

//重要颜色定义
#define k_defaultViewControllerBGColor  rgb(255, 254, 242)      //默认viewController的view背景颜色
#define k_defaultNavBGColor             yello_color             //默认导航栏背景颜色
#define k_defaultTextColor              rgb(78, 78, 78)         //默认普通字体颜色
#define k_defaultLightTextColor         rgb(180, 180, 180)      //默认浅色字体颜色（比普通字体颜色较浅）
#define k_defaultTitleColor             rgb(73, 45, 34)         //默认标题字体颜色（导航栏标题字体颜色、重要标题字体颜色），颜色比普通字体较深
#define k_defaultLineColor              lightgray_color         //默认线条颜色（浅灰色）

#define k_defaultTipTextColor         rgb(213, 213, 213)        //默认浅色字体颜色（比普通字体颜色较浅）


#define darkZongSeColor         rgba(93, 73, 61, 0.8)   //深棕色
#define midZongSeColor          rgb(230, 190, 120)      //棕色
#define lightZongSeBGColor      rgb(194, 179, 159)      //浅棕色
#define minlightZongSeBGColor   rgb(230, 228, 210)      //淡棕色


#define clear_color             [UIColor clearColor]
#define white_color             [UIColor whiteColor]    //白色
#define milky_color             rgb(253,255,243)        //乳白色

#define black_color             @"#000000"              //黑色
#define darkblack_color         [UIColor blackColor]    //暗黑色

#define yello_color             rgb(253, 220, 67)       //小黄人黄色

#define gray_color              [UIColor grayColor]     //灰
//#define lightgray_color         @"#f5f5f5"              //浅灰色
#define lightgray_color         rgb(228,228,228)        //浅灰色
#define darkGary_color          rgb(104,104,104)        //深灰色

#define blueLight_color         @"#1eb6de"              //淡蓝色
#define orange_color            rgb(251, 107, 11)
#define green_color             rgb(147, 205, 86)
#define red_color               @"#fe4c4c"
#define darkRed_color          rgb(217,68,9)        //深红色

/*---------------------------------------------------------------------------*/
//字体
#define k_defaultFontName           k_fontName_FZZY             //默认字体
#define k_defaultFontSize           15.0                        //默认普通文本字体大小
#define k_defaultNavTitleFontSize   18.0                        //默认导航栏标题文本字体大小

#define k_fontName_Number_Thin      @"HelveticaNeue-Thin"       //极细体
#define k_fontName_Number_Light     @"HelveticaNeue-Light"      //较细体
#define k_fontName_Number_Medium    @"HelveticaNeue-Medium"     //粗体

//#define k_fontName_FZXY             @"FZY1JW--GB1-0"            //方正细圆
#define k_fontName_FZXY             k_fontName_FZZY             //
#define k_fontName_FZZY             @"FZY3JW--GB1-0"            //方正准圆

/*---------------------------------------------------------------------------*/
//常用判断
#define k_SYS_VERSION               [[UIDevice currentDevice] systemVersion]
//设备操作系统版本号（floatValue）
#define kDeviceSystemVersion        [k_SYS_VERSION floatValue]

#define k_NO_LESS_THAN_IOS(x)       ([k_SYS_VERSION floatValue] >= x)

#define k_isIphone4s                (kScreenHeight < 568)
#define k_SCREEN_SIZE_HEIGHT_480    ((kScreenHeight==480) ? YES:NO)

/*---------------------------------------------------------------------------*/
//常用常量
// default status bar height
#define k_DEFAULT_STATUS_BAR_HEIGHT         20

// default navigation bar
#define k_DEFAULT_NAVIGATION_BAR_HEIGHT     44.0
#define k_IOS7_NAVIGATION_BAR_HEIGHT        64.0

// default bottom bar
#define k_DEFAULT_BOTTOM_BAR_HEIGHT         49.0        //50.0

#define k_KeyboardHeight                    (216)       //键盘高度

#define APPLICATION     ([[UIApplication sharedApplication] delegate])

/*---------------------------------------------------------------------------*/

#define k_User_Agent                @"shitouren_citystate_ios"
#define k_NSHTTPCookieName_SSID     @"shitouren_ssid"
#define k_NSHTTPCookieName_CHECK    @"shitouren_check"
#define k_NSHTTPCookieName_VERIFY   @"shitouren_verify"

//服务器接口地址
#define SHITOUREN_DOMAIN                        @"shitouren.com"
#define k_EXTERN_ENDPOINT_SERVER_URL            @"http://taiyuantest.shitouren.com"    //测试地址
//#define k_EXTERN_ENDPOINT_SERVER_URL            @"http://test.shitouren.com"    //测试地址

//#define k_EXTERN_ENDPOINT_SERVER_URL            @"http://www.shitouren.com"     //发布地址

/*---------------------------------------------------------------------------*/
/******* 接口（运行参数） ******/

#define k_api_user_signin               @"/api/user/signin"           //登录
#define k_api_user_signout              @"/api/user/signout"          //登出
#define k_api_user_validate             @"/api/user/validate"         //测试是否成功登录
#define k_api_user_signup               @"/api/user/signup"           //注册
#define k_api_user_findpwdverify        @"/api/user/findpwdverify"    //找回密码验证验证码
#define k_api_user_resetpwd             @"/api/user/resetpwd"         //重置密码
#define k_api_user_editpwd              @"/api/user/editpwd"          //修改密码
#define k_api_user_sendsms              @"/api/user/sendsms"          //发送验证码
#define k_api_user_resetphone           @"/api/user/resetphone"       //重置手机号码
#define k_api_user_getuser              @"/api/user/getuser"          //获取用户信息
#define k_api_user_updatedetail         @"/api/user/updatedetail"     //更新用户细节信息
#define k_api_user_updatebrief          @"/api/user/updatebrief"      //更新用户简介(普通用户)
#define k_api_user_updateother          @"/api/user/updateother"      //更新用户简介(普通用户)
#define k_api_store_manage_updatebrief  @"/api/store/manage/updatebrief"//更新用户简介(商家用户)

#define k_api_user_updatehead           @"/api/user/updatehead"       //更新用户头像(普通用户)
//#define k_api_store_manage_updatehead   @"/api/store/manage/updatehead"//更新用户头像(商家用户)

#define k_api_feedback_add              @"/api/feedback/add"          //用户反馈


#define k_api_store_manage_updateimgs   @"/api/store/manage/updateimgs"//上传商家相册

#define k_api_shout_list                @"/api/shout/list"            //喊话列表
#define k_api_qrcode                    @"/api/qrcode"                //生成个人二维码

#define k_api_message_system            @"/api/message/system"
#define k_api_message_system_del        @"/api/message/system/del"
#define k_api_message_user              @"/api/message/user"
#define k_api_message_user_add          @"/api/message/user/add"
#define k_api_message_user_del          @"/api/message/user/del"
#define k_api_message_pet               @"/api/message/pet"
#define k_api_message_pet_add           @"/api/message/pet/add"
#define k_api_message_pet_del           @"/api/message/pet/del"
#define k_api_message_feed_like         @"/api/message/feed/like"

#define k_api_feed_comment_list         @"/api/feed/comment/list"   //获取评论
#define k_api_feed_comment_post         @"/api/feed/comment/post"   //发表评论

#define k_api_feed_user_list             @"/api/feed/user/list"
#define k_api_feed_like_list             @"/api/feed/like/list"
#define k_api_user_feed_hide_set         @"/api/user/feed/hide/set"
#define k_api_user_feed_buddy            @"/api/user/feed/buddy"    //查看用户的关注用户动态
#define k_api_feed_hot                   @"/api/feed/hot"           //广场 热门
#define k_api_feed_follow                @"/api/feed/follow"        //广场 关注
#define k_api_note_like_post             @"/api/note/like/post"
#define k_api_note_like_del              @"/api/note/like/del"
#define k_api_feed_like_post             @"/api/feed/like/post"     //点赞
#define k_api_feed_like_del              @"/api/feed/like/del"
#define k_api_feed_nearby_list           @"/api/feed/nearby/list"   // 获取附近的人的动态
#define k_api_feed_special             @"/api/feed/special"
#define k_api_feed_area_list             @"/api/feed/area/list"     // 获取片区所有feed
#define k_api_store_goods_special        @"/api/store/goods/special"     // 获取片区所有的特卖


#define k_api_topic_one                  @"/api/topic/one"
#define k_api_topic_list                 @"/api/topic/list"
#define k_api_topic_hot                  @"/api/topic/hot"
#define k_api_note_one                   @"/api/note/one"
#define k_api_note_list                  @"/api/note/list"

#define k_api_feed_post                  @"/api/feed/post"          //发表note


#define k_api_topic_like_post            @"/api/topic/like/post"    //收藏话题
#define k_api_topic_like_del             @"/api/topic/like/del"     //取消收藏话题

#define k_api_shout_update               @"/api/shout/update"        //喊话


#define k_api_user_square                @"/api/user/square"        //获取广场上用户
#define k_api_user_getfollow             @"/api/user/getfollow"     //获取关注的用户
#define k_api_user_getfans               @"/api/user/getfans"       //获取粉丝
#define k_api_user_follow                @"/api/user/follow"        //关注用户
#define k_api_user_unfollow              @"/api/user/unfollow"      //取消关注用户
#define k_api_user_getbuddycount         @"/api/user/getbuddycount" //获取用户关注粉丝统计



#define k_api_location                      @"/api/location"        //获取用户位置
#define k_api_location_update               @"/api/location/update" //更新用户位置


#define k_api_category_cost_list                    @"/api/category/cost/list"   // 消费指数列表
#define k_api_category_social_list                  @"/api/category/social/list" // 社交指数列表
#define k_api_category_tag_list                     @"/api/category/tag/list"    // 社交指数标签列表
#define k_api_category_cost                         @"/api/category/cost"        // 消费指数下的用户属性地图
#define k_api_category_social                       @"/api/category/social"      // 社交指数下的用户属性地图
#define k_api_category_tag                          @"/api/category/tag"         // 社交指数下的标签属性地图
#define k_api_user_list                             @"/api/user/list"            // 用户列表

#define k_api_order_list                            @"/api/order/list"           // 获取用户订单
#define k_api_order_detail                          @"/api/order/detail"         // 获取用户订单详情
#define k_api_order_comment                         @"/api/store/comment/add"        // 评论订单
#define k_api_order_user_list                         @"/api/order/user/list"

#define k_api_store_list                            @"/api/store/list"            // 指数下的地图上某片区某街道的商店列表
#define k_api_store_intro                           @"/api/store/intro"           // 商店信息
#define k_api_store_goods                           @"/api/store/goods"         // 商店商品
#define k_api_store_special                         @"/api/store/special"         // 商店特卖
#define k_api_store_comment_list                    @"/api/store/comment/list"    // 针对商家的评论
#define k_api_store_comment_post                    @"/api/store/comment/post"    // 添加商家评论
#define k_api_store_like_post                       k_api_user_follow               // 收藏商店
#define k_api_store_like_del                        k_api_user_unfollow             // 取消收藏商店
#define k_api_street_list                           @"api/street/list"              //获取片区下所有的街道的列表
#define k_api_store_manage_updatecategory           @"/api/store/manage/updatecategory"
#define k_api_store_manage_goods                    @"/api/store/manage/goods"
#define k_api_store_manage_goods_add                @"/api/store/manage/goods/add"
#define k_api_store_manage_goods_del                @"/api/store/manage/goods/del"
#define k_api_store_manage_goods_edit               @"/api/store/manage/goods/edit"

#define k_web_store_manage_report                   @"/web/store/manage/report"


//获取服务器端支付数据地址（商户自定义）
#define k_api_create_order_to_pay                      @"/api/order/pay"          //生成订单
#define k_api_order_pay                             @"/api/order/pay"                 //支付订单
#define k_api_order_pay_result                      @"/api/order/pay/result"  //查询支付结果接口

#define k_api_proimid_check              @"/api/promo/validate"          //检查特卖卷的使用状态

#define k_api_device_token             @"/api/device/token"



#define k_registrationID          @"registrationID"         //极光推送ID名称

/*---------------------------------------------------------------------------*/
//接口字段
#define k_result            @"result"
#define k_msg               @"msg"

#define k_sightID           @"sightID"      //景点ID
#define k_sightName         @"sightName"    //景点名称
#define k_sightDescs        @"sightDescs"   //景点描述

/*---------------------------------------------------------------------------*/
//other defines
#define k_applicationDidEnterBackgroundTime     @"applicationDidEnterBackgroundTime"    //记录程序进入后台的时间
#define k_hasEverLaunch                         @"hasEverLaunch"                        //标识是否是第一次启动
#define k_NavBarTag             2163

#define k_buttonIndex_cancel    0
#define k_buttonIndex_btn1      1
#define k_buttonIndex_btn2      2

#define k_pageSize              @"pageSize"                     //每页的条数
#define k_pageIdx               @"pageIdx"                      //当前页码


#define k_OrdersNotifysPlist    @"OrdersNotifys.plist"          //Document文档中，储存远程通知的订单(储存对象为推送过来的订单消息)
#define k_MessagesNotifysPlist  @"MessagesNotifys.plist"        //Document文档中，储存远程通知的消息(储存对象为推送过来的消息)，注意：消息可能包含订单的消息


#define _Map_Default_longitude_         113.332357              //默认经度
#define _Map_Default_latitude_          23.128108               //默认纬度

#define _Map_Min_longitude_of_china     73.30
#define _Map_Max_longitude_of_china     135.06

#define _Map_Min_latitude_of_china      3.50
#define _Map_Max_latitude_of_china      53.34

/*---------------------------------------------------------------------------*/
/* Model

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate

#pragma mark other delegate

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
