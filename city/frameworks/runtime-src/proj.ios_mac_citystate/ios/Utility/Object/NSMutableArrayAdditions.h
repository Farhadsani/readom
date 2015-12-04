//
//  NSMutableArray+NSMutableArrayAdditions.h
//  BOCiPadX
//
//  Created by Tracy E on 12-9-12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NonEmpty)

- (void)addNonEmptyObject:(id)obj;
- (void)removeDuplicateObjects;
- (void)removeDuplicateObjectsWithFlag:(NSString *)flag;
- (void)insertNonEmptyObject:(id)anObject atIndex:(NSUInteger)index;

@end

@interface NSArray (InBounds)

- (id)objectAtExistIndex:(NSInteger)index;

+ (BOOL)isNotEmpty:(NSArray *)arr;

@end