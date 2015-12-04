//
//  CalloutViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/5.
//
//

/*
 *【喊话内容】界面
 *功能：发布三句话题内容显示到主界面
 *
 */

#import "CalloutViewController.h"
#import "UserManager.h"
#import "BRPlaceholderTextView.h"
#import "NSString+Extension.h"

@interface CalloutViewController ()
@property (nonatomic, weak) BRPlaceholderTextView *callout1;
@property (nonatomic, weak) BRPlaceholderTextView *callout2;
@property (nonatomic, weak) BRPlaceholderTextView *callout3;
@end

@implementation CalloutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"喊话内容";
    CGRect mainRect = [[UIScreen mainScreen]bounds];
    CGFloat padding = 10;
    CGFloat calloutX = padding;
    CGFloat calloutW = mainRect.size.width - padding * 2;
    CGFloat calloutH = 50;
    
    BRPlaceholderTextView *callout1 = [self createTextView:CGRectMake(calloutX, padding, calloutW, calloutH)];
    self.callout1 = callout1;
    [self.contentView addSubview:callout1];
    
    BRPlaceholderTextView *callout2 = [self createTextView:CGRectMake(calloutX, padding * 2 + calloutH, calloutW, calloutH)];
    self.callout2 = callout2;
    [self.contentView addSubview:callout2];

    BRPlaceholderTextView *callout3 = [self createTextView:CGRectMake(calloutX, padding * 3 + calloutH * 2, calloutW, calloutH)];
    self.callout3 = callout3;
    [self.contentView addSubview:callout3];
    
    UIButton *postBtn = [[UIButton alloc] init];
    [self.contentView addSubview:postBtn];
    CGFloat postBtnX = 2 * padding;
    CGFloat postBtnY = padding * 4 + calloutH * 3 + 10;
    CGFloat postBtnW = mainRect.size.width - 4 * padding;
    CGFloat postBtnH = 35;
    postBtn.frame = CGRectMake(postBtnX, postBtnY, postBtnW, postBtnH);
    [postBtn setTitle:@"发布" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont fontWithName:@"FZY3JW--GB1-0 " size:18.0];
    postBtn.backgroundColor = UIColorFromRGB(0x8bce60, 1.0f);
    postBtn.layer.cornerRadius = 3;
    [postBtn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([UserManager sharedInstance].callout1 || [UserManager sharedInstance].callout2 || [UserManager sharedInstance].callout3) {
        self.callout1.text = [UserManager sharedInstance].callout1;
        self.callout2.text = [UserManager sharedInstance].callout2;
        self.callout3.text = [UserManager sharedInstance].callout3;
    }
    else{
        [self requestCalloutList];
    }
}

- (BRPlaceholderTextView *)createTextView:(CGRect)frame{
    BRPlaceholderTextView *textView = [[BRPlaceholderTextView alloc] initWithFrame:frame];
    textView.placeholder = @" 添加喊话内容";
    textView.maxTextLength = 20;
    textView.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    [textView setFont:[UIFont fontWithName:k_fontName_FZXY size:13.0]];
    textView.layer.cornerRadius = 3;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = UIColorFromRGB(0x99d472, 1.0f).CGColor;
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"20字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:11];
    maxLabel.textColor = UIColorFromRGB(0xb29474, 1.0f);
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(textView.frame) - maxLabelSize.width - 5, CGRectGetHeight(textView.frame) - maxLabelSize.height - 5, maxLabelSize.width, maxLabelSize.height);
    [textView addSubview:maxLabel];
    
    return textView;
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
//    if(callback){
//        callback( 1 );
//    }
}

- (void)requestCalloutList{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid]
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_shout_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_showError:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)post{
    NSDictionary * params = @{@"content1": self.callout1.text,
                              @"content2": self.callout2.text,
                              @"content3": self.callout3.text};
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_shout_update,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_update]) {
        [UserManager sharedInstance].callout1 = self.callout1.text;
        [UserManager sharedInstance].callout2 = self.callout2.text;
        [UserManager sharedInstance].callout3 = self.callout3.text;
        
        [self clickLeftBackButtonItem:nil];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_list]) {
        NSDictionary * res = [result objectOutForKey:@"res"];
        if (res) {
            [[UserManager sharedInstance] saveCallouts:res];
            self.callout1.text = [UserManager sharedInstance].callout1;
            self.callout2.text = [UserManager sharedInstance].callout2;
            self.callout3.text = [UserManager sharedInstance].callout3;
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_update]) {
    }
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_list]) {
        
    }
}
@end
