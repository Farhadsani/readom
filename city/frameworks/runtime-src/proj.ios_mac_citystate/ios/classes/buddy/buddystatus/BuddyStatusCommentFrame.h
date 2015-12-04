//
//  BuddyStatusCommentFrame.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import <Foundation/Foundation.h>
#import "BuddyStatusComment.h"

#define BuddyStatusCommentCellUserNameFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define BuddyStatusCommentCellDateFont [UIFont fontWithName:k_defaultFontName size:12]
#define BuddyStatusCommentCellCommentTextFont [UIFont fontWithName:k_fontName_FZZY size:15]

#define BuddyStatusCommentCellPadding 10
#define BuddyStatusCommentCellSubviewsMargin 5

@interface BuddyStatusCommentFrame : NSObject
@property (nonatomic, assign) CGRect userIconFrame;
@property (nonatomic, assign) CGRect userNameFrame;
@property (nonatomic, assign) CGRect dateFrame;
@property (nonatomic, assign) CGRect commentTextFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) BuddyStatusComment *buddyStatusComment;
@end
