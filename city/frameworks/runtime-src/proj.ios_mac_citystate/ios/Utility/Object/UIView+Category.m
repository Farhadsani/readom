//
//  UIView+Category.m
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)


- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void) addUnderlineWithColor:(UIColor *) color{
    CGRect selfRect = self.frame;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, selfRect.size.height - 1);
    CGPathAddLineToPoint(path, NULL, selfRect.size.width, selfRect.size.height - 1);
    lineLayer.path = path;
    CGPathRelease(path);
    
    lineLayer.lineWidth = 1;
    //    lineLayer.fillColor = [UIColor blackColor].CGColor;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.masksToBounds = NO;
    
    [self.layer addSublayer:lineLayer];
}

//- (void) setBorderWithWidth:(float)borderwidth  color:(UIColor *)bordercolor radius:(float) borderradius{
//    
//    CAShapeLayer *_shapeLayer;
//    
//    //    if (_shapeLayer) [_shapeLayer removeFromSuperlayer];
//    
//    //border definitions
//	CGFloat cornerRadius = borderradius;
//	CGFloat borderWidth = borderwidth;
////	NSInteger dashPattern1 = 3;
////	NSInteger dashPattern2 = 3;
//    UIColor *color = bordercolor;
//    
//    //drawing
//	CGRect frame = self.bounds;
//    
//	_shapeLayer = [CAShapeLayer layer];
//    
//    //creating a path
//	CGMutablePathRef path = CGPathCreateMutable();
//    
//    //drawing a border around a view
//	CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
//	CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
//	CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
//	CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
//	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
//	CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
//	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
//	CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
//	CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
//    
//    //path is set as the _shapeLayer object's path
//	_shapeLayer.path = path;
//	CGPathRelease(path);
//    
//	_shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
//	_shapeLayer.frame = frame;
//	_shapeLayer.masksToBounds = NO;
//	[_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
//	_shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//	_shapeLayer.strokeColor = [color CGColor];
//	_shapeLayer.lineWidth = borderWidth;
////	_shapeLayer.lineDashPattern = style.border_.type == StyleLineType_dotted ? [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil] : nil;
//	_shapeLayer.lineCap = kCALineCapRound;
//    
//    //_shapeLayer is added as a sublayer of the view
//	[self.layer addSublayer:_shapeLayer];
//	self.layer.cornerRadius = cornerRadius;
//    
//}


- (void) doSelectedAnimation{
    CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    centerZoom.duration = 1.0f;
    centerZoom.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:centerZoom forKey:@"buttonScale"];
}

- (void) doShakeAnimation{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.4];
    
    shake.toValue = [NSNumber numberWithFloat:+0.4];
    
    shake.duration = 0.05;
    
    shake.autoreverses = YES; //是否重复
    
    shake.repeatCount = 4;
    
    [self.layer addAnimation:shake forKey:@"imageView"];
    
    self.alpha = 1.0;
    
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}

//给图片添加点击事件
- (void)imageView:(UIImageView *)imgView addAction:(SEL)sel target:(id)target{
    if (!imgView || !imgView.superview) {
        return;
    }
    
    imgView.userInteractionEnabled = YES;
    
    UIView * v = [imgView viewWithTag:723];
    if (v && [v isKindOfClass:[UIControl class]]) {
        [v removeFromSuperview];
    }
    
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
    control.backgroundColor = [UIColor clearColor];
    control.tag = 723;
    [imgView addSubview:control];
    [control release];
    control.layer.cornerRadius = imgView.layer.cornerRadius;
    control.layer.masksToBounds = YES;
    
    if (sel && target) {
        [control addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
}



@end

@implementation UIViewController (Category)

- (void) hideTabBar:(BOOL)hidden animation:(BOOL)animation{
//    if (self.tabBarController.tabBar.frame.origin.y >= self.view.height) {
//        //tabbar已经隐藏
//        if (hidden) {
//            return;
//        }
//    }
//    else{
//        //tabbar已经显示
//        if (!hidden) {
//            return;
//        }
//    }
    
//    CGFloat hh = (k_NO_LESS_THAN_IOS(7)) ? (kScreenWidth-49) : (kScreenHeight-49-20);
//    hh = ([[UIScreen mainScreen] bounds].size.height);
    
    [UIView animateWithDuration:((animation) ? 0.4 : 0) animations:^{
        for(UIView *view in self.tabBarController.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                if (hidden) {
                    [view setFrame:CGRectMake(view.frame.origin.x, kScreenHeight, view.frame.size.width, view.frame.size.height)];
                } else {
                    [view setFrame:CGRectMake(view.frame.origin.x, kScreenHeight-k_DEFAULT_BOTTOM_BAR_HEIGHT, view.frame.size.width, view.frame.size.height)];
                }
            }
            else
            {
                if (!k_NO_LESS_THAN_IOS(7.0)) {
                    CGFloat screenHeight = k_SCREEN_SIZE_HEIGHT_480 ? 480 : 568;
                    if (hidden) {
                        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, screenHeight)];
                    } else {
                        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,  screenHeight-k_DEFAULT_BOTTOM_BAR_HEIGHT)];
                    }
                }
                
            }
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if (hidden) {
                self.tabBarController.tabBar.clipsToBounds = YES;
            }
            else{
                self.tabBarController.tabBar.clipsToBounds = NO;
            }
        }
    }];
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:((animation) ? 0.4 : 0)];
//    
//    for(UIView *view in self.tabBarController.view.subviews)
//    {
//        if([view isKindOfClass:[UITabBar class]])
//        {
//            if (hidden) {
//                [view setFrame:CGRectMake(view.frame.origin.x, kScreenHeight, view.frame.size.width, view.frame.size.height)];
//            } else {
//                [view setFrame:CGRectMake(view.frame.origin.x, kScreenHeight-k_DEFAULT_BOTTOM_BAR_HEIGHT, view.frame.size.width, view.frame.size.height)];
//            }
//        }
//        else
//        {
//            if (!k_NO_LESS_THAN_IOS(7.0)) {
//                CGFloat screenHeight = k_SCREEN_SIZE_HEIGHT_480 ? 480 : 568;
//                if (hidden) {
//                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, screenHeight)];
//                } else {
//                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,  screenHeight-k_DEFAULT_BOTTOM_BAR_HEIGHT)];
//                }
//            }
//            
//        }
//    }
//    
//    [UIView commitAnimations];
}

