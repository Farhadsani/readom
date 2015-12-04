//
//  BuddyViewController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

/*
 *【出访】界面
 *功能：查看[粉丝]、[关注]、[广场]的用户信息。
 *关注好友、取消关注好友、粉丝好友、查看好友个人空间
 *
 */

//#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "BuddyManager.h"
#import "TitleBar.h"

@interface BuddyViewController : BaseViewController<BuddyManagerDelegate,TitleBarDelegate,UITableViewDataSource,UITableViewDelegate,BuddyCellDelegate> {
    
}

@property (nonatomic, retain) NSArray * tName;
@property (nonatomic, retain) UIView *selectedView;
@property (strong, nonatomic) BuddyManager *buddyManager;

// 是否是其他人
@property (nonatomic, assign,getter=isOther) BOOL other;


@end
