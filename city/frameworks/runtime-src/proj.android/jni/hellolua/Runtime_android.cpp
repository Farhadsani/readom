#include <jni.h>
#include <android/log.h>
#include "jni/JniHelper.h"
#include <string>
#include <vector>
#include "../../../Classes/qmap/ToolFunction.h"
using namespace std;
using namespace cocos2d;

#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

string getIPAddress()
{
	JniMethodInfo t;
    string IPAddress("");

    if (JniHelper::getStaticMethodInfo(t, "org/cocos2dx/lua/AppActivity", "getLocalIpAddress", "()Ljava/lang/String;")) {
        jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
        IPAddress = JniHelper::jstring2string(str);
        t.env->DeleteLocalRef(str);
    }
    return IPAddress;
}

#include "../../../Classes/qmap/ToolFunction.h"
std::string getSSID()
{
	//锟斤拷锟矫撅拷态锟斤拷锟斤拷
//	jclass cls = env->FindClass("test/Demo");
//	jmethodID mid = env->GetStaticMethodID(cls, "getHelloWorld","()Ljava/lang/String;");
//	jstring msg = (jstring)env->CallStaticObjectMethod(cls, mid);
//	cout<<JStringToCString(env, msg);

	JniMethodInfo t;
	string ssid("000000000000");
	if(JniHelper::getStaticMethodInfo(t, "org/cocos2dx/lua/AppActivity", "getSSID", "()Ljava/lang/String;")){
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
		ssid = JniHelper::jstring2string(str);
		t.env->DeleteLocalRef(str);
	}

    return ssid;
}

std::string getSSID_Check()
{
	string check("");

	return check;
}
std::string getSSID_Verify()
{
	string verify("");

	return verify;
}

//锟斤拷锟斤拷锟铰硷拷
void ymOnEvent(string eventName)
{
	JniMethodInfo t;
	if(JniHelper::getStaticMethodInfo(t, "org/cocos2dx/lua/AppActivity", "ymOnEvent", "(Ljava/lang/String;)V")){
		jstring jst = t.env->NewStringUTF(eventName.c_str());
		t.env->CallStaticObjectMethod(t.classID, t.methodID, jst);
	}
}

std::string getRequestHeader()
{
	JniMethodInfo t;
	string requestHeader("android");
	if(JniHelper::getStaticMethodInfo(t, "org/cocos2dx/lua/AppActivity", "getRequestHeader", "()Ljava/lang/String;")){
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
		requestHeader = JniHelper::jstring2string(str);
		t.env->DeleteLocalRef(str);
	}

    return requestHeader;
}

std::string getAppVersion()
{
	JniMethodInfo t;
	string appVersion("android");
	if(JniHelper::getStaticMethodInfo(t, "org/cocos2dx/lua/AppActivity", "getAppVersion", "()Ljava/lang/String;")){
		jstring str = (jstring)t.env->CallStaticObjectMethod(t.classID, t.methodID);
		t.env->DeleteLocalRef(t.classID);
		appVersion = JniHelper::jstring2string(str);
		t.env->DeleteLocalRef(str);
	}

	return appVersion;
}

void showWebView( std::string strUrl){
	JniMethodInfo minfo;
	//getStaticMethodInfo锟斤拷锟叫讹拷Java锟斤拷态锟斤拷锟斤拷锟角凤拷锟斤拷冢锟斤拷锟斤拷野锟斤拷锟较�锟斤拷锟芥到minfo锟斤拷
	//锟斤拷锟斤拷1锟斤拷JniMethodInfo
	//锟斤拷锟斤拷2锟斤拷Java锟斤拷锟斤拷锟�+锟斤拷锟斤拷
	//锟斤拷锟斤拷3锟斤拷Java锟斤拷锟斤拷锟斤拷锟斤拷
	//锟斤拷锟斤拷4锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟酵和凤拷锟斤拷值锟斤拷锟斤拷

	bool isHave = JniHelper::getStaticMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","getAppActivity","()Lorg/cocos2dx/lua/AppActivity;");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		//锟斤拷锟斤拷牡锟斤拷锟�getInstance锟斤拷锟斤拷锟斤拷Test锟斤拷亩锟斤拷锟�
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);

		isHave = JniHelper::getMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","openWebview","(Ljava/lang/String;)V");
		if (isHave) {
			//锟斤拷锟斤拷openWebview, 锟斤拷锟斤拷1锟斤拷Test锟斤拷锟斤拷   锟斤拷锟斤拷2锟斤拷锟斤拷锟斤拷ID
			jstring jst = minfo.env->NewStringUTF(strUrl.c_str());
			minfo.env->CallVoidMethod(jobj, minfo.methodID, jst);
		}
	}
}

