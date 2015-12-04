
#import "TopicItem.h"

@interface TopicCell : UITableViewCell
@property (nonatomic, strong) TopicItem *topicItem;
+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
