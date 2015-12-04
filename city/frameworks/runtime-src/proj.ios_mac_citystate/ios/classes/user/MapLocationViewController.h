//
//  MapLocationViewController.h
//  citystate
//
//  Created by hf on 15/10/19.
//
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "StreetListInAreaViewController.h"

@protocol MapLocationVCDelegate;
@interface MapLocationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, StreetListInAreaVCDelegate>

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) BMKPoiInfo * selectePoi;

@end

#pragma mark -
#pragma mark MapLocationVCDelegate

@protocol MapLocationVCDelegate <NSObject>

@optional
- (void)VC:(MapLocationViewController *)cell didSelectedLocation:(BMKPoiInfo *)poiInfo;

@end