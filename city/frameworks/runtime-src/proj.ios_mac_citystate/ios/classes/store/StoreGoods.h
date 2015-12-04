//
//  StoreGoods.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <Foundation/Foundation.h>

@interface StoreGoods : NSObject
@property (nonatomic, assign) long goodsid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *oprice;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) int sold;
@property (nonatomic, copy) NSString *imglink;
@end
