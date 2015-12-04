//
//  StoreGoodsDetailSectionTwoView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import <UIKit/UIKit.h>
#import "StoreGoodsDetail.h"


#define StoreGoodsDetailSectionTwoViewStartReateLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]
#define StoreGoodsDetailSectionTwoViewAddressLabelFont [UIFont fontWithName:k_fontName_FZZY size:13]

#define StoreGoodsDetailSectionTwoViewSubViewMargin 8
#define StoreGoodsDetailSectionTwoViewStartReateH 30
#define StoreGoodsDetailSectionTwoViewAddressIconViewH 30
#define StoreGoodsDetailSectionTwoViewHight (StoreGoodsDetailSectionTwoViewStartReateH + StoreGoodsDetailSectionTwoViewAddressIconViewH + StoreGoodsDetailSectionTwoViewSubViewMargin * 3)

@interface StoreGoodsDetailSectionTwoView : UIView
+ (instancetype)storeGoodsDetailSectionTwoView;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@end
