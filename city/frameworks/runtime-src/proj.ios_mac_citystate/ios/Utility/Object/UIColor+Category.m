//
//  UIView+Category.m
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)
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

//参数示例1：#FF453D or #e23ad3 or Oxff
//参数示例2：UIColor对象
//参数示例3：rgb(234,211,2) or rgba(234,211,2,0.8)
+ (UIColor *)color:(id)description{
    if (!description) return nil;
    
    if ([description isKindOfClass:[UIColor class]]) {
        return description;
    }
    if ([description isKindOfClass:[UIImage class]]) {
        return [UIColor colorWithPatternImage:description];
    }
    else if ([description isKindOfClass:[NSString class]]){
        NSString * str = [NSString stringWithFormat:@"%@", description];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([str rangeOfString:@"#"].location != NSNotFound) {
            str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
            return [UIColor colorFromHexRGB:[str uppercaseString]];
        }
        else if ([str rangeOfString:@"0x"].location != NSNotFound) {
            return [UIColor colorFromHexRGB:str];
        }
        else if ([str rangeOfString:@"rgb"].location != NSNotFound || [str rangeOfString:@"RGB"].location != NSNotFound){
            str = [str stringByReplacingOccurrencesOfString:@"rgba" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"RGBA" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"rgb" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"RGB" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSArray * arr = [str componentsSeparatedByString:@","];
            return [UIColor colorWithRed:[[arr objectAtIndex:0] integerValue]/255.0 green:[[arr objectAtIndex:1] integerValue]/255.0 blue:[[arr objectAtIndex:2] integerValue]/255.0 alpha:([arr count] == 3) ? 1 : [[arr objectAtIndex:3] integerValue]];
        }
    }
    return nil;
}

@end
