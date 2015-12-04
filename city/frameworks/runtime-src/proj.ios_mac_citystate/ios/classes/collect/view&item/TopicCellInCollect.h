

#import "TopicItem.h"

@protocol CollectCellInCollectDelegate;

@interface TopicCellInCollect : UIView {
    UIButton * colectBtn;
}

@property(nonatomic, retain)NSDictionary * date_dict;
@property(nonatomic, retain)TopicItem * topicItem;
@property (nonatomic, assign) id<CollectCellInCollectDelegate> delegate;

- (void)updateCell:(NSDictionary *)inf;

@end
