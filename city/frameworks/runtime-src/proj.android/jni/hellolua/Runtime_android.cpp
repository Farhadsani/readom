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
	//�����ゆ�烽����������锋�������ゆ�烽����ゆ��
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

//�����ゆ�烽����ゆ�烽����扮》���
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
	//getStaticMethodInfo�����ゆ�烽�����璁规��Java�����ゆ�锋�������ゆ�烽����ゆ�烽��瑙���ゆ�烽����ゆ�峰�㈤����ゆ�烽����ゆ�烽�������ゆ�烽��杈�锟介����ゆ�烽����ュ��minfo�����ゆ��
	//�����ゆ�烽����ゆ��1�����ゆ��JniMethodInfo
	//�����ゆ�烽����ゆ��2�����ゆ��Java�����ゆ�烽����ゆ�烽��锟�+�����ゆ�烽����ゆ��
	//�����ゆ�烽����ゆ��3�����ゆ��Java�����ゆ�烽����ゆ�烽����ゆ�烽����ゆ��
	//�����ゆ�烽����ゆ��4�����ゆ�烽����ゆ�烽����ゆ�烽����ゆ�烽����ゆ�烽����ゆ�烽����靛����ゆ�烽����ゆ�峰�奸����ゆ�烽����ゆ��

	bool isHave = JniHelper::getStaticMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","getAppActivity","()Lorg/cocos2dx/lua/AppActivity;");
	jobject jobj;//�����ゆ�烽����ゆ�烽��锟�
	if (isHave) {
		//�����ゆ�烽����ゆ�风�￠����ゆ�烽��锟�getInstance�����ゆ�烽����ゆ�烽����ゆ��Test�����ゆ�蜂憨�����ゆ�烽��锟�
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);

		isHave = JniHelper::getMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","openWebview","(Ljava/lang/String;)V");
		if (isHave) {
			//�����ゆ�烽����ゆ��openWebview, �����ゆ�烽����ゆ��1�����ゆ��Test�����ゆ�烽����ゆ��   �����ゆ�烽����ゆ��2�����ゆ�烽����ゆ�烽����ゆ��ID
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

//�����ゆ�烽����ゆ��
TOPICCALLBACK topicCallback_c;
void topicCallback(int)
{
    topicCallback_c();
}
//�����ゆ��topicID涓�0��堕����ゆ�烽����ゆ�烽��璇���������ゆ�烽����ゆ�烽〉�����ゆ�烽����ゆ�烽����ゆ��0��堕����ゆ�烽����ゆ�峰�间负�����ゆ�烽����ゆ�烽��锟�ID�����ゆ�烽����ゆ�烽����ゆ�峰�������ゆ�烽����ゆ�烽����ゆ�烽����ゆ��
void openTopic(long topicID, TOPICCALLBACK f)
{

}

//�����ゆ�烽����ゆ��
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

//�����ゆ�烽�����锛������ゆ�烽����ゆ�烽��缁�纭锋�� �����ゆ��userID�����ゆ�烽����ゆ�烽����ゆ�锋��
SENDMAILCALLBACK sendMailCallback_c;
void sendMailCallback(int ret)
{
    sendMailCallback_c();
}
void openSendmail(long userID, SENDMAILCALLBACK f)
{
    sendMailCallback_c = f;

}

//�����ゆ�烽����ゆ�烽����ゆ�烽��浠�锛�detail
DETAILCALLBACK detailCallback_c;
void detailCallback(int ret)
{

    detailCallback_c();
}
void openDetail(long userID, DETAILCALLBACK f)
{
    detailCallback_c = f;

}

//���绉歌��锝����collect
COLLECTCALLBACK collectCallback_c;
void collectCallback(int ret)
{
    collectCallback_c();
}
void openCollect(long userID, COLLECTCALLBACK f)
{
    collectCallback_c = f;

}

//�����ゆ�烽��绐�璁规�锋��
FRIENDTRENDCALLBACK friendTrendCallback_c;
void friendTrendCallback(int ret)
{
    friendTrendCallback_c();
}
void openFriendTrend(long userID, FRIENDTRENDCALLBACK f)
{
    friendTrendCallback_c = f;
    //涓������拌�ф�烽����ゆ�烽����ゆ�疯��������锟介��渚ュ�℃�烽����ゆ�烽����ゆ��

}

//�����ゆ�烽����ゆ�烽����ゆ�烽��渚ワ�����usercenter  ���娲ュ��浼���烽����ゆ�烽����ゆ�烽��杈���ゆ�烽����ゆ��
USERCENTERCALLBACK userCenterCallback_c;
void usercenterCallback(int ret)
{

}
void openUsercenter(long userID, std::string name ,std::string intro,std::string zone ,std::string thumblink,std::string imglink, USERCENTERCALLBACK f)
{

}

//�����ゆ�烽����ゆ�烽����ゆ��speak, �����ゆ�烽�������存�烽����ゆ�烽����ゆ�烽�����璇�
SPEAKCALLBACK speakCallback_c;
void speakCallback(int ret)
{

}
void openSpeak(SPEAKCALLBACK f)
{
    speakCallback_c = f;

}

//��锋�扮�ㄦ�蜂腑蹇�锛�褰�oc�����㈤��瑕����寮�锛�涓����杩����锛�lua涓����灏�宀�涓荤����㈡�讹��璋����
USERHOMECALLBACK userHomeCallback_c;
void openUserHomeCallback(long userID, string name, string intro, string zone, string thumblink, string imglink)
{
    if(userHomeCallback_c)
    {
    	userHomeCallback_c(userID, name, intro, zone, thumblink, imglink);
    }
}

extern "C"
{
	void Java_org_cocos2dx_lua_AppActivity_openUserHomeCallback(JNIEnv *env, jint categoryType, jstring categoryID)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openUserHomeCallback");
		openUserHomeCallback(0, "name1", "intro", "zone", "thumb", "img");
//		if(mapCallback_c)
//		{
//			LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback into lua...");
//			std::string strID = JniHelper::jstring2string(categoryID);
//			mapCallback_c((int)categoryType, strID);
//		}
	}
}
void openUserHome(USERHOMECALLBACK f)
{
	userHomeCallback_c = f;
}

