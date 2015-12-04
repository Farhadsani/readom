//
//  Device.h
//  Device
//
//  Created by hf on 13-4-15.
//  Copyright (c) 2013年 hf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDevice-Hardware.h"

@interface Device : NSObject

//设备指纹(公共报文头上送参数)
+ (NSDictionary *)getUserDeviceInfo;

//手机型号
+ (NSString *)deviceModel;

////手机唯一标识（UDID）
//+ (NSString *)deviceIndentifierUDIDNumber;

//手机唯一标识（UUID）
+ (NSString *)deviceIndentifierUUIDNumber;

//手机系统版本
+ (NSString *)deviceSystemVersion;

//设备名称
+ (NSString *)deviceName;

//手机别名
+ (NSString *)deviceUserName;

//当前应用名称
+ (NSString *)appDisplayName;

//当前应用软件版本
+ (NSString *)appBundleShortVersion;

//当前应用版本号
+ (NSString *)BundleVersion;

//cpu型号
+ (NSString *)DeviceCPUType;

//电池电量
+ (NSString *)DeviceBatteryLevel;

//是否支持蓝牙
+ (NSString *)isSuportBluetooth;

//是否越狱
+ (NSString *)isDeviceJailBreaked;

@end
