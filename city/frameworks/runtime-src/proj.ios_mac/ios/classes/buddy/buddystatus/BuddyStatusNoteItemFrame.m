//
//  BuddyStatusNoteItemFrame.m
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

#import "BuddyStatusNoteItemFrame.h"
//#import "BuddyStatusNoteThumbView.h"
#import "BuddyStatusNotePlaceTagsView.h"
#import "NSString+Extension.h"
#import "TagItem.h"

@implementation BuddyStatusNoteItemFrame
- (void)setNoteItem:(BuddyStatusNoteItem *)noteItem
{
    _noteItem = noteItem;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat userIconWH = 45;
    CGFloat userIconX = BuddyStatusCellPadding;
    CGFloat userIconY = BuddyStatusCellPadding;
    CGFloat userIconW = userIconWH;
    CGFloat userIconH = userIconWH;
    self.userIconFrame = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    
//    int progress = [self computeProgress:noteItem];
//    noteItem.complete = progress;
//    
//    CGSize completeTextSize = [[NSString stringWithFormat:@"%d%%", progress] sizeWithFont:BuddyStatusCellCompleteTextFont andMaxSize:CGSizeMake(cellWidth, MAXFLOAT)];
//    CGFloat completeTextH = userIconH;
//    CGFloat completeTextW = completeTextSize.width;
//    CGFloat completeTextX = cellWidth - BuddyStatusCellPadding - completeTextW;
//    CGFloat completeTextY = userIconY;
//    self.completeTextFrame = CGRectMake(completeTextX, completeTextY, completeTextW, completeTextH);
//    
//    CGFloat completePVW = 50;
//    CGFloat completePVH = 14;
//    CGFloat completePVX = cellWidth - BuddyStatusCellPadding - completeTextW - BuddyStatusCellSubviewsMargin - completePVW;
//    CGFloat completePVY = CGRectGetMidY(self.completeTextFrame) - completePVH * 0.5;
//    self.completePVFrame = CGRectMake(completePVX, completePVY, completePVW, completePVH);
    
    CGFloat arrowIVY = userIconY;
    CGFloat arrowIVH = userIconH;
    CGFloat arrowIVW = arrowIVH;
    CGFloat arrowIVX = cellWidth - BuddyStatusCellPadding - arrowIVW;
    self.arrowIVFrame = CGRectMake(arrowIVX, arrowIVY, arrowIVW, arrowIVH);
    
    CGFloat userNameX = CGRectGetMaxX(self.userIconFrame) + BuddyStatusCellSubviewsMargin;
    CGFloat userNameY = userIconY;
    CGFloat userNameH = userIconH / 2;
    if (noteItem.user.intro.length == 0) {
        userNameH = userIconH;
    }
//    CGFloat userNameW = CGRectGetMidX(self.completePVFrame) - CGRectGetMaxX(self.userIconFrame) - 2 * BuddyStatusCellSubviewsMargin;
    CGFloat userNameW = CGRectGetMidX(self.arrowIVFrame) - CGRectGetMaxX(self.userIconFrame) - 2 * BuddyStatusCellSubviewsMargin;
    self.userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameH);

    CGFloat userIntroX = userNameX;
    CGFloat userIntroY = CGRectGetMaxY(self.userNameFrame);
    CGFloat userIntroW = userNameW;
    CGFloat userIntroH = userNameH;
    self.userIntroFrame = CGRectMake(userIntroX, userIntroY, userIntroW, userIntroH);
    
    if (noteItem.thumbs.count > 0) {
//        CGFloat thumbX = userIconX;
        CGFloat thumbY = CGRectGetMaxY(self.userIconFrame) + BuddyStatusCellSubviewsMargin;
//        CGSize thumbSize = [BuddyStatusNoteThumbView size];
        CGFloat thumbX = 0;
        CGSize thumbSize = CGSizeMake(cellWidth, BuddyStatusNoteNewThumbViewCellH);
        self.thumbFrame = (CGRect){{thumbX, thumbY}, thumbSize};
    } else {
        self.thumbFrame = self.userIconFrame; // 假数据，为了方便下面计算
    }
    
    NSString *noteText = noteItem.note;
    if (noteText.length > 0) {
        CGFloat noteTextX = userIconX;
        CGFloat noteTextY = CGRectGetMaxY(self.thumbFrame) + BuddyStatusCellSubviewsMargin;
        CGSize noteTextSize = [noteText sizeWithFont:BuddyStatusCellNoteTextFont andMaxSize:CGSizeMake(cellWidth - 2 * BuddyStatusCellPadding, MAXFLOAT)];
        self.noteTextFrame = (CGRect){{noteTextX, noteTextY}, noteTextSize};
    } else {
        self.noteTextFrame = self.thumbFrame;
    }
    
    if (noteItem.tags.count > 0) {
        if (noteItem.thumbs.count > 0) { // 有图片
//            CGFloat tagsViewW =  cellWidth - 2 * BuddyStatusNoteThumbViewPadding - 2 * BuddyStatusCellPadding;
//            CGFloat tagsViewH = BuddyStatusNoteTagsViewH;
//            CGFloat tagsViewX = BuddyStatusCellPadding + BuddyStatusNoteThumbViewPadding;
//            CGFloat tagsViewY = CGRectGetMinY(self.thumbFrame) + BuddyStatusNoteThumbViewPadding + CGRectGetWidth(self.thumbFrame) * 0.5  - tagsViewH;
            CGFloat tagsViewW =  cellWidth - 2 * BuddyStatusCellPadding - BuddyStatusNoteImageIndexLabelW;
            CGFloat tagsViewH = BuddyStatusNoteTagsViewH;
            CGFloat tagsViewX = BuddyStatusCellPadding;
            CGFloat tagsViewY = CGRectGetMaxY(self.thumbFrame) - tagsViewH;
            self.tagsFrame = CGRectMake(tagsViewX, tagsViewY, tagsViewW, tagsViewH);
        } else {  // 无图片
            CGFloat tagsViewX = userIconX;
            CGFloat tagsViewY = CGRectGetMaxY(self.noteTextFrame) + BuddyStatusCellSubviewsMargin;
            CGSize tagsSize = CGSizeMake(cellWidth - 2 * BuddyStatusCellPadding, BuddyStatusNoteTagsViewH);
            self.tagsFrame = (CGRect){{tagsViewX, tagsViewY}, tagsSize};
        }
    } else {
        self.tagsFrame = self.noteTextFrame;
    }
    
    if (noteItem.place.count > 0) {
        CGFloat placeTagX = userIconX;
        CGSize placeTagSize = CGSizeMake(cellWidth - 2 * BuddyStatusCellPadding, BuddyStatusNoteTagsViewH);
        if (noteItem.thumbs.count > 0) { // 有图片
            CGFloat placeTagY = CGRectGetMaxY(self.noteTextFrame) + BuddyStatusCellSubviewsMargin;
            self.placeTagFrame = (CGRect){{placeTagX, placeTagY}, placeTagSize};
        } else { // 无图片
            CGFloat placeTagY = CGRectGetMaxY(self.tagsFrame) + BuddyStatusCellSubviewsMargin;
            self.placeTagFrame = (CGRect){{placeTagX, placeTagY}, placeTagSize};
        }
    } else {
        if (noteItem.thumbs.count > 0) { // 有图片
            self.placeTagFrame = self.noteTextFrame;
        } else { // 无图片
            self.placeTagFrame = self.tagsFrame;
        }
    }
    
    CGFloat likedW = 60;
    CGFloat likedX = cellWidth - BuddyStatusCellPadding - likedW;
    
    CGFloat topicTextX = userIconX;
    CGFloat topicTextY = CGRectGetMaxY(self.placeTagFrame) + BuddyStatusCellSubviewsMargin;
    NSString *topicText = noteItem.topic;
    CGSize topicTextSize = [[NSString stringWithFormat:@"#%@#", topicText] sizeWithFont:BuddyStatusCellTopicTextFont andMaxSize:CGSizeMake(cellWidth - 2 * BuddyStatusCellPadding - BuddyStatusNoteTagsViewH, MAXFLOAT)];
    self.topicTextFrame = (CGRect){{topicTextX, topicTextY}, {likedX - BuddyStatusCellPadding - BuddyStatusCellSubviewsMargin, topicTextSize.height}};
    
    CGFloat likedH = CGRectGetHeight(self.topicTextFrame);
    CGFloat likedY = topicTextY;
    self.likedFrame = CGRectMake(likedX, likedY, likedW, likedH);
    
    self.cellHeight = CGRectGetMaxY(self.likedFrame) + BuddyStatusCellPadding;
}

///**
// *  计算完成度
// */
//- (int)computeProgress:(BuddyStatusNoteItem *)noteItem
//{
//    int progress = 0;
//    if (noteItem.imgs.count == 1) {
//        progress += 50;
//    } else if (noteItem.imgs.count >= 2) {
//        progress += 70;
//    }
//    
//    if (noteItem.note.length > 0) {
//        progress += 10;
//    }
//    if (noteItem.tags.count > 0) {
//        progress += 10;
//    }
//    if (noteItem.place.count > 0) {
//        progress += 10;
//    }
//    
//    return progress;
//}
@end
