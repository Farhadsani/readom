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
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"个性签名";
    [self setupRightBackButtonItem:@"完成" img:nil del:self sel:@selector(clickRightBackButton:)];

    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    [self.contentView addSubview:textView];
    if (self.titleLabelType == UserBaseInfoTitleLabelTypeZone) {
        textView.text = self.userBriefItem.name;
    } else if (self.titleLabelType == UserBaseInfoTitleLabelTypeIntro) {
        textView.text = self.userBriefItem.intro;
    }
    textView.text = self.signText;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor color:k_defaultTextColor];
    CALayer *textFieldLayer = textView.layer;
    textFieldLayer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    textFieldLayer.borderWidth = 0.5;
    textFieldLayer.cornerRadius = 5;
    CGFloat padding = 10;
    CGFloat textFieldY = padding;
    CGFloat textFieldW = self.contentView.width;
    CGFloat textFieldH = self.contentView.height * 1/5;
    textView.frame = CGRectMake(0, textFieldY, textFieldW, textFieldH);
    
//    if (self.editable) {
//        [self setupRightBackButtonItem:@"完成" img:nil del:self sel:@selector(clickRightBackButtonItem:)];
//        textView.editable = YES;
//    } else {
//        textView.editable = YES;
//    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    [self baseBack:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)clickRightBackButton:(UIButton *)sender
{
//    if (self.textView.editable == YES) return;
    
    NSDictionary *params = nil;
    
    NSString *name = self.userBriefItem.name;
    NSString *intro = self.userBriefItem.intro;
    if (self.titleLabelType == UserBaseInfoTitleLabelTypeZone) {
        name = self.textView.text;
        params = @{@"name": name};
    }
    else if (self.titleLabelType == UserBaseInfoTitleLabelTypeIntro) {
        intro = self.textView.text;
        params = @{@"intro": intro};
    }
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
        if ([[UserManager sharedInstance] isCurrentUser:self.userid]) {
            [[UserManager sharedInstance] updateUserData:[result objectOutForKey:@"res"]];
            self.userBriefItem = [UserManager sharedInstance].brief;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.passValueDelegate && [self.passValueDelegate respondsToSelector:@selector(passCalloutValue:)]) {
            [self.passValueDelegate passCalloutValue:self.textView.text];
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatebrief]) {
    }
}
@end
