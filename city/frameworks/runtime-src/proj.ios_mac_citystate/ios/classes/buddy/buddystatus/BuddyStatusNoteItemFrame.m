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
#import "NSString+Extension.h"
#import "TagItem.h"

@implementation BuddyStatusNoteItemFrame
- (void)setNoteItem:(BuddyStatusNoteItem *)noteItem
{
    _noteItem = noteItem;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat userIconWH = 45;
    CGFloat userIconX = BuddyStatusCellPadding;
    CGFloat userIconY = BuddyStatusCellPadding * 2;
    CGFloat userIconW = userIconWH;
    CGFloat userIconH = userIconWH;
    self.userIconFrame = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    
    CGFloat arrowIVY = userIconY;
    CGFloat arrowIVH = userIconH;
    CGFloat arrowIVW = arrowIVH;
    CGFloat arrowIVX = cellWidth - BuddyStatusCellPadding - arrowIVW;
    self.arrowIVFrame = CGRectMake(arrowIVX, arrowIVY, arrowIVW, arrowIVH);
    
    CGFloat userNameX = CGRectGetMaxX(self.userIconFrame) + BuddyStatusCellSubviewsMargin;
    CGFloat userNameY = userIconY;
    CGFloat userNameH = userIconH / 2;
    CGFloat userNameW = CGRectGetMidX(self.arrowIVFrame) - CGRectGetMaxX(self.userIconFrame) - 2 * BuddyStatusCellSubviewsMargin;
    self.userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameH);

    CGFloat dateX = userNameX;
    CGFloat dateY = CGRectGetMaxY(self.userNameFrame);
    CGFloat dateW = userNameW;
    CGFloat dateH = userNameH;
    self.dateFrame = CGRectMake(dateX, dateY, dateW, dateH);
    
    if (noteItem.imgs.count > 0) {
        CGFloat thumbY = CGRectGetMaxY(self.userIconFrame) + BuddyStatusCellSubviewsMargin;
        CGFloat thumbX = 0;
        CGSize thumbSize = CGSizeMake(cellWidth, BuddyStatusNoteNewThumbViewCellH);
        self.thumbFrame = (CGRect){{thumbX, thumbY}, thumbSize};
    } else {
        self.thumbFrame = self.userIconFrame; // 假数据，为了方便下面计算
    }
    
    NSString *noteText = noteItem.content;
    if (noteText.length > 0) {
        CGFloat noteTextX = userIconX;
        CGFloat noteTextY = CGRectGetMaxY(self.thumbFrame) + BuddyStatusCellSubviewsMargin;
        CGSize noteTextSize = [noteText sizeWithFont:BuddyStatusCellNoteTextFont andMaxSize:CGSizeMake(cellWidth - 2 * BuddyStatusCellPadding, MAXFLOAT)];
        self.noteTextFrame = (CGRect){{noteTextX, noteTextY}, noteTextSize};
    } else {
        self.noteTextFrame = self.thumbFrame;
    }
    
    if (noteItem.tags.count > 0) {
        if (noteItem.imgs.count > 0) { // 有图片
            CGFloat tagsViewW =  cellWidth - BuddyStatusNoteImageIndexLabelW;
            CGFloat tagsViewH = BuddyStatusNoteTagsViewH;
            CGFloat tagsViewX = 0;
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
        CGFloat placeTagX = 0;
        CGSize placeTagSize = CGSizeMake(cellWidth - 1.5 * BuddyStatusCellPadding, BuddyStatusNoteTagsViewH);
        if (noteItem.imgs.count > 0) { // 有图片
            CGFloat placeTagY = CGRectGetMaxY(self.noteTextFrame);
            self.placeTagFrame = (CGRect){{placeTagX, placeTagY}, placeTagSize};
        } else { // 无图片
            CGFloat placeTagY = CGRectGetMaxY(self.tagsFrame);
            self.placeTagFrame = (CGRect){{placeTagX, placeTagY}, placeTagSize};
        }
    } else {
        if (noteItem.imgs.count > 0) { // 有图片
            self.placeTagFrame = self.noteTextFrame;
        } else { // 无图片
            self.placeTagFrame = self.tagsFrame;
        }
    }
    
    CGFloat toolBarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(self.placeTagFrame) + BuddyStatusCellSubviewsMargin;
    CGFloat toolBarW = cellWidth;
    CGFloat toolBarH = 44;
    self.toolBarFrame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    self.cellHeight = CGRectGetMaxY(self.toolBarFrame);
}
@end
