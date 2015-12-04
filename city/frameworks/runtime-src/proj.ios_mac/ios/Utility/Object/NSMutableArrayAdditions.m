//
//  NSMutableArray+NSMutableArrayAdditions.m
//  BOCiPadX
//
//  Created by Tracy E on 12-9-12.
//
//

#import "NSMutableArrayAdditions.h"

@implementation NSMutableArray (NonEmpty)

- (void)addNonEmptyObject:(id)obj{
    if (obj) {
        [self addObject:obj];
    }
}

- (void)removeDuplicateObjects{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self];
    [self removeAllObjects];
    
    NSMutableSet *addedObjects = [NSMutableSet set];
    
    for (id obj in tempArray) {
        if (![addedObjects containsObject:obj]) {
            [self addObject:obj];
            [addedObjects addObject:obj];
        }
    }
}

- (void)removeDuplicateObjectsWithFlag:(NSString *)flag{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self];
    [self removeAllObjects];
    
    NSMutableArray *addedObjects = [NSMutableArray array];
    
    for (id obj in tempArray) {
        if (![self isArray:addedObjects containObj:obj withKey:flag]) {
            [self addObject:obj];
            [addedObjects addObject:obj];
        }
    }
}

//如果obj是字典类型：key为字典中的一个Key
- (BOOL)isArray:(NSArray *)arr containObj:(id)obj withKey:(NSString *)key{
    if (!arr || [arr count] == 0 || !obj) {
        return NO;
    }
    
    if ([NSString isEmptyString:key]) {
        return [arr containsObject:obj];
    }
    else{
        if ([obj isKindOfClass:[NSDictionary class]] && [[obj allKeys] containsObject:key]) {
            for (id src in arr) {
                if ([src isKindOfClass:[NSDictionary class]] && [[src allKeys] containsObject:key]) {
                    if ([[src objectOutForKey:key] isEqual:[obj objectOutForKey:key]]) {
                        return YES;
                    }
                }
            }
        }
        else{
            return [arr containsObject:obj];
        }
    }
    
    return NO;
}

- (void)insertNonEmptyObject:(id)anObject atIndex:(NSUInteger)index{
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    }
    else{
        InfoLog(@"");
    }
}

@end

@implementation NSArray (InBounds)

- (id)objectAtExistIndex:(NSInteger)index{
    if (index >= 0 && index < [self count]) {
        return [self objectAtIndex:index];
    }
    InfoLog(@"数组越界——————————————————————————————————");
    return nil;
}

+ (BOOL)isNotEmpty:(NSArray *)arr{
    if (arr && [arr isKindOfClass:[NSArray class]] && [arr count]>0) {
        return YES;
    }
    
    return NO;
}

@end