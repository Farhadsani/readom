//
//  TopicController.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/31.
//
//

/*
 *[话题]页面
 *功能：显示话题列表、进入地图
 */

#import "BaseViewController.h"
#import "TopicBanner.h"

@interface TopicController : BaseViewController<TopicBannerDelegate>
@property (nonatomic, assign) int index;
- (void)setUserData:(long)userID;
@end
