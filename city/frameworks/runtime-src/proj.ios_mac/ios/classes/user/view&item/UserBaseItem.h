
@interface UserBaseItem : NSObject<NSCopying>
{
}

@property(assign, atomic)long userid;
@property(copy, atomic)NSString *phone;
@property(copy, atomic)NSString *passwd;

- (id)init:(long)pUserid;

@end