void goback()
{
//    //ctrol�����ゆ�烽����ゆ�烽����ゆ��UITabBarController
//    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    //������浼���烽�����璁规�烽����ゆ�峰��
//    [ctrol setSelectedIndex:1];

    //ctrol�����ゆ�烽����ゆ�烽����ゆ��IIViewDeckController
//    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //������浼���烽�����璁规�烽����ゆ�峰��
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

//�����ゆ�烽����ゆ�烽����ゆ�烽����������烽�����绛规�烽����ゆ�烽����ゆ�烽����ゆ�烽����ゆ�疯�鹃����点��锟藉�������ゆ�烽����ゆ�烽����ゆ��
void sceneLoadOver(std::string name)
{

}

//��锋�板��宀���版��
REFRESHUSERHOMECALLBACK refreshUserHomeCallback_c;
void refreshUserHomeCallback_1(long userID)    //���_1���涓轰����垮��������
{
//    InfoLog(@"��锋�颁釜浜轰腑蹇�");
    if (refreshUserHomeCallback_c) {
        refreshUserHomeCallback_c(userID);
    }
}
void refreshUserHome(REFRESHUSERHOMECALLBACK f)
{
    refreshUserHomeCallback_c = f;
//    [BaseUIViewController setRefreshUserHome:refreshUserHomeCallback_1];
}

//���寮���板�炬��浣�
MAPCALLBACK mapCallback_c;

void fangdongTest()
{
	LOGD("fangdongtest into lua...");
	if(mapCallback_c)
	{
		LOGD("Java_org_cocos2dx_lua_AppActivity_openmapCallback into lua...");
//		std::string strID = JniHelper::jstring2string(categoryID);
//		mapCallback_c((int)categoryType, strID);
		mapCallback_c( 0, "");
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
	LOGD("娉ㄥ��openMap���������������������");
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

//��抽�������逛��缁�������瑕�璋���ㄤ����㈢�����璋���芥��
SIGHTINTROCALLBACK sightIntroCallback_c;
void sightIntroCallback(int)   //���寮������逛��缁����������璋���芥��
{
    if(sightIntroCallback_c)
    {
        sightIntroCallback_c();
    }
}

//���寮������逛��缁�
//sightID锛�������id
//sightName锛������瑰��绉�
//sightDescs锛������规�������������������版��
void openSightIntro(long sightID, std::string sightName, std::string sightDescs, SIGHTINTROCALLBACK f)
{
	LOGD("openSightIntro.........");
	JniMethodInfo minfo;
		//getStaticMethodInfo

	bool isHave = JniHelper::getStaticMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","getAppActivity","()Lorg/cocos2dx/lua/AppActivity;");
	jobject jobj;//锟斤拷锟斤拷锟�
	if (isHave) {
			//锟斤拷锟斤拷牡锟斤拷锟�getInstance锟斤拷锟斤拷锟斤拷Test锟斤拷亩锟斤拷锟�
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
		LOGD("openSightIntro.........1");
		isHave = JniHelper::getMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","popUp","()V");
		if (isHave) {
			LOGD("openSightIntro.........2");
				//锟斤拷锟斤拷openWebview, 锟斤拷锟斤拷1锟斤拷Test锟斤拷锟斤拷   锟斤拷锟斤拷2锟斤拷锟斤拷锟斤拷ID
//				jstring jst = minfo.env->NewStringUTF(strUrl.c_str());
				minfo.env->CallVoidMethod(jobj, minfo.methodID);
		}
	}
//    SightDetailViewController * vc = [[[SightDetailViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    [vc.data_dict setNonEmptyObject:@(sightID) forKey:k_sightID];
//    [vc.data_dict setNonEmptyObject:[NSString stringWithCString:sightName.c_str() encoding:NSUTF8StringEncoding] forKey:k_sightName];
//    [vc.data_dict setNonEmptyObject:[NSString stringWithCString:sightDescs.c_str() encoding:NSUTF8StringEncoding] forKey:k_sightDescs];
//    sightIntroCallback_c = f;
//    [vc setCocosCallback:sightIntroCallback];
//    CocosMapIndexRootViewController * sVC = (CocosMapIndexRootViewController *)[(AppController *)APPLICATION getVisibleViewController];
//    [sVC showSightDetailView:vc];

    //sightDescs  ��������圭��浠�缁�������杩帮��json瀛�绗�涓�,濡�涓�锛�
    //"[{\"content\":\"4���-10���\",\"descid\":1},{\"content\":\"娣″��(12-3���):07:00-21:30\\r\\n��哄��(4-11���):06:30-21:30\",\"descid\":2},{\"content\":\"1-2灏����\",\"descid\":3},{\"content\":\"璞￠蓟灞便��姘存��娲�������璐ゅ�����璞＄�煎博\",\"descid\":4},{\"content\":\"灞卞��涓�澶寸����ㄦ��杈逛几榧昏豹楗�婕�姹����娉����宸ㄨ薄\",\"descid\":5},{\"content\":\"妗����甯����寰斤��妗����灞辨按���璞″��\",\"descid\":6},{\"content\":\"75���\\/浜�\",\"descid\":7}]"
    //content:浠�缁�������瀹癸��descid:涓轰��缁�������绀猴��璇ユ��绀哄�瑰����炬��������棰�锛����棰�濡�涓�锛�1 = "���缇�瀛ｈ��", 2 = "寮���炬�堕��", 3 = "娓歌����堕��", 4 = "涓昏��������", 5 = "澶у�跺�拌薄", 6 = "��ㄨ��������", 7 = "��ㄧエ浠锋��", 8 = "娓歌��Tips", 9 = "浜ら��绾胯矾"
}

//��抽�������轰俊���������瑕�璋���ㄤ����㈢�����璋���芥��
CATEGORYCALLBACK categoryCallback_c;
void categoryCallback(int)
{
    if(categoryCallback_c)
    {
        categoryCallback_c();
    }
}

//���寮�������/�����烘����扮�����
//sightID锛�������id
//categoryID锛������╃��������id
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

//褰���������卞ソ�����ㄦ�蜂腑蹇���存�ヨ�������拌��宸辩����ㄦ�蜂腑蹇���跺��璋���ㄦ�ゅ�芥�伴����ュ�����绋�搴�,
//褰�������绋�搴����浣�瀹�姣����锛�璋���ㄥ��璋�
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
//    NSLog(@"������涓���存�ヨ����ㄤ�������拌��宸辩��涓�浜轰腑蹇�锛�������绋�搴�澶����瀹�姣����锛�璋����onMainPageCallback");
    onMainPageCallback_c = f;
//    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
//    if (sVC.navigationController) {
//        [sVC.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [sVC dismissViewControllerAnimated:YES completion:nil];
//    }
}

//��ㄦ�风�瑰�讳�����姘����锛�hotball
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
