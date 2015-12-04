//
//  NetworkProber.h
//  
//
//  Created by wang wen hui on 13-7-17.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NetworkStatusPro{
    NetworkNotReachable,
    NetworkReachableViaWifi,
    NetworkReachableViaCelluar, //gprs, edge, 3g ...
    NetworkReachableViaUnkown,//network is reachable , but unkown it is which type.
}NetworkStatusPro;

typedef enum DataNetworkType{
    DataNetworkTypeNone = 0, //No celluar or Wifi
    DataNetworkType2G,
    DataNetworkType3G,
    DataNetworkType4G,   //4G
    DataNetworkTypeLTE,
    DataNetworkTypeWifi, //wifi
    DataNetworkTypeUnkown,
}DataNetworkType;

@interface NetworkProber : NSObject
//Check if network is available.
+ (BOOL)networkAvailable;

//Get the current network status , including network type such as wifi, 3g ..
+ (NetworkStatusPro)currentNetworkStatusPro;

/**
 Get the current data network type according to the status bar.
 But we don't assure that the data network  is available.
 */
+ (DataNetworkType)dataNetworkTypeFromStatusBar;
@end
