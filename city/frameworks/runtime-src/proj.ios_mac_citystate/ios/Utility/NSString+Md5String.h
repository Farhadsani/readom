//
//  NSString+Md5String.h
//  coldjoke-ios-client
//
//  Created by ColdWorks-Ted on 13-2-22.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Md5String)
- (NSString *) md5strLower:(NSString *)str;
- (NSString *) md5strUpper:(NSString *)str;

@end
