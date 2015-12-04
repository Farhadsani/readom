
@interface UserDetailItem : NSObject<NSCopying>
{
}

@property(assign, atomic)long userid;
@property(copy, atomic)NSString *sex;
@property(copy, atomic)NSString *sexot;
@property(copy, atomic)NSString *love;
@property(copy, atomic)NSString *horo;

- (id)init:(long)pUserid;

@end
