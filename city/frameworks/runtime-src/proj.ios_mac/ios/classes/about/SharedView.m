//
//  SharedView.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/29.
//
//

/*
 *【好友动态】--->[分享应用]界面
 *功能：分享到微信、朋友圈、新浪
 *
 */

#import "SharedView.h"
#import "UMSocial.h"

#define SharedViewHight 150

typedef enum {
    SharedViewButtonTypeWeixin,
    SharedViewButtonTypeFriend,
    SharedViewButtonTypeWeibo
} SharedViewButtonType;

@interface SharedView ()
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, weak) UIView *bottomView;
@end

@implementation SharedView
+ (instancetype)sharedview
{
    return [[self alloc] init];
}

- (void)show
{
    if (self.animating)  return;
    
    self.animating = YES;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.3;
    self.frame = [UIScreen mainScreen].bounds;
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    [window addSubview:bottomView];
    bottomView.backgroundColor = UIColorFromRGB(0xf1f1f1, 1.0f);
    bottomView.frame = CGRectMake(0, window.frame.size.height, window.frame.size.width, SharedViewHight);
    
    // 初始化bottomView中的子控件
    [self setupBottomView];

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = bottomView.frame;
        frame.origin.y -= SharedViewHight;
        bottomView.frame = frame;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)hide
{
    if (self.animating)  return;
    
    self.animating = YES;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.bottomView.frame;
        frame.origin.y += SharedViewHight;
        self.bottomView.frame = frame;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

- (void)setupBottomView
{
    CGFloat bottomViewWidh = self.bottomView.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:titleLabel];
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:k_fontName_FZXY size:14];
    titleLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = bottomViewWidh;
    CGFloat titleLabelH = 30;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    int count = 3;
    NSArray *iconNames = @[@"weixin", @"friend", @"weibo"];
    CGFloat margin = 20;
    CGFloat iconButtonW = (bottomViewWidh - margin * 2) / count;
    CGFloat iconButtonH = 50;
    CGFloat iconButtonY = CGRectGetMaxY(titleLabel.frame);
    for (int i = 0; i < count; i++) {
        UIButton *iconButton = [[UIButton alloc] init];
        [self.bottomView addSubview:iconButton];
        CGFloat iconButtonX = i * iconButtonW + margin;
        iconButton.frame = CGRectMake(iconButtonX, iconButtonY, iconButtonW, iconButtonH);
        [iconButton setImage:[UIImage imageNamed:iconNames[i]] forState:UIControlStateNormal];
        iconButton.tag = i;
        [iconButton addTarget:self action:@selector(iconButtonDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [self.bottomView addSubview:cancelBtn];
    
    margin = 30;
    CGFloat cancelBtnX = 2 * margin;
    CGFloat cancelBtnY = iconButtonY + iconButtonH + 20;
    CGFloat cancelBtnW = bottomViewWidh - 4 * margin;
    CGFloat cancelBtnH = 30;
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:k_fontName_FZXY size:14];
    cancelBtn.backgroundColor = UIColorFromRGB(0x99d472, 1.0f);
    cancelBtn.layer.cornerRadius = 3;
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

- (void)iconButtonDidOnClick:(UIButton *)button
{
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://a3.mzstatic.com/us/r30/Purple7/v4/2a/85/4d/2a854df4-3bce-fe68-02b8-e97510fd65c0/icon175x175.jpeg"];
    NSString *content = @"跟着我走，帮你见识不一样的旅游。";
    
    switch (button.tag) {
        case SharedViewButtonTypeWeixin:
            NSLog(@"SharedViewButtonTypeWeixin。。。");
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:nil location:nil urlResource:urlResource presentedController:nil completion:nil];
            break;
        case SharedViewButtonTypeFriend:
            NSLog(@"SharedViewButtonTypeFriend。。。");
             [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:nil location:nil urlResource:urlResource presentedController:nil completion:nil];
            break;
        case SharedViewButtonTypeWeibo:
            NSLog(@"SharedViewButtonTypeWeibo。。。");
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:nil location:nil urlResource:urlResource presentedController:nil completion:nil];
            break;
        default:
            break;
    }
}
@end
