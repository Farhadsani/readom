//
//  BuddyStatusUser.h
//  qmap
//
//  Created by 小玛依 on 15/8/24.
//
//

#import <Foundation/Foundation.h>

@interface BuddyStatusUser : NSObject
@property (nonatomic, assign) long userid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *zone;
@property (nonatomic, copy) NSString *imglink;
@property (nonatomic, copy) NSString *thumblink;
@property (nonatomic, copy) NSString *utime;
@end