LOGINCALLBACK loginCallback_c;
void loginCallback(int ret)
{
}
void userLogin(int autoLogin, LOGINCALLBACK f)
{

}

ABOUTCALLBACK aboutCallback_c;
void aboutCallback(int ret)
{
    aboutCallback_c(ret);
}
void openAbout(ABOUTCALLBACK f)
{
    aboutCallback_c = f;

}

//锟斤拷锟斤拷
TOPICCALLBACK topicCallback_c;
void topicCallback(int)
{
    topicCallback_c();
}
//锟斤拷topicID为0时锟斤拷锟斤拷锟诫发锟斤拷锟斤拷页锟斤拷锟斤拷锟斤拷0时锟斤拷锟斤拷值为锟斤拷锟斤拷锟�ID锟斤拷锟斤拷锟斤拷幕锟斤拷锟斤拷锟斤拷锟斤拷
void openTopic(long topicID, TOPICCALLBACK f)
{

}

//锟斤拷锟斤拷
BUDDYCALLBACK buddyCallback_c;
void buddyCallback(int ret)
{
    buddyCallback_c(ret);
}
void openBuddy(long userID, std::string name, std::string intro, std::string zone, std::string thumblink, std::string imglink, BUDDYCALLBACK f)
{

}

MAILCALLBACK mailCallback_c;
void mailCallback(int ret)
{
    mailCallback_c();
}
void openMail(MAILCALLBACK f)
{
    mailCallback_c = f;

}

//锟斤拷锟戒，锟斤拷锟斤拷锟绞硷拷 锟斤拷userID锟斤拷锟斤拷锟斤拷息
SENDMAILCALLBACK sendMailCallback_c;
void sendMailCallback(int ret)
{
    sendMailCallback_c();
}
void openSendmail(long userID, SENDMAILCALLBACK f)
{
    sendMailCallback_c = f;

}

//锟斤拷锟斤拷锟斤拷锟介，detail
DETAILCALLBACK detailCallback_c;
void detailCallback(int ret)
{

    detailCallback_c();
}
void openDetail(long userID, DETAILCALLBACK f)
{
    detailCallback_c = f;

}

//锟秸藏ｏ拷collect
COLLECTCALLBACK collectCallback_c;
void collectCallback(int ret)
{
    collectCallback_c();
}
void openCollect(long userID, COLLECTCALLBACK f)
{
    collectCallback_c = f;

}

//锟斤拷锟窖讹拷态
FRIENDTRENDCALLBACK friendTrendCallback_c;
void friendTrendCallback(int ret)
{
    friendTrendCallback_c();
}
void openFriendTrend(long userID, FRIENDTRENDCALLBACK f)
{
    friendTrendCallback_c = f;
    //一锟铰诧拷锟斤拷锟斤拷讯锟教�锟侥匡拷锟斤拷锟斤拷

}

//锟斤拷锟斤拷锟斤拷锟侥ｏ拷usercenter  锟津开伙拷锟斤拷锟斤拷锟较斤拷锟斤拷
USERCENTERCALLBACK userCenterCallback_c;
void usercenterCallback(int ret)
{

}
void openUsercenter(long userID, std::string name ,std::string intro,std::string zone ,std::string thumblink,std::string imglink, USERCENTERCALLBACK f)
{

}

//锟斤拷锟斤拷锟斤拷speak, 锟斤拷锟截猴拷锟斤拷锟斤拷锟戒话
SPEAKCALLBACK speakCallback_c;
void speakCallback(int ret)
{

}
void openSpeak(SPEAKCALLBACK f)
{
    speakCallback_c = f;

}

//刷新用户中心，当oc界面需要打开（不是返回）lua中的小岛主界面时，调用
USERHOMECALLBACK userHomeCallback_c;
void openUserHomeCallback(long userID, string name, string intro, string zone, string thumblink, string imglink)
{
    if(userHomeCallback_c)
    {
//        refreshUserCenterCallback_c(userID, [name UTF8String], [intro UTF8String], [zone UTF8String], [thumblink UTF8String], [imglink UTF8String]);
    }
}
void openUserHome(USERHOMECALLBACK f)
{
	userHomeCallback_c = f;
}

