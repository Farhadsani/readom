//
//  StoreIntro.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import "StoreIntro.h"
#import "MJExtension.h"

@implementation StoreIntro
+ (NSDictionary *)objectClassInArray
{
    return @{@"goods": @"StoreGoods"};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"imglink": @"photolink", @"phone": @"telephone"};
}
@end
