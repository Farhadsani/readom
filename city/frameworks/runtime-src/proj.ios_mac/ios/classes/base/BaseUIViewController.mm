#import "BaseUIViewController.h"
#import "AppDelegate.h"
#import "LoggerClient.h"
#import "IIViewDeckController.h"
/*
 *所有Controller的父类
 *
 */
@implementation BaseUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    baseHud = [[MBProgressHUD alloc] initWithView:self.view];
    baseHud.mode = MBProgressHUDModeText;
    baseHud.removeFromSuperViewOnHide = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    baseNavBarHairlineImageView = [self baseFindHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];  //设置背景
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    baseNavBarHairlineImageView.hidden = NO;
    
    CGRect frame = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.frame = CGRectMake(frame.origin.x, 0, frame.size.width, 64);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    baseNavBarHairlineImageView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIImageView *)baseFindHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self baseFindHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)setCocosCallback:(CocosCallback)pCocosCallback {
    callback = pCocosCallback;
}

- (void)baseShowTopHud:(NSString *)text {
    baseHud.yOffset = -180.0f;
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
    [baseHud hide:YES afterDelay:1.5];
}

- (void)baseShowMidHud:(NSString *)text {
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
    [baseHud hide:YES afterDelay:1.5];
}

- (void)baseShowBotHud:(NSString *)text {
    baseHud.yOffset = 180.0f;
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
    [baseHud hide:YES afterDelay:1.5];
}

- (void)baseShowMidHudAllways:(NSString *)text
{
    baseHud.labelText = text;
    [self.view addSubview:baseHud];
    baseHud.opacity = 0.7;
    [baseHud show:YES];
}

- (void)baseHideMidHud
{
    [baseHud hide:YES];
}

- (void)baseDeckAndNavBack {
    //    //ctrol现在是UITabBarController
    //    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //    //切换第二视图
    //    [ctrol setSelectedIndex:0];
    
    //ctrol现在是IIViewDeckController
    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //切换第二视图
    [ctrol toggleTopViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        [self baseNavBack];
        [[LoadingView shared] hideLoading];
    }];
}
- (void)baseDeckBack {
    //    //ctrol现在是UITabBarController
    //    UITabBarController* ctrol=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //    //切换第二视图
    //    [ctrol setSelectedIndex:0];
    
    //ctrol现在是IIViewDeckController
    IIViewDeckController* ctrol=(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //切换第二视图
    [ctrol toggleTopViewAnimated:YES];
}
- (void)baseNavBack {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)baseBack:(id)sender
{
    [self.view endEditing:YES];
    [self baseNavBack];
}

- (void)toCocos : (long) userID
                : (NSString *) name
                : (NSString *) intro
                : (NSString *) zone
                : (NSString *) thumblink
                : (NSString *) imglink
{
    if(toCocosCallback)
    {
        toCocosCallback(userID, name, intro, zone, thumblink, imglink);
    }
}

- (void)toMap
{
    if (toMapCallback)
    {
        toMapCallback();
    }
}

- (void)backUserHome
{
    if (backUserHomeCallback)
    {
        backUserHomeCallback();
    }
}

+ (void)setToCocosCallback:(ToCocosCallback)pToCocosCallback
{
    toCocosCallback = pToCocosCallback;
}

+ (void)setToMapCallback:(ToMapCallback)pToMapCallback
{
    toMapCallback = pToMapCallback;
}

+ (void)setBackUserHome:(BackUserHomeCallback) pBackUserHomeCallback
{
    backUserHomeCallback = pBackUserHomeCallback;
}

@end
