//
//  UIDevice+Hardware.h
//  UIDevice+Hardware
//
//  Created by hf on 13-4-15.
//  Copyright (c) 2013年 hf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS" 
#define IPHONE_4_NAMESTRING             @"iPhone 4" 
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_Retina_NAMESTRING          @"iPad Retina"
#define IPAD_mini_NAMESTRING            @"iPad mini"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator"

//iPhone 3G 以后各代的CPU型号和频率
#define IPHONE_3G_CPUTYPE               @"ARM11"
#define IPHONE_3G_CPUFREQUENCY          @"412MHz"
#define IPHONE_3GS_CPUTYPE              @"ARM Cortex A8"
#define IPHONE_3GS_CPUFREQUENCY         @"600MHz" 
#define IPHONE_4_CPUTYPE                @"Apple A4"
#define IPHONE_4_CPUFREQUENCY           @"1GMHz"
#define IPHONE_4S_CPUTYPE               @"Apple A5 Double Core"
#define IPHONE_4S_CPUFREQUENCY          @"800MHz"
#define IPHONE_5_CPUTYPE                @"Apple A6 Double Core"
#define IPHONE_5_CPUFREQUENCY           @"1GHz"

//iPhone 3G 以后各代的分辨率
#define IPHONE_1G_screen_resolution              @"320*480"
#define IPHONE_3G_screen_resolution              @"320*480"
#define IPHONE_3GS_screen_resolution             @"320*480"
#define IPHONE_4_screen_resolution               @"640*960"
#define IPHONE_4S_screen_resolution              @"640*960"
#define IPHONE_5_screen_resolution               @"640*1136"
#define IOS_iPhone_screen_resolution             @"320*480"

//iPad1 以后各代的分辨率
#define IPAD_1_screen_resolution                @"768*1024"
#define IPAD_2_screen_resolution                @"768*1024"
#define IPAD_3_screen_resolution                @"1536*2048"
#define IPAD_4_screen_resolution                @"1536*2048"
#define IPAD_Retina_screen_resolution           @"1536*2048"
#define IPAD_mini_screen_resolution             @"768*1024"
#define IOS_iPad_screen_resolution              @"768*1024"

//iPad1 以后各代的CPU型号和频率
#define IPAD_1_CPUTYPE                @"Apple A4"
#define IPAD_1_CPUFREQUENCY           @"1GHz"
#define IPAD_2_CPUTYPE                @"Apple A5 Double Core"
#define IPAD_2_CPUFREQUENCY           @"1GHz"
#define IPAD_3_CPUTYPE                @"Apple A5X Double Core"
#define IPAD_3_CPUFREQUENCY           @"1GHz"
#define IPAD_4_CPUTYPE                @"Apple A6 Double Core"
#define IPAD_4_CPUFREQUENCY           @"1.3GHz"
#define IPAD_Retina_CPUTYPE           @"Apple A6X Double Core"
#define IPAD_Retina_CPUFREQUENCY      @"1GHz"

//iPad mini 以后各代的CPU型号和频率
#define IPAD_mini_CPUTYPE                @"Apple A5 Double Core"
#define IPAD_mini_CPUFREQUENCY           @"1GHz"

//iPod touch 4G 的CPU型号和频率
#define IPOD_4G_CPUTYPE                 @"Apple A4"
#define IPOD_4G_CPUFREQUENCY            @"800MHz"

#define IOS_CPUTYPE_UNKNOWN             @"unknown cpu type"
#define IOS_CPUFREQUENCY_UNKNOWN        @"unknown cpu frequency"

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    
    UIDevice1GiPad,
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,
    UIDevice1GiPadRetina,
    
    UIDevice1GiPadMini,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,

} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
    
} UIDeviceFamily;

@interface UIDevice (Hardware)

- (NSString *) platformString;      //平台信息

- (NSString *)deviceScreenResolution;//设备分辨率

- (NSString *) cpuType;             //cpu型号
- (NSString *) cpuFrequency;        //cpu频率
- (NSUInteger) cpuCount;            //cpu核数
- (NSArray *) cpuUsage;             //cpu利用率

- (NSUInteger) totalMemoryBytes;    //获取手机内存总量,返回的是字节数
//- (NSUInteger) freeMemoryBytes;     //获取手机可用内存,返回的是字节数

- (long long) freeDiskSpaceBytes;   //获取手机硬盘空闲空间,返回的是字节数
- (long long) totalDiskSpaceBytes;  //获取手机硬盘总空间,返回的是字节数

- (BOOL) isJailBreak;               //是否越狱
- (BOOL) isJailbroken;              //是否越狱
- (BOOL) bluetoothCheck;            //是否支持蓝牙


@end