//
//  UIDevice+Hardware.m
//  UIDevice+Hardware
//
//  Created by hf on 13-4-15.
//  Copyright (c) 2013年 hf. All rights reserved.
//

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <mach/processor_info.h>
#include <sys/stat.h>

#import "UIDevice-Hardware.h"

@implementation UIDevice (Hardware)
/**
 Platforms
 
 iFPGA ->        ??

 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 4S/GSM), TBD
 iPhone4,2 ->    (iPhone 4S/CDMA), TBD
 iPhone4,3 ->    (iPhone 4S/???)
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD

 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, WiFi)
 iPad3,2   ->    (iPad 3G, GSM)
 iPad3,3   ->    (iPad 3G, CDMA)
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)

 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??

 i386, x86_64 -> iPhone Simulator
*/


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

#pragma mark platform information
- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSUInteger) platformType
{
    NSString *platform = [self platform];
//    InfoLog(@"platform:%@", platform);
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice4SiPhone;
    if ([platform hasPrefix:@"iPhone5"])            return UIDevice5iPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4"])              return UIDevice4GiPad;
    if ([platform hasPrefix:@"iPad Retina"])        return UIDevice1GiPadRetina;
    
    //iPad mini
    if ([platform hasPrefix:@"iPad mini"])          return UIDevice1GiPadMini;

    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice4SiPhone: return IPHONE_4S_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDevice4GiPad : return IPAD_4G_NAMESTRING;
        case UIDevice1GiPadRetina : return IPAD_Retina_NAMESTRING;
        case UIDevice1GiPadMini : return IPAD_mini_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (NSString *)deviceScreenResolution{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_screen_resolution;
        case UIDevice3GiPhone: return IPHONE_3G_screen_resolution;
        case UIDevice3GSiPhone: return IPHONE_3GS_screen_resolution;
        case UIDevice4iPhone: return IPHONE_4_screen_resolution;
        case UIDevice4SiPhone: return IPHONE_4S_screen_resolution;
        case UIDevice5iPhone: return IPHONE_5_screen_resolution;
        case UIDeviceUnknowniPhone: return IOS_iPhone_screen_resolution;
            
        case UIDevice1GiPod: return IPHONE_1G_screen_resolution;
        case UIDevice2GiPod: return IPHONE_3G_screen_resolution;
        case UIDevice3GiPod: return IPHONE_3G_screen_resolution;
        case UIDevice4GiPod: return IPHONE_4_screen_resolution;
        case UIDeviceUnknowniPod: return IOS_iPhone_screen_resolution;
            
        case UIDevice1GiPad : return IPAD_1_screen_resolution;
        case UIDevice2GiPad : return IPAD_2_screen_resolution;
        case UIDevice3GiPad : return IPAD_3_screen_resolution;
        case UIDevice4GiPad : return IPAD_4_screen_resolution;
        case UIDevice1GiPadRetina : return IPAD_Retina_screen_resolution;
        case UIDevice1GiPadMini : return IPAD_mini_screen_resolution;
        case UIDeviceUnknowniPad : return IOS_iPad_screen_resolution;
        default: return IOS_iPhone_screen_resolution;
    }
    return nil;
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

#pragma mark cpu information
- (NSString *) cpuType
{
    switch ([self platformType])
    {
        case UIDevice3GiPhone: return IPHONE_3G_CPUTYPE;
        case UIDevice3GSiPhone: return IPHONE_3GS_CPUTYPE;
        case UIDevice4iPhone: return IPHONE_4_CPUTYPE;
        case UIDevice4SiPhone: return IPHONE_4S_CPUTYPE;
        case UIDevice5iPhone: return IPHONE_5_CPUTYPE;
            
        case UIDevice1GiPad: return IPAD_1_CPUTYPE;
        case UIDevice2GiPad: return IPAD_2_CPUTYPE;
        case UIDevice3GiPad: return IPAD_3_CPUTYPE;
        case UIDevice4GiPad: return IPAD_4_CPUTYPE;
        case UIDevice1GiPadRetina: return IPAD_Retina_CPUTYPE;
            
        case UIDevice1GiPadMini: return IPAD_mini_CPUTYPE;

        case UIDevice4GiPod: return IPOD_4G_CPUTYPE;
        default: return IOS_CPUTYPE_UNKNOWN;
    }
}

- (NSString *) cpuFrequency
{
    switch ([self platformType])
    {
        case UIDevice3GiPhone: return IPHONE_3G_CPUFREQUENCY;
        case UIDevice3GSiPhone: return IPHONE_3GS_CPUFREQUENCY;
        case UIDevice4iPhone: return IPHONE_4_CPUFREQUENCY;
        case UIDevice4SiPhone: return IPHONE_4S_CPUFREQUENCY;
        case UIDevice5iPhone: return IPHONE_5_CPUFREQUENCY;
            
        case UIDevice1GiPad: return IPAD_1_CPUFREQUENCY;
        case UIDevice2GiPad: return IPAD_2_CPUFREQUENCY;
        case UIDevice3GiPad: return IPAD_3_CPUFREQUENCY;
        case UIDevice4GiPad: return IPAD_4_CPUFREQUENCY;
        case UIDevice1GiPadRetina: return IPAD_Retina_CPUFREQUENCY;
            
        case UIDevice1GiPadMini: return IPAD_mini_CPUFREQUENCY;
            
        case UIDevice4GiPod: return IPOD_4G_CPUFREQUENCY;
        default: return IOS_CPUFREQUENCY_UNKNOWN;
    }
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSArray *)cpuUsage
{
    NSMutableArray *usage = [NSMutableArray array];
//    float usage = 0;
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if(_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if(err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        for(unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if(_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            //            InfoLog(@"Core : %u, Usage: %.2f%%", i, _inUse / _total * 100.f);
            float u = _inUse / _total * 100.f;
            [usage addObject:[NSNumber numberWithFloat:u]];
        }
        
        [_cpuUsageLock unlock];
        
        if(_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        
//        _prevCPUInfo = _cpuInfo;
//        _numPrevCPUInfo = _numCPUInfo;
        
        _cpuInfo = nil;
        _numCPUInfo = 0U;
    } else {
        InfoLog(@"Error!");
    }
    [_cpuUsageLock release];
    return usage;
}

#pragma mark memory information
- (NSUInteger) totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

//- (NSUInteger) freeMemoryBytes 
//{
//    mach_port_t           host_port = mach_host_self();
//    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
//    vm_size_t               pagesize;
//    vm_statistics_data_t     vm_stat;
//    
//    host_page_size(host_port, &pagesize);
//    
//    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) InfoLog(@"Failed to fetch vm statistics");
//    
////    natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
//    natural_t   mem_free = vm_stat.free_count * pagesize;
////    natural_t   mem_total = mem_used + mem_free;
//    
//    return mem_free;
//}

#pragma mark disk information
- (long long) freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

- (long long) totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }    
    return totalspace;
}

- (BOOL) isJailBreak
{
    int res = access("/var/mobile/Library/AddressBook/AddressBook.sqlitedb", F_OK);
    if (res != 0)
        return NO;
    return YES;
}

- (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;  
}

#pragma mark bluetooth information
- (BOOL) bluetoothCheck
{
    switch ([self platformType])
    {
        case UIDevice3GiPhone: return YES;
        case UIDevice3GSiPhone: return YES;
        case UIDevice4iPhone: return YES;
        case UIDevice4SiPhone: return YES;
        case UIDevice5iPhone: return YES;
            
        case UIDevice3GiPod: return YES;
        case UIDevice4GiPod: return YES;
            
        case UIDevice1GiPad : return YES;
        case UIDevice2GiPad : return YES;
        case UIDevice3GiPad : return YES;
        case UIDevice4GiPad : return YES;
        case UIDevice1GiPadRetina : return YES;
        case UIDevice1GiPadMini : return YES;
            
        default: return NO;
    }
}

@end