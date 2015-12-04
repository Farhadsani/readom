//
//  StoreGoodsDetailSectionThreeView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import <UIKit/UIKit.h>
#import "StoreGoodsDetail.h"

#define StoreGoodsDetailSectionThreeView_ID @"StoreGoodsDetailSectionThreeView"
#define StoreGoodsDetailSectionThreeViewLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreGoodsDetailSectionThreeViewTitleLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define StoreGoodsDetailSectionThreeViewContentLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]
#define StoreGoodsDetailSectionThreeViewSubViewMargin 8
#define StoreGoodsDetailSectionThreeViewLayoutSubviewsNotification @"StoreGoodsDetailSectionThreeViewLayoutSubviewsNotification"

@interface StoreGoodsDetailSectionThreeView : UIView
+ (instancetype)storeGoodsDetailSectionThreeView;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@end
