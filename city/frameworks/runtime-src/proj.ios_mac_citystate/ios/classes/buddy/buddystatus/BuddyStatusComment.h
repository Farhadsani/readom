//
//  BuddyStatusComment.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import <Foundation/Foundation.h>
#import "BuddyStatusUser.h"

@interface BuddyStatusComment : NSObject
@property (nonatomic, strong) BuddyStatusUser *user;
@property (nonatomic, assign) long commentid;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *comment;
@end
