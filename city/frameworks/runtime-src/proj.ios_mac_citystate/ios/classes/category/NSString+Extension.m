//
//  NSString+Extension.m
//  qmap
//
//  Created by 小玛依 on 15/8/24.
//
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (NSString *)timeString2DateString
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter1 dateFromString:self];
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"yyyy-MM-dd";
    date = [formatter2 dateFromString:[formatter2 stringFromDate:date]];
    nowDate = [formatter2 dateFromString:[formatter2 stringFromDate:nowDate]];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date toDate:nowDate options:0];
    if (comp.day == 0) {
        formatter2.dateFormat = @"HH:mm";
        return [formatter2 stringFromDate:[formatter1 dateFromString:self]];
    } else if (comp.day == 1) {
        formatter2.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"昨天 %@", [formatter2 stringFromDate:[formatter1 dateFromString:self]]];
    } else if (comp.day == 2) {
        formatter2.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"前天 %@", [formatter2 stringFromDate:[formatter1 dateFromString:self]]];
    } else {
        formatter2.dateFormat = @"yyyy-MM-dd";
        return [formatter2 stringFromDate:[formatter1 dateFromString:self]];
    }
}
@end
