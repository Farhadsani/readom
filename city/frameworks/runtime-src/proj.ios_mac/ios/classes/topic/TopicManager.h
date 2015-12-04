
@interface TopicManager : NSObject
{
    NSMutableArray              *listNext;
    NSMutableSet                *setShow;
    int                         backIndex;
}
@property (assign, atomic)    int index;
@property (strong, atomic)    NSMutableArray  *listShow;
@property (assign, atomic)    BOOL            started;
@property (assign, atomic)    BOOL            gettingNext;
@property (assign, atomic)    BOOL            responsing;
-(id)init;
-(void)getStart:(int)limit;
-(void)getNext:(int)limit;
-(BOOL)likePost:(long)topicid;
-(BOOL)likeDel:(long)topicid;
@end
