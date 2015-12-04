//
//  PayMoneyView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import <UIKit/UIKit.h>
#import "GoodsOrder.h"

@class PayMoneyView;

@protocol PayMoneyViewDelegate <NSObject>
- (void)payMoneyView:(PayMoneyView *)view zhifubaoPayBtnDidOnClick:(UIButton *)button;
- (void)payMoneyView:(PayMoneyView *)view weixinPayBtnDidOnClick:(UIButton *)button;
@end

@interface PayMoneyView : UIView
+ (instancetype)payMoneyView;
@property (nonatomic, weak) id<PayMoneyViewDelegate> delegate;
@property (nonatomic, strong) GoodsOrder *goodsOrder;
@end
