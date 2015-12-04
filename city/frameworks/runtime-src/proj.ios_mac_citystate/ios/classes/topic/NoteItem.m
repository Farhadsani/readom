#import "NoteItem.h"
#import "TagItem.h"

@implementation NoteItem

@synthesize topicid, noteid, complete, like_count, imgs, thumbs, text, tags, place, ctime, brief, liked;
@synthesize uiClickIndex;

- (id)init {
    self = [super init];
    if (self) {
        topicid = 0;
        noteid = 0;
        complete = 0;
        like_count = 0;
        imgs = [[NSMutableArray alloc] init];
        thumbs = [[NSMutableArray alloc] init];
        text = @"";
        tags = [[NSMutableArray alloc] init];
        place = [[NSMutableArray alloc] init];
        ctime = @"";
        brief = [[UserBriefItem alloc] init];
		liked = YES;
        uiClickIndex = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NoteItem *copy = [[[self class] allocWithZone: zone] init];
    copy.topicid = self.topicid;
    copy.noteid = self.noteid;
    copy.complete = self.complete;
    copy.like_count = self.like_count;
    for( NSString *imgOne in self.imgs ){
        [copy.imgs addObject:imgOne];
    }
    for( NSString *thumbOne in self.thumbs ){
        [copy.thumbs addObject:thumbOne];
    }
    copy.text = self.text;
    for( TagItem *tagOne in self.tags ){
        [copy.tags addObject:tagOne];
    }
    for( TagItem *placeOne in self.place ){
        [copy.place addObject:placeOne];
    }
    copy.ctime = self.ctime;
    copy.liked = self.liked;
    copy.brief = self.brief;
    copy.uiClickIndex = self.uiClickIndex;
    return copy;
}

@end
