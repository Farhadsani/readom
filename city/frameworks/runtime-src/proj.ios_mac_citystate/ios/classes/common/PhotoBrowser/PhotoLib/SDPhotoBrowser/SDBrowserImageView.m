//
//  SDBrowserImageView.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBrowserImageView.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowserConfig.h"

@implementation SDBrowserImageView
{
    SDWaitingView * _waitingView;
    BOOL _didCheckSize;
    UIScrollView *_scroll;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
    UIImageView *_zoomingImageView;
    CGFloat _totalScale;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        
//        // 捏合手势缩放图片
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (BOOL)isScaled
{
    return  1.0 != _totalScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    if (self.image.size.height > self.bounds.size.height) {
        if (!_scroll) {
            UIScrollView *scroll = [[UIScrollView alloc] init];
            scroll.showsHorizontalScrollIndicator = NO;
            scroll.showsVerticalScrollIndicator = NO;
            scroll.frame = self.bounds;
            scroll.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = self.image;
            _scrollImageView = imageView;
            [scroll addSubview:imageView];
            imageView.frame = CGRectMake(0, 0, scroll.bounds.size.width, self.frame.size.height);
            scroll.backgroundColor = SDPhotoBrowserBackgrounColor;
            _scroll = scroll;
            [self addSubview:scroll];
            self.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    
    _scroll.contentSize = CGSizeMake(0, self.image.size.height);
}



- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWaitingView * waiting = [[SDWaitingView alloc]init];
    waiting.bounds = CGRectMake(0, 0, 40, 40);
    waiting.mode = SDWaitingViewProgressMode;
    _waitingView = waiting;
    [self addSubview:waiting];
    
    __weak SDBrowserImageView *imageViewWeak = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageViewWeak removeWaitingView];
        
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];
        }
    }];
}

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer{
    CGFloat scale = recognizer.scale;
    CGFloat temp = _totalScale + (scale - 1);
    
    if (!_zoomingScroolView && temp > 1.0) {
        _zoomingScroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScroolView.backgroundColor = SDPhotoBrowserBackgrounColor;
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.image];
        zoomingImageView.bounds = self.bounds;
        zoomingImageView.center = _zoomingScroolView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _zoomingImageView = zoomingImageView;
        [_zoomingScroolView addSubview:zoomingImageView];
        [self addSubview:_zoomingScroolView];
        
        _zoomingScroolView.contentSize = CGSizeMake(zoomingImageView.bounds.size.width * 2, zoomingImageView.bounds.size.height * 1.5);
        _zoomingScroolView.contentInset = UIEdgeInsetsMake(zoomingImageView.bounds.size.height, zoomingImageView.bounds.size.width, 0, 0);
        _zoomingScroolView.contentOffset = _zoomingScroolView.frame.origin;
    }
    
    
    if (!(_totalScale <= 1 && temp < _totalScale) && !(_totalScale > 2.0 && temp > _totalScale)) { // 最大缩放 2倍,最小1倍
        _zoomingImageView.transform = CGAffineTransformScale(_zoomingImageView.transform, scale, scale);
        _totalScale = temp;
    }
    if ((_totalScale <= 1 && temp < _totalScale)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self eliminateScale];
        });
    }
    
    recognizer.scale = 1.0;
}

// 清除缩放
- (void)eliminateScale
{
    [_zoomingScroolView removeFromSuperview];
    _zoomingScroolView = nil;
    _zoomingImageView = nil;
    _totalScale = 1.0;
}

- (void)removeWaitingView
{
    [_waitingView removeFromSuperview];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com