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
@end

@implementation SendMsgController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    self.contentView.backgroundColor = [UIColor color:k_defaultViewControllerBGColor];
    [self setupRightBackButtonItem:@"发送" img:nil del:self sel:@selector(sendBtnOnClick)];
    
    UIView * bgView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                         V_Width:strFloat(self.contentView.width),
                                         V_Height:@100,
                                         V_Margin_Top:@10,
                                         V_BGColor:white_color,
                                         V_Border_Width:@0.5,
                                         V_Border_Color:k_defaultLineColor,
                                         }];
    [self.contentView addSubview:bgView];
    
    BRPlaceholderTextView *msgTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 0,self.contentView.width, 100)];
    self.msgTextView = msgTextView;
    [bgView addSubview:msgTextView];
    msgTextView.placeholder = @"填写内容...";
    msgTextView.backgroundColor = [UIColor whiteColor];
    msgTextView.maxTextLength = 100;
    msgTextView.textColor = k_defaultTextColor;
    [msgTextView setFont:[UIFont fontWithName:k_fontName_FZXY size:15]];

    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"100字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:13];
    maxLabel.textColor = yello_color;
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(msgTextView.frame) - maxLabelSize.width - 15, CGRectGetHeight(msgTextView.frame) - maxLabelSize.height - 15, maxLabelSize.width, maxLabelSize.height);
    [bgView addSubview:maxLabel];
    
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

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}
@end
