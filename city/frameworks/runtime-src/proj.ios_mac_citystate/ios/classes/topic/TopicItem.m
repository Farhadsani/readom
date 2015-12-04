#import "TopicItem.h"

@implementation TopicItem

@synthesize topicid, title, summary, hot, provid, cityid, channel, imglink, ctime, liked, noteManager;

- (id)init {
    self = [super init];
    if (self) {
        topicid = 0;
        title = @"";
        summary = @"";
        hot = 0;
        provid = 0;
        cityid = 0;
        channel = @"";
        imglink = @"";
        ctime = @"";
        liked = YES;
        noteManager = nil;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TopicItem *copy = [[[self class] allocWithZone: zone] init];
    copy.topicid = self.topicid;
    copy.title = self.title;
    copy.summary = self.summary;
    copy.hot = self.hot;
    copy.provid = self.provid;
    copy.cityid = self.cityid;
    copy.channel = self.channel;
    copy.imglink = self.imglink;
    copy.ctime = self.ctime;
    copy.liked = self.liked;
    copy.noteManager = self.noteManager;
    return copy;
}

@end
