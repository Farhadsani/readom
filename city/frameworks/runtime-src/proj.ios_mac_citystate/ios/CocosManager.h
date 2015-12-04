//
//  CocosManager.h
//  citystate
//
//  Created by hf on 15/10/8.
//
//

#import <UIKit/UIKit.h>
#import "platform/ios/CCEAGLView-ios.h"

typedef enum CocosViewStatus{
    CocosView_Map = 0,       //Cocos当前显示的是地图
    CocosView_UserCenter,    //Cocos当前显示的是个人中心
}CocosViewStatus;

@interface CocosManager : NSObject

@property (nonatomic, assign) CocosViewStatus viewType;

+ (CocosManager *)shared;
- (CCEAGLView *)cocosView;

- (BOOL)isMapStatus;
- (BOOL)isUserCenterStatus;

- (void)addCocosMapView:(UIViewController *)vc;
- (void)removeCocosMapView:(UIViewController *)vc;
- (void)addCocosUserCenterView:(UIViewController *)vc;


@end
