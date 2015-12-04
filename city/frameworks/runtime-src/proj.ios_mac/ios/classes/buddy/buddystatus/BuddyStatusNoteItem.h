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
@property (nonatomic, assign) long topicid;
@property (nonatomic, assign) long noteid;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, assign) long like_count;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *thumbs;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *place;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, strong) BuddyStatusUser *user;
@property (nonatomic, assign) int complete;
@end
