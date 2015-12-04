//
//  StoreViewNavBar.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/19.
//
//

#import "StoreViewNavBar.h"

#define StoreViewNavBarH 64
#define backBtnWH 44

@interface StoreViewNavBar ()
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITextField *titleTextField;
@end

@implementation StoreViewNavBar
+ (instancetype)storeViewNavBarWithTitle:(NSString *)title
{
    StoreViewNavBar *storeViewNavBar = [[self alloc] init];
    storeViewNavBar.titleTextField.text = title;
    return storeViewNavBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        self.bgView = bgView;
        bgView.backgroundColor = yello_color;
        
        UITextField *titleTextField = [[UITextField alloc] init];
        [self.bgView addSubview:titleTextField];
        self.titleTextField = titleTextField;
        titleTextField.font = [UIFont fontWithName:k_fontName_FZZY size:k_defaultNavTitleFontSize];
        titleTextField.textColor = darkblack_color;
        titleTextField.textAlignment = NSTextAlignmentCenter;
        titleTextField.enabled = NO;
        
        UIButton *backBtn = [[UIButton alloc] init];
        [self addSubview:backBtn];
        self.backBtn = backBtn;
        [backBtn setImage:[UIImage imageNamed:@"store_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleTextField.text = title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    self.titleTextField.frame = CGRectMake(0, StoreViewNavBarH - backBtnWH, [UIScreen mainScreen].bounds.size.width, backBtnWH);
    self.backBtn.frame = CGRectMake(5, StoreViewNavBarH - backBtnWH, backBtnWH, backBtnWH);
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, StoreViewNavBarH);
    self.frame = frame;
}

- (void)setBgViewAlpha:(CGFloat)alpha
{
    self.bgView.alpha = alpha;
}

- (void)backBtnDidOnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(storeViewNavBar:backBtnDidOnClick:)]) {
        [self.delegate storeViewNavBar:self backBtnDidOnClick:btn];
    }
}
@end
