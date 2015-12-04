//
//  StorePayMoneyViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GoodsOrder.h"
#import "OrderIntro.h"
#import "AppController+pay.h"
#import "AppController+WXLogin+Pay.h"

@interface StorePayMoneyViewController : BaseViewController
@property (nonatomic, strong) GoodsOrder * goodsOrder;
@property (nonatomic, assign) long long orderid;
@end
