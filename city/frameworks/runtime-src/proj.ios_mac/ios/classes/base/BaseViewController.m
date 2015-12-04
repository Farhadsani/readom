//
//  BaseViewController.m
//  cxy
//
//  Created by hf on 15/6/5.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import "BaseViewController.h"
#import "IIViewDeckController.h"


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
- (void)variableInit{
    if (!_data_dict) {
        _data_dict = [[NSMutableDictionary alloc] init];
    }
    if (!_post_dict) {
        _post_dict = [[NSMutableDictionary alloc] init];
    }
    _hidTopStatusBar = YES;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (k_NO_LESS_THAN_IOS(7)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0)];
    
    [self setupLeftBackButtonItem:nil img:nil action:nil];
    
    [self createContentCantainer];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    InfoLog(@"%@", (self.navigationController.navigationBarHidden)?@"导航栏隐藏":@"导航栏显示");
//    InfoLog(@"screen:%f %f", kScreenWidth, kScreenHeight);
//    InfoLog(@"_contentView:%@", _contentView);
//    InfoLog(@"self.view:%@", self.view);
    
//    [self reloadContentViewIfNeeded];
    BOOL isNanHidden = ((UINavigationController *)self.navigationController).navigationBarHidden;
    InfoLog(@"%@", (isNanHidden)?@"导航栏隐藏":@"导航栏显示");
    
    CGFloat y = [self origin_Y_HidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
    if (y == k_IOS7_NAVIGATION_BAR_HEIGHT) {
        y -= k_IOS7_NAVIGATION_BAR_HEIGHT;
        CGFloat h = [self heightOfViewHidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        _contentView.frame = CGRectMake(_contentView.x, y, _contentView.width, h);
    }
    
    if (self.view.y == k_DEFAULT_NAVIGATION_BAR_HEIGHT) {
        self.view.frame = CGRectMake(self.view.x, k_IOS7_NAVIGATION_BAR_HEIGHT, self.view.width, self.view.height);
    }
    
    if (_contentView) {
        CGFloat maxHeight = 0.0;
        for (UIView * v in _contentView.subviews) {
            maxHeight = (v.y + v.height > maxHeight) ? v.y + v.height : maxHeight;
        }
        if (maxHeight > _contentView.height) {
            _contentView.contentSize = CGSizeMake(_contentView.width, maxHeight+20);
        }
    }
    
    InfoLog(@"_contentView:%@", _contentView);
    InfoLog(@"self.view:%@", self.view);
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
//    if (!(UINavigationController *)self.navigationController) {
//        isNanHidden = YES;
//    }
    
    if (_contentView && _contentView.superview) {
        CGFloat y = [self origin_Y_HidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        CGFloat h = [self heightOfViewHidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        _contentView.frame = CGRectMake(_contentView.x, y, _contentView.width, h);
        _contentViewHeight = _contentView.frame.size.height;
    }
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

#pragma mark - init & dealloc

- (void)createContentCantainer{
    BOOL isNanHidden = ((UINavigationController *)self.navigationController).navigationBarHidden;
//    if (!(UINavigationController *)self.navigationController) {
//        isNanHidden = YES;
//    }
    
    InfoLog(@"%@", (isNanHidden)?@"导航栏隐藏":@"导航栏显示");
    _contentViewHeight = self.view.frame.size.height - ((isNanHidden)?0:k_IOS7_NAVIGATION_BAR_HEIGHT);
    if (!_contentView) {
        CGFloat y = [self origin_Y_HidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        CGFloat h = [self heightOfViewHidTabBar:YES hidNavBar:isNanHidden hidTopStatusBar:_hidTopStatusBar];
        if (y == k_IOS7_NAVIGATION_BAR_HEIGHT) {
            y -= k_IOS7_NAVIGATION_BAR_HEIGHT;
//            h += k_IOS7_NAVIGATION_BAR_HEIGHT;
        }
        _contentView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, h)] autorelease];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = YES;
        _contentView.delegate = self;
//        _contentView.backgroundColor = [UIColor color:blueLight_color];
        [self.view addSubview:_contentView];
        _contentViewHeight = _contentView.frame.size.height;
    }
    [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
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
//    messageView.backgroundColor = [UIColor grayColor];
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
