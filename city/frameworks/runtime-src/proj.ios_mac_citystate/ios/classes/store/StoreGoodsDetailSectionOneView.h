//
//  StoreGoodsDetailSectionOneView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import <UIKit/UIKit.h>
#import "StoreGoodsDetail.h"

@class StoreGoodsDetailSectionOneView;

#define StoreGoodsDetailSectionOneViewStoreNameLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreGoodsDetailSectionOneViewNameLabelFont [UIFont fontWithName:k_fontName_FZXY size:12]
#define StoreGoodsDetailSectionOneViewPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:32]
#define StoreGoodsDetailSectionOneViewOldPriceLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]
#define StoreGoodsDetailSectionOneViewOldPriceLabelFont2 [UIFont fontWithName:k_fontName_FZZY size:12]
#define StoreGoodsDetailSectionOneViewQuickBuyBtnFont [UIFont fontWithName:k_fontName_FZZY size:18]

#define StoreGoodsDetailSectionOneViewPadding 12
#define StoreGoodsDetailSectionOneViewPicViewH ([UIScreen mainScreen].bounds.size.width * 0.5)
#define StoreGoodsDetailSectionOneViewQuickBuyBtnH 36
#define StoreGoodsDetailSectionOneViewHight (StoreGoodsDetailSectionOneViewPicViewH + StoreGoodsDetailSectionOneViewQuickBuyBtnH +StoreGoodsDetailSectionOneViewPadding * 2)

@protocol StoreGoodsDetailSectionOneViewDelegate <NSObject>
- (void)storeGoodsDetailSectionOneView:(StoreGoodsDetailSectionOneView *)view quickBuyBtnDidOnClick:(UIButton *)button;
@end

@interface StoreGoodsDetailSectionOneView : UIView
+ (instancetype)storeGoodsDetailSectionOneView;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@property (nonatomic, weak) id<StoreGoodsDetailSectionOneViewDelegate> delegate;
@end
