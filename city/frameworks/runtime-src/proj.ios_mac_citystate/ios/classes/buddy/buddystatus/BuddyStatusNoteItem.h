//
//  BuddyStatusNoteItem.h
//  qmap
//
//  Created by 小玛依 on 15/8/24.
//
//

#import <Foundation/Foundation.h>
#import "BuddyStatusUser.h"

@interface BuddyStatusNoteItem : NSObject
@property (nonatomic, assign) long feedid;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) long like_count;
@property (nonatomic, assign) BOOL commented;
@property (nonatomic, assign) long comments_count;
@property (nonatomic, strong) NSArray *place;
@property (nonatomic, strong) BuddyStatusUser *user;
@end
