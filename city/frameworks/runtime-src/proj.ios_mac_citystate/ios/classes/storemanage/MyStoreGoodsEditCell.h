//
//  MyStoreGoodsEditCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/30.
//
//

#import <UIKit/UIKit.h>

@interface MyStoreGoodsEditCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@end
