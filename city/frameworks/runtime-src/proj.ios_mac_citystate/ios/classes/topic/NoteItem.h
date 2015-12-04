#import "UserBriefItem.h"

@interface NoteItem : NSObject<NSCopying>
{
}

@property(assign, atomic)long topicid;
@property(assign, atomic)long noteid;
@property(assign, atomic)int complete;
@property(assign, atomic)int like_count;
@property(strong, atomic)NSMutableArray *imgs;
@property(strong, atomic)NSMutableArray *thumbs;
@property(copy, atomic)NSString *text;
@property(strong, atomic)NSMutableArray *tags;
@property(strong, atomic)NSMutableArray *place;
@property(copy, atomic)NSString *ctime;
@property(copy, atomic)UserBriefItem *brief;
@property(assign, atomic)BOOL liked;
@property(assign, atomic)NSInteger uiClickIndex;
@property (nonatomic, copy) NSString *topic;
@end
