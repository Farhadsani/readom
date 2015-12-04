//
//  StoreBindNewPhoneNumberViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import "BaseViewController.h"
#import "GoodsOrder.h"

typedef void (^BackBlk)(NSString *phone);

@interface StoreBindNewPhoneNumberViewController : BaseViewController
@property (nonatomic, strong) GoodsOrder *goodsOrder;
@property (nonatomic, copy) BackBlk backBlk;
@end