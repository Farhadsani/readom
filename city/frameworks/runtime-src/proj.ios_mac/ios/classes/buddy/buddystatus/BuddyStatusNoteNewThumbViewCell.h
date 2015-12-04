//
//  BuddyStatusNoteNewThumbViewCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/9/18.
//
//

#import <UIKit/UIKit.h>

#define BuddyStatusNoteNewThumbViewCell_ID @"BuddyStatusNoteNewThumbViewCell"

@interface BuddyStatusNoteNewThumbViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, weak) UIImageView  *imageView;

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath;
@end
