//
//  HotTagCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <UIKit/UIKit.h>
#import "HotTag.h"

#define HotTagCell_ID @"HotTagCell"

@interface HotTagCell : UICollectionViewCell
@property (nonatomic, strong) HotTag *hotTag;
@end
