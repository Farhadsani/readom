//
//  SupportMsgItem.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/18.
//
//

#import <Foundation/Foundation.h>
#import "UserBriefItem.h"

@interface SupportMsgItem : NSObject
{
    
}

@property (assign, atomic)long imgCount;
@property (copy, atomic) NSString* imgLink;
@property (assign, atomic) long noteID;
@property (copy, atomic) NSString* ctime;
@property (assign, atomic) long cityID;
@property (copy, atomic) NSString *topic_ctime;
@property (assign, atomic) long provid;
@property (copy, atomic) NSString *content;
@property (copy, atomic) NSString *title;
@property (assign, atomic) long topicID;
@property (copy, atomic) UserBriefItem* userItem;

@end
