//
//  TitleBar.m
//  TitleBarDemo
//
//  Created by 石头人6号机 on 15/9/24.
//  Copyright (c) 2015年 石头人6号机. All rights reserved.
//

#import "TitleBar.h"

@interface TitleBar ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger showCount;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleBtns;
@property (nonatomic, strong) NSMutableArray *separators;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIButton *selectedTitleBtn;
@property (nonatomic, weak) UIView *bottomLineView;
@end

@implementation TitleBar
+ (instancetype)titleBarWithTitles:(NSArray *)titles andShowCount:(NSInteger)showCount
{
    TitleBar *titleBar = [[self alloc] init];
    titleBar.showCount = showCount;
    titleBar.titles = titles;
    return titleBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = [titles copy];
    
    [self setup];
}

- (NSMutableArray *)titleBtns
{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (NSMutableArray *)separators
{
    if (!_separators) {
        _separators = [NSMutableArray array];
    }
    return _separators;
}

- (void)setup
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.titleBtns removeAllObjects];
    [self.separators removeAllObjects];

    for (int i = 0; i < self.titles.count; i++) {
        UIButton *titleBtn = [[UIButton alloc] init];
        [self.scrollView addSubview:titleBtn];
        [self.titleBtns addObject:titleBtn];
        [titleBtn setTitle:self.titles[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont fontWithName:@"FZY3JW--GB1-0" size:15];
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(titleBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self titleBtnDidOnClick:titleBtn];
        }
        
        if (i != self.titles.count - 1) {
            UIView *separator = [[UIView alloc] init];
            [self.scrollView addSubview:separator];
            [self.separators addObject:separator];
            separator.backgroundColor = [UIColor blackColor];
            separator.alpha = 0.3;
        }
    }
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor blackColor];
    bottomLineView.alpha = 0.3;
    [self.scrollView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor color:yello_color];
    [self.scrollView addSubview:lineView];
    self.lineView = lineView;
    self.lineView.layer.anchorPoint = CGPointZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    NSInteger showCount = self.showCount > self.titles.count ? self.titles.count : self.showCount;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat titleBtnW = width / showCount;
    CGFloat titleBtnH = height;
    
    self.scrollView.contentSize = CGSizeMake(titleBtnW * self.titles.count, 0);

    CGFloat separatorW = 0.5;
    CGFloat separatroY = 8;
    CGFloat separatroH =height - 2 * separatroY;
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *titleBtn = self.titleBtns[i];
        titleBtn.frame = CGRectMake(i * titleBtnW, 0, titleBtnW, titleBtnH);
        
        if (i != self.titles.count - 1) {
            UIView *separator = self.separators[i];
            separator.frame = CGRectMake(CGRectGetMaxX(titleBtn.frame) - separatorW, separatroY, separatorW, separatroH);
        }
    }
 
    CGFloat lineViewW = titleBtnW;
    CGFloat lineViewH = 1;
    CGFloat lineViewX = 0;
    CGFloat lineViewY = height - lineViewH;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    self.bottomLineView.frame = CGRectMake(0,  self.scrollView.height - 0.5,  self.scrollView.width, 0.5);
}

- (void)titleBtnDidOnClick:(UIButton *)titleBtn
{
    // NSLog(@"%s %ld", __func__, titleBtn.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleBar:titleBtnWillOnClick:)]) {
        if ([self.delegate titleBar:self titleBtnWillOnClick:titleBtn.tag]) {
            [self doCallBack:titleBtn];
        }
    }
    else{
        [self doCallBack:titleBtn];
    }
}

- (void)doCallBack:(UIButton *)titleBtn{
    self.selectedTitleBtn.enabled = YES;
    titleBtn.enabled = NO;
    self.selectedTitleBtn = titleBtn;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    CGPoint point = self.lineView.frame.origin;
    point.x = titleBtn.frame.origin.x;
    animation.toValue = [NSValue valueWithCGPoint:point];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.2;
    [self.lineView.layer addAnimation:animation forKey:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleBar:titleBtnDidOnClick:)]) {
        [self.delegate titleBar:self titleBtnDidOnClick:titleBtn.tag];
    }
}
@end
