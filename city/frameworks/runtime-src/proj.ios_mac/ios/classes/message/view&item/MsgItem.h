//
//  MsgItem.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import <Foundation/Foundation.h>
#import "UserBriefItem.h"

@interface MsgItem : NSObject
{
    
}

@property(copy, atomic) UserBriefItem* userItem;
@property(copy, atomic) NSString* strMsg;
@property(copy, atomic) NSString* strTime;

@end
