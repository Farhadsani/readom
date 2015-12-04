//
//  StoreGoodsDetail.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import <Foundation/Foundation.h>

@interface StoreGoodsDetail : NSObject
@property (nonatomic, assign) long userid;
@property (nonatomic, copy) NSString *storename;
@property (nonatomic, assign) int sold;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *notice; // 废弃
@property (nonatomic, assign) long goodsid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *oprice;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *startdate;
@property (nonatomic, copy) NSString *enddate;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, copy) NSString *imglink;
@property (nonatomic, assign) Boolean holidaysvalidate;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *shoper;
@property (nonatomic, assign) int goodscount;
@end