void goback()
{
//    //ctrol锟斤拷锟斤拷锟斤拷UITabBarController
//    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    //锟叫伙拷锟节讹拷锟斤拷图
//    [ctrol setSelectedIndex:1];

    //ctrol锟斤拷锟斤拷锟斤拷IIViewDeckController
//    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //锟叫伙拷锟节讹拷锟斤拷图
//    [ctrol toggleTopViewAnimated:YES];
}

CUserManager *CUserManager::getInstance()
{
	return new CUserManager();
}

long CUserManager::userid()
{
	return 0;
}

long CUserManager::role()
{
	return 0;
}

std::string CUserManager::name()
{
	return "";
}

std::string CUserManager::intro()
{
	return "";
}

std::string CUserManager::zone()
{
	return "";
}

std::string CUserManager::imglink()
{
	return "";
}

std::string CUserManager::thumblink()
{
	return "";
}

int CUserManager::userLoginStatus()
{
	return 0;
}

std::string getAppName()
{
    return "citystate";
}

//锟斤拷锟斤拷锟斤拷锟脚憋拷锟叫筹拷锟斤拷锟斤拷锟斤拷锟斤拷虾锟酵ㄖ�原锟斤拷锟斤拷锟斤拷
void sceneLoadOver(std::string name)
{

}

//刷新小岛数据
REFRESHUSERHOMECALLBACK refreshUserHomeCallback_c;
void refreshUserHomeCallback_1(long userID)    //加_1是为了避免重名
{
//    InfoLog(@"刷新个人中心");
    if (refreshUserHomeCallback_c) {
        refreshUserHomeCallback_c(userID);
    }
}
void refreshUserHome(REFRESHUSERHOMECALLBACK f)
{
    refreshUserHomeCallback_c = f;
//    [BaseUIViewController setRefreshUserHome:refreshUserHomeCallback_1];
}

//打开地图操作
MAPCALLBACK mapCallback_c;

void fangdongTest()
{
	LOGD("fangdongtest into lua...");
	if(mapCallback_c)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback into lua...");
//		std::string strID = JniHelper::jstring2string(categoryID);
//		mapCallback_c((int)categoryType, strID);
//		mapCallback_c( 0, "");
	}
}
extern "C"
{
	void Java_org_cocos2dx_lua_AppActivity_openmapCallback(JNIEnv *env, jint categoryType, jstring categoryID)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback");
		fangdongTest();
//		if(mapCallback_c)
//		{
//			LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback into lua...");
//			std::string strID = JniHelper::jstring2string(categoryID);
//			mapCallback_c((int)categoryType, strID);
//		}
	}
}
void openMap(MAPCALLBACK f)
{
	LOGD("注册openMap。。。。。。。");
    mapCallback_c = f;
//    mapCallback_c(0, "");
}

