#include <jni.h>
#include <android/log.h>
#include "jni/JniHelper.h"
#include <string>
#include <vector>
#include "../../../Classes/qmap/ToolFunction.h"
using namespace std;
using namespace cocos2d;

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
	//ï¿½ï¿½ï¿½Ã¾ï¿½Ì¬ï¿½ï¿½ï¿½ï¿½
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

//ï¿½ï¿½ï¿½ï¿½ï¿½Â¼ï¿½
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
	//getStaticMethodInfoï¿½ï¿½ï¿½Ð¶ï¿½Javaï¿½ï¿½Ì¬ï¿½ï¿½ï¿½ï¿½ï¿½Ç·ï¿½ï¿½ï¿½Ú£ï¿½ï¿½ï¿½ï¿½Ò°ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½æµ½minfoï¿½ï¿½
	//ï¿½ï¿½ï¿½ï¿½1ï¿½ï¿½JniMethodInfo
	//ï¿½ï¿½ï¿½ï¿½2ï¿½ï¿½Javaï¿½ï¿½ï¿½ï¿½ï¿½+ï¿½ï¿½ï¿½ï¿½
	//ï¿½ï¿½ï¿½ï¿½3ï¿½ï¿½Javaï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
	//ï¿½ï¿½ï¿½ï¿½4ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ÍºÍ·ï¿½ï¿½ï¿½Öµï¿½ï¿½ï¿½ï¿½

	bool isHave = JniHelper::getStaticMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","getAppActivity","()Lorg/cocos2dx/lua/AppActivity;");
	jobject jobj;//ï¿½ï¿½ï¿½ï¿½ï¿½
	if (isHave) {
		//ï¿½ï¿½ï¿½ï¿½Äµï¿½ï¿½ï¿½getInstanceï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Testï¿½ï¿½Ä¶ï¿½ï¿½ï¿½
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);

		isHave = JniHelper::getMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","openWebview","(Ljava/lang/String;)V");
		if (isHave) {
			//ï¿½ï¿½ï¿½ï¿½openWebview, ï¿½ï¿½ï¿½ï¿½1ï¿½ï¿½Testï¿½ï¿½ï¿½ï¿½   ï¿½ï¿½ï¿½ï¿½2ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ID
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

//ï¿½ï¿½ï¿½ï¿½
TOPICCALLBACK topicCallback_c;
void topicCallback(int)
{
    topicCallback_c();
}
//ï¿½ï¿½topicIDÎª0Ê±ï¿½ï¿½ï¿½ï¿½ï¿½ë·¢ï¿½ï¿½ï¿½ï¿½Ò³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½0Ê±ï¿½ï¿½ï¿½ï¿½ÖµÎªï¿½ï¿½ï¿½ï¿½ï¿½IDï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
void openTopic(long topicID, TOPICCALLBACK f)
{

}

//ï¿½ï¿½ï¿½ï¿½
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

//ï¿½ï¿½ï¿½ä£¬ï¿½ï¿½ï¿½ï¿½ï¿½Ê¼ï¿½ ï¿½ï¿½userIDï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ï¢
SENDMAILCALLBACK sendMailCallback_c;
void sendMailCallback(int ret)
{
    sendMailCallback_c();
}
void openSendmail(long userID, SENDMAILCALLBACK f)
{
    sendMailCallback_c = f;

}

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½é£¬detail
DETAILCALLBACK detailCallback_c;
void detailCallback(int ret)
{

    detailCallback_c();
}
void openDetail(long userID, DETAILCALLBACK f)
{
    detailCallback_c = f;

}

//ï¿½Õ²Ø£ï¿½collect
COLLECTCALLBACK collectCallback_c;
void collectCallback(int ret)
{
    collectCallback_c();
}
void openCollect(long userID, COLLECTCALLBACK f)
{
    collectCallback_c = f;

}

//ï¿½ï¿½ï¿½Ñ¶ï¿½Ì¬
FRIENDTRENDCALLBACK friendTrendCallback_c;
void friendTrendCallback(int ret)
{
    friendTrendCallback_c();
}
void openFriendTrend(long userID, FRIENDTRENDCALLBACK f)
{
    friendTrendCallback_c = f;
    //Ò»ï¿½Â²ï¿½ï¿½ï¿½ï¿½ï¿½Ñ¶ï¿½Ì¬ï¿½Ä¿ï¿½ï¿½ï¿½ï¿½ï¿½

}

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä£ï¿½usercenter  ï¿½ò¿ª»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ï½ï¿½ï¿½ï¿½
USERCENTERCALLBACK userCenterCallback_c;
void usercenterCallback(int ret)
{

}
void openUsercenter(long userID, std::string name ,std::string intro,std::string zone ,std::string thumblink,std::string imglink, USERCENTERCALLBACK f)
{

}

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½speak, ï¿½ï¿½ï¿½Øºï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ä»°
SPEAKCALLBACK speakCallback_c;
void speakCallback(int ret)
{

}
void openSpeak(SPEAKCALLBACK f)
{
    speakCallback_c = f;

}

<<<<<<< HEAD
//Ë¢ÐÂÓÃ»§ÖÐÐÄ£¬µ±oc½çÃæÐèÒª´ò¿ª£¨²»ÊÇ·µ»Ø£©luaÖÐµÄÐ¡µºÖ÷½çÃæÊ±£¬µ÷ÓÃ
=======
//Ë¢ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½Ä£ï¿½ï¿½ï¿½ocï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Òªï¿½ò¿ª£ï¿½ï¿½ï¿½ï¿½Ç·ï¿½ï¿½Ø£ï¿½luaï¿½Ðµï¿½Ð¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ê±ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
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
//    //ctrolï¿½ï¿½ï¿½ï¿½ï¿½ï¿½UITabBarController
//    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    //ï¿½Ð»ï¿½ï¿½Ú¶ï¿½ï¿½ï¿½Í¼
//    [ctrol setSelectedIndex:1];

    //ctrolï¿½ï¿½ï¿½ï¿½ï¿½ï¿½IIViewDeckController
//    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //ï¿½Ð»ï¿½ï¿½Ú¶ï¿½ï¿½ï¿½Í¼
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
<<<<<<< HEAD
	return "";
}

