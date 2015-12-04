//
//  BuddyStatusNoteItemFrame.h
//  qmap
//
//  Created by 小玛依 on 15/8/24.
//
//

/*
 *【好友动态】界面
 *功能：计算cell中每个控件高度，适配
 *
 */

#import <Foundation/Foundation.h>
#import "BuddyStatusNoteItem.h"

#define BuddyStatusCellUserNameFont [UIFont fontWithName:k_fontName_FZZY size:14]
//#define BuddyStatusCellCompleteTextFont [UIFont fontWithName:k_fontName_FZXY size:13]
#define BuddyStatusCellUserIntroFont [UIFont fontWithName:k_fontName_FZXY size:13]
#define BuddyStatusCellNoteTextFont [UIFont fontWithName:k_fontName_FZXY size:14]
#define BuddyStatusCellTopicTextFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface BuddyStatusNoteItemFrame : NSObject
@property (nonatomic, assign) CGRect userIconFrame;
@property (nonatomic, assign) CGRect userNameFrame;
//@property (nonatomic, assign) CGRect completePVFrame;
//@property (nonatomic, assign) CGRect completeTextFrame;
@property (nonatomic, assign) CGRect userIntroFrame;
//@property (nonatomic, assign) CGRect thumbFrame;
@property (nonatomic, assign) CGRect thumbFrame;
@property (nonatomic, assign) CGRect noteTextFrame;
@property (nonatomic, assign) CGRect placeTagFrame;
@property (nonatomic, assign) CGRect tagsFrame;
@property (nonatomic, assign) CGRect topicTextFrame;
@property (nonatomic, assign) CGRect likedFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) BuddyStatusNoteItem *noteItem;
@property (nonatomic, assign) CGRect arrowIVFrame;
@end
