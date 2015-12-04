#import "NetworkManager.h"
#import "Reachability.h"

@implementation NetworkManager
SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkManager);

-(id)init{
    self = [super init];
    wifiAvailable = NO;
    networkAvailable = NO;
    return self;
}

-(BOOL)hasNetwork
{
    [self netWorkJudge];
    return networkAvailable;
}

-(BOOL)hasWifiNetwork
{
    [self netWorkJudge];
    return wifiAvailable;
}

-(void)netWorkJudge
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        networkAvailable = NO;
        wifiAvailable = NO;
//        Log(@"res : (NONE)");
    }else if (status == ReachableViaWiFi){
        networkAvailable = YES;
        wifiAvailable = YES;
//        Log(@"res : (WIFI)");
    }else if (status == ReachableViaWWAN){
        networkAvailable = YES;
        wifiAvailable = NO;
//        Log(@"res : (2G/3G)");
    }
}
@end
