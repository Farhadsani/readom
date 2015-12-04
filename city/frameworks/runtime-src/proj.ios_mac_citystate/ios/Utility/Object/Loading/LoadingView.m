//
//  LoadingView.m
//  iBeaconMall
//
//  Created by hf on 14-9-10.
//  Copyright (c) 2014年 hf. All rights reserved.
//

#import "LoadingView.h"
#import "HYCircleLoadingView.h"

@interface LoadingView ()

@property (nonatomic, retain) HYCircleLoadingView *loadingView;
@property (nonatomic, retain) NSString *message;

@end

static LoadingView *sharedLoadingView = nil;

@implementation LoadingView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isFullScreen = NO;
    }
    return self;
}

- (void)dealloc{
    self.message = nil;
    self.loadingView = nil;
    [super dealloc];
}

+ (LoadingView *)shared{
    if (sharedLoadingView == nil) {
        sharedLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        return sharedLoadingView;
    }
    
    return sharedLoadingView;
}

+ (id) alloc {
    @synchronized ([LoadingView class]) {
        sharedLoadingView = [super alloc];
        return sharedLoadingView;
    }
    
    return nil;
}

- (void)setShowingMessage:(NSString *)msg{
    if (!_message) {
        _message = [[NSString alloc] init];
    }
    
    if (msg && msg.length > 0) {
        _message = msg;
    }
}

- (void)resetShowingMessage{
    if (_message) {
        self.message = nil;
        UIView * vi = [self viewWithTag:2223];
        if (vi) {
            [vi removeFromSuperview];
        }
    }
}

- (void)showLoading:(NSString *)type message:(NSString *)msg{
    if (self && self.superview) {
        return;
    }
    
//    for (UIView * vi in APPLICATION.window.subviews) {
//        if (vi.tag == kAlphaViewTag) {
//            [vi removeFromSuperview];
//        }
//    }
    
//    [self removeViews];
    
    self.frame = CGRectMake(0, 0, 100, 100);
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.cornerRadius = 5.0;
    self.alpha = 1;
    
    
    if (_loadingView) {
        _loadingView = nil;
    }
    
    UIView * vi = [self viewWithTag:2223];
    if (vi) {
        [vi removeFromSuperview];
    }
    
//    if (!_loadingView.superview) {
        if ([type integerValue] == 2) {
            self.frame = CGRectMake(0, 0, 80, 80);
            _loadingView = (HYCircleLoadingView *)[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        }
        else{
            _loadingView = [[HYCircleLoadingView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
            _loadingView.lineColor = [UIColor color:lightgray_color];
        }
//    }
    
    _loadingView.frame = CGRectMake(0, 0, 45, 45);
    
    if (!_loadingView.superview) {
        [self addSubview:_loadingView];
        [_loadingView release];
    }
    
    NSString * showMsg = nil;
    if (![NSString isEmptyString:msg]) {
        showMsg = msg;
    }
    else if (![NSString isEmptyString:_message]){
        showMsg = _message;
    }
    
    if (showMsg) {
        CGFloat msgW = [showMsg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
        
        if (msgW+30>100) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, msgW+30, self.frame.size.height);
        }
        
        CGFloat h = 30;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-h, self.frame.size.width, h)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 2223;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:k_fontName_FZXY size:13];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = showMsg;
        [self addSubview:label];
        [label release];
        
        _loadingView.center = CGPointMake(self.center.x, self.center.y-h/2);
    }
    else{
        _loadingView.center = self.center;
    }
    
//    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    self.center = APPLICATION.window.center;
    
    if (_isFullScreen) {
        UIControl * alphaView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+20)];
        alphaView.tag = kAlphaViewTag;
        alphaView.backgroundColor = [UIColor clearColor];
        alphaView.userInteractionEnabled = YES;
        [alphaView addAlphaView:[UIColor grayColor] alpha:0.3];
        [APPLICATION.window addSubview:alphaView];
        [alphaView release];
        
        self.backgroundColor = [UIColor lightGrayColor];
        [alphaView addSubview:self];
    }
    else{
        self.tag = kAlphaViewTag;
        [APPLICATION.window addSubview:self];
    }
    
    if ([_loadingView isKindOfClass:[UIActivityIndicatorView class]]) {
        [(UIActivityIndicatorView *)_loadingView startAnimating];
    }
    else{
        [_loadingView startAnimation];
    }
    
//    [self checkRequestTime];
}

- (void)hideLoading{
    [self stopTimer];
    
    if (self && self.superview) {
        if (_loadingView && _loadingView.superview) {
            if ([_loadingView isKindOfClass:[UIActivityIndicatorView class]]) {
                [(UIActivityIndicatorView *)_loadingView stopAnimating];
            }
            else{
                [_loadingView stopAnimation];
            }
        }
        
        UIView * vi = [self viewWithTag:2223];
        if (vi) {
            [vi removeFromSuperview];
        }
        
        [self performSelector:@selector(removeViews) withObject:nil afterDelay:0.1];
        
        self.isFullScreen = NO;//回复默认全屏显示Loading视图
    }
}

- (void)removeViews{
    [self resetShowingMessage];
    
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        [self removeFromSuperview];
    }
    else if ([self.superview.superview isKindOfClass:[UIWindow class]]) {
        [self.superview removeFromSuperview];
    }
    else if ([self.superview.superview.superview isKindOfClass:[UIWindow class]]) {
        [self.superview.superview removeFromSuperview];
    }
    
    for (UIView * vi in APPLICATION.window.subviews) {
        if (vi.tag == kAlphaViewTag) {
            [vi removeFromSuperview];
        }
    }
}

- (void)checkRequestTime{
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
}

- (void)timeOut{
//    [APPLICATION showMessageView:@"正在努力加载中，请耐心等候..." autoDimiss:YES];
    [self stopTimer];
}

- (void)stopTimer{
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
