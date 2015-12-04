//
//  CocosViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/9.
//
//

/**
 *  别人的个人中心
 */
#import "RootViewController.h"
#import "BuddyItem.h"

typedef NS_ENUM(NSInteger, CocosViewControllerBackType){
    CocosViewControllerBackTypeIOS,
    CocosViewControllerBackTypeCoCos
};

@interface CocosViewController : RootViewController
@property (nonatomic, retain) BuddyItem * buddyItem;
/**
 *  创建一个包装Cocos的view的控制器，参数backType、indexType用于返回时判断处理
 *
 *  @param backType  返回时的界面类型（iOS、Cocos）
 *  @param mapIndexType 返回时的界面是Cocos时，则Cocos地图的类型（景点、社交指数、热门标签、消费指数）
 */
+ (instancetype)cocosViewControllerWithBackType:(CocosViewControllerBackType)backType mapIndexType:(MapIndexType)mapIndexType;
@end
