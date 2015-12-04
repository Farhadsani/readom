//
//  NSString+SubString.m
//  
//
//  Created by wang wen hui on 13-1-30.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSString+SubString.h"

@implementation NSString (SubString)

- (NSString *)substringBettweenString:(NSString *)start andString:(NSString *)end
{
    if (nil == start
        || nil == end
        || [start isEqualToString:@""]
        || [end isEqualToString:@""]) {
        
        return nil;
    }
    
    NSString *subString = nil;
    NSString *srcString = self;
    NSScanner *theScanner = [NSScanner scannerWithString:srcString];
    while (![theScanner isAtEnd]) {
        BOOL found = [theScanner scanString:start intoString:NULL];
        if (!found) {
            theScanner.scanLocation++;
            continue;
        }
        
        found = [theScanner scanUpToString:end intoString:&subString];
        if (found) {
            if ([theScanner isAtEnd]) {
                subString = nil;
            }
            break;
        }
    }
    
    return subString;
}


- (NSString *)decodeFromPercentEscapeString{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"  
                               withString:@" "  
                                  options:NSLiteralSearch  
                                    range:NSMakeRange(0, [outputStr length])];  
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeToPercentEscapeString 
{  
    
    // Encode all the reserved characters, per RFC 3986  
    // (<http://www.ietf.org/rfc/rfc3986.txt>)  
    NSString *encoded = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                            (CFStringRef)self,  
                                            NULL,  
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",  
                                            kCFStringEncodingUTF8));
    NSString *output = [encoded copy];
//    CFRelease((__bridge CFTypeRef)(encoded));
    
    return [output autorelease];
}


@end

@implementation NSString (UIAlertView)

- (NSTextAlignment)alertTextAlignment:(UIFont *)font{
    NSString * text = self;
    if (!text || text.length == 0) {
        return NSTextAlignmentCenter;
    }
    NSString * info = [NSString stringWithString:[text stringByReplacingOccurrencesOfString:@"\n" withString:@"|"]];
    if ([info rangeOfString:@"|"].location == NSNotFound) {
        if ([info sizeWithAttributes:@{NSFontAttributeName:font}].width < 260) {
            return NSTextAlignmentCenter;
        }
        else{
            return NSTextAlignmentLeft;
        }
    }
    else{
        return NSTextAlignmentLeft;
    }
}

- (NSString *)Message{
    NSString * text = self;
    if (!text) {
        return @"";
    }
    
    if ([text rangeOfString:@"|"].location != NSNotFound) {
        return [text stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    }
    else{
        return text;
    }
}

@end

@implementation UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
