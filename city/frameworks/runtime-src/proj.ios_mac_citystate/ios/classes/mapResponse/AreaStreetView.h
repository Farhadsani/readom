//
//  AreaStreetView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/22.
//
//

#import <UIKit/UIKit.h>
#import "AreaStreetItem.h"

@class AreaStreetView;

@protocol AreaStreetViewDelegate <NSObject>
- (void)areaStreetView:(AreaStreetView *)areaStreetView didSelectItem:(AreaStreetItem *)areaStreetItem;
- (void)areaStreetViewHide:(AreaStreetView *)areaStreetView;
@end

@interface AreaStreetView : UIView
+ (instancetype)areaStreetViewWithAreaId:(NSInteger)areaid;
- (void)show;
- (void)hide;
@property (nonatomic, weak) id<AreaStreetViewDelegate> delegate;
@end
