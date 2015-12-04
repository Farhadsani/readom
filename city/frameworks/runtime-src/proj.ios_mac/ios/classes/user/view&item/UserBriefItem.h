
@interface UserBriefItem : NSObject<NSCopying>
{
}

@property(assign, atomic)long userid;
@property(copy, atomic)NSString *name;
@property(copy, atomic)NSString *zone;
@property(copy, atomic)NSString *intro;
@property(copy, atomic)NSString *imglink;
@property(copy, atomic)NSString *thumblink;
@property(strong, atomic)NSData *thumbdata;

- (id)init:(long)pUserid;

@end
