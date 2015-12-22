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

#define TOOLFUNCTION_CLASS "org/cocos2dx/lua/ToolFunction"

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
	LOGD("C++ userlogin。。。。。。");
	loginCallback_c = f;
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "userLogin","()V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
}

ABOUTCALLBACK aboutCallback_c;
void aboutCallback(int ret)
{
    aboutCallback_c(ret);
}
void openAbout(ABOUTCALLBACK f)
{
    aboutCallback_c = f;
    LOGD("C++ openAbout。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openAbout","()V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
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
	LOGD("C++ openDetail。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openBuddy","()V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
}

MAILCALLBACK mailCallback_c;
void mailCallback(int ret)
{
    mailCallback_c();
}
void openMail(MAILCALLBACK f)
{
    mailCallback_c = f;
    JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openMail","()V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
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
    JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openSendmail","(I)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, userID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
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
    LOGD("C++ openDetail。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openDetail","(I)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, userID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
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
    LOGD("C++ openCollect。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openCollect","(I)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, userID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
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
    LOGD("C++ openFriendTrend。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openLighthouse","(I)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, userID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}

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
    LOGD("C++ openSpeak。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openSpeak","()V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
}

//刷新用户中心，当oc界面需要打开（不是返回）lua中的小岛主界面时，调用
USERHOMECALLBACK userHomeCallback_c;
void openUserHomeCallback(long userID, string name, string intro, string zone, string thumblink, string imglink)
{
	LOGD("openUserHomeCallback in C++");
    if(userHomeCallback_c)
    {
    	userHomeCallback_c(userID, name , intro , zone , thumblink , imglink );
    }
}

extern "C"
{
	void Java_org_cocos2dx_lua_AppActivity_openUserHomeCallback(JNIEnv *env, jlong userID, jstring userName, jstring userIntro, jstring userZone, jstring thumbLink, jstring imgLink)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openUserHomeCallback");
		long userid = userID;
//		LOGD("Java_org_cocos2dx_lua_AppActivity_openUserHomeCallback 11111");
//		const char *nameStr = env->GetStringUTFChars(userName, NULL);
//		string username = nameStr;
//		env->ReleaseStringUTFChars(userName, nameStr);
//		LOGD("Java_org_cocos2dx_lua_AppActivity_openUserHomeCallback 22222");

		string username = JniHelper::jstring2string(userName);
		string userintro = JniHelper::jstring2string(userIntro);
		string userzone = JniHelper::jstring2string(userZone);
		string thumblink = JniHelper::jstring2string(thumbLink);
		string imglink = JniHelper::jstring2string(imgLink);

		openUserHomeCallback(userid, username, "", "", "", "");
	}
}

void openUserHome(USERHOMECALLBACK f)
{
	LOGD("openUserHome C++ ......");
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
void sceneLoadOver(std::string scenename)
{
	LOGD("C++ sceneLoadOver。。。。。。");
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "sceneLoadOver","(Ljava/lang/String;)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jstring name = minfo.env->NewStringUTF(scenename.c_str());
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID, name);
		minfo.env->DeleteLocalRef(minfo.classID);
		minfo.env->DeleteLocalRef(name);
	}
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

void openmapCallback(int categoryType, std::string categoryID)
{
	LOGD("fangdongtest into lua...");
	if(mapCallback_c)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback into lua...");
		mapCallback_c( categoryType, categoryID);
	}
}
extern "C"
{
	void Java_org_cocos2dx_lua_AppActivity_openmapCallback(JNIEnv *env, jint categoryType, jstring categoryID)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback");
		int categorytype = categoryType;
		std::string categoryid = JniHelper::jstring2string(categoryID);;
		openmapCallback(categorytype, categoryid);
	}
}
void openMap(MAPCALLBACK f)
{
	LOGD("注册openMap。。。。。。。");
    mapCallback_c = f;
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
	LOGD("C++打开景点介绍。。。。。。%s",sightDescs.c_str());

	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS,"openSightIntro","(ILjava/lang/String;Ljava/lang/String;)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jstring name = minfo.env->NewStringUTF(sightName.c_str());
		jstring descs = minfo.env->NewStringUTF(sightDescs.c_str());
//		jint id = sightID;
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID,  sightID, name, descs);
		minfo.env->DeleteLocalRef(minfo.classID);
		minfo.env->DeleteLocalRef(name);
		minfo.env->DeleteLocalRef(descs);
	}
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
	LOGD("C++打开片区筛选。。。。。。");

	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openCategory","(IILjava/lang/String;)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jstring categoryid = minfo.env->NewStringUTF(categoryID.c_str());
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID,  sightID, categoryType, categoryid);
		minfo.env->DeleteLocalRef(minfo.classID);
		minfo.env->DeleteLocalRef(categoryid);
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
	LOGD("C++打开打开主页。。。。。。");
    onMainPageCallback_c = f;
    JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "onMainPage","()V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
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
	LOGD("C++打开热气球。。。。。。");
	hotBallCallback_c = f;
	JniMethodInfo minfo;
	bool isHave = JniHelper::getStaticMethodInfo(minfo, TOOLFUNCTION_CLASS, "openHotBall","(I)V");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		minfo.env->DeleteLocalRef(minfo.classID);
	}
}
