//
//  MsgItem.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import "MsgItem.h"


@implementation MsgItem
@synthesize userItem, strMsg, strTime;

- (id)init {
    self = [super init];
    if (self) {
        userItem = [[UserBriefItem alloc]init:0];
        strMsg = @"";
        strTime = @"";
    }
    return self;
}

@end
