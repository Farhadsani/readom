//
//  SightDetailGoodsCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/21.
//
//

#import <UIKit/UIKit.h>
#import "SightDetailGoods.h"

@class SightDetailGoodsCell;

#define SightDetailGoodsCell_ID @"SightDetailGoodsCell"
#define SightDetailGoodsCellPicCountViewFont [UIFont fontWithName:k_fontName_FZZY size:12]
#define SightDetailGoodsCellStoreNameLabelFont [UIFont fontWithName:k_fontName_FZZY size:17]
#define SightDetailGoodsCellStartReateLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]
#define SightDetailGoodsCellAddressLabelFont [UIFont fontWithName:k_fontName_FZZY size:13]
#define SightDetailGoodsCellNameLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]
#define SightDetailGoodsCellPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:17]
#define SightDetailGoodsCellOldPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:12]
#define SightDetailGoodsCellQuickBuyBtnFont [UIFont fontWithName:k_fontName_FZZY size:18]

#define SightDetailGoodsCellSubViewMargin 5
#define SightDetailGoodsCellPicViewH ([UIScreen mainScreen].bounds.size.width * 0.5)
#define SightDetailGoodsCellStoreNameLabelH 22
#define SightDetailGoodsCellStartReateH 25
#define SightDetailGoodsCellAddressIconViewH 25
#define SightDetailGoodsCellQuickBuyBtnH 36
#define SightDetailGoodsCellHight (SightDetailGoodsCellSubViewMargin * 3 + SightDetailGoodsCellStoreNameLabelH + SightDetailGoodsCellStartReateH + SightDetailGoodsCellSubViewMargin + SightDetailGoodsCellAddressIconViewH + SightDetailGoodsCellSubViewMargin + SightDetailGoodsCellPicViewH + SightDetailGoodsCellSubViewMargin * 2 + SightDetailGoodsCellQuickBuyBtnH + SightDetailGoodsCellSubViewMargin * 2)

@protocol SightDetailGoodsCellDelegate <NSObject>
- (void)sightDetailGoodsCell:(SightDetailGoodsCell *)view quickBuyBtnDidOnClickWithSightDetailGoods:(SightDetailGoods *)sightDetailGoods;
@end

@interface SightDetailGoodsCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) SightDetailGoods *sightDetailGoods;
@property (nonatomic, weak) id<SightDetailGoodsCellDelegate> delegate;
@end