- (void)hideTabBar2:(BOOL)hide
{
    if ( [self.tabBarController.view.subviews count] < 2 )
    {
        return;
    }
    UIView *contentView;
    
    if ( [[self.tabBarController.view.subviews objectAtExistIndex:0] isKindOfClass:[UITabBar class]] )
    {
        contentView = [self.tabBarController.view.subviews objectAtExistIndex:1];
    }
    else
    {
        contentView = [self.tabBarController.view.subviews objectAtExistIndex:0];
    }
    //    [UIView beginAnimations:@"TabbarHide" context:nil];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    
    if ( hide )
    {
        contentView.frame = self.tabBarController.view.bounds;
    }
    else
    {
        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
                                       self.tabBarController.view.bounds.origin.y,
                                       self.tabBarController.view.bounds.size.width,
                                       self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    }
    
    self.tabBarController.tabBar.hidden = hide;
    
    [UIView commitAnimations];
}

- (CGFloat)getNavBarHeight{
    if (k_NO_LESS_THAN_IOS(7)) {
        return k_IOS7_NAVIGATION_BAR_HEIGHT;
    }
    else{
        return k_DEFAULT_NAVIGATION_BAR_HEIGHT;
    }
}

- (CGFloat)origin_Y_HidTabBar:(BOOL)hasHidTabBar hidNavBar:(BOOL)hasHidNavBar hidTopStatusBar:(BOOL)isHidTopStatusBar{
    CGFloat y = k_DEFAULT_NAVIGATION_BAR_HEIGHT;
//    if (k_NO_LESS_THAN_IOS(7)) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        y = _IOS7_NAVIGATION_BAR_HEIGHT;
//    }
//    if (hasHidNavBar) {
//        y -= _DEFAULT_NAVIGATION_BAR_HEIGHT;
//        if (k_NO_LESS_THAN_IOS(7)) {
//            y -= 20;
//        }
//    }
    
    if (hasHidNavBar) {
        y = 0;
        if (k_NO_LESS_THAN_IOS(7) && !isHidTopStatusBar) {
            y = 20;
        }
    }
    else{
        if (k_NO_LESS_THAN_IOS(7)) {
            y = k_IOS7_NAVIGATION_BAR_HEIGHT;
        }
        else{
            y = k_DEFAULT_NAVIGATION_BAR_HEIGHT;
        }
    }
    
    if (k_NO_LESS_THAN_IOS(7)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    self.navigationController.navigationBar.translucent = YES;
    
    return y;
}

- (CGFloat)heightOfViewHidTabBar:(BOOL)hasHidTabBar hidNavBar:(BOOL)hasHidNavBar hidTopStatusBar:(BOOL)isHidTopStatusBar{
//    CGFloat h = self.view.frame.size.height-_DEFAULT_NAVIGATION_BAR_HEIGHT-_DEFAULT_BOTTOM_BAR_HEIGHT;
//    if (k_NO_LESS_THAN_IOS(7)) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        h = self.view.frame.size.height-_IOS7_NAVIGATION_BAR_HEIGHT-_DEFAULT_BOTTOM_BAR_HEIGHT;
//    }
    
    CGFloat h = kScreenHeight;
    if (!hasHidTabBar) {
        h -= k_DEFAULT_BOTTOM_BAR_HEIGHT;
    }
    
    if (hasHidNavBar) {
        if (!k_NO_LESS_THAN_IOS(7)) {
            h -= 20;
        }
        else{
            if (!isHidTopStatusBar) {
                h -= 20;
            }
        }
    }
    else{
        h -= k_IOS7_NAVIGATION_BAR_HEIGHT;
    }
    
    if (k_NO_LESS_THAN_IOS(7)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    self.navigationController.navigationBar.translucent = YES;
    return h;
}

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end
