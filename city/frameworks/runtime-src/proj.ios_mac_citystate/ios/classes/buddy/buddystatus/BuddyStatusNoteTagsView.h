//
//  BuddyStatusNoteTagsView.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

/*
 *【好友动态】界面
 *功能：view的界面展示
 * BuddyStatusNoteTagsViewCell 展示 TagItem中的text。
 */

#import <UIKit/UIKit.h>
@class BuddyStatusNoteTagsView;

@protocol BuddyStatusNoteTagsViewDelegate <NSObject>
@optional
- (void)tagDidOnClick:(NSUInteger)index;
@end

@interface BuddyStatusNoteTagsView : UIView
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) UIColor *tagsColor;
@property (nonatomic, strong) UIFont *tagsFont;
@property (nonatomic, copy) NSString *iconName;
@property (weak, nonatomic) id<BuddyStatusNoteTagsViewDelegate>  delegate;
@end
