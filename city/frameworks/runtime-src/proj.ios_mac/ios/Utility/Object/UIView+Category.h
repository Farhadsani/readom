//
//  UIView+Category.h
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Category)

- (void)removeAllSubviews;

- (void) addUnderlineWithColor:(UIColor *) color;


- (void) doSelectedAnimation;

- (void) doShakeAnimation;

//给图片添加点击事件
- (void)imageView:(UIImageView *)imgView addAction:(SEL)sel target:(id)target;

@end

@interface UIViewController (Category)

- (void) hideTabBar:(BOOL)hidden animation:(BOOL)animation;
- (void)hideTabBar2:(BOOL)hide;
- (CGFloat)origin_Y_HidTabBar:(BOOL)hasHidTabBar hidNavBar:(BOOL)hasHidNavBar hidTopStatusBar:(BOOL)isHidTopStatusBar;
- (CGFloat)heightOfViewHidTabBar:(BOOL)hasHidTabBar hidNavBar:(BOOL)hasHidNavBar hidTopStatusBar:(BOOL)isHidTopStatusBar;
- (CGFloat)getNavBarHeight;

@end
