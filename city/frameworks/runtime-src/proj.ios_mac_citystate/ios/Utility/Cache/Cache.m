//
//  Cache.m
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import "Cache.h"

static Cache * st_cache = nil;

@implementation Cache
@synthesize user_dict = _user_dict;
@synthesize pics_dict = _pics_dict;
@synthesize cache_dict = _cache_dict;

+ (Cache *)shared{
    if (st_cache == nil) {
        st_cache = [[Cache alloc] init];
        [st_cache variableInit];
    }
    return st_cache;
}

- (void)variableInit{
    if (!_user_dict) {
        _user_dict = [[NSMutableDictionary alloc] init];
    }
    if (!_pics_dict) {
        _pics_dict = [[NSMutableDictionary alloc] init];
    }
    if (!_cache_dict) {
        _cache_dict = [[NSMutableDictionary alloc] init];
    }
    
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:k_User_Info];
    if (!userInfo || ![userInfo objectForKey:k_login_status]) {
        [_user_dict setObject:str(S_UnRegister) forKey:k_login_status];
    }
    else{
        [_user_dict setNonEmptyValuesForKeysWithDictionary:userInfo];
    }
    
    InfoLog(@"UserInfo:%@", _user_dict);
}


- (LoginStatus)getLoginStatus{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:k_User_Info];
    if (!userInfo || ![userInfo objectForKey:k_login_status]) {
        return S_UnRegister;
    }
    else if (userInfo && [userInfo objectForKey:k_login_status]) {
        return (LoginStatus)[[userInfo objectForKey:k_login_status] integerValue];
    }
    else{
        return S_Login_Failed;
    }
}
//18600405293
//470315
- (void)saveLoginData:(NSDictionary *)userInf status:(LoginStatus)status{
    switch (status) {
        case S_UnRegister:{
            [_user_dict setObject:str(S_UnRegister) forKey:k_login_status];
        }
            break;
        case S_Login_Success:{
            [_user_dict setObject:str(S_Login_Success) forKey:k_login_status];
            
            if (userInf) {
                [_user_dict setNonEmptyValuesForKeysWithDictionary:userInf];
                [self saveUserCacheToUserDefaults];
            }
        }
            break;
        case S_Login_Out:{
            [_user_dict setObject:str(S_Login_Out) forKey:k_login_status];
            [self saveUserCacheToUserDefaults];
        }
            break;
        default:{
            [_user_dict setObject:str(S_Login_Failed) forKey:k_login_status];
            [self saveUserCacheToUserDefaults];
        }
            break;
    }
    InfoLog(@"UserInfo:%@", _user_dict);
}

- (void)saveUserCacheToUserDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:_user_dict forKey:k_User_Info];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 保存通知消息

- (NSString *)getPlistName:(PlistType)type{
    if (type == Plist_notifyOrder) {
        return k_OrdersNotifysPlist;
    }
    else{
        return k_MessagesNotifysPlist;
    }
}

- (NSDictionary *)getNotifyInf:(NSDictionary *)inf plistType:(PlistType)type{
    if (![NSDictionary isNotEmpty:inf] || type == Plist_notifyMessage) {
        return nil;
    }
    
    NSArray * list = [self getNotifyListPlistType:type];
    if (list) {
        NSString * orderId = [self getNotifyValue:@"orderId" from:inf];
        if (!orderId) {
            return nil;
        }
        for (NSDictionary * tmp in list) {
            NSString * tmpOrderId = [self getNotifyValue:@"orderId" from:tmp];
            if (tmpOrderId && [tmpOrderId isEqualToString:orderId]) {
                return tmp;
            }
        }
    }
    
    return nil;
}

- (NSArray *)getNotifyListPlistType:(PlistType)type{
    NSArray * oldList = [FileManager readPlistFileOfArrayTypeAtDocument:[self getPlistName:type]];
    if ([NSArray isNotEmpty:oldList]) {
        return oldList;
    }
    return nil;
}

- (void)saveNotifys:(NSArray *)list handle:(BOOL)isReplaced plistType:(PlistType)type{
    //更新数据库
    NSArray * oldListTR = [self getNotifyListPlistType:type];
    if (oldListTR) {
        if (isReplaced) {
            [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:(list)?list:[NSArray array]];
        }
        else{
            NSMutableArray * mass = [[NSMutableArray alloc] init];
            [mass addObjectsFromArray:oldListTR];
            if ([NSArray isNotEmpty:list]) {
                [mass addObjectsFromArray:list];
            }
            [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:mass];
            [mass release];
        }
    }
    else{
        [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:(list)?list:[NSArray array]];
    }
}

