
@interface UserBaseItem : NSObject<NSCopying>
{
}

@property(assign, atomic)long userid;
@property(copy, atomic)NSString *phone;//用户绑定的手机号(普通用户和商家用户通用)
@property(copy, atomic)NSString *passwd;

- (id)init:(long)pUserid;

@end
