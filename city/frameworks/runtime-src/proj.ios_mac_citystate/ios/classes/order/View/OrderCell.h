//
//  OrderCelll.h
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import <UIKit/UIKit.h>
#import "OrderIntro.h"

#define k_order_cell_height 135

@protocol OrderCellDelegate;

@interface OrderCell : UITableViewCell

@property (nonatomic, retain) OrderIntro * orderIntro;
@property (nonatomic, strong) id<OrderCellDelegate> delegate;

+ (instancetype)cellForTableView:(UITableView *)tableView;

- (void)setupCell;

@end


#pragma mark -
#pragma mark OrderCellDelegate

@protocol OrderCellDelegate <NSObject>

@optional
- (void)didClickComment:(OrderCell *)cell;
- (void)didClickPay:(OrderCell *)cell;

@end
