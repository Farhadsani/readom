//
//  SightDetailIntroCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/20.
//
//

#import <UIKit/UIKit.h>
#import "SightDetailIntroItem.h"

@interface SightDetailIntroCell : UIView
+ (instancetype)sightDetailIntroCell;
@property (nonatomic, strong) SightDetailIntroItem *sightDetailIntroItem;
@end
