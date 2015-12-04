//
//  BuddyStatusCommentFrame.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import "BuddyStatusCommentFrame.h"

@implementation BuddyStatusCommentFrame
- (void)setBuddyStatusComment:(BuddyStatusComment *)buddyStatusComment
{
    _buddyStatusComment = buddyStatusComment;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat userIconWH = 45;
    CGFloat userIconX = BuddyStatusCommentCellPadding;
    CGFloat userIconY = BuddyStatusCommentCellPadding;
    CGFloat userIconW = userIconWH;
    CGFloat userIconH = userIconWH;
    self.userIconFrame = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    
    CGFloat userNameX = CGRectGetMaxX(self.userIconFrame) + BuddyStatusCommentCellSubviewsMargin;
    CGFloat userNameY = userIconY;
    CGFloat userNameH = userIconH / 2;
    CGFloat userNameW = cellWidth - CGRectGetMaxX(self.userIconFrame) - BuddyStatusCommentCellSubviewsMargin - BuddyStatusCommentCellPadding;
    self.userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    
    CGFloat dateX = userNameX;
    CGFloat dateY = CGRectGetMaxY(self.userNameFrame);
    CGFloat dateW = userNameW;
    CGFloat dateH = userNameH;
    self.dateFrame = CGRectMake(dateX, dateY, dateW, dateH);
    
    CGFloat commentTextX = userNameX;
    CGFloat commentTextY = CGRectGetMaxY(self.userIconFrame) + BuddyStatusCommentCellSubviewsMargin;
    CGSize commentTextSize = [buddyStatusComment.comment sizeWithFont:BuddyStatusCommentCellCommentTextFont andMaxSize:CGSizeMake(cellWidth - userNameX - BuddyStatusCommentCellPadding, MAXFLOAT)];
    self.commentTextFrame = (CGRect){{commentTextX, commentTextY}, commentTextSize};
    
    self.cellHeight = CGRectGetMaxY(self.commentTextFrame) + BuddyStatusCommentCellPadding;
}
@end
