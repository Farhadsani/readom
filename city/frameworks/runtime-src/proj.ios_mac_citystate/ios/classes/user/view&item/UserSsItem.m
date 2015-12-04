#import "UserSsItem.h"

@implementation UserSsItem

//@synthesize userid, ssid, ssid_check, ssid_verify;

- (id)init:(long)pUserid {
    self = [super init];
    if (self) {
        _userid = pUserid;
        _ssid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        _ssid_check = @"";
        _ssid_verify = @"";
        if (_userid != 0 ){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            _ssid_check = [defaults stringForKey:@"SHITOUREN_UD_SSID_CHECK"];
            _ssid_verify = [defaults stringForKey:@"SHITOUREN_UD_SSID_VERIFY"];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UserSsItem *copy = [[[self class] allocWithZone: zone] init];
    copy.userid = self.userid;
    copy.ssid = self.ssid;
    copy.ssid_check = self.ssid_check;
    copy.ssid_verify = self.ssid_verify;
    return copy;
}

@end
