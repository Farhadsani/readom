//
//  OrdersViewController.h
//  citystate
//
//  Created by hf on 15/10/15.
//
//

/**
 *  我的订单主界面
 */

#import "BaseViewController.h"
#import "OrderCell.h"
#import "OrderCommentViewController.h"

@interface OrdersViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, OrderCellDelegate, OrderCommentVCDelegate>

- (void)OrderCommentViewController:(OrderCommentViewController *)vc data:(OrderIntro*)orderIntro;

@end

