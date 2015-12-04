//
//  MyStoreGoodsSelectImgView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/30.
//
//

#import <UIKit/UIKit.h>
#import "StoreGoodsDetail.h"

@class MyStoreGoodsSelectImgView;

@protocol MyStoreGoodsSelectImgViewDelegate <NSObject>
- (void)myStoreGoodsSelectImgViewAddBtnDidOnClik:(MyStoreGoodsSelectImgView *)view;
@end

@interface MyStoreGoodsSelectImgView : UIView
+ (instancetype)myStoreGoodsSelectImgView;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@property (nonatomic, weak) id<MyStoreGoodsSelectImgViewDelegate> delegate;
@property (nonatomic, strong) UIImage *thumb;
@property (nonatomic, strong) UIImage *image;
@end
