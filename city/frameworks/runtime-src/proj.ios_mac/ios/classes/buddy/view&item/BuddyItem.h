//
//  BoddyItem.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/27.
//
//

#import <Foundation/Foundation.h>

@interface BuddyItem : NSObject<NSCopying>
{
    
}
@property(assign, atomic)long userid;
@property(nonatomic)NSInteger relationship;
@property(copy, atomic)NSString *name;
@property(copy, atomic)NSString *zone;
@property(copy, atomic)NSString *intro;
@property(copy, atomic)NSString *imglink;
@property(copy, atomic)NSString *thumblink;
@property(strong, atomic)NSData *thumbdata;

@end
