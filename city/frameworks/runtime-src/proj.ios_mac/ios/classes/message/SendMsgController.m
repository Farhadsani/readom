//
//  SendMsgController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/28.
//
//


/*
 *好友空间中 [消息]界面
 *功能：给好友的个人空间中发送消息
 */

#import "SendMsgController.h"
#import "BRPlaceholderTextView.h"
#import "NSString+Extension.h"

@interface SendMsgController ()
@property (nonatomic, weak) BRPlaceholderTextView *msgTextView;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) long userid;
@end

@implementation SendMsgController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    
    CGFloat width = self.view.width;
    BRPlaceholderTextView *msgTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(20, 20, width-40, 160)];
    self.msgTextView = msgTextView;
    [self.contentView addSubview:msgTextView];
    msgTextView.placeholder = @"填写内容...";
    msgTextView.maxTextLength = 100;
    msgTextView.textColor = UIColorFromRGB(0xb29474, 1.0f);
    [msgTextView setFont:[UIFont fontWithName:k_fontName_FZXY size:15]];
    msgTextView.layer.cornerRadius = 5;
    msgTextView.layer.borderWidth = 0.5;
    msgTextView.layer.borderColor = UIColorFromRGB(0x99d472, 1.0f).CGColor;
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"100字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:11];
    maxLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(msgTextView.frame) - maxLabelSize.width - 5, CGRectGetHeight(msgTextView.frame) - maxLabelSize.height - 5, maxLabelSize.width, maxLabelSize.height);
    [msgTextView addSubview:maxLabel];
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [self.contentView addSubview:sendBtn];
    CGFloat padding = 50;
    CGFloat logoutBtnX = padding;
    CGFloat logoutBtnY = 200;
    CGFloat logoutBtnW = width - padding * 2;
    CGFloat logoutBtnH = 35;
    sendBtn.frame = CGRectMake(logoutBtnX, logoutBtnY, logoutBtnW, logoutBtnH);
    [sendBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor color:green_color] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:18.0];
    sendBtn.backgroundColor = UIColorFromRGB(0x8bce60, 1.0f);
    [sendBtn addTarget:self action:@selector(sendBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    CALayer *sendBtnLayer = sendBtn.layer;
    sendBtnLayer.cornerRadius = 5;
}


- (void)sendBtnOnClick
{
    NSString *content = self.msgTextView.text;
    if (content.length <= 0) {
        [self showMessageView:@"请填写消息!" delayTime:1.0];
        return ;
    }
    NSDictionary *params = @{@"content": content,
                             @"peerid": @(self.userid)};
    NSDictionary *dict = @{@"idx":str((++self.index)%1000),
                           @"ver":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           @"params":params,
                           };
    NSDictionary *d = @{k_r_url:k_api_message_user_add,
                        k_r_delegate:self,
                        k_r_postData:dict,
                        };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_user_add]) {
        [self showMessageView:@"已成功发送了消息！"  delayTime:1.0];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clickLeftBackButtonItem:nil];
//        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_user_add]) {
        InfoLog(@"error:%@", error);
    }
}

-(void)setUserInfo:(long)userID
{
    self.userid = userID;
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if( callback ){
//        callback( 1 );
//    }
}
@end
