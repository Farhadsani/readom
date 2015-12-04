//
//  PlaceTagViewController.h
//  citystate
//
//  Created by hf on 15/10/19.
//
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@protocol PlaceTagVCDelegate;
@interface PlaceTagViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<PlaceTagVCDelegate> delegate;

@end

#pragma mark -
#pragma mark PlaceTagVCDelegate

@protocol PlaceTagVCDelegate <NSObject>

@optional
- (void)VC:(PlaceTagViewController *)cell didSelectedPlaceTag:(BMKPoiInfo *)poiInfo;

@end