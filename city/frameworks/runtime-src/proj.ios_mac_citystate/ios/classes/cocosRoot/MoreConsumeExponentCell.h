//
//  MoreConsumeExponentCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/11/10.
//
//

#import <UIKit/UIKit.h>
#import "ConsumeExponentButton.h"

@class MoreConsumeExponentCell;

@protocol MoreConsumeExponentCellDelegate <NSObject>
- (void)moreConsumeExponentCell:(MoreConsumeExponentCell *)cell btnDidOnClick:(ConsumeExponentButton *)button;
@end

@interface MoreConsumeExponentCell : UITableViewCell
@property (nonatomic, strong) NSArray *consumeExponentItem;
@property (nonatomic, weak) id<MoreConsumeExponentCellDelegate> delegate;
- (CGFloat)cellHeight;
@end
