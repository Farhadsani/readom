//
//  UIView+Category.h
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (Category)

//时间戳转时间
+ (NSString *)tran1970TimeToNormalTime:(id)date;

//时间转时间戳
+ (NSString *)tranNormalTimeTo1970Time:(NSDate *)date;

//是当年就不显示年份，不是当年就显示年份
+ (NSString *)dateOfCurrentYear:(NSString *)dateString;

//+ (NSDate *)dateFromTwoParamsDay:(NSDate *)dayDate Hours:(NSString *)hourStr;
+ (NSString *)dateFromTwoParamsDay:(NSDate *)dayDate Hours:(NSString *)hourStr;

+ (NSString *)stringFromDate:(id)date;
+ (NSDate *)dateFromString:(id)dateString;
+ (NSDate *)dateFromStringyMdHms:(id)dateString;

@end