BACKTOUSERHOMECALLBACK backToUserHomeCallback_c;
void backToUserHomeCallback(long userID)
{
//    InfoLog(@"");
    if(backToUserHomeCallback_c)
    {
        backToUserHomeCallback_c(userID);
    }
}
void registBackToUserHome(BACKTOUSERHOMECALLBACK f)
{
//    InfoLog(@"");
    backToUserHomeCallback_c = f;
//    [BaseUIViewController setBackUserHome:backToUserHomeCallback];
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
//    SightDetailViewController * vc = [[[SightDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    [vc.data_dict setNonEmptyObject:@(sightID) forKey:k_sightID];
//    [vc.data_dict setNonEmptyObject:[NSString stringWithCString:sightName.c_str() encoding:NSUTF8StringEncoding] forKey:k_sightName];
//    [vc.data_dict setNonEmptyObject:[NSString stringWithCString:sightDescs.c_str() encoding:NSUTF8StringEncoding] forKey:k_sightDescs];
//    sightIntroCallback_c = f;
//    [vc setCocosCallback:sightIntroCallback];
//    CocosMapIndexRootViewController * sVC = (CocosMapIndexRootViewController *)[(AppController *)APPLICATION getVisibleViewController];
//    [sVC showSightDetailView:vc];

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
//    NSInteger ID = [[NSString stringWithCString:categoryID.c_str() encoding:NSUTF8StringEncoding] integerValue];
//
//    if (ID != 0) {
//        NSArray *socailArr = [[Cache shared].cache_dict valueForKey:SocialCategoryIds];
//        NSArray *consumeArr = [[Cache shared].cache_dict valueForKey:ConsumeCategoryIds];
//        NSArray *tagArr = [[Cache shared].cache_dict valueForKey:HotTagsCategoryIds];
//
//        if ([socailArr containsObject:@(ID)] || [tagArr containsObject:@(ID)]) {
//            SocialIndexViewController *socialIndexViewController = [[SocialIndexViewController alloc] init];
//            socialIndexViewController.areaid = sightID;
//            if (categoryType == 1) {
//                NSArray *socialKey = [[Cache shared].cache_dict valueForKey:SocialKey];
//                for (NSDictionary *d in socialKey) {
//                    if ([d[@"categoryid"] intValue] == ID) {
//                        socialIndexViewController.title = d[@"cname"];
//                        break ;
//                    }
//                }
//                socialIndexViewController.categoryid = ID;
//            } else {
//                NSArray *hotTagsKey = [[Cache shared].cache_dict valueForKey:HotTagsKey];
//                for (NSDictionary *d in hotTagsKey) {
//                    if ([d[@"tagid"] intValue] == ID) {
//                        socialIndexViewController.title = d[@"name"];
//                        break ;
//                    }
//                }
//                socialIndexViewController.tagid = ID;
//            }
//            UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
//            [sVC.navigationController pushViewController:socialIndexViewController animated:YES];
//        } else if ([consumeArr containsObject:@(ID)]) {
//            ConsumeIndexViewController *consumeIndexViewController = [[ConsumeIndexViewController alloc] init];
//            NSArray *consumeKey = [[Cache shared].cache_dict valueForKey:ConsumeKey];
//            for (NSDictionary *d in consumeKey) {
//                if ([d[@"categoryid"] intValue] == ID) {
//                    consumeIndexViewController.title = d[@"cname"];
//                    break ;
//                }
//            }
//            consumeIndexViewController.areaid = sightID;
//            consumeIndexViewController.categoryid = ID;
//            consumeIndexViewController.streetid = 0;
//            UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
//            [sVC.navigationController pushViewController:consumeIndexViewController animated:YES];
//        }
//    }
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
//    NSLog(@"脚本中直接调用了回到自己的个人中心，原生程序处理完毕后，调用onMainPageCallback");
    onMainPageCallback_c = f;
//    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
//    if (sVC.navigationController) {
//        [sVC.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [sVC dismissViewControllerAnimated:YES completion:nil];
//    }
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
//    if ([[UserManager sharedInstance] isCurrentUser:userID] && [[UserManager sharedInstance] isStoreUser:[UserManager sharedInstance].brief]) {
//        hotBallCallback_c = f;
////        StoreViewController *vc = [[StoreViewController alloc] init];
//        MyStoreViewController *vc = [[MyStoreViewController alloc] init];
//        [vc setUserData:userID];
//        [vc setCocosCallback:detailCallback];
//        toIOS(vc);
//        [vc release];
//    }
//    else{
//        [[UserManager sharedInstance] UserID:userID getUserInfo:^(NSDictionary *info) {
//            BOOL isStore = NO;
//            if(info && info.count > 0 && [info objectOutForKey:@"role"] && [[info objectOutForKey:@"role"] integerValue] == Role_Store){
//                isStore = YES;
//            }
//            if (isStore) {
//                hotBallCallback_c = f;
//
//                StoreViewController *vc = [[StoreViewController alloc] init];
//
//
////                MyStoreViewController *vc = [[MyStoreViewController alloc] init];
//                [vc setUserData:userID];
//                [vc setCocosCallback:detailCallback];
//                toIOS(vc);
//                [vc release];
//            }
//            else{
//                hotBallCallback_c = f;
//                ShoppingListViewController *vc = [[ShoppingListViewController alloc] init];
//                [vc setUserData:userID];
//                [vc setCocosCallback:hotBallCallback];
//                toIOS(vc);
//                [vc release];
//            }
//        }];
//    }
}
