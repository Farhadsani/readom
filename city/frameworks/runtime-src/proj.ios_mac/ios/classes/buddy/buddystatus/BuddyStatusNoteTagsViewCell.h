//
//  BuddyStatusNoteTagsViewCell.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BuddyStatusNoteTagsViewCell_ID @"BuddyStatusNoteTagsViewCell"

@interface BuddyStatusNoteTagsViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath;
@end
