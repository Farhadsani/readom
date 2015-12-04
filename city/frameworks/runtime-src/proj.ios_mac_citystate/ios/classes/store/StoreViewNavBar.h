//
//  StoreViewNavBar.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/19.
//
//

#import <UIKit/UIKit.h>

@class StoreViewNavBar;

@protocol StoreViewNavBarDelegate <NSObject>
- (void)storeViewNavBar:(StoreViewNavBar *)navBar backBtnDidOnClick:(UIButton *)btn;
@end

@interface StoreViewNavBar : UIView
+ (instancetype)storeViewNavBarWithTitle:(NSString *)title;
- (void)setBgViewAlpha:(CGFloat)alpha;
- (void)setTitle:(NSString *)title;
@property (nonatomic, weak) id<StoreViewNavBarDelegate> delegate;
@end
