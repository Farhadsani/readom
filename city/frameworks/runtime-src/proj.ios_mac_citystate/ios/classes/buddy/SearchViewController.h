//
//  SearchViewController.h
//  citystate
//
//  Created by 小生 on 15/10/25.
//
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController

//@property (nonatomic, strong) UINavigationItem *searchNavigationItem;

@property (nonatomic, copy) void(^cancel)();

@end
