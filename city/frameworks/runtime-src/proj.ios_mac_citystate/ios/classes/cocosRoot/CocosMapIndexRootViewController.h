//
//  CocosMapIndexRootViewController.h
//  citystate
//
//  Created by hf on 15/10/8.
//
//

#import "RootViewController.h"
#import "ExponentViewController.h"

@class SightDetailViewController;
@interface CocosMapIndexRootViewController : RootViewController <ExponentVCDelegate>

@property (nonatomic) MapIndexType currentMapIndexType;     // 存放当前选择的指数的类型
@property (nonatomic, strong) NSString * currentIndexId;    // 存放当前选择的指数的ID
@property (nonatomic, strong) UIViewController * sightDetailViewController;    //

- (void)showSightDetailView:(UIViewController *)vc;

@end