//µ±³¡¾°½Å±¾ÖÐ³¡¾°¼ÓÔØÍê±Ïºó£¬Í¨ÖªÔ­Éú´úÂë
=======
    return "citystate";
}

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Å±ï¿½ï¿½Ð³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ïºï¿½Í¨ÖªÔ­ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
void sceneLoadOver(std::string name)
{

}

<<<<<<< HEAD
//Ë¢ÐÂÐ¡µºÊý¾Ý
REFRESHUSERHOMECALLBACK refreshUserHomeCallback_c;
void refreshUserHomeCallback_1(long userID)    //¼Ó_1ÊÇÎªÁË±ÜÃâÖØÃû
{
//    InfoLog(@"Ë¢ÐÂ¸öÈËÖÐÐÄ");
=======
//Ë¢ï¿½ï¿½Ð¡ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
REFRESHUSERHOMECALLBACK refreshUserHomeCallback_c;
void refreshUserHomeCallback_1(long userID)    //ï¿½ï¿½_1ï¿½ï¿½Îªï¿½Ë±ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
{
//    InfoLog(@"Ë¢ï¿½Â¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½");
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
    if (refreshUserHomeCallback_c) {
        refreshUserHomeCallback_c(userID);
    }
}
void refreshUserHome(REFRESHUSERHOMECALLBACK f)
{
    refreshUserHomeCallback_c = f;
//    [BaseUIViewController setRefreshUserHome:refreshUserHomeCallback_1];
}

MAPCALLBACK mapCallback_c;
void mapCallback(int categoryType, std::string categoryID)
{
//    if (categoryID == nil) {
//        categoryID = "";
//    }
//    InfoLog(@"");
    if(mapCallback_c)
    {
//        mapCallback_c(categoryType, [categoryID UTF8String]);
    }
}
void openMap(MAPCALLBACK f)
{
//    InfoLog(@"");
    mapCallback_c = f;
//    [BaseUIViewController setToMapCallback : mapCallback];
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

<<<<<<< HEAD
//¹Ø±Õ¾°µã½éÉÜºóÐèÒªµ÷ÓÃÏÂÃæµÄ»Øµ÷º¯Êý
SIGHTINTROCALLBACK sightIntroCallback_c;
void sightIntroCallback(int)   //´ò¿ª¾°µã½éÉÜºóµÄ»Øµ÷º¯Êý
=======
//ï¿½Ø±Õ¾ï¿½ï¿½ï¿½ï¿½ï¿½Üºï¿½ï¿½ï¿½Òªï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä»Øµï¿½ï¿½ï¿½ï¿½ï¿½
SIGHTINTROCALLBACK sightIntroCallback_c;
void sightIntroCallback(int)   //ï¿½ò¿ª¾ï¿½ï¿½ï¿½ï¿½ï¿½Üºï¿½Ä»Øµï¿½ï¿½ï¿½ï¿½ï¿½
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
{
    if(sightIntroCallback_c)
    {
        sightIntroCallback_c();
    }
}

<<<<<<< HEAD
//´ò¿ª¾°µã½éÉÜ
//sightID£º¾°µãid
//sightName£º¾°µãÃû³Æ
//sightDescs£º¾°µãËù°üº¬µÄËùÓÐÊý¾Ý
=======
//ï¿½ò¿ª¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
//sightIDï¿½ï¿½ï¿½ï¿½ï¿½ï¿½id
//sightNameï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
//sightDescsï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
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

<<<<<<< HEAD
    //sightDescs  ÊÇ¾°µãµÄ½éÉÜµÄÃèÊö£¬json×Ö·û´®,ÈçÏÂ£º
    //"[{\"content\":\"4ÔÂ-10ÔÂ\",\"descid\":1},{\"content\":\"µ­¼¾(12-3ÔÂ):07:00-21:30\\r\\nÍú¼¾(4-11ÔÂ):06:30-21:30\",\"descid\":2},{\"content\":\"1-2Ð¡Ê±\",\"descid\":3},{\"content\":\"Ïó±ÇÉ½¡¢Ë®ÔÂ¶´¡¢ÆÕÏÍËþ¡¢ÏóÑÛÑÒ\",\"descid\":4},{\"content\":\"É½ÏñÒ»Í·Õ¾ÔÚ½­±ßÉì±ÇºÀÒûÀì½­¸ÊÈªµÄ¾ÞÏó\",\"descid\":5},{\"content\":\"¹ðÁÖÊÐ³Ç»Õ£¬¹ðÁÖÉ½Ë®µÄÏóÕ÷\",\"descid\":6},{\"content\":\"75Ôª\\/ÈË\",\"descid\":7}]"
    //content:½éÉÜµÄÄÚÈÝ£¬descid:Îª½éÉÜµÄ±êÊ¾£¬¸Ã±êÊ¾¶ÔÓ¦Í¼±êºÍ±êÌâ£¬±êÌâÈçÏÂ£º1 = "×îÃÀ¼¾½Ú", 2 = "¿ª·ÅÊ±¼ä", 3 = "ÓÎÀÀÊ±¼ä", 4 = "Ö÷Òª¿´µã", 5 = "´ó¼ÒÓ¡Ïó", 6 = "ÍÆ¼öÀíÓÉ", 7 = "ÃÅÆ±¼Û¸ñ", 8 = "ÓÎÀÀTips", 9 = "½»Í¨ÏßÂ·"
}

//¹Ø±ÕÆ¬ÇøÐÅÏ¢ºóÐèÒªµ÷ÓÃÏÂÃæµÄ»Øµ÷º¯Êý
=======
    //sightDescs  ï¿½Ç¾ï¿½ï¿½ï¿½Ä½ï¿½ï¿½Üµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½jsonï¿½Ö·ï¿½ï¿½ï¿½,ï¿½ï¿½ï¿½Â£ï¿½
    //"[{\"content\":\"4ï¿½ï¿½-10ï¿½ï¿½\",\"descid\":1},{\"content\":\"ï¿½ï¿½ï¿½ï¿½(12-3ï¿½ï¿½):07:00-21:30\\r\\nï¿½ï¿½ï¿½ï¿½(4-11ï¿½ï¿½):06:30-21:30\",\"descid\":2},{\"content\":\"1-2Ð¡Ê±\",\"descid\":3},{\"content\":\"ï¿½ï¿½ï¿½É½ï¿½ï¿½Ë®ï¿½Â¶ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½\",\"descid\":4},{\"content\":\"É½ï¿½ï¿½Ò»Í·Õ¾ï¿½Ú½ï¿½ï¿½ï¿½ï¿½ï¿½Çºï¿½ï¿½ï¿½ï¿½ì½­ï¿½ï¿½Èªï¿½Ä¾ï¿½ï¿½ï¿½\",\"descid\":5},{\"content\":\"ï¿½ï¿½ï¿½ï¿½ï¿½Ð³Ç»Õ£ï¿½ï¿½ï¿½ï¿½ï¿½É½Ë®ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½\",\"descid\":6},{\"content\":\"75Ôª\\/ï¿½ï¿½\",\"descid\":7}]"
    //content:ï¿½ï¿½ï¿½Üµï¿½ï¿½ï¿½ï¿½Ý£ï¿½descid:Îªï¿½ï¿½ï¿½ÜµÄ±ï¿½Ê¾ï¿½ï¿½ï¿½Ã±ï¿½Ê¾ï¿½ï¿½Ó¦Í¼ï¿½ï¿½Í±ï¿½ï¿½â£¬ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Â£ï¿½1 = "ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½", 2 = "ï¿½ï¿½ï¿½ï¿½Ê±ï¿½ï¿½", 3 = "ï¿½ï¿½ï¿½ï¿½Ê±ï¿½ï¿½", 4 = "ï¿½ï¿½Òªï¿½ï¿½ï¿½ï¿½", 5 = "ï¿½ï¿½ï¿½Ó¡ï¿½ï¿½", 6 = "ï¿½Æ¼ï¿½ï¿½ï¿½ï¿½ï¿½", 7 = "ï¿½ï¿½Æ±ï¿½Û¸ï¿½", 8 = "ï¿½ï¿½ï¿½ï¿½Tips", 9 = "ï¿½ï¿½Í¨ï¿½ï¿½Â·"
}

