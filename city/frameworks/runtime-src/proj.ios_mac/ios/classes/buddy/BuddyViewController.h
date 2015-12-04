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
#import "BuddyListView.h"
#import "BuddyManager.h"

@interface BuddyViewController : BaseViewController<BuddyListDelegate,BuddyManagerDelegate> {
    
}

@property (strong, nonatomic) BuddyListView    *listView;

- (void) onTouch:(id)sender;
- (void) setUserData:(long)userID :(NSString*) name :(NSString*)intro : (NSString*)zonename : (NSString*)thumblink : (NSString*)imglink ;

@end
