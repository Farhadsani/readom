//
//  NetworkProber.m
//  
//
//  Created by wang wen hui on 13-7-17.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import "NetworkProber.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

enum  {
    NoWifiOrCelluar  = 0, //No wifi or cellluar
    JD2GIndex          = 1, //2G
    JD3GIndex          = 2, //3G
    JD4GIndex          = 3, //4G
    LTEIndex         = 4, //LTE
    WifiIndex        = 5, //WIFI
};
    
NSString * const kTryConnectHostName = @"www.baidu.cn";//TODO:the url will be replaced by the bank url.
NSString * const kStatusBar = @"statusBar";
NSString * const kForegroundView = @"foregroundView";
NSString * const kUIStatusBarDataNetworkItemView = @"UIStatusBarDataNetworkItemView";
NSString * const kDataNetworkType = @"dataNetworkType";

Boolean NetworkReachabilityGetFlags(SCNetworkReachabilityFlags *flags)
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [kTryConnectHostName UTF8String]);
    
    if (reachability == NULL) {
        Warning(@"Failed to create Network reachability.");
        return false;
    }
    
    if (!SCNetworkReachabilityGetFlags(reachability, flags)){
        Warning(@"Network reachability failed to get flag.");
        return false;
    }
    
    return true;
}

@implementation NetworkProber

+ (BOOL)networkAvailable
{
    BOOL available = NO;
    SCNetworkReachabilityFlags flags;
    
    if (NetworkReachabilityGetFlags(&flags)){
        if ((flags & kSCNetworkReachabilityFlagsReachable) != 0) {
            available = YES;
        }
    }

    return available;
}

+ (NetworkStatusPro)currentNetworkStatusPro
{    
    SCNetworkReachabilityFlags flags;
    
    if (!NetworkReachabilityGetFlags(&flags)){
        return NetworkNotReachable;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0){
        Warning(@"Network not reachable.");
        return NetworkNotReachable;
        
    }
    
    NetworkStatusPro retVal = NetworkReachableViaUnkown;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = NetworkReachableViaWifi;
	}
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)){
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
            // ... and no [user] intervention is needed
            retVal = NetworkReachableViaWifi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
        if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
            
            retVal = NetworkReachableViaCelluar;
            
        }
        
    }
    
    return retVal;
}

+ (DataNetworkType)dataNetworkTypeFromStatusBar
{
    UIApplication *app1 = [UIApplication sharedApplication];
    NSArray *subviews = [[[app1 valueForKey:kStatusBar] valueForKey:kForegroundView] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(kUIStatusBarDataNetworkItemView) class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    DataNetworkType networkType = DataNetworkTypeUnkown;
    NSNumber * typeNum = [dataNetworkItemView valueForKey:kDataNetworkType];
    if (nil == typeNum) {
        return networkType;
    }
    
    NSInteger type = [typeNum integerValue];
    if (type >= 0) {
        switch (type) {
            case 0:
                networkType = DataNetworkTypeNone;

                break;
            case 1:
                networkType = DataNetworkType2G;

                break;
            case 2:
                networkType = DataNetworkType3G;

                break;
            case 3:
                networkType = DataNetworkType4G;

                break;
            case 4:
                networkType = DataNetworkTypeLTE;

                break;
            case 5:
                networkType = DataNetworkTypeWifi;
                
                break;
            default:
                networkType = DataNetworkTypeUnkown;

                break;
        }
    }else{
        networkType = DataNetworkTypeUnkown;
    }
    
    return networkType;
}
@end
