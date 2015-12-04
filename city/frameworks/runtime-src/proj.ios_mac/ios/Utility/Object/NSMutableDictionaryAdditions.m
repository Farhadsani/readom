//
//  NSMutableDictionary+NSMutableDictionaryAdditions.m
//  BOCiPadX
//
//  Created by Tracy E on 12-9-12.
//
//

#import "NSMutableDictionaryAdditions.h"

@implementation NSMutableDictionary (NonEmpty)

- (void)setNonEmptyObject:(id)obj forKey:(NSString *)key{
    if (obj && key) {
        [self setObject:obj forKey:key];
    }
}

- (void)setNonEmptyValuesForKeysWithDictionary:(NSDictionary *)obj{
    if ([NSDictionary isNotEmpty:obj]) {
        for (NSString * key in [obj allKeys]) {
            if ([obj objectOutForKey:key]) {
                [self setNonEmptyObject:[obj objectOutForKey:key] forKey:key];
            }
        }
    }
}

- (void)setNonEmptyValue:(id)value forKey:(NSString *)key{
    if (value && key) {
        [self setValue:value forKey:key];
    }
}

- (void)removeNonEmptyObject:(id)object{
    if (object) {
        NSString *theKey = nil;
        for (NSString *key in [self allKeys]) {
            if ([[self objectOutForKey:key] isEqual:object]) {
                theKey = key;
                break;
            }
        }
        if (theKey) {
            [self removeObjectForKey:theKey];
        }
    }
}

@end

@implementation NSDictionary (RightType)

- (id)objectOutForKey:(NSString *)anAttribute{
    if (!self || !anAttribute || ![anAttribute isKindOfClass:[NSString class]] || anAttribute.length == 0) {
        return nil;
    }
    
    if (![[self allKeys] containsObject:anAttribute]) {
        return nil;
    }
    
    id value = [self objectForKey:anAttribute];
    if (value) {
        if ([value isKindOfClass:[NSNull class]]) {
            return nil;
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", value];
        }
        else if ([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@"Null"]||[value isEqualToString:@"null"]||[value isEqualToString:@"NULL"]) {
                return nil;
            }
            else{
                return value;
            }
        }
        else{
            return value;
        }
    }
    
    return nil;
}

- (NSString *)picUrlAtFirstForKey:(NSString *)picListStr{
    if ([NSString isEmptyString:picListStr]) {
        return nil;
    }
    
    if (![[self allKeys] containsObject:picListStr]) {
        return nil;
    }
    
    id obj = [self objectForKey:picListStr];
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        }
        else if (([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) && [obj count] > 0){
            return [NSString stringWithFormat:@"%@", [obj objectAtExistIndex:0]];
        }
    }
    
    return nil;
}

+ (BOOL)isNotEmpty:(NSDictionary *)dict{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && [dict count]>0) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)removeEmptyValueKey{
    NSMutableDictionary * mdic = [[[NSMutableDictionary alloc] init] autorelease];
    if ([NSDictionary isNotEmpty:self]) {
        for (NSString * key in [self allKeys]) {
            if ([self objectOutForKey:key]) {
                [mdic setObject:[self objectOutForKey:key] forKey:key];
            }
        }
    }
    return mdic;
}



@end