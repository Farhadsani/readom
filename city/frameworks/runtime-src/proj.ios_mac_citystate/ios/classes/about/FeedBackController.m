//
//  FeedBackController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/28.
//
//

/*
 *【好友动态】-->【反馈】界面
 *功能：查看好友的发表的动态消息
 *
 */
#import "FeedBackController.h"
#import "BRPlaceholderTextView.h"
#import "NSString+Extension.h"

@interface FeedBackController ()
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, weak) BRPlaceholderTextView *msgTextView;
@property (nonatomic, weak) UITextField *connectTextField;
@end

@implementation FeedBackController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"反馈";
    [self setupRightBackButtonItem:@"发送" img:nil del:self sel:@selector(clickRightBackButtonItem:)];
    
    CGFloat width = self.view.width;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 26)];
    self.tipLabel = tipLabel;
    [self.contentView addSubview:tipLabel];
    tipLabel.text = @"有任何疑问请给我们留言，并可以留下联系方式";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont fontWithName:k_fontName_FZXY size:11];
    tipLabel.textColor = k_defaultTextColor;
    tipLabel.alpha = 0.5;
    
    UIView * msgView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, self.contentView.width, 120)];
    msgView.layer.borderWidth = 0.5;
    msgView.layer.borderColor = k_defaultLineColor.CGColor;
    msgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:msgView];

    BRPlaceholderTextView *msgTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 0, self.contentView.width -10, 120)];
    self.msgTextView = msgTextView;
    [msgView addSubview:msgTextView];
    msgTextView.placeholder = @"请填写反馈内容";
    msgTextView.maxTextLength = 100;
    msgTextView.textColor =k_defaultTextColor;
    [msgTextView setFont:[UIFont fontWithName:k_fontName_FZXY size:14]];
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"100字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:11];
    maxLabel.textColor = yello_color;
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(msgTextView.frame) - maxLabelSize.width, CGRectGetHeight(msgTextView.frame) - maxLabelSize.height - 5, maxLabelSize.width, maxLabelSize.height);
    [msgView addSubview:maxLabel];
    
    UIView * fieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 158, self.contentView.width, 44)];
    fieldView.backgroundColor = [UIColor whiteColor];
    fieldView.layer.borderWidth = 0.5;
    fieldView.layer.borderColor = k_defaultLineColor.CGColor;
    [self.contentView addSubview:fieldView];
    
    UITextField *connectTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.contentView.width, 44)];
    self.connectTextField = connectTextField;
    [fieldView addSubview:connectTextField];
    connectTextField.backgroundColor = [UIColor whiteColor];
    connectTextField.placeholder = @"请输入联系方式：手机，QQ，微信号";
    connectTextField.textColor = k_defaultTextColor;
    [connectTextField setFont:[UIFont fontWithName:k_fontName_FZXY size:14]];
    connectTextField.layer.borderColor = k_defaultLineColor.CGColor;
}

- (void)clickRightBackButtonItem:(UIButton *)sender
{
    NSString *content = self.msgTextView.text;
    NSString *contact = self.connectTextField.text;
    if (content.length <= 0 || contact.length <= 0) {
        [self showMessageView:@"请完整填写信息" delayTime:1.0];
        return ;
    }
    NSDictionary *params = @{@"content": content,
                             @"contact": contact};
    NSDictionary *dict = @{@"idx":str((++self.index)%1000),
                           @"ver":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           @"params":params,
                           };
    NSDictionary *d = @{k_r_url:k_api_feedback_add,
                        k_r_delegate:self,
                        k_r_postData:dict,
                        };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feedback_add]) {
        [self showMessageView:@"感谢您的反馈！"  delayTime:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feedback_add]) {
        
    }
}
@end
