//
//  BaseViewController.m
//  cxy
//
//  Created by hf on 15/6/5.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import "BaseViewController.h"
#import "IIViewDeckController.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize contentView = _contentView;
@synthesize data_dict = _data_dict;
@synthesize contentViewHeight = _contentViewHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self variableInit];
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        [self variableInit];
    }
    return self;
}
- (void)variableInit{
    if (!_data_dict) {
        _data_dict = [[NSMutableDictionary alloc] init];
    }
    if (!_post_dict) {
        _post_dict = [[NSMutableDictionary alloc] init];
    }
    _hidTopStatusBar = YES;
    _hasLeftNavBackButton = YES;
    _hidTabbarBar = YES;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    if (k_NO_LESS_THAN_IOS(7)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self.view setBackgroundColor:k_defaultViewControllerBGColor];
    
    if (_hasLeftNavBackButton) {
        [self setupLeftBackButtonItem:nil img:nil action:nil];
    }
    
    [self createContentCantainer];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - delegate (CallBack)

#pragma mark request
- (void)didStartLoad:(Reqest *)req{}
- (void)didReceiveResponse:(Reqest *)req responseHead:(NSDictionary *)heads{}
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{}
- (void)didLoading:(Reqest *)req withProcess:(NSString *)process{}
#pragma mark UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - action such as: click touch tap slip ...

#pragma mark 检查当前登录状态，未登录则跳转到登录界面
- (void)tryCheckLogin{
//    [[LoginHelper shared] tryCheckLogin:self];
}

- (void)resetFrameHeightOfView:(UIView *)view{
    if (view) {
        CGFloat maxHeight = 0.0;
        for (UIView * v in view.subviews) {
            maxHeight = (v.y + v.height > maxHeight) ? v.y + v.height : maxHeight;
        }
        if (maxHeight > 0) {
            view.frame = CGRectMake(view.x, view.y, view.width, maxHeight+10);
        }
    }
}

- (void)reloadContentViewIfNeeded{
    BOOL isNanHidden = ((UINavigationController *)self.navigationController).navigationBarHidden;
    if (_contentView && _contentView.superview) {
        CGFloat y = [self origin_Y_HidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        CGFloat h = [self heightOfViewHidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        _contentView.frame = CGRectMake(_contentView.x, y, _contentView.width, h);
        _contentViewHeight = _contentView.frame.size.height;
    }
}

#pragma mark - init & dealloc

- (void)createContentCantainer{
    BOOL isNanHidden = ((UINavigationController *)self.navigationController).navigationBarHidden;
//    if (!(UINavigationController *)self.navigationController) {
//        isNanHidden = YES;
//    }
    
    BOOL isTabbarHidden = _hidTabbarBar;
//    if (isTabbarHidden) {
//        if (self.navigationController && [((UINavigationController *)self.navigationController).viewControllers count] <= 1) {
//            UIViewController * fvc = [((UINavigationController *)self.navigationController).viewControllers objectAtExistIndex:0];
//            if (fvc && [fvc isKindOfClass:[LoginViewController class]]) {
//            }
//            else{
//                isTabbarHidden = NO;
//                [self hideTabBar:NO animation:NO];
//            }
//        }else{
//            [self hideTabBar:YES animation:NO];
//        }
//    }
//    _hidTabbarBar = isTabbarHidden;
    
    InfoLog(@"%@", (isNanHidden)?@"导航栏隐藏":@"导航栏显示");
    _contentViewHeight = self.view.frame.size.height - ((isNanHidden)?0:k_IOS7_NAVIGATION_BAR_HEIGHT);
    if (!_contentView) {
        CGFloat y = [self origin_Y_HidTabBar:isTabbarHidden hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        CGFloat h = [self heightOfViewHidTabBar:isTabbarHidden hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        if (y == k_IOS7_NAVIGATION_BAR_HEIGHT) {
            y -= k_IOS7_NAVIGATION_BAR_HEIGHT;
        }
        _contentView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, h)] autorelease];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = YES;
        _contentView.delegate = self;
        [self.view addSubview:_contentView];
        _contentViewHeight = _contentView.frame.size.height;
    }
//    [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

- (void)dealloc{
    self.data_dict = nil;
    self.post_dict = nil;
    [super dealloc];
}

#pragma mark - other method

#pragma mark - 弹出信息提示框
- (void)showMessageView:(NSString *)msg delayTime:(NSTimeInterval)time{
    delayTimeOfHiddenMessage = time;
    [self showMessageView:msg];
}

- (void)showMessageView:(NSString *)msg{
    if (messageView && messageView.superview) {
        [messageView removeFromSuperview];
        messageView = nil;
    }
    
    CGFloat msgWidth = [msg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}].width;
    NSInteger lines = 1;
    if (msgWidth > (kScreenWidth-40)) {
        msgWidth = kScreenWidth-40;
        lines = [NSString numberOfLineWithText:msg font:[UIFont systemFontOfSize:15.0] superWidth:(kScreenWidth-40-10) breakLineChar:nil];
    }
    else{
        msgWidth += 40;
    }
    
    messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, msgWidth, (lines>1)?lines*20:40)];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.layer.cornerRadius = 5.0;
    [APPLICATION.window addSubview:messageView];
    [messageView release];
    messageView.center = CGPointMake(APPLICATION.window.center.x, APPLICATION.window.center.y-130);
    messageView.clipsToBounds = YES;
    messageView.userInteractionEnabled = NO;
    messageView.layer.borderColor = rgb(185, 164, 143).CGColor;
    messageView.layer.borderWidth = 0.5;
    
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, messageView.frame.size.width-10, messageView.frame.size.height)];
    lab.text = msg;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14.0];
//    lab.textColor = [UIColor whiteColor];
    lab.textColor = rgb(185, 164, 143);
    lab.numberOfLines = lines;
    [messageView addSubview:lab];
    [lab release];
    
    [self performSelector:@selector(hiddenMessageView) withObject:nil afterDelay:delayTimeOfHiddenMessage];
}
//信息view提示框
- (void)hiddenMessageView{
    if (messageView && messageView.superview) {
        [UIView animateWithDuration:0.4f animations:^{
            messageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [messageView removeFromSuperview];
                messageView = nil;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
