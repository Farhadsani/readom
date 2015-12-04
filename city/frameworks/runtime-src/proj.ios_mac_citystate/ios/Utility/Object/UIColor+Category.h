//
//  UIView+Category.h
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIColor (Category)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)color:(id)description;

@end

