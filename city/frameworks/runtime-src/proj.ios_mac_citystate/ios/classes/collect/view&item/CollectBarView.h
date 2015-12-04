//
//  CollectBarView.h
//  citystate
//
//  Created by 小生 on 15/11/6.
//
//

#import <UIKit/UIKit.h>
#import "CollectItem.h"
#import "BuddyStatusNoteItem.h"

#define BuddyStatusToolBarCommentDidOnClick @"BuddyStatusToolBarCommentDidOnClick"
#define BuddyStatusToolBarCommentDidOnClickFeedid @"BuddyStatusToolBarCommentDidOnClickFeedid"

@interface CollectBarView : UIView
typedef enum {
    BarBtnTypeLike,
    BarBtnTypeComment,
    BarBtnTypeMore
} BarBtnType;

@property (nonatomic, strong) CollectItem *noteItem;
@property (nonatomic, strong) BuddyStatusNoteItem *statusItem;

+ (instancetype)toolBar;

@end
