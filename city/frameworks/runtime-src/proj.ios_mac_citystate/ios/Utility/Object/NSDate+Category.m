//
//  UIView+Category.m
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

//时间戳转时间
+ (NSString *)tran1970TimeToNormalTime:(id)date{
    if (!date || [date isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if ([date isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        return [formatter stringFromDate:(NSDate *)date];
    }
    else if ([date isKindOfClass:[NSString class]] || [date isKindOfClass:[NSNumber class]]) {
        NSString * dateStr = [NSString stringWithFormat:@"%@", date];
        if ([dateStr rangeOfString:@"-"].location == NSNotFound) {
            //时间戳转时间
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[dateStr longLongValue]];
            dateStr = [formatter stringFromDate:confromTimesp];
        }
        
        return dateStr;
    }
    
    return @"";
}

//时间转时间戳
+ (NSString *)tranNormalTimeTo1970Time:(NSDate *)date{
    if (!date || ![date isKindOfClass:[NSDate class]]) {
        return @"";
    }
    
    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //时间转时间戳
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}

//+ (NSDate *)dateFromTwoParamsDay:(NSDate *)dayDate Hours:(NSString *)hourStr{
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
////    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
////    [formatter setTimeZone:[NSTimeZone localTimeZone]];
////
//    
//    NSString * dayStr = [formatter stringFromDate:dayDate];
//    dayStr = [[[dayDate description] componentsSeparatedByString:@" "] objectAtExistIndex:0];
//    dayStr = [NSString stringWithFormat:@"%@ %@", dayStr,[[hourStr componentsSeparatedByString:@" "] lastObject]];
//    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    return [formatter dateFromString:dayStr];
//}

//是当年就不显示年份，不是当年就显示年份
+ (NSString *)dateOfCurrentYear:(NSString *)dateString{
    if ([NSString isEmptyString:dateString]) {
        return dateString;
    }
    
    NSArray * arr = [dateString componentsSeparatedByString:@"年"];
    if ([arr count] >= 2 && ![NSString isEmptyString:[arr objectAtExistIndex:1]]) {
        if (![NSString isEmptyString:[arr objectAtExistIndex:0]]) {
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"YYYY"];
            NSDate *date = [NSDate date];
            NSDate *currentDate = [NSDate dateWithTimeInterval:60*60 sinceDate:date];//起点时间
            NSString * year = [formatter stringFromDate:currentDate];
            if ([[arr objectAtExistIndex:0] integerValue] > [year integerValue]) {
                return dateString;//跨年
            }
            else{
                //是当年（没有跨年）
                dateString = [arr objectAtExistIndex:1];
            }
        }
        else{
            dateString = [arr objectAtExistIndex:1];
        }
    }
    return dateString;
}

+ (NSString *)dateFromTwoParamsDay:(NSDate *)dayDate Hours:(NSString *)hourStr{
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    //
    
    NSString * dayStr = nil;
    dayStr = [[[dayDate description] componentsSeparatedByString:@" "] objectAtExistIndex:0];
    dayStr = [NSString stringWithFormat:@"%@ %@", dayStr,[[hourStr componentsSeparatedByString:@" "] lastObject]];
//    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return dayStr;
//    return [formatter dateFromString:dayStr];
}

+ (NSString *)stringFromDate:(id)date{
    if ([date isKindOfClass:[NSString class]]) {
        return (NSString *)date;
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
//    NSLocale *local = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
//    [formatter setLocale:local];
    
    if ([formatter stringFromDate:date]) {
        return [formatter stringFromDate:date];
    }
    else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [formatter stringFromDate:date];
    }
}


+ (NSDate *)dateFromString:(id)dateString{
    if ([dateString isKindOfClass:[NSDate class]]) {
        return (NSDate *)dateString;
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    [formatter setTimeZone:[NSTimeZone localTimeZone]];
//    [formatter setDateStyle:NSDateFormatterShortStyle];
    if (![formatter dateFromString:dateString]) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateFromStringyMdHms:(id)dateString{
    if ([dateString isKindOfClass:[NSDate class]]) {
        return (NSDate *)dateString;
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateString];
    
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
//    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    //    [formatter setDateStyle:NSDateFormatterShortStyle];
    return localeDate;
}

@end
