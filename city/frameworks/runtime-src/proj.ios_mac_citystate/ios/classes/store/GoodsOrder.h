//
//  GoodsOrder.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/19.
//
//

#import <Foundation/Foundation.h>

@interface GoodsOrder : NSObject
@property (nonatomic, assign) long goodsid;
@property (nonatomic, assign) long storeid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) int count;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *phone;//特卖商品对应的商家所绑定的手机号
@end
