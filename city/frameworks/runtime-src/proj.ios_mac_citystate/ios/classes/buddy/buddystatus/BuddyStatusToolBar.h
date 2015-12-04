//
//  BuddyStatusToolBar.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/12.
//
//

#import <UIKit/UIKit.h>
#import "BuddyStatusNoteItem.h"

#define BuddyStatusToolBarCommentDidOnClick @"BuddyStatusToolBarCommentDidOnClick"
#define BuddyStatusToolBarCommentDidOnClickFeedid @"BuddyStatusToolBarCommentDidOnClickFeedid"

typedef void (^BackBlock)();
typedef enum {
    ToolBarBtnTypeLike,
    ToolBarBtnTypeComment,
    ToolBarBtnTypeMore
} ToolBarBtnType;

@interface BuddyStatusToolBar : UIView
@property (nonatomic, strong) BuddyStatusNoteItem *noteItem;
@property (nonatomic, copy) BackBlock back;
+ (instancetype)toolBar;
@end
