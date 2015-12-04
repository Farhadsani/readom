//
//  BuddyStatusSharedView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/12.
//
//

#import "BuddyStatusSharedView.h"
#import "UMSocial.h"
#import "SharedViewButton.h"
#import "AppController.h"

#define Margin 20
#define SharedViewTitleHight 50
#define SharedViewButtonHight 80
#define SharedViewHight (SharedViewTitleHight + SharedViewButtonHight * self.type + Margin)

@interface BuddyStatusSharedView ()
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, assign) BuddyStatusSharedViewType type;
@end

@implementation BuddyStatusSharedView
+ (instancetype)sharedviewWithType:(BuddyStatusSharedViewType)type
{
    BuddyStatusSharedView *buddyStatusSharedView = [[self alloc] init];
    buddyStatusSharedView.type = type;
    return buddyStatusSharedView;
}

- (void)show
{
    if (self.animating)  return;
    
    self.animating = YES;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    self.frame = [UIScreen mainScreen].bounds;
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    [window addSubview:bottomView];
    bottomView.backgroundColor = white_color;
    bottomView.frame = CGRectMake(0, window.frame.size.height, window.frame.size.width, SharedViewHight);
    
    // 初始化bottomView中的子控件
    [self setupBottomView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = bottomView.frame;
        frame.origin.y -= SharedViewHight;
        bottomView.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
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
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (void)setupBottomView
{
    CGFloat bottomViewWidh = self.bottomView.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:titleLabel];
    titleLabel.text = @"分享给朋友";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:k_defaultFontSize];
    titleLabel.textColor = darkZongSeColor;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = bottomViewWidh;
    CGFloat titleLabelH = SharedViewTitleHight;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    [self setupBtnWithTitle:@"微信好友" icon:@"buddystatus_friends" selIcon:@"buddystatus_friends_sel" type:BuddyStatusSharedViewBtnTypeFriends];
    [self setupBtnWithTitle:@"微信朋友圈" icon:@"buddystatus_friendsgroup" selIcon:@"buddystatus_friendsgroup_sel" type:BuddyStatusSharedViewBtnTypeFriendsGroup];
    [self setupBtnWithTitle:@"新浪微博" icon:@"buddystatus_weibo" selIcon:@"buddystatus_weibo_sel" type:BuddyStatusSharedViewBtnTypeWeiBo];
    [self setupBtnWithTitle:@"QQ空间" icon:@"buddystatus_qzone" selIcon:@"buddystatus_qzone_sel" type:BuddyStatusSharedViewBtnTypeQZone];
    [self setupBtnWithTitle:@"添加关注" icon:@"buddystatus_addfriend" selIcon:@"buddystatus_addfriend_sel" type:BuddyStatusSharedViewBtnTypeAddFriend];
    
    int count = (self.type == BuddyStatusSharedViewTypeWithAddFriend) ? 5 : 4;
    CGFloat btnW = bottomViewWidh / 4;
    CGFloat btnH = SharedViewButtonHight;
    CGFloat btnBaseY = CGRectGetMaxY(titleLabel.frame);
    for (int i = 0; i < count; i++) {
        SharedViewButton *btn = self.btns[i];
        int row = i / 4;
        int col = i % 4;
        CGFloat btnX = col * btnW;
        CGFloat btnY = row * (btnH + Margin) + btnBaseY;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    if (self.type == BuddyStatusSharedViewTypeWithAddFriend) {
        UIView *lineView = [[UIView alloc] init];
        [self.bottomView addSubview:lineView];
        lineView.backgroundColor = k_defaultLineColor;
        CGFloat lineViewMargin = 10;
        lineView.frame = CGRectMake(lineViewMargin, btnBaseY + btnH + Margin * 0.5, bottomViewWidh - lineViewMargin * 2, 0.6);
    }
}

- (SharedViewButton *)setupBtnWithTitle:(NSString *)title icon:(NSString *)iconName selIcon:(NSString *)selIconName type:(BuddyStatusSharedViewBtnType)type
{
    SharedViewButton *btn = [[SharedViewButton alloc] init];
    [self.bottomView addSubview:btn];
    [self.btns addObject:btn];
    [btn setTag:type];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selIconName] forState:UIControlStateHighlighted];
    [btn setTitleColor:darkZongSeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:13];
    [btn addTarget:self action:@selector(btnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

// TODO 分享调试
- (void)btnDidOnClick:(SharedViewButton *)button
{
    [self hide];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://a3.mzstatic.com/us/r30/Purple7/v4/2a/85/4d/2a854df4-3bce-fe68-02b8-e97510fd65c0/icon175x175.jpeg"];
    NSString *content = @"跟着我走，帮你见识不一样的旅游。";
    
    switch (button.tag) {
        case BuddyStatusSharedViewBtnTypeFriends:
            NSLog(@"BuddyStatusSharedViewBtnTypeFriends。。。");
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:nil location:nil urlResource:urlResource presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MessageView showMessageView:@"分享成功" delayTime:2.0];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                        message:@"分享成功"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                        [alert show];
                    }
                }];
            }
            break;
        case BuddyStatusSharedViewBtnTypeFriendsGroup:
            NSLog(@"BuddyStatusSharedViewBtnTypeFriendsGroup。。。");
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:nil location:nil urlResource:urlResource presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MessageView showMessageView:@"分享成功" delayTime:2.0];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                        message:@"分享成功"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                        [alert show];
                    }
                }];
            }
            break;
        case BuddyStatusSharedViewBtnTypeWeiBo:
            {
                NSLog(@"BuddyStatusSharedViewBtnTypeWeiBo。。。");
                AppController *delegate = (AppController *)[UIApplication sharedApplication].delegate;
                
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:nil location:nil urlResource:urlResource presentedController:[delegate getVisibleViewController] completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MessageView showMessageView:@"分享成功" delayTime:2.0];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                        message:@"分享成功"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                        [alert show];
                    }
                }];

            }
            break;
        case BuddyStatusSharedViewBtnTypeQZone:
            NSLog(@"BuddyStatusSharedViewBtnTypeQZone。。。");
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:[UIImage imageNamed:@"icon-144.png"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MessageView showMessageView:@"分享成功" delayTime:2.0];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                        message:@"分享成功"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                        [alert show];
                    }
                }];
            }
            break;
        case BuddyStatusSharedViewBtnTypeAddFriend:
            if ([self.delegate respondsToSelector:@selector(buddyStatusSharedViewDidClickAddFriendBtn:)]) {
                [self.delegate buddyStatusSharedViewDidClickAddFriendBtn:self];
            }
            break;
        default:
            break;
    }
}
@end
