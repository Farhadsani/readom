
@interface NetworkManager : NSObject
{
    BOOL networkAvailable;
    BOOL wifiAvailable;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NetworkManager);

-(BOOL)hasNetwork;
-(BOOL)hasWifiNetwork;

@end
