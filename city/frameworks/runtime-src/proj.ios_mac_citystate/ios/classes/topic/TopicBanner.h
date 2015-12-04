/*
 *[话题]topic界面图片轮播
 *功能设置：分页滚动、定时器
 */

#import "TopicManager.h"
#import "TopicItem.h"
@class TopicBanner;

@protocol TopicBannerDelegate <NSObject>
@optional
- (void)topicBanner:(TopicBanner *)banner didOnClick:(NSString *)topicID;
@end

@interface TopicBanner : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *dicts;
@property (nonatomic, weak) id<TopicBannerDelegate> delegate;
- (void)openTimer;
- (void)closeTimer;
@end
