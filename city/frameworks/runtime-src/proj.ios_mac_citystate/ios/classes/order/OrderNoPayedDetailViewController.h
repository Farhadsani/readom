//
//  OrderNoPayedDetailViewController.h
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

@protocol OrderNoPayedDetailVCDelegate;
@interface OrderNoPayedDetailViewController : BaseViewController <OrderCommentVCDelegate, StoreSimpleCellDelegate>

@property (nonatomic, retain) OrderIntro * orderIntro;
@property (nonatomic, assign) id<OrderNoPayedDetailVCDelegate> delegate;

@end

#pragma mark -
#pragma mark OrderNoPayedDetailVCDelegate

@protocol OrderNoPayedDetailVCDelegate <NSObject>

@optional
- (void)OrderNoPayedDetailViewController:(OrderNoPayedDetailViewController *)vc data:(OrderIntro*)orderIntro;

@end