//
//  BindNewPhoneNumber.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import "BindNewPhoneNumberView.h"
#import "MBProgressHUD+Extension.h"
#import "LoginViewController.h"
#import "BaseViewController.h"

#define BindNewPhoneNumberViewFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define BindNewPhoneNumberViewSendSMSBtnFont [UIFont fontWithName:k_fontName_FZZY size:11]

@interface BindNewPhoneNumberView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) int index;
@end

@implementation BindNewPhoneNumberView
+ (instancetype)bindNewPhoneNumberView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BindNewPhoneNumberView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.titleLabel.font = BindNewPhoneNumberViewFont;
    self.titleLabel.textColor = gray_color;
    
    self.phoneField.font = BindNewPhoneNumberViewFont;
    self.phoneField.textColor = darkGary_color;
    
    self.sendSMSBtn.titleLabel.font = BindNewPhoneNumberViewSendSMSBtnFont;
    [self.sendSMSBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendSMSBtn setTitleColor:yello_color forState:UIControlStateDisabled];

    self.codeField.font = BindNewPhoneNumberViewFont;
    self.codeField.textColor = gray_color;
    
    self.nextBtn.titleLabel.font = BindNewPhoneNumberViewFont;
    [self.nextBtn setTitleColor:yello_color forState:UIControlStateNormal];
}

- (IBAction)sendSMSBtnDidOnClick:(UIButton *)sender
{
    if (self.phoneField.text.length != 11) {
        [[ExceptionEngine shared] popMsg:@"请输入正确的手机号!"];
        return ;
    }
    
    [self.sendSMSBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.count = 15;
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [self.countTimer fire];
    
    NSDictionary * params = @{@"phone": self.phoneField.text,
                              @"type": @"phone",
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_sendsms,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (IBAction)nextBtnDidOnClick:(UIButton *)sender
{
    if (self.codeField.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入验证码!"];
        return ;
    }
    
    [[LoadingView shared] setIsFullScreen:YES];
    NSDictionary * params = @{@"phone": self.phoneField.text,
                              @"verify": self.codeField.text,
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_resetphone,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)countDown
{
    if (self.count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        self.sendSMSBtn.enabled = YES;
        [self.sendSMSBtn setBackgroundImage:[UIImage imageNamed:@"store_sendsmsbtnbg"] forState:UIControlStateNormal];
    } else {
        self.sendSMSBtn.enabled = NO;
        [self.sendSMSBtn setTitle:[NSString stringWithFormat:@"再次发送(%d)", self.count] forState:UIControlStateDisabled];
        self.count--;
    }
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        [MessageView showMessageView:@"验证码已发送，请注意查收" delayTime:3.0];
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_resetphone]) {
        [UserManager sharedInstance].base.phone = self.phoneField.text;
        [UserManager sharedInstance].brief.phone = self.phoneField.text;
        [[NSUserDefaults standardUserDefaults] setObject:[UserManager sharedInstance].base.phone forKey:@"SHITOUREN_UD_PHONE"];
        [[NSUserDefaults standardUserDefaults] setObject:[UserManager sharedInstance].brief.phone forKey:@"SHITOUREN_UD_PHONE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.delegate respondsToSelector:@selector(bindNewPhoneNumberView:withSuccessPhoneNumber:)]) {
            [self.delegate bindNewPhoneNumberView:self withSuccessPhoneNumber:[req.data_dict objectOutForKey:k_r_postData][@"params"][@"phone"]];
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        InfoLog(@"error:%@", error);
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_resetphone]) {
        InfoLog(@"error:%@", error);
    }
}
@end
