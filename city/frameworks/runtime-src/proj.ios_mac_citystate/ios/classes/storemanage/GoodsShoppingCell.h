//
//  GoodsShoppingCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/11/26.
//
//

#import <UIKit/UIKit.h>
#import "StoreGoodsDetail.h"

@interface GoodsShoppingCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
- (void)setTimelineStr:(NSString *)timelineStr;
@end
