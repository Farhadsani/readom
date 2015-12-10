//
//  BuddyStatusToolBar.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/12.
//
//

#import "BuddyStatusToolBar.h"
#import "BuddyStatusSharedView.h"
#import "UMSocial.h"
#import "AppController.h"

@interface BuddyStatusToolBar () <BuddyStatusSharedViewDelegate>
@property (nonatomic, strong) NSMutableArray *separators;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIButton *likeBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *moreBtn;
@property (nonatomic, assign) int index;
@property (nonatomic, weak) BuddyStatusSharedView *sharedView;
@end

@implementation BuddyStatusToolBar
+ (instancetype)toolBar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = clear_color;
        
        self.likeBtn = [self setupBtnWithTitle:[NSString stringWithFormat:@"%ld", self.noteItem.like_count] icon:@"buddystatus_like.png" selIcon:@"buddystatus_like_sel.png" type:ToolBarBtnTypeLike];
        self.commentBtn = [self setupBtnWithTitle:[NSString stringWithFormat:@"%ld", self.noteItem.like_count] icon:@"buddystatus_comment.png" selIcon:@"buddystatus_comment_sel.png" type:ToolBarBtnTypeComment];
        self.moreBtn = [self setupBtnWithTitle:nil icon:@"buddystatus_more.png" selIcon:@"buddystatus_more_sel.png" type:ToolBarBtnTypeMore];
        
        [self setupLine];
        [self setupLine];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = k_defaultLineColor;
        [self addSubview:lineView];
        self.lineView = lineView;
    }
    return self;
}

- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)separators
{
    if (!_separators) {
        _separators = [NSMutableArray array];
    }
    return _separators;
}

- (UIButton *)setupBtnWithTitle:(NSString *)title icon:(NSString *)iconName selIcon:(NSString *)selIconName type:(ToolBarBtnType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    [self.btns addObject:btn];
    [btn setTag:type];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    if (type == ToolBarBtnTypeMore) {
        [btn setImage:[UIImage imageNamed:selIconName] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:selIconName] forState:UIControlStateSelected];
    }
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [btn setTitleColor:k_defaultTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:k_defaultFontName size:k_defaultFontSize];
    [btn addTarget:self action:@selector(btnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setupLine
{
    UIView *separator = [[UIView alloc] init];
    [self addSubview:separator];
    [self.separators addObject:separator];
    separator.backgroundColor = k_defaultLineColor;
}

- (void)setNoteItem:(BuddyStatusNoteItem *)noteItem
{
    _noteItem = noteItem;
    
    self.likeBtn.selected = _noteItem.liked;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld", _noteItem.like_count] forState:UIControlStateNormal];
    self.commentBtn.selected = _noteItem.commented;
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld", _noteItem.comments_count] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat lineViewMargin = 10;
    self.lineView.frame = CGRectMake(lineViewMargin, 0, width - lineViewMargin * 2, 0.6);
    
    NSInteger bntsCount = self.btns.count;
    
    CGFloat btnW = width / bntsCount;
    CGFloat btnH = height;
    
    CGFloat separatorW = 0.6;
    CGFloat separatroY = 8;
    CGFloat separatroH = height - 2 * separatroY;
    
    for (int i = 0; i < bntsCount; i++) {
        UIButton *btn = self.btns[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
        
        if (i != bntsCount - 1) {
            UIView *separator = self.separators[i];
            separator.frame = CGRectMake(CGRectGetMaxX(btn.frame) - separatorW, separatroY, separatorW, separatroH);
        }
    }
}

// TODO 点赞、评论接口调试
- (void)btnDidOnClick:(UIButton *)button
{
    switch (button.tag) {
        case ToolBarBtnTypeLike:
            [self requestLike];
            break;
        case ToolBarBtnTypeComment:
            [self requestComment];
            break;
        case ToolBarBtnTypeMore:
            [self requestMore];
            break;
        default:
            break;
    }
}

/**
 *  处理点击点赞按钮
 */
- (void)requestLike
{
    NSString *uri = nil;
    if (self.likeBtn.selected == NO) { // 没有点赞，切换到点赞
        uri = k_api_feed_like_post;
    } else {
        uri = k_api_feed_like_del;
    }

    NSDictionary * params = @{@"feedid":@(self.noteItem.feedid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:uri,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

/**
 *  处理点击评论按钮
 */
- (void)requestComment
{
    if (self.back) {
        self.back();
    }
}

/**
 *  处理点击更多按钮
 */
- (void)requestMore
{
    BuddyStatusSharedView *sharedView;
    if (self.noteItem.user.type == 0 || self.noteItem.user.type == 2) {
        sharedView = [BuddyStatusSharedView sharedviewWithType:BuddyStatusSharedViewTypeWithAddFriend];
    } else {
        sharedView = [BuddyStatusSharedView sharedviewWithType:BuddyStatusSharedViewTypeWithoutAddFriend];
    }
    sharedView.delegate = self;
    self.sharedView = sharedView;
    [sharedView show];
}

#pragma mark - BuddyStatusSharedViewDelegate
-(void)buddyStatusSharedViewDidClickSharedBtn:(BuddyStatusSharedViewBtnType)type
{
    NSString *url;
    UIImage *image;
    if (self.noteItem.thumbs.count > 0) {
        url = self.noteItem.imgs[self.noteItem.selectedIndex];
        image = self.noteItem.selectedImageView.image;
    } else {
        url = @"http://www.shitouren.com";
        image = [UIImage imageNamed:@"icon-144.png"];
    }
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    NSString *content = self.noteItem.content;
    
    switch (type) {
        case BuddyStatusSharedViewBtnTypeFriends:
            NSLog(@"BuddyStatusSharedViewBtnTypeFriends。。。");
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
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
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
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
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:nil presentedController:[delegate getVisibleViewController] completion:^(UMSocialResponseEntity *shareResponse){
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
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
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
            [self addFriend];
            break;
        default:
            break;
    }
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.shitouren.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.shitouren.com";
}

- (void)addFriend
{
    NSDictionary * params = @{@"userid":@(self.noteItem.user.userid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_follow,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result
{
    [[Cache shared] setNeedRefreshData:3 value:1];//设置个人动态页面刷新
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_post]) {
        self.noteItem.like_count++;
        self.noteItem.liked = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%zd", self.noteItem.like_count] forState:UIControlStateNormal];
            self.likeBtn.selected = self.noteItem.liked;
        });
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_del]) {
        self.noteItem.like_count--;
        self.noteItem.liked = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%zd", self.noteItem.like_count] forState:UIControlStateNormal];
            self.likeBtn.selected = self.noteItem.liked;
        });
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        self.noteItem.user.type = [result[@"res"][@"type"] intValue];
        [self.sharedView hide];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error
{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_post] || [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_del]) {
        InfoLog(@"error:%@", error);
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        InfoLog(@"error:%@", error);
    }
}
@end
