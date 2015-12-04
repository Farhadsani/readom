//
//  BuddyStatusNoteThumbViewCell.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BuddyStatusNoteThumbViewCellWH 50
#define BuddyStatusNoteThumbViewCell_ID @"BuddyStatusNoteThumbViewCell"

@interface BuddyStatusNoteThumbViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign, getter=isSelect) BOOL select;
@property (nonatomic, weak) UIImageView  *imageView;


+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath;
@end
