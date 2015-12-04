//
//  StoreIntro.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <Foundation/Foundation.h>
#import "StoreGoods.h"
#import "StoreComment.h"

@interface StoreIntro : NSObject
@property (nonatomic, assign) long userid;
@property (nonatomic, copy) NSString *name;         //店铺名称
@property (nonatomic, copy) NSString *storename;    //该字段废除，以上面的name为准
@property (nonatomic, copy) NSString *rate;         //评分数
@property (nonatomic, assign) Boolean liked;
@property (nonatomic, assign) int imgcount;
@property (nonatomic, strong) NSArray *imglink;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *telephone;    //商家的联系方式
@property (nonatomic, copy) NSString *phone;        //用户登录绑定的手机号
@property (nonatomic, assign) int goodscount;
@property (nonatomic, strong) NSArray *goods;
@property (nonatomic, assign) int commentscount;
@end
