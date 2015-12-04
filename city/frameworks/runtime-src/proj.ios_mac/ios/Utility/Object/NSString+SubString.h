//
//  NSString+SubString.h
//  
//
//  Created by wang wen hui on 13-1-30.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SubString)

- (NSString *)substringBettweenString:(NSString *)start andString:(NSString *)end;

@end

@interface NSString (URLCode)
//
//- (NSString *)decodeFromPercentEscapeString;
//- (NSString *)encodeToPercentEscapeString;

@end

@interface NSString (UIAlertView)

//UIAlertView的对齐方式，根据文字的长短及换行符来判断
- (NSTextAlignment)alertTextAlignment:(UIFont *)font;

//后台返回的文本中，自定义字符“|”为换行符，将“|”转换为“\n”
- (NSString *)Message;

@end

@interface UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size;
@end

