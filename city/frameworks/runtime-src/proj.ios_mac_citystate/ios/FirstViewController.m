//
//  FirstViewController.m
//  qmap
//
//  Created by hf on 15/9/23.
//
//

#import "FirstViewController.h"
#import "SlideNavigationViewController.h"
#import "RootViewController.h"
#import "SquareViewController.h"
#import "MessageTabController.h"
#import "AppController.h"
#import "PostViewController.h"
#import "CocosMapIndexRootViewController.h"
#import "CocosUserCenterRootViewController.h"
#import "GuideView.h"

@interface FirstViewController () <GuideVDelegate> {
    GuideView * guideV;
}

@end

@implementation FirstViewController

- (void)variableInit{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super variableInit];
    self.hasLeftNavBackButton = NO;
    _lastSelectedIndexOfTabBarController = ((AppController *)([[UIApplication sharedApplication] delegate])).lastSelectedIndexOfTabBarController;
}

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self initTabbarViewController];
    
    [self loadMainMenuView];
    
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    
    [self loadGuideViews];
}

- (void)loadMainMenuView{
    [self.view addSubview:self.tabBarController.view];
//    APPLICATION.window.rootViewController = self.tabBarController;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

#pragma mark - delegate (CallBack)

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == [tabBarController.viewControllers indexOfObject:viewController]) {
        return NO;
    }
    
    if ([viewController isEqual:[self.tabBarController.viewControllers objectAtIndex:0]]) {
        if (![[CocosManager shared] isMapStatus]) {
            UIViewController * vc = viewController;
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                vc = [(UINavigationController *)viewController topViewController];
            }
            if ([vc isKindOfClass:[CocosMapIndexRootViewController class]]) {
                CocosMapIndexRootViewController * cocosVc = (CocosMapIndexRootViewController *)vc;
                if (!cocosVc.currentIndexId) {
                    [self toMap:MapIndexType_sight indexId:nil];
                }
                else{
                    [self toMap:cocosVc.currentMapIndexType indexId:(cocosVc.currentMapIndexType==MapIndexType_social)?nil:cocosVc.currentIndexId];
                }
            }
            else{
                [self toMap:MapIndexType_sight indexId:nil];
            }
            
            [[CocosManager shared] addCocosMapView:viewController];
            self.tabBarController.tabBar.userInteractionEnabled = NO;
            [self performSelector:@selector(enableTabbar) withObject:nil afterDelay:0.6];
        }
    }
    else if ([viewController isEqual:[self.tabBarController.viewControllers lastObject]]) {
        if (![[CocosManager shared] isUserCenterStatus]) {
            [self toCocos:[UserManager sharedInstance].userid
                         :[UserManager sharedInstance].brief.name
                         :[UserManager sharedInstance].brief.intro
                         :[UserManager sharedInstance].brief.name
                         :[UserManager sharedInstance].brief.thumblink
                         :[UserManager sharedInstance].brief.imglink];
//            [self backUserHome:0];
            [[CocosManager shared] addCocosUserCenterView:viewController];
            self.tabBarController.tabBar.userInteractionEnabled = NO;
            [self performSelector:@selector(enableTabbar) withObject:nil afterDelay:0.6];
        }
    }
    else if ([viewController isEqual:[self.tabBarController.viewControllers objectAtIndex:2]]) {
        [self hideTabBar:YES animation:YES];
        PostViewController * vc = [[[PostViewController alloc] init] autorelease];
        SlideNavigationViewController *midviewControllerNav = [[SlideNavigationViewController alloc] initWithRootViewController:vc];
        UIViewController * vc2 = [((AppController *)APPLICATION) getVisibleViewController];
        [vc2 presentViewController:midviewControllerNav animated:YES completion:nil];
//        [self.view.window.rootViewController presentViewController:midviewControllerNav animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)initTabbarViewController{
    CocosMapIndexRootViewController *cocosMapIndexVC = [[CocosMapIndexRootViewController alloc] initWithNibName:nil bundle:nil];
    SlideNavigationViewController *cocosMapIndexVCNav = [[[SlideNavigationViewController alloc] initWithRootViewController:cocosMapIndexVC] autorelease];
    cocosMapIndexVC.title = @"指数";
    cocosMapIndexVCNav.wantsFullScreenLayout = YES;
    UIImage *image = [UIImage imageNamed:@""];
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cocosMapIndexVC.tabBarItem initWithTitle:@"指数" image:[[UIImage imageNamed:@"exponent.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"exponent_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    SquareViewController * squareVC = [[SquareViewController alloc] initWithNibName:nil bundle:nil];
    squareVC.title = @"广场";
    SlideNavigationViewController *squareVCNav = [[[SlideNavigationViewController alloc] initWithRootViewController:squareVC] autorelease];
    [squareVC.tabBarItem initWithTitle:@"广场" image:[[UIImage imageNamed:@"square.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"square_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* midviewController = [[[UIViewController alloc] init] autorelease];
    SlideNavigationViewController *midviewControllerNav = [[[SlideNavigationViewController alloc] initWithRootViewController:midviewController] autorelease];
    
    [midviewController.tabBarItem initWithTitle:@"" image:[[UIImage imageNamed:@"pluspost.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"pluspost.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    midviewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    MessageTabController * messageVC = [[MessageTabController alloc] initWithNibName:nil bundle:nil];
    messageVC.title = @"消息";
    SlideNavigationViewController *messageVCNav = [[[SlideNavigationViewController alloc] initWithRootViewController:messageVC] autorelease];
    [messageVC.tabBarItem initWithTitle:@"消息" image:[[UIImage imageNamed:@"message.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"message_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    CocosUserCenterRootViewController *cocosUserCenterVC = [[CocosUserCenterRootViewController alloc] initWithNibName:nil bundle:nil];
    cocosUserCenterVC.title = @"我的";
    SlideNavigationViewController *cocosUserCenterVCNav = [[[SlideNavigationViewController alloc] initWithRootViewController:cocosUserCenterVC] autorelease];
    cocosUserCenterVC.wantsFullScreenLayout = YES;
    [cocosUserCenterVC.tabBarItem initWithTitle:@"我的" image:[[UIImage imageNamed:@"my.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"my_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[cocosMapIndexVCNav,squareVCNav,midviewControllerNav, messageVCNav, cocosUserCenterVCNav];
    self.tabBarController.delegate = self;
    [self.tabBarController setSelectedIndex:_lastSelectedIndexOfTabBarController];
    [CocosManager shared].viewType = CocosView_Map;//默认是地图模式
    
    [self setTabBarStyle];
    
    //初始化隐藏导航栏和tabbar，等待cocos的通知
    [self hiddenTabBarAndNavBar];
}

#pragma mark

- (void)showTabBarAndNavBar{
    [[self getFirstVCOfTabbar] setNavigationBarHidden:NO animated:YES];
    [self hideTabBar:NO animation:YES];
}

- (void)hiddenTabBarAndNavBar{
    [[self getFirstVCOfTabbar] setNavigationBarHidden:YES animated:NO];
    [self hideTabBar:YES animation:NO];
}

- (UINavigationController *)getFirstVCOfTabbar{
    id obj = [[self.tabBarController viewControllers] objectAtIndex:0];
    UINavigationController * nav = nil;
    if ([obj isKindOfClass:[UINavigationController class]]) {
        nav = obj;
    }
    else{
        nav = ((UIViewController *)obj).navigationController;
    }
    return nav;
}

- (void)enableTabbar{
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

#pragma mark

- (void)setTabBarStyle{
    [[UITabBar appearance] setClipsToBounds:YES];//隐藏tabbar上的那条分隔线
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    [[UITabBar appearance] setTranslucent:YES];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]]];

    if (k_NO_LESS_THAN_IOS(7.0)) {
        [[UITabBar appearance] setBarTintColor:[UIColor lightGrayColor]];
    }else{
        [[UITabBar appearance] setTintColor:[UIColor lightGrayColor]];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontName_FZZY size:14],
                                                        NSForegroundColorAttributeName: [UIColor lightGrayColor]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontName_FZZY size:14],
                                                        NSForegroundColorAttributeName: [UIColor color:darkblack_color]}
                                             forState:UIControlStateHighlighted];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontName_FZZY size:14],
                                                        NSForegroundColorAttributeName: [UIColor color:darkblack_color]}
                                             forState:UIControlStateSelected];
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark 引导

- (void)loadGuideViews{
    id flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_LUNCH_FLAG"];
    if (!flag) {
        //第一次启动，需要加载引导页
        [[UserManager sharedInstance] signout];
        [self addGuidePage];
    }
}

//添加引导界面
- (void)addGuidePage{
    if (guideV) {
        if (guideV.superview) {
            [guideV removeFromSuperview];
        }
        [guideV release];
    }
    guideV = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    guideV.delegate = self;
    guideV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:guideV];
}

//引导结束时回调
- (void)guideViewDidClose{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FIRST_LUNCH_FLAG"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

@end
