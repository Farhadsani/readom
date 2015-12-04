//
//  NSMutableDictionary+NSMutableDictionaryAdditions.h
//  BOCiPadX
//
//  Created by Tracy E on 12-9-12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NonEmpty)

- (void)setNonEmptyObject:(id)obj forKey:(NSString *)key;
- (void)setNonEmptyValue:(id)value forKey:(NSString *)key;
- (void)removeNonEmptyObject:(id)object;
- (void)setNonEmptyValuesForKeysWithDictionary:(NSDictionary *)obj;

@end

@interface NSDictionary (RightType)

- (id)objectOutForKey:(NSString *)anAttribute;
+ (BOOL)isNotEmpty:(NSDictionary *)dict;
- (NSDictionary *)removeEmptyValueKey;

- (NSString *)picUrlAtFirstForKey:(NSString *)picListStr;

@end
