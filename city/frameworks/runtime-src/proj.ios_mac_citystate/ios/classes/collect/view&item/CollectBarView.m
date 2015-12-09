//
//  CollectBarView.m
//  citystate
//
//  Created by 小生 on 15/11/6.
//
//

#import "CollectBarView.h"
#import "BuddyStatusSharedView.h"
#import "BuddyStatusCommentsViewController.h"
#import "UMSocial.h"
#import "AppController.h"

@interface CollectBarView () <BuddyStatusSharedViewDelegate>
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, weak) UIButton *likeBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *moreBtn;
@property (nonatomic, assign) int index;
@end

@implementation CollectBarView

+ (instancetype)toolBar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = clear_color;
        
        self.likeBtn = [self setupBtnWithTitle:[NSString stringWithFormat:@"%ld", self.noteItem.likecount] icon:@"buddystatus_like.png" selIcon:@"buddystatus_like_sel.png" type:BarBtnTypeLike];
        self.commentBtn = [self setupBtnWithTitle:[NSString stringWithFormat:@"%ld", self.noteItem.commentscount] icon:@"buddystatus_comment.png" selIcon:@"buddystatus_comment_sel.png" type:BarBtnTypeComment];
        self.moreBtn = [self setupBtnWithTitle:nil icon:@"buddystatus_more.png" selIcon:@"buddystatus_more_sel.png" type:BarBtnTypeMore];
        
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

- (UIButton *)setupBtnWithTitle:(NSString *)title icon:(NSString *)iconName selIcon:(NSString *)selIconName type:(BarBtnType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    [self.btns addObject:btn];
    [btn setTag:type];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    if (type == BarBtnTypeMore) {
        [btn setImage:[UIImage imageNamed:selIconName] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:selIconName] forState:UIControlStateSelected];
    }
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleColor:k_defaultTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:k_defaultFontName size:k_defaultFontSize];
    [btn addTarget:self action:@selector(btnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)setNoteItem:(CollectItem *)noteItem
{
    _noteItem = noteItem;
    
    self.likeBtn.selected = _noteItem.likecount;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld", _noteItem.likecount] forState:UIControlStateNormal];
    self.commentBtn.selected = _noteItem.commentscount;
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld", _noteItem.commentscount] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    NSInteger bntsCount = self.btns.count;
    
    CGFloat btnW = width / bntsCount;
    CGFloat btnH = height;
    
    for (int i = 0; i < bntsCount; i++) {
        UIButton *btn = self.btns[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
}

// TODO 点赞、评论接口调试
- (void)btnDidOnClick:(UIButton *)button
{
    switch (button.tag) {
        case BarBtnTypeLike:
            [self requestLike];
            break;
        case BarBtnTypeComment:
            [self requestComment];
            break;
        case BarBtnTypeMore:
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
    [[NSNotificationCenter defaultCenter] postNotificationName:BuddyStatusToolBarCommentDidOnClick object:nil userInfo:@{BuddyStatusToolBarCommentDidOnClickFeedid: @(self.noteItem.feedid)}];
}

/**
 *  处理点击更多按钮
 */
- (void)requestMore
{
    BuddyStatusSharedView *sharedView;
    if (self.statusItem.user.type == 1 || self.statusItem.user.type == 3) {
        sharedView = [BuddyStatusSharedView sharedviewWithType:BuddyStatusSharedViewTypeWithoutAddFriend];
    } else {
        sharedView = [BuddyStatusSharedView sharedviewWithType:BuddyStatusSharedViewTypeWithAddFriend];
        
    }
    sharedView.delegate = self;
    [sharedView show];
}

#pragma mark - BuddyStatusSharedViewDelegate
-(void)buddyStatusSharedViewDidClickSharedBtn:(BuddyStatusSharedViewBtnType)type
{
    NSString *url;
    UIImage *image;
    if (self.noteItem.imglinkArr.count > 0) {
        url = self.noteItem.imglinkArr[0];
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
    NSDictionary * params = @{@"userid":@(self.noteItem.feedid),
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
        self.noteItem.likecount++;
        self.noteItem.liked = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%zd", self.noteItem.likecount] forState:UIControlStateNormal];
            self.likeBtn.selected = self.noteItem.liked;
        });
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_like_del]) {
        self.noteItem.likecount--;
        self.noteItem.liked = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%zd", self.noteItem.likecount] forState:UIControlStateNormal];
            self.likeBtn.selected = self.noteItem.liked;
        });
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        
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
