//
//  StoreCommentFrame.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreCommentFrame.h"
#import "NSString+Extension.h"

#define StoreCommentCellPadding 8
#define StoreCommentCellSubviewsMargin 5

@implementation StoreCommentFrame
- (void)setStoreComment:(StoreComment *)storeComment
{
    _storeComment = storeComment;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat userIconWH = 45;
    CGFloat userIconX = StoreCommentCellPadding;
    CGFloat userIconY = StoreCommentCellPadding;
    CGFloat userIconW = userIconWH;
    CGFloat userIconH = userIconWH;
    self.userIconFrame = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    
    CGFloat userNameX = CGRectGetMaxX(self.userIconFrame) + StoreCommentCellSubviewsMargin;
    CGFloat userNameY = userIconY;
    CGFloat userNameH = userIconH / 2;
    CGFloat userNameW = cellWidth - userNameX - StoreCommentCellPadding;
    self.userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    
    CGFloat startReateX = userNameX;
    CGFloat startReateY = CGRectGetMaxY(self.userNameFrame);
    CGFloat startReateW = 100;
    CGFloat startReateH = StoreCommentCellStartReateH;
    self.startReateFrame = CGRectMake(startReateX, startReateY, startReateW, startReateH);
    
    CGFloat startReateLabelX = CGRectGetMaxX(self.startReateFrame) + StoreCommentCellSubviewsMargin;
    CGFloat startReateLabelY = startReateY + 4;
    CGFloat startReateLabelW = 50;
    CGFloat startReateLabelH = startReateH - 4;
    self.startReateLabelFrame = CGRectMake(startReateLabelX, startReateLabelY, startReateLabelW, startReateLabelH);
    
    CGFloat timeLabelW = 80;
    CGFloat timeLabelH = userNameH;
    CGFloat timeLabelX = cellWidth - timeLabelW - StoreCommentCellPadding;
    CGFloat timeLabelY = startReateY;
    self.timeLabelFrame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    self.cellHight = CGRectGetMaxY(self.userIconFrame) + StoreCommentCellPadding;
    
    if (_storeComment.comment.length > 0) {
        CGSize contentLabeSize = [_storeComment.comment sizeWithFont:StoreCommentCellContentFont andMaxSize:CGSizeMake(cellWidth - userNameX - StoreCommentCellPadding, MAXFLOAT)];
        CGFloat contentLabelX = userNameX;
        CGFloat contentLabelY =  CGRectGetMaxY(self.userIconFrame) + StoreCommentCellSubviewsMargin;
        self.contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, contentLabeSize};
        self.cellHight = CGRectGetMaxY(self.contentLabelFrame) + StoreCommentCellPadding;
    } else {
        self.contentLabelFrame = self.userIconFrame;
    }
    

    if (_storeComment.photolink.count > 0) {
        CGFloat commentImgsViewX = userNameX;
        CGFloat commentImgsViewY =  CGRectGetMaxY(self.contentLabelFrame) + StoreCommentCellSubviewsMargin;
        CGFloat commentImgsViewW = cellWidth - commentImgsViewX - StoreCommentCellPadding;
        CGFloat commentImgsViewH = StoreCommentImgsViewCellWH;
        self.commentImgsViewFrame = (CGRect){{commentImgsViewX, commentImgsViewY}, {commentImgsViewW, commentImgsViewH}};
        self.cellHight = CGRectGetMaxY(self.commentImgsViewFrame) + StoreCommentCellPadding;
    }
}
@end
