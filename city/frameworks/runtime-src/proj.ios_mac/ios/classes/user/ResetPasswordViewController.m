//
//  ResetPasswordViewController.m
//  cxy
//
//  Created by hf on 15/6/28.
//  Copyright (c) 2015年 hf. All rights reserved.
//

/*
 *[找回密码]页面
 *功能：用于用户找回密码、发送手机验证码，进行密码重制
 *
 */

#import "ResetPasswordViewController.h"
#import "InputVerCodeViewController.h"

@interface ResetPasswordViewController (){
    UIButton * nextButton;    
}

@property(nonatomic, retain) UITextField * phoneInputTextField;

@end

@implementation ResetPasswordViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    [self createMainView];
}

#pragma mark - request
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        //跳转到修改密码界面
        [self showMessageView:@"验证码已发送到您的手机，请注意查收" delayTime:3.0];
        InputVerCodeViewController * vc = [[[InputVerCodeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        vc.title = @"找回密码";
        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.post_dict];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
//    InfoLog(@"%@", textField);
    if (![NSString isEmptyString:_phoneInputTextField.text]) {
        nextButton.userInteractionEnabled = YES;
        nextButton.selected = YES;
    }
    else{
        nextButton.userInteractionEnabled = NO;
        nextButton.selected = NO;
    }
}

#pragma mark - action

- (void)doSend:(id)sender{
    [self.view endEditing:YES];
    
    if (_phoneInputTextField.text.length > 0 && _phoneInputTextField.text.length <= 11) {
        [self.post_dict setNonEmptyObject:_phoneInputTextField.text forKey:@"phone"];
        [self requestSendsms];
        
//        //跳转到修改密码界面
//        [self showMessageView:@"验证码已发送到您的手机" delayTime:2.0];
//        InputVerCodeViewController * vc = [[[InputVerCodeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//        vc.title = @"找回密码";
//        [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.post_dict];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [[ExceptionEngine shared] popMsg:@"请输入有效的手机号"];
    }
}

- (void)requestSendsms{
    NSDictionary * params = @{@"phone":_phoneInputTextField.text,
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
    CGFloat margin = 42;

    UILabel * lab = [UIView label:@{V_Parent_View:self.contentView,
                                    V_Margin_Top:strFloat(20.0),
                                    V_Margin_Left:strFloat(margin),
                                    V_Margin_Right:strFloat(margin),
                                    V_Height:@60,
                                    V_Color:darkZongSeColor,
                                    V_Font_Size:@14,
                                    V_NumberLines:@2,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Text:@"输入注册或绑定的手机号，获取验证码短信"
                                    }];
    [self.contentView addSubview:lab];
    
    margin = 20;
    self.phoneInputTextField = [UIView textFiled:@{V_Parent_View:self.contentView,
                                                   V_Last_View:lab,
                                                   V_Margin_Top:strFloat(30),
                                                   V_Margin_Left:strFloat(margin),
                                                   V_Margin_Right:strFloat(margin),
                                                   V_Height:@40,
                                                   V_Font_Size:num(16),
                                                   V_LeftImageMarginLeft:strFloat(15),
                                                   V_LeftTextMarginLeft:strFloat(15),
                                                   V_Color:darkZongSeColor,
                                                   V_tintColor:darkZongSeColor,
                                                   V_LeftImage:@"login-4-1",
                                                   V_KeyboardType:num(Number),
                                                   V_Delegate:self,
                                                   V_Font_Family:k_fontName_FZZY,
                                                   V_Placeholder:@"请输入手机号"}];
    [self.contentView addSubview:_phoneInputTextField];
    
    margin = 42;
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:_phoneInputTextField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Height:@0.5,
                                       V_BGColor:lightZongSeBGColor,
                                       }];
    [self.contentView addSubview:line];
    
    nextButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:_phoneInputTextField,
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
                                  V_Font_Family:k_fontName_FZZY,
                                  V_SEL:selStr(@selector(doSend:)),
                                  V_Title:@"下一步"}];
    [self.contentView addSubview:nextButton];
}

@end
