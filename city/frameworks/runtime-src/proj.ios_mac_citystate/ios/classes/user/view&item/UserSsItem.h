
@interface UserSsItem : NSObject<NSCopying>
{
}

@property(assign, atomic)long userid;
@property (copy, atomic) NSString *ssid;
@property (copy, atomic) NSString *ssid_check;
@property (copy, atomic) NSString *ssid_verify;

- (id)init:(long)pUserid;

@end