- (void)saveNotify:(NSDictionary *)notifyInf handle:(BOOL)isReplaced plistType:(PlistType)type{
    if (![NSDictionary isNotEmpty:notifyInf]) {
        return;
    }
    
    NSArray * oldListTR = [self getNotifyListPlistType:type];
    if (oldListTR) {
        if (type == Plist_notifyOrder) {
            NSString * orderId = [self getNotifyValue:@"orderId" from:notifyInf];
            if (!orderId) {
                return;
            }
            
            NSMutableArray * oldList = [[NSMutableArray alloc] initWithArray:oldListTR];
            NSMutableArray * newList = [[NSMutableArray alloc] initWithArray:oldListTR];
            
            BOOL isIn = NO;
            for (NSDictionary * tmp in oldList) {
                NSString * tmpOrderId = [self getNotifyValue:@"orderId" from:tmp];
                if (tmpOrderId && [tmpOrderId isEqualToString:orderId]) {
                    isIn = YES;
                    NSInteger i = [oldList indexOfObject:tmp];
                    if (isReplaced) {
                        [newList replaceObjectAtIndex:i withObject:notifyInf];
                    }
                    else{
                        [newList removeObjectAtIndex:i];
                        [newList insertNonEmptyObject:notifyInf atIndex:0];//放在最前面
                    }
                    break;
                }
            }
            
            if (!isIn) {
                [newList insertNonEmptyObject:notifyInf atIndex:0];//放在最前面
            }
            [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:newList];
            
            [oldList release];
            [newList release];
        }
        else if (type == Plist_notifyMessage){
            NSMutableArray * mass = [[NSMutableArray alloc] init];
            [mass addObjectsFromArray:oldListTR];
            if ([NSDictionary isNotEmpty:notifyInf]) {
                [mass insertObject:notifyInf atIndex:0];
            }
            [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:mass];
            [mass release];
        }
    }
    else{
        NSArray * list = [[NSArray alloc] initWithObjects:notifyInf, nil];
        [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:list];
        [list release];
    }
}

- (void)removeNotify:(NSDictionary *)notifyInf plistType:(PlistType)type{
    if (![NSDictionary isNotEmpty:notifyInf] || type == Plist_notifyMessage) {
        return;
    }
    
    NSArray * oldListTR = [self getNotifyListPlistType:type];
    if (oldListTR) {
        NSString * orderId = [self getNotifyValue:@"orderId" from:notifyInf];
        if (!orderId) {
            return;
        }
        NSMutableArray * oldList = [[NSMutableArray alloc] initWithArray:oldListTR];
        for (NSDictionary * tmp in oldList) {
            NSString * tmpOrderId = [self getNotifyValue:@"orderId" from:tmp];
            if (tmpOrderId && [tmpOrderId isEqualToString:orderId]) {
                NSInteger i = [oldList indexOfObject:tmp];
                NSMutableArray * newList = [[NSMutableArray alloc] initWithArray:oldListTR];
                [newList removeObjectAtIndex:i];
                [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:newList];
                [newList release];
                break;
            }
        }
        
        [oldList release];
    }
}

- (void)removeAllNotifyPlistType:(PlistType)type{
    [FileManager savePlistFileAtDocument:[self getPlistName:type] withArray:[NSArray array]];
}

- (NSString *)getNotifyValue:(NSString *)key from:(NSDictionary *)userInfo{
    if ([NSString isEmptyString:key] || ![NSDictionary isNotEmpty:userInfo]) {
        return nil;
    }
    
    NSString * value = nil;
    
    if ([userInfo objectOutForKey:key]) {
        value = [userInfo objectOutForKey:key];
    }
    
    if (!value) {
        NSDictionary * customContent = [userInfo objectOutForKey:@"customContent"];
        if ([NSDictionary isNotEmpty:customContent] && [customContent objectOutForKey:key]) {
            value = [customContent objectOutForKey:key];
        }
    }
    
    if (!value) {
        NSDictionary * aps = [userInfo objectOutForKey:@"aps"];
        if ([NSDictionary isNotEmpty:aps] && [aps objectOutForKey:key]) {
            value = [aps objectOutForKey:key];
        }
    }
    
    if (!value && [key isEqualToString:@"description"]) {
        value = [self getNotifyValue:@"alert" from:userInfo];
    }
    
    if (!value && [key isEqualToString:@"orderId"]) {
        value = [self getNotifyValue:@"orderID" from:userInfo];
    }
    if (!value && [key isEqualToString:@"orderID"]) {
        value = [self getNotifyValue:@"orderCode" from:userInfo];
    }
    if (!value && [key isEqualToString:@"orderCode"]) {
        value = [self getNotifyValue:@"oId" from:userInfo];
    }
    if (!value && [key isEqualToString:@"oId"]) {
        value = [self getNotifyValue:@"oid" from:userInfo];
    }
    
    return value;
}

