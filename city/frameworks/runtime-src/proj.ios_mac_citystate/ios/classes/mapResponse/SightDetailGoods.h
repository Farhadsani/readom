//
//  SightDetailGoods.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/21.
//
//

#import <Foundation/Foundation.h>
#import "StoreIntro.h"

@interface SightDetailGoods : NSObject
//@property (nonatomic, assign) long userid;
//@property (nonatomic, assign) Boolean liked;
@property (nonatomic, assign) long goodsid;
//@property (nonatomic, copy) NSString *storename;
@property (nonatomic, copy) NSString *name;         //特卖卷的名称
@property (nonatomic, copy) NSString *price;        //当前价格
@property (nonatomic, copy) NSString *oprice;       //原价
//@property (nonatomic, copy) NSString *rate;
//@property (nonatomic, copy) NSString *address;
//@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *imglink;

@property (nonatomic, copy) NSString *enddate;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, copy) NSString *startdate;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, assign) int sold;             //是否已经卖出(0:未卖出   1:已卖出)

@property (nonatomic, strong) StoreIntro *store;

@end
