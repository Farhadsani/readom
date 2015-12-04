//
//  UserBaseInfoEditController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/28.
//
//

/*
 *[基本资料]编辑页面
 *功能：编辑 用户的名称、个人简介.完成操作
 *
 */
 
#import "UserBaseInfoEditController.h"
#import "UserManager.h"

@interface UserBaseInfoEditController ()
@property (nonatomic, weak) UITextView *textView;
@end

@implementation UserBaseInfoEditController
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = @"基本资料";
    
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    [self.contentView addSubview:textView];
    if (self.titleLabelType == UserBaseInfoTitleLabelTypeZone) {
        textView.text = self.userBriefItem.zone;
    } else if (self.titleLabelType == UserBaseInfoTitleLabelTypeIntro) {
        textView.text = self.userBriefItem.intro;
    }
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    CALayer *textFieldLayer = textView.layer;
    textFieldLayer.borderColor = [UIColor color:green_color].CGColor;
    textFieldLayer.borderWidth = 0.5;
    textFieldLayer.cornerRadius = 5;
    CGFloat padding = 20;
    CGFloat textFieldX = padding;
    CGFloat textFieldY = padding;
    CGFloat textFieldW = self.contentView.width - padding * 2;
    CGFloat textFieldH = 160;
    textView.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
    
    if (self.editable) {
        [self setupRightBackButtonItem:@"完成" img:nil del:self sel:@selector(clickRightBackButtonItem:)];
        textView.editable = YES;
    } else {
        textView.editable = NO;
    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}

- (void)clickRightBackButtonItem:(UIButton *)sender
{
    if (self.textView.editable == NO) return;
    
    NSString *zone = self.userBriefItem.zone;
    NSString *intro = self.userBriefItem.intro;
    if (self.titleLabelType == UserBaseInfoTitleLabelTypeZone) {
        zone = self.textView.text;
    } else if (self.titleLabelType == UserBaseInfoTitleLabelTypeIntro) {
        intro = self.textView.text;
    }
    
    NSDictionary *params = @{@"zone": zone,
                              @"intro": intro};
    NSDictionary *dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                            @"params":params,
                            };
    NSDictionary *d = @{k_r_url:k_api_user_updatebrief,
                        k_r_delegate:self,
                        k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatebrief]) {
        [[UserManager sharedInstance] updateUserData:[result objectOutForKey:@"res"]];
        self.userBriefItem = [UserManager sharedInstance].brief;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatebrief]) {
        InfoLog(@"error:%@", error);
    }
}
@end
