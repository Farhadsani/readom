#import "NoteManager.h"

@interface TopicItem : NSObject<NSCopying>
@property(assign, atomic)long topicid;
@property(copy, atomic)NSString *title;
@property(copy, atomic)NSString *summary;
@property(assign, atomic)int hot;
@property(assign, atomic)int provid;
@property(assign, atomic)int cityid;
@property(copy, atomic)NSString *channel;
@property(copy, atomic)NSString *imglink;
@property(copy, atomic)NSString *ctime;
@property(assign, atomic)BOOL liked;
@property(strong, atomic)NoteManager *noteManager;
@end
