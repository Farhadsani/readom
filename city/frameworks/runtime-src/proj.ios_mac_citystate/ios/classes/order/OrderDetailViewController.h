//
//  OrderDetailViewController.h
//  citystate
//
//  Created by hf on 15/10/15.
//
//

/**
 *  订单详情
 */

#import "BaseViewController.h"
#import "OrderIntro.h"
#import "RatingView.h"
#import "OrderCommentViewController.h"
#import "StoreSimpleCell.h"

@protocol OrderDetailVCDelegate;
@interface OrderDetailViewController : BaseViewController <OrderCommentVCDelegate, StoreSimpleCellDelegate>

@property (nonatomic, retain) OrderIntro * orderIntro;
@property (nonatomic, assign) id<OrderDetailVCDelegate> delegate;

@end

#pragma mark -
#pragma mark OrderDetailVCDelegate

@protocol OrderDetailVCDelegate <NSObject>

@optional
- (void)OrderDetailViewController:(OrderDetailViewController *)vc data:(OrderIntro*)orderIntro;

@end