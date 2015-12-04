//
//  CocosManager.m
//  citystate
//
//  Created by hf on 15/10/8.
//
//

#import "CocosManager.h"
#import "AppController.h"


@interface CocosManager (){
    
}

@end

static CocosManager * sharedManager = nil;

@implementation CocosManager

- (CCEAGLView *)cocosView{
    return ((AppController *)(APPLICATION)).eaglView;
}

- (BOOL)isMapStatus{
    return (self.viewType == CocosView_Map) ? YES : NO;
}

- (BOOL)isUserCenterStatus{
    return (self.viewType == CocosView_UserCenter) ? YES : NO;
}

- (void)addCocosMapView:(UIViewController *)vc{
    UIViewController * v = vc;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        v = ((UINavigationController *)vc).visibleViewController;
    }
    
    InfoLog(@"%@", v.view);
    
    if (![v.view.subviews containsObject:self.cocosView]) {
        [v.view addSubview:self.cocosView];
    }
    
//    [v.view bringSubviewToFront:self.cocosView];
    
    for (UIView * vi in v.view.subviews) {
        if ([vi isKindOfClass:[UINavigationBar class]] || vi.tag == k_NavBarTag) {
            [v.view bringSubviewToFront:vi];
            break;
        }
    }
    
    self.cocosView.frame = CGRectMake(self.cocosView.x, 0, self.cocosView.width, self.cocosView.height);
}

- (void)removeCocosMapView:(UIViewController *)vc{
    UIViewController * v = vc;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        v = ((UINavigationController *)vc).visibleViewController;
    }
    
    for (UIView * vi in v.view.subviews) {
        if ([vi isEqual:self.cocosView]) {
            [self.cocosView removeFromSuperview];
            break;
        }
    }
}

- (void)addCocosUserCenterView:(UIViewController *)vc{
    UIViewController * v = vc;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        v = ((UINavigationController *)vc).visibleViewController;
    }
    
    if (![v.view.subviews containsObject:self.cocosView]) {
        [v.view addSubview:self.cocosView];
    }
    
    [v.view bringSubviewToFront:self.cocosView];
    
    for (UIView * vi in v.view.subviews) {
        if ([vi isKindOfClass:[UINavigationBar class]] || vi.tag == k_NavBarTag) {
            [v.view bringSubviewToFront:vi];
            break;
        }
    }
    
    self.cocosView.frame = CGRectMake(self.cocosView.x, 0, self.cocosView.width, self.cocosView.height);
}

+ (CocosManager *)shared{
    if (sharedManager == nil) {
        sharedManager = [[CocosManager alloc] init];
        sharedManager.viewType = CocosView_Map;
        return sharedManager;
    }
    
    return sharedManager;
}

+ (id) alloc {
    @synchronized ([CocosManager class]) {
        sharedManager = [super alloc];
        return sharedManager;
    }
    
    return nil;
}

- (void)dealloc{
    [super dealloc];
}


@end
