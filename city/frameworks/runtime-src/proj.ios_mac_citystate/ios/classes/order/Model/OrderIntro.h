//
//  OrderIntro.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <Foundation/Foundation.h>
#import "StoreIntro.h"
#import "StoreGoods.h"

@interface OrderIntro : NSObject

@property (nonatomic, assign) long long orderid;
@property (nonatomic, copy) NSString * imglink;
@property (nonatomic, assign) int count;
@property (nonatomic, copy)  NSString *price;
@property (nonatomic, assign) Boolean refundEnable;        //是否能退款
@property (nonatomic, assign) Boolean commented;
@property (nonatomic, assign) Boolean payed;
@property (nonatomic, copy) NSString * storename;       //商家公司
@property (nonatomic, assign) long storeid;

@property (nonatomic, copy) NSString * goodsid;       //商品id
@property (nonatomic, copy) NSString * goodsname;       //商品名称
@property (nonatomic, copy) NSString * intro;       //商品名称
@property (nonatomic, assign) int goodscount;
@property (nonatomic, copy) NSString * ptime;       //支付时间
@property (nonatomic, copy) NSString * btime;       //下单时间
@property (nonatomic, copy) NSString * dtime;       //过期时间
@property (nonatomic, copy) NSString * utime;       //使用时间
@property (nonatomic, copy) NSString * phone;       //
@property (nonatomic, copy) NSArray * code;       //用户购买的特卖卷个数

@property (nonatomic, copy) NSString * content;       //点评内容
@property (nonatomic, copy) NSString * ctime;       //点评时间
@property (nonatomic, copy) NSArray * pictures;       //点评的图片列表
@property (nonatomic, assign) Boolean expired; // 是否已过期

@property (nonatomic, assign) Boolean rated;
@property (nonatomic, copy) NSString * rate;


@end
