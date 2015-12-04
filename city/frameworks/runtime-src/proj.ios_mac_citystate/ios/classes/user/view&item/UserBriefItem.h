
@interface UserBriefItem : NSObject<NSCopying>
{
}

@property(assign, atomic)   long            userid;
@property(assign, atomic)   int             role;               //用户角色（0：普通用户；1：商家用户）

@property(copy, atomic)     NSString    *   phone;              //用户绑定的手机号

@property(copy, atomic)     NSString    *   name;               //普通用户的名称(普通用户的小岛昵称) or 商家用户的店铺名称
@property(copy, atomic)     NSString    *   intro;              //普通用户的小岛简介 or 商家用户的店铺介绍
@property(copy, atomic)     NSString    *   imglink;            //普通用户的头像 or 商家用户的头像
@property(copy, atomic)     NSString    *   thumblink;          //普通用户的缩略图头像 or 商家用户的缩略图头像

@property(strong, atomic)   NSData      *   thumbdata;          //普通用户的个人头像 or 商家用户的店铺头像（Logo）

@property(nonatomic)        NSInteger       fans;
@property(nonatomic)        NSInteger       follow;

@property(copy, atomic)     NSString    *   hobby;              //兴趣爱好
@property(copy, atomic)     NSString    *   music;              //喜欢的音乐

//如果是商家用户，则有以下数据，否则没有
@property(copy, atomic)     NSArray     *   photolink;          //商家用户的店铺相册列表
@property(copy, atomic)     NSArray     *   photothumb;         //商家用户的店铺相册列表
@property(copy, atomic)     NSString    *   address;            //商家用户的商家地址
@property(copy, atomic)     NSString    *   telephone;          //商家用户的联系电话
@property(copy, atomic)     NSArray     *   categories;         //商家用户的店铺分类


- (id)init:(long)pUserid;


@end
