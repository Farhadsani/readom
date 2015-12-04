//
//  StoreDetailCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import <UIKit/UIKit.h>
#import "StoreIntro.h"

#define StoreDetailCell_ID @"StoreDetailCell"
#define StoreDetailCellPicCountViewFont [UIFont fontWithName:k_fontName_FZZY size:12]
#define StoreDetailCellStoreNameLabelFont [UIFont fontWithName:k_fontName_FZZY size:17]
#define StoreDetailCellStartReateLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]
#define StoreDetailCellAddressLabelFont [UIFont fontWithName:k_fontName_FZZY size:13]

#define StoreDetailCellSubViewMargin 8
#define StoreDetailCellPicViewH ([UIScreen mainScreen].bounds.size.width * 0.5)
#define StoreDetailCellStoreNameLabelH 22
#define StoreDetailCellStartReateH 25
#define StoreDetailCellAddressIconViewH 25
#define StoreDetailCellHight (StoreDetailCellPicViewH + StoreDetailCellStoreNameLabelH + StoreDetailCellStartReateH + StoreDetailCellAddressIconViewH + StoreDetailCellSubViewMargin * 3)

@interface StoreDetailCell : UITableViewCell
@property (nonatomic, strong) StoreIntro *storeIntro;
+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
