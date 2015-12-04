//
//  Cache.h
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_User_Info @"UserInfo"

#define k_login_status @"loginStatus"
typedef enum LoginStatus{
    S_UnRegister = 0,       //未激活账户（需要验证码激活）
    S_Login_Out,            //激活后，已退出登录（需要重新登录：手机号+验证码 or 手机号+密码）
    S_Login_Failed,         //登录失败（请求后台登录接口）
    S_Login_Success,        //登录成功
    S_Login_unknowError     //未知错误
}LoginStatus;

@interface Cache : NSObject

@property(nonatomic,retain) NSMutableDictionary * user_dict;//用户信息缓存

@property(nonatomic,retain) NSMutableDictionary * pics_dict;//图片缓存

@property(nonatomic,retain) NSMutableDictionary * cache_dict;//其它缓存

+ (Cache *)shared;

- (void)saveLoginData:(NSDictionary *)inf status:(LoginStatus)status;
- (void)saveUserCacheToUserDefaults;

- (LoginStatus)getLoginStatus;


#pragma mark - 保存通知消息

typedef enum PlistType{
    Plist_notifyOrder = 0,
    Plist_notifyMessage,
}PlistType;

- (NSArray *)getNotifyListPlistType:(PlistType)type;
- (NSDictionary *)getNotifyInf:(NSDictionary *)inf plistType:(PlistType)type;

- (void)saveNotifys:(NSArray *)list handle:(BOOL)isReplaced plistType:(PlistType)type;
- (void)saveNotify:(NSDictionary *)notifyInf handle:(BOOL)isReplaced plistType:(PlistType)type;

- (void)removeNotify:(NSDictionary *)notifyInf plistType:(PlistType)type;
- (void)removeAllNotifyPlistType:(PlistType)type;


#define k_Refresh_FollowList @"Refresh_FollowList"    //没有值默认不刷新数据，0：不刷新；1：刷新
#define k_Refresh_squareList @"Refresh_SquareList"    //没有值默认不刷新数据，0：不刷新；1：刷新
#define k_Refresh_topicAndNotes @"Refresh_topicAndNotes"    //没有值默认不刷新数据，0：不刷新；1：刷新
#define k_Refresh_collectVC @"Refresh_collectVC"    //没有值默认不刷新数据，0：不刷新；1：刷新

//index: 0:关注
- (BOOL)isNeedRefreshData:(NSInteger)index removeFlag:(BOOL)flag;
- (BOOL)setNeedRefreshData:(NSInteger)index value:(NSInteger)val;


@end
