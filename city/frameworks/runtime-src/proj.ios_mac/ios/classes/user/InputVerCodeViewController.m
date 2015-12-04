//
//  InputVerCodeViewController.h.m
//  cxy
//
//  Created by hf on 15/6/28.
//  Copyright (c) 2015年 hf. All rights reserved.
//

/*
 *【找回密码】
 *获取验证码、进行验证码验证。
 */
#import "InputVerCodeViewController.h"
#import "ChangePasswordViewController.h"

#define k_MaxTime 120

@interface InputVerCodeViewController (){
    UIButton * nextButton;
    
    UIButton * timeButton;
    NSInteger count;
    NSTimer * leaseTimer;
}

@property(nonatomic, retain) UITextField * varCodeTextField;

@end


@implementation InputVerCodeViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    count = k_MaxTime;
    
    [self createMainView];
}

#pragma mark request

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_findpwdverify]) {
        //跳转到修改密码界面
        ChangePasswordViewController * vc = [[[ChangePasswordViewController alloc] initWithNibName:nil bundle:nil]autorelease];
        vc.title = @"设置密码";
        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.data_dict];
        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.post_dict];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        [self showMessageView:@"验证码已发送到您的手机" delayTime:3.0];
    }
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    InfoLog(@"error:%@", error);
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        [self stopTimer];
        
        timeButton.userInteractionEnabled = YES;
        timeButton.selected = YES;
    }
}
- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
//    InfoLog(@"%@", textField);
    if (![NSString isEmptyString:_varCodeTextField.text]) {
        nextButton.userInteractionEnabled = YES;
        nextButton.selected = YES;
    }
    else{
        nextButton.userInteractionEnabled = NO;
        nextButton.selected = NO;
    }
}

#pragma mark action

- (void)doSave:(id)sender{
    if (_varCodeTextField.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入验证码"];
    }
    else{
        [self.post_dict setNonEmptyObject:_varCodeTextField.text forKey:@"vercode"];
        
        [self requestFindpwdverify];
        
//        ChangePasswordViewController * vc = [[[ChangePasswordViewController alloc] initWithNibName:nil bundle:nil]autorelease];
//        vc.title = @"设置密码";
//        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.data_dict];
//        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.post_dict];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestFindpwdverify{
    NSDictionary * params = @{@"phone":[self.data_dict objectOutForKey:@"phone"],
                              @"verify":_varCodeTextField.text,
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_findpwdverify,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}
- (void)requestSendsms{
    [self beginTimer];
    
    NSDictionary * params = @{@"phone":[self.data_dict objectOutForKey:@"phone"],
                              @"type":@"find"
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_sendsms,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - init & dealloc

- (void)createMainView{
    NSString * phone = [self.data_dict objectOutForKey:@"phone"];
    if (phone.length >= 11) {
        phone = [NSString stringWithFormat:@"您的账号绑定的手机：%@******%@\n会收到一条含有6位数字验证码的短信", [phone substringToIndex:2],[phone substringFromIndex:phone.length-4]];
    }
    else{
        phone = [NSString stringWithFormat:@"您的账号绑定的手机号为：%@\n会收到一条含有6位数字验证码的短信",phone];
    }
    
    CGFloat margin = 42;
    
    UILabel * lab = [UIView label:@{V_Parent_View:self.contentView,
                                    V_Margin_Top:strFloat(20.0),
                                    V_Margin_Left:strFloat(margin),
                                    V_Margin_Right:strFloat(margin),
                                    V_Height:@60,
                                    V_Color:darkZongSeColor,
                                    V_Font_Size:@14,
                                    V_NumberLines:@4,
                                    V_Font_Family:k_fontName_FZXY,
                                    V_Text:phone
                                    }];
    [self.contentView addSubview:lab];
    
    margin = 30;
    self.varCodeTextField = [UIView textFiled:@{V_Parent_View:self.contentView,
                                                V_Last_View:lab,
                                                V_Margin_Top:strFloat(20),
                                                V_Margin_Left:strFloat(margin),
                                                V_Margin_Right:strFloat(margin),
                                                V_Height:@40,
                                                V_Font_Size:@(15),
                                                V_Color:darkblack_color,
                                                V_tintColor:darkZongSeColor,
                                                V_Delegate:self,
                                                V_Font_Family:k_fontName_FZXY,
                                                V_Placeholder:@"请输入验证码"}];
    [self.contentView addSubview:_varCodeTextField];
    
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:_varCodeTextField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Height:@0.5,
                                       V_BGColor:lightZongSeBGColor,
                                       }];
    [self.contentView addSubview:line];
    
    nextButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:_varCodeTextField,
                                  V_Height:numFloat(35),
                                  V_Margin_Top:numFloat(fit_H(30)),
                                  V_Margin_Left:numFloat(margin),
                                  V_Margin_Right:numFloat(margin),
                                  V_BGColor:slightGrayColor3,
                                  V_BGImg_S:green_color,
                                  V_Color:white_color,
                                  V_Font_Size:num(16),
                                  V_Font_Weight:num(FontWeightBold),
                                  V_Tag:@2,
                                  V_Border_Radius:@2,
                                  V_Selected:num(SelectedNO),
                                  V_Click_Enable:num(Click_No),
                                  V_Delegate:self,
                                  V_Font_Family:k_fontName_FZXY,
                                  V_SEL:selStr(@selector(doSave:)),
                                  V_Title:@"确 定"}];
    [self.contentView addSubview:nextButton];
    
    timeButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:nextButton,
                                  V_Height:numFloat(35),
                                  V_Margin_Top:numFloat(fit_H(20)),
                                  V_Margin_Left:numFloat(margin),
                                  V_Margin_Right:numFloat(margin),
                                  V_BGColor:minlightZongSeBGColor,
                                  V_BGImg_S:green_color,
                                  V_Color:darkZongSeColor,
                                  V_Color_S:white_color,
                                  V_Font_Size:num(14),
                                  V_Font_Weight:num(FontWeightBold),
                                  V_Tag:@2,
                                  V_Border_Radius:@2,
                                  V_Selected:num(SelectedNO),
                                  V_Click_Enable:num(Click_No),
                                  V_Delegate:self,
                                  V_Font_Family:k_fontName_FZXY,
                                  V_SEL:selStr(@selector(requestSendsms)),
                                  V_Title:@"120秒后重新发送验证码",
                                  V_Title_S:@"重新发送验证码",
                                  }];
    [self.contentView addSubview:timeButton];
    
    [self beginTimer];
}

- (void)beginTimer{
    [self stopTimer];
    
    if (!leaseTimer) {
        leaseTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginCount:) userInfo:nil repeats:YES];
    }
}

- (void)beginCount:(NSTimer *)timer{
    count--;
    if (count <= 0) {
        timeButton.userInteractionEnabled = YES;
        timeButton.selected = YES;
        
        [self stopTimer];
    }
    else{
        timeButton.userInteractionEnabled = NO;
        timeButton.selected = NO;
        [timeButton setTitle:[NSString stringWithFormat:@"%d秒后重新发送验证码", (int)count] forState:UIControlStateNormal];
    }
}

- (void)stopTimer{
    if (leaseTimer) {
        [leaseTimer invalidate];
        leaseTimer = nil;
    }
    count = k_MaxTime;
    [timeButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
}

@end
