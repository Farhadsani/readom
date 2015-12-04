//
//  MyStoreGoodsCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/29.
//
//

#import "SWTableViewCell.h"
#import "StoreGoodsDetail.h"

#define MyStoreGoodsCell_ID @"MyStoreGoodsCell"

#define MyStoreGoodsCellIconViewHight 60
#define MyStoreGoodsCellSubViewMargin 8
#define MyStoreGoodsCellHight (MyStoreGoodsCellIconViewHight + MyStoreGoodsCellSubViewMargin * 2)
#define MyStoreGoodsCellNameLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define MyStoreGoodsCellPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define MyStoreGoodsCellOldPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:12]
#define MyStoreGoodsCellCountLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]

@interface MyStoreGoodsCell : SWTableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@end
