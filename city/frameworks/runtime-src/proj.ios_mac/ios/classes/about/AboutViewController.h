//
//  AboutViewController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/15.
//
//

/*
 *【关于城市达人】界面
 *功能：城市达人简介、分享应用、好评、反馈意见
 *
 */

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import <StoreKit/StoreKit.h>

@interface FollowItem : NSObject
@property (strong, atomic) NSString *strCaption;
@property (assign, atomic) SEL callBack ;
@end

@interface AboutViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,SKStoreProductViewControllerDelegate>

@end