//- (NSString *)getOrderIdOfNotify:(NSDictionary *)inf{
//    if (![NSDictionary isNotEmpty:inf]) {
//        return nil;
//    }
//    NSString * tmpId = [self getNotifyValue:@"orderId" from:inf];
//    if (tmpId) {
//    }
//    else{
//        tmpId = [self getNotifyValue:@"orderID" from:inf];
//        if (tmpId) {
//        }
//        else{
//            tmpId = [self getNotifyValue:@"orderCode" from:inf];
//        }
//    }
//    return tmpId;
//}

//- (NSDictionary *)getNotifyInfFromList:(NSArray *)list withOrderId:(NSString *)orderid{
//    if (![NSArray isNotEmpty:list] || [NSString isEmptyString:orderid]) {
//        return nil;
//    }
//    
//    for (NSDictionary * dic in list) {
//        NSString * tmpId = [self getOrderIdOfNotify:dic];
//        if (![NSString isEmptyString:tmpId] && [tmpId isEqualToString:orderid]) {
//            return dic;
//        }
//    }
//    return nil;
//}

//返回刷新标识
//index: 0:关注 1:广场 2:话题 3:个人动态
- (BOOL)isNeedRefreshData:(NSInteger)index removeFlag:(BOOL)flag{
    switch (index) {
        case 0:{
            if ([self.cache_dict objectOutForKey:k_Refresh_FollowList] && [[self.cache_dict objectOutForKey:k_Refresh_FollowList] integerValue] == 1) {
                if (flag) {
                    [self.cache_dict removeObjectForKey:k_Refresh_FollowList];
                }
                return YES;
            }
        }
            break;
        case 1:{
            if ([self.cache_dict objectOutForKey:k_Refresh_squareList] && [[self.cache_dict objectOutForKey:k_Refresh_squareList] integerValue] == 1) {
                if (flag) {
                    [self.cache_dict removeObjectForKey:k_Refresh_squareList];
                }
                return YES;
            }
        }
            break;
        case 2:{
            if ([self.cache_dict objectOutForKey:k_Refresh_topicAndNotes] && [[self.cache_dict objectOutForKey:k_Refresh_topicAndNotes] integerValue] == 1) {
                if (flag) {
                    [self.cache_dict removeObjectForKey:k_Refresh_topicAndNotes];
                }
                return YES;
            }
        }
            break;
        case 3:{
            if ([self.cache_dict objectOutForKey:k_Refresh_collectVC] && [[self.cache_dict objectOutForKey:k_Refresh_collectVC] integerValue] == 1) {
                if (flag) {
                    [self.cache_dict removeObjectForKey:k_Refresh_collectVC];
                }
                return YES;
            }
        }
            break;
            
        default:
            break;
    }
    return NO;
}

//设置刷新标识
//index: 0:关注 1:广场 2:话题 3:个人动态
- (BOOL)setNeedRefreshData:(NSInteger)index value:(NSInteger)val{
    switch (index) {
        case 0:{
            [self.cache_dict setNonEmptyObject:str(val) forKey:k_Refresh_FollowList];
        }
            break;
        case 1:{
            [self.cache_dict setNonEmptyObject:str(val) forKey:k_Refresh_squareList];
        }
            break;
        case 2:{
            [self.cache_dict setNonEmptyObject:str(val) forKey:k_Refresh_topicAndNotes];
        }
            break;
        case 3:{
            [self.cache_dict setNonEmptyObject:str(val) forKey:k_Refresh_collectVC];
        }
            break;
            
        default:
            break;
    }
    return NO;
}

@end
