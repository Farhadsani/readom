//
//  SubmitOrderView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/16.
//
//

#import <UIKit/UIKit.h>
#import "GoodsOrder.h"

@class SubmitOrderView;

@protocol SubmitOrderViewDelegate <NSObject>
- (void)submitOrderView:(SubmitOrderView *)view goPayBtnDidOnClick:(UIButton *)button;
- (void)submitOrderView:(SubmitOrderView *)view bindPhoneBtnDidOnClick:(UIButton *)button;
@end

@interface SubmitOrderView : UIView
+ (instancetype)submitOrderView;
@property (nonatomic, weak) id<SubmitOrderViewDelegate> delegate;
@property (nonatomic, strong) GoodsOrder *goodsOrder;
@end
