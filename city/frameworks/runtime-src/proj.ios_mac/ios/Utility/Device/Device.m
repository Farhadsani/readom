//
//  Device.m
//  Device
//
//  Created by hf on 13-4-15.
//  Copyright (c) 2013年 hf. All rights reserved.
//

#import "Device.h"
#import "UIDevice-Hardware.h"

@implementation Device

//设备指纹(公共报文头上送参数)
+ (NSDictionary *)getUserDeviceInfo{
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc] init];
    
    NSMutableString  * user_agent = [[NSMutableString alloc] init];
    
    /***版本号控制为两位数***/
    NSString * sysVersion2 = [Device deviceSystemVersion];
    if ([sysVersion2 rangeOfString:@"("].location != NSNotFound) {
        sysVersion2 = [sysVersion2 substringToIndex:[sysVersion2 rangeOfString:@"("].location];
    }
    NSMutableString * mSysVersion = [NSMutableString stringWithString:@""];
    NSArray * arr = [sysVersion2 componentsSeparatedByString:@"."];
    if ([arr count] == 1) {
        [mSysVersion appendFormat:@"%@.0",sysVersion2];
    }
    else if ([arr count] >= 2) {
        [mSysVersion appendFormat:@"%@.%@", [arr objectAtExistIndex:0], [arr objectAtExistIndex:1]];
    }
    else{
        [mSysVersion appendFormat:@"0.0"];
    }
    [user_agent appendFormat:@"ios_%@", mSysVersion];
    /***End***/
    
    [user_agent appendFormat:@"/1"];
    
    
    if ([[[UIDevice currentDevice] platformString] rangeOfString:@"iPhone"].location != NSNotFound) {
        [user_agent appendFormat:@"/user_Phone_%@", [Device appBundleShortVersion]];
        [user_agent appendFormat:@"/Phone"];
    }
    else{
        [user_agent appendFormat:@"/user_Pad_%@", [Device appBundleShortVersion]];
        [user_agent appendFormat:@"/Pad"];
    }
    
    [user_agent appendFormat:@"/%@", [[UIDevice currentDevice] deviceScreenResolution]];//分辨率
    
    
    [user_agent setString:[user_agent stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [mDic setObject:user_agent forKey:@"user-agent"];
    [user_agent release];
    
//    NSMutableString  * di = [[NSMutableString alloc] init];
//    [di appendFormat:@"/%@", [[UIDevice currentDevice] cpuType]];
//    [di appendFormat:@"/%@", [Device deviceIndentifierUUIDNumber]];
//    [di appendFormat:@"/%@", [[UIDevice currentDevice] deviceScreenResolution]];//分辨率
//    [di setString:[di stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    [mDic setObject:di forKey:@"di"];
//    [di release];
    
    [mDic setObject:[Device appBundleShortVersion] forKey:@"cv"];
    
    [mDic setObject:[Device deviceIndentifierUUIDNumber] forKey:@"uuid"];
    
    return [mDic autorelease];
}

//手机型号
+ (NSString *)deviceModel{
    InfoLog(@"手机型号:%@",[[UIDevice currentDevice] model]);
    return [[UIDevice currentDevice] model];
}

//手机唯一标识（UDID）
+ (NSString *)deviceIndentifierUDIDNumber{
#ifndef __IPHONE_5_0
    if ([_SYS_VERSION floatValue] != 5.0) {
        InfoLog(@"手机唯一标识（UDID）:%@",[[UIDevice currentDevice] uniqueIdentifier]);
        return [[UIDevice currentDevice] uniqueIdentifier];
    }
#endif
    
    return @"";
}

//手机唯一标识（UUID）
+ (NSString *)deviceIndentifierUUIDNumber{
//    if ([_SYS_VERSION floatValue] >= 6.0) {
//#ifdef __IPHONE_6_0
//        InfoLog(@"手机唯一标识（UUID）:%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
//        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//#endif
//    }
    CFUUIDRef puuid = CFUUIDCreate( nil );
    
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    
    CFRelease(puuid);
    
    CFRelease(uuidString);
    
    return [result autorelease];
}

//手机系统版本
+ (NSString *)deviceSystemVersion{
    InfoLog(@"手机系统版本:%@", k_SYS_VERSION);
    return k_SYS_VERSION;
}

//设备名称
+ (NSString *)deviceName{
    InfoLog(@"设备名称:%@",[[UIDevice currentDevice] systemName]);
    return [[UIDevice currentDevice] systemName];
}

//手机别名
+ (NSString *)deviceUserName{
    InfoLog(@"手机别名:%@", [[UIDevice currentDevice] name]);
    return [[UIDevice currentDevice] name];
}

//当前应用名称
+ (NSString *)appDisplayName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    InfoLog(@"当前应用名称：%@",[infoDictionary objectOutForKey:@"CFBundleDisplayName"]);
    return [infoDictionary objectOutForKey:@"CFBundleDisplayName"];
}

//当前应用软件版本
+ (NSString *)appBundleShortVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    InfoLog(@"当前应用软件版本：%@",[infoDictionary objectOutForKey:@"CFBundleShortVersionString"]);
    return [infoDictionary objectOutForKey:@"CFBundleShortVersionString"];
}

//当前应用版本号
+ (NSString *)BundleVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    InfoLog(@"当前应用版本号：%@",[infoDictionary objectOutForKey:@"CFBundleVersion"]);
    return [infoDictionary objectOutForKey:@"CFBundleVersion"];
}

//地方型号（国际化区域名称）
+ (NSString *)deviceLocalModel{
    InfoLog(@"国际化区域名称:%@",[[UIDevice currentDevice] localizedModel]);
    return [[UIDevice currentDevice] localizedModel];
}

#pragma mark - wifi address

//这是外网可见的ip地址，如果你在小区的局域网中，那就是小区的，不是局域网的内网地址。
+ (NSString *) whatismyipdotcom{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
    return ip ? ip : [error localizedDescription];
}

#define PRIVATE_PATH "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony"

//cpu型号
+ (NSString *)DeviceCPUType{
    InfoLog(@"设备cpu型号:%@",[[UIDevice currentDevice] cpuType]);
    return [[UIDevice currentDevice] cpuType];
}

//电池电量
+ (NSString *)DeviceBatteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    NSString * level = [NSString stringWithFormat:@"%d%%", (int)([[UIDevice currentDevice] batteryLevel] * 100)];
    level = [level stringByReplacingOccurrencesOfString:@"-" withString:@""];
    InfoLog(@"电池电量:%@",level);
    return level;
}

//是否支持蓝牙
+ (NSString *)isSuportBluetooth{
    InfoLog(@"是否支持蓝牙:%@",[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] bluetoothCheck] ? @"YES" : @"NO"]);
    return [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] bluetoothCheck] ? @"YES" : @"NO"];
}

//是否越狱
+ (NSString *)isDeviceJailBreaked{
    InfoLog(@"是否越狱:%@",[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] isJailbroken] ? @"YES" : @"NO"]);
    return [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] isJailbroken] ? @"YES" : @"NO"];
}

@end
