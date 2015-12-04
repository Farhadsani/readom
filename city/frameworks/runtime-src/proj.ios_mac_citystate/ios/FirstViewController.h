//
//  FirstViewController.h
//  qmap
//
//  Created by hf on 15/9/23.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FirstViewController : BaseViewController <UITabBarControllerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic) NSInteger lastSelectedIndexOfTabBarController;

- (void)showTabBarAndNavBar;

@end
