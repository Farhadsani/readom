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
    [self setupRightBackButtonItem:nil img:@"about_1.png" del:self sel:@selector(clickRightBackButtonItem:)];
    
    CGFloat width = self.view.width;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, width, 20)];
    self.tipLabel = tipLabel;
    [self.contentView addSubview:tipLabel];
    tipLabel.text = @"有任何疑问请给我们留言，并可以留下联系方式";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont fontWithName:k_fontName_FZXY size:13];
    tipLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    
    BRPlaceholderTextView *msgTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(20, 40, width-40, 160)];
    self.msgTextView = msgTextView;
    [self.contentView addSubview:msgTextView];
    msgTextView.placeholder = @" 请填写反馈内容";
    msgTextView.maxTextLength = 100;
    msgTextView.textColor = UIColorFromRGB(0xb29474, 1.0f);
    [msgTextView setFont:[UIFont fontWithName:k_fontName_FZXY size:11]];
    msgTextView.layer.cornerRadius = 5;
    msgTextView.layer.borderWidth = 0.5;
    msgTextView.layer.borderColor = UIColorFromRGB(0x99d472, 1.0f).CGColor;
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"100字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:9];
    maxLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(msgTextView.frame) - maxLabelSize.width - 5, CGRectGetHeight(msgTextView.frame) - maxLabelSize.height - 5, maxLabelSize.width, maxLabelSize.height);
    [msgTextView addSubview:maxLabel];
    
    
    UITextField *connectTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, width-40, 36)];
    self.connectTextField = connectTextField;
    [self.contentView addSubview:connectTextField];
    connectTextField.backgroundColor = [UIColor whiteColor];
    connectTextField.placeholder = @" 请输入联系方式：手机，QQ，微信号";
    connectTextField.textColor = UIColorFromRGB(0xb29474, 1.0f);
    [connectTextField setFont:[UIFont fontWithName:k_fontName_FZXY size:13]];
    connectTextField.layer.cornerRadius = 5;
    connectTextField.layer.borderWidth = 0.5;
    connectTextField.layer.borderColor = UIColorFromRGB(0x99d472, 1.0f).CGColor;
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
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatebrief]) {
        InfoLog(@"error:%@", error);
    }
}
@end
