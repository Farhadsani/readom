//
//  BuddyStatusCommentInputView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import "BuddyStatusCommentInputView.h"
#import "BRPlaceholderTextView.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"

#define BuddyStatusCommentInputViewCommentFieldFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface BuddyStatusCommentInputView () <UITextViewDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) BRPlaceholderTextView *commentField;
@property (nonatomic, weak) UIButton *sendBtn;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, assign) CGFloat lastHeight;
@end

@implementation BuddyStatusCommentInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self addSubview:iconView];
        self.iconView = iconView;
        iconView.layer.masksToBounds = YES;
        self.iconView.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
        self.iconView.layer.borderWidth = 0.5;
        
        BRPlaceholderTextView *commentField = [[BRPlaceholderTextView alloc] init];
        [self addSubview:commentField];
        self.commentField = commentField;
        commentField.placeholder = @"说点什么吧";
        commentField.font = BuddyStatusCommentInputViewCommentFieldFont;
        [commentField setPlaceholderFont:BuddyStatusCommentInputViewCommentFieldFont];
        commentField.textColor = k_defaultTextColor;
        commentField.delegate = self;
        commentField.tintColor = k_defaultLightTextColor;
        commentField.maxTextLength = 120;
        
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        
        UIButton *sendBtn = [[UIButton alloc] init];
        [self addSubview:sendBtn];
        self.sendBtn = sendBtn;
        [sendBtn setImage:[UIImage imageNamed:@"buddystatus_sendcomment"] forState:UIControlStateNormal];
        [sendBtn setImage:[UIImage imageNamed:@"buddystatus_sendcomment_sel"] forState:UIControlStateHighlighted];
        [sendBtn addTarget:self action:@selector(sendBtnDidOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.inputView = [[UIView alloc] init];
        self.inputView.backgroundColor = RandomColor;
        self.inputView.frame = CGRectMake(0, 0, 100, 100);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat iconViewWH = 45;
    CGFloat iconViewX = margin;
    CGFloat iconViewY = margin;
    CGFloat iconViewW = iconViewWH;
    CGFloat iconViewH = iconViewWH;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    self.iconView.layer.cornerRadius = iconViewW * 0.5;
    
    NSString *link = nil;
    if ([UserManager sharedInstance].brief.imglink && [[UserManager sharedInstance].brief.imglink isKindOfClass:[NSString class]]) {
        link = [UserManager sharedInstance].brief.imglink;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:link] placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    
    CGFloat sendBtnY = iconViewY;
    CGFloat sendBtnW = iconViewWH / 2;
    CGFloat sendBtnH = iconViewWH;
    CGFloat sendBtnX = self.width - margin - sendBtnW;
    self.sendBtn.frame = CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH);
    
    CGFloat commentFieldX = CGRectGetMaxX(self.iconView.frame) + margin;
    CGFloat commentFieldY = iconViewY;
    CGFloat commentFieldH = self.height - 2 * margin;
    CGFloat commentFieldW = CGRectGetMinX(self.sendBtn.frame) - CGRectGetMaxX(self.iconView.frame) - margin * 2;
    self.commentField.frame = CGRectMake(commentFieldX, commentFieldY, commentFieldW, commentFieldH);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.lastHeight = [self.commentField.text sizeWithFont:BuddyStatusCommentInputViewCommentFieldFont andMaxSize:CGSizeMake(self.commentField.width, CGFLOAT_MAX)].height;
}

- (CGFloat)addedHeight
{
    CGFloat height = [self.commentField.text sizeWithFont:BuddyStatusCommentInputViewCommentFieldFont andMaxSize:CGSizeMake(self.commentField.width, CGFLOAT_MAX)].height;
  
    if (height != self.lastHeight) {
        CGFloat h = height - self.lastHeight;
        self.lastHeight = height;
        return h;
    } else {
        return 0;
    }
}

- (void)quit
{
    self.commentField.text = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
    [self.commentField endEditing:YES];
}

- (void)sendBtnDidOnClick
{
    if (self.commentField.text.length == 0) {
        return ;
    }
    NSDictionary * params = @{@"feedid": @(self.feedid),
                              @"comment": self.commentField.text
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_feed_comment_post,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_comment_post]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.commentField.text = @"";
            [MessageView showMessageView:@"评论发表成功" delayTime:2.0];
            if ([self.delegate respondsToSelector:@selector(buddyStatusCommentInputView:sendBtnDidOnClick:)]) {
                [self.delegate buddyStatusCommentInputView:self sendBtnDidOnClick:nil];
            }
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_comment_post]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageView showMessageView:@"评论发表失败,请稍后尝试!" delayTime:2.0];
        });
    }
}
@end
