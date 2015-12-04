//
//  AreaStreetCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/23.
//
//

#import <UIKit/UIKit.h>
#import "AreaStreetItem.h"

#define AreaStreetCell_ID @"AreaStreetCell"

@interface AreaStreetCell : UICollectionViewCell
@property (nonatomic, strong) AreaStreetItem *areaStreetItem;
@end
