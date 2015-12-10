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
	//���þ�̬����
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

//�����¼�
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
	//getStaticMethodInfo���ж�Java��̬�����Ƿ���ڣ����Ұ���Ϣ���浽minfo��
	//����1��JniMethodInfo
	//����2��Java�����+����
	//����3��Java��������
	//����4�������������ͺͷ���ֵ����

	bool isHave = JniHelper::getStaticMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","getAppActivity","()Lorg/cocos2dx/lua/AppActivity;");
	jobject jobj;//�����
	if (isHave) {
		//����ĵ���getInstance������Test��Ķ���
		jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);

		isHave = JniHelper::getMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","openWebview","(Ljava/lang/String;)V");
		if (isHave) {
			//����openWebview, ����1��Test����   ����2������ID
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

//����
TOPICCALLBACK topicCallback_c;
void topicCallback(int)
{
    topicCallback_c();
}
//��topicIDΪ0ʱ�����뷢����ҳ������0ʱ����ֵΪ�����ID������Ļ��������
void openTopic(long topicID, TOPICCALLBACK f)
{

}

//����
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

//���䣬�����ʼ� ��userID������Ϣ
SENDMAILCALLBACK sendMailCallback_c;
void sendMailCallback(int ret)
{
    sendMailCallback_c();
}
void openSendmail(long userID, SENDMAILCALLBACK f)
{
    sendMailCallback_c = f;

}

//�������飬detail
DETAILCALLBACK detailCallback_c;
void detailCallback(int ret)
{

    detailCallback_c();
}
void openDetail(long userID, DETAILCALLBACK f)
{
    detailCallback_c = f;

}

//�ղأ�collect
COLLECTCALLBACK collectCallback_c;
void collectCallback(int ret)
{
    collectCallback_c();
}
void openCollect(long userID, COLLECTCALLBACK f)
{
    collectCallback_c = f;

}

//���Ѷ�̬
FRIENDTRENDCALLBACK friendTrendCallback_c;
void friendTrendCallback(int ret)
{
    friendTrendCallback_c();
}
void openFriendTrend(long userID, FRIENDTRENDCALLBACK f)
{
    friendTrendCallback_c = f;
    //һ�²�����Ѷ�̬�Ŀ�����

}

//�������ģ�usercenter  �򿪻������Ͻ���
USERCENTERCALLBACK userCenterCallback_c;
void usercenterCallback(int ret)
{

}
void openUsercenter(long userID, std::string name ,std::string intro,std::string zone ,std::string thumblink,std::string imglink, USERCENTERCALLBACK f)
{

}

//������speak, ���غ������仰
SPEAKCALLBACK speakCallback_c;
void speakCallback(int ret)
{

}
void openSpeak(SPEAKCALLBACK f)
{
    speakCallback_c = f;

}

//ˢ���û����ģ���oc������Ҫ�򿪣����Ƿ��أ�lua�е�С��������ʱ������
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
//    //ctrol������UITabBarController
//    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    //�л��ڶ���ͼ
//    [ctrol setSelectedIndex:1];

    //ctrol������IIViewDeckController
//    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //�л��ڶ���ͼ
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

//�������ű��г���������Ϻ�֪ͨԭ������
void sceneLoadOver(std::string name)
{

}

//ˢ��С������
REFRESHUSERHOMECALLBACK refreshUserHomeCallback_c;
void refreshUserHomeCallback_1(long userID)    //��_1��Ϊ�˱�������
{
//    InfoLog(@"ˢ�¸�������");
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

//�رվ�����ܺ���Ҫ��������Ļص�����
SIGHTINTROCALLBACK sightIntroCallback_c;
void sightIntroCallback(int)   //�򿪾�����ܺ�Ļص�����
{
    if(sightIntroCallback_c)
    {
        sightIntroCallback_c();
    }
}

//�򿪾������
//sightID������id
//sightName����������
//sightDescs����������������������
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

    //sightDescs  �Ǿ���Ľ��ܵ�������json�ַ���,���£�
    //"[{\"content\":\"4��-10��\",\"descid\":1},{\"content\":\"����(12-3��):07:00-21:30\\r\\n����(4-11��):06:30-21:30\",\"descid\":2},{\"content\":\"1-2Сʱ\",\"descid\":3},{\"content\":\"���ɽ��ˮ�¶�����������������\",\"descid\":4},{\"content\":\"ɽ��һͷվ�ڽ�����Ǻ����콭��Ȫ�ľ���\",\"descid\":5},{\"content\":\"�����гǻգ�����ɽˮ������\",\"descid\":6},{\"content\":\"75Ԫ\\/��\",\"descid\":7}]"
    //content:���ܵ����ݣ�descid:Ϊ���ܵı�ʾ���ñ�ʾ��Ӧͼ��ͱ��⣬�������£�1 = "��������", 2 = "����ʱ��", 3 = "����ʱ��", 4 = "��Ҫ����", 5 = "���ӡ��", 6 = "�Ƽ�����", 7 = "��Ʊ�۸�", 8 = "����Tips", 9 = "��ͨ��·"
}

//�ر�Ƭ����Ϣ����Ҫ��������Ļص�����
CATEGORYCALLBACK categoryCallback_c;
void categoryCallback(int)
{
    if(categoryCallback_c)
    {
        categoryCallback_c();
    }
}

//��ָ��/Ƭ��ָ��ɸѡ
//sightID��Ƭ��id
//categoryID��ѡ���ָ��id
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

//���ű��ɺ����û�����ֱ�ӷ��ص��Լ����û�����ʱ�����ô˺���֪ͨԭ������,
//��ԭ�����������Ϻ󣬵��ûص�
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
//    NSLog(@"�ű���ֱ�ӵ����˻ص��Լ��ĸ������ģ�ԭ����������Ϻ󣬵���onMainPageCallback");
    onMainPageCallback_c = f;
//    UIViewController * sVC = [(AppController *)APPLICATION getVisibleViewController];
//    if (sVC.navigationController) {
//        [sVC.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [sVC dismissViewControllerAnimated:YES completion:nil];
//    }
}

//�û������������hotball
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
