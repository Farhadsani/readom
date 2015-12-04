//
//  StoreGoodsCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import <UIKit/UIKit.h>
#import "StoreGoods.h"

#define StoreGoodsCell_ID @"StoreGoodsCell"

#define StoreGoodsCellIconViewHight 60
#define StoreGoodsCellSubViewMargin 8
#define StoreGoodsCellHight (StoreGoodsCellIconViewHight + StoreGoodsCellSubViewMargin * 2)
#define StoreGoodsCellNameLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreGoodsCellPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreGoodsCellOldPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:12]
#define StoreGoodsCellCountLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]

@interface StoreGoodsCell : UITableViewCell
@property (nonatomic, strong) StoreGoods *storeGoods;
+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
