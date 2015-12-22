//
//  BuddyStatusSharedView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/12.
//
//

#import <UIKit/UIKit.h>

@class BuddyStatusSharedView;

typedef enum {
    BuddyStatusSharedViewBtnTypeFriends,
    BuddyStatusSharedViewBtnTypeFriendsGroup,
    BuddyStatusSharedViewBtnTypeWeiBo,
    BuddyStatusSharedViewBtnTypeQZone,
    BuddyStatusSharedViewBtnTypeAddFriend,
    BuddyStatusSharedViewBtnTypeReport
} BuddyStatusSharedViewBtnType;

typedef NS_ENUM(NSInteger, BuddyStatusSharedViewType){
    BuddyStatusSharedViewTypeWithoutAddFriend = 1,
    BuddyStatusSharedViewTypeWithAddFriend
};

@protocol BuddyStatusSharedViewDelegate <NSObject>
- (void)buddyStatusSharedViewDidClickSharedBtn:(BuddyStatusSharedViewBtnType)type;
@end

@interface BuddyStatusSharedView : UIView
@property (nonatomic, weak) id<BuddyStatusSharedViewDelegate> delegate;
+ (instancetype)sharedviewWithType:(BuddyStatusSharedViewType)type;
- (void)show;
- (void)hide;
@end
