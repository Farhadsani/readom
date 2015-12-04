//
//  StreetListInAreaViewController.h
//  citystate
//
//  Created by hf on 15/11/17.
//
//

#import "BaseViewController.h"
#import "AreaStreetItem.h"

@protocol StreetListInAreaVCDelegate;
@interface StreetListInAreaViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<StreetListInAreaVCDelegate> delegate;
@property (nonatomic, strong) BMKPoiInfo * selectePoi;
@property (nonatomic, strong) AreaStreetItem * streetItem;

@end

#pragma mark -
#pragma mark StreetListInAreaVCDelegate

@protocol StreetListInAreaVCDelegate <NSObject>

@optional
- (void)VC:(StreetListInAreaViewController *)cell didSelectedLocation:(BMKPoiInfo *)poiInfo streetInfo:(AreaStreetItem *)streetItem;

@end