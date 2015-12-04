//
//  SupportMsgItem.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/18.
//
//

#import "SupportMsgItem.h"

@implementation SupportMsgItem
@synthesize imgCount, imgLink, noteID, ctime, cityID, topic_ctime, provid, content, title, topicID, userItem;

- (id)init
{
    self = [super init];
    if (self) {
        userItem = [[UserBriefItem alloc]init:0];
        imgCount = 0;
        imgLink = @"";
        noteID = 0;
        ctime = @"";
        cityID = 0;
        topic_ctime = @"";
        provid = 0;
        content = @"";
        title = @"";
        topicID = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)pZone {
    SupportMsgItem *copy = [[[self class] allocWithZone: pZone] init];
    copy.userItem = self.userItem;
    copy.imgCount = self.imgCount;
    copy.noteID = self.noteID;
    copy.imgLink = self.imgLink;
    copy.ctime = self.ctime;
    copy.cityID = self.cityID;
    copy.topic_ctime = self.topic_ctime;
    copy.provid = self.provid;
    copy.content = self.content;
    copy.title = self.title;
    copy.topicID = self.topicID;
    return copy;
}


@end