//ï¿½Ø±ï¿½Æ¬ï¿½ï¿½ï¿½ï¿½Ï¢ï¿½ï¿½ï¿½ï¿½Òªï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä»Øµï¿½ï¿½ï¿½ï¿½ï¿½
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
CATEGORYCALLBACK categoryCallback_c;
void categoryCallback(int)
{
    if(categoryCallback_c)
    {
        categoryCallback_c();
    }
}

<<<<<<< HEAD
//´ò¿ªÖ¸Êý/Æ¬ÇøÖ¸ÊýÉ¸Ñ¡
//sightID£ºÆ¬Çøid
//categoryID£ºÑ¡ÔñµÄÖ¸Êýid
=======
//ï¿½ï¿½Ö¸ï¿½ï¿½/Æ¬ï¿½ï¿½Ö¸ï¿½ï¿½É¸Ñ¡
//sightIDï¿½ï¿½Æ¬ï¿½ï¿½id
//categoryIDï¿½ï¿½Ñ¡ï¿½ï¿½ï¿½Ö¸ï¿½ï¿½id
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
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

<<<<<<< HEAD
//µ±½Å±¾ÓÉºÃÓÑÓÃ»§ÖÐÐÄÖ±½Ó·µ»Øµ½×Ô¼ºµÄÓÃ»§ÖÐÐÄÊ±½«µ÷ÓÃ´Ëº¯ÊýÍ¨ÖªÔ­Éú³ÌÐò,
//µ±Ô­Éú³ÌÐò²Ù×÷Íê±Ïºó£¬µ÷ÓÃ»Øµ÷
=======
//ï¿½ï¿½ï¿½Å±ï¿½ï¿½Éºï¿½ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Ö±ï¿½Ó·ï¿½ï¿½Øµï¿½ï¿½Ô¼ï¿½ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½Ê±ï¿½ï¿½ï¿½ï¿½ï¿½Ã´Ëºï¿½ï¿½ï¿½Í¨ÖªÔ­ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½,
//ï¿½ï¿½Ô­ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ïºó£¬µï¿½ï¿½Ã»Øµï¿½
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
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
<<<<<<< HEAD
//    NSLog(@"½Å±¾ÖÐÖ±½Óµ÷ÓÃÁË»Øµ½×Ô¼ºµÄ¸öÈËÖÐÐÄ£¬Ô­Éú³ÌÐò´¦ÀíÍê±Ïºó£¬µ÷ÓÃonMainPageCallback");
=======
//    NSLog(@"ï¿½Å±ï¿½ï¿½ï¿½Ö±ï¿½Óµï¿½ï¿½ï¿½ï¿½Ë»Øµï¿½ï¿½Ô¼ï¿½ï¿½Ä¸ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä£ï¿½Ô­ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ïºó£¬µï¿½ï¿½ï¿½onMainPageCallback");
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
    onMainPageCallback_c = f;
//    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
//    if (sVC.navigationController) {
//        [sVC.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [sVC dismissViewControllerAnimated:YES completion:nil];
//    }
}

<<<<<<< HEAD
//ÓÃ»§µã»÷ÁËÈÈÆøÇò£¬hotball
=======
//ï¿½Ã»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½hotball
>>>>>>> 812f904c987edf514271a796933f1527d2b1340c
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
