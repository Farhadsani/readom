//
//  ExponentCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/10.
//
//

#import <UIKit/UIKit.h>
#import "ExponentItem.h"

#define ExponentCell_ID @"ExponentCell"

@interface ExponentCell : UICollectionViewCell
@property (nonatomic, strong) ExponentItem *exponentItem;
@end
