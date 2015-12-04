//
//  ChangePasswordViewController.m
//  cxy
//
//  Created by hf on 15/6/28.
//  Copyright (c) 2015年 hf. All rights reserved.
//

/*
 *[设置密码]页面
 *功能：输入新密码，进行修改
 */
#import "InputVerCodeViewController.h"
#import "ChangePasswordViewController.h"
#import "LoginViewController.h"

@interface ChangePasswordViewController (){
    UIButton * nextButton;
}

@property(nonatomic, retain) UITextField * newPswTextField;
@property(nonatomic, retain) UITextField * newPswAgainTextField;

@end


@implementation ChangePasswordViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    [self createMainView];
}

- (void)doSave:(id)sender{
    if (_newPswTextField.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入新密码"];
    }
    else if (_newPswTextField.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请再次输入新密码"];
    }
    else{
        [self requestResetpwd];
    }
}

- (void)requestResetpwd{
    NSDictionary * params = @{@"phone":[self.data_dict objectOutForKey:@"phone"],
                              @"verify":[self.data_dict objectOutForKey:@"vercode"],
                              @"passwd":[_newPswTextField.text MD5HMACWithKey:k_encryptCode],
                              @"repasswd":[_newPswAgainTextField.text MD5HMACWithKey:k_encryptCode],
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_resetpwd,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark request

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_resetpwd]) {
        [self popToMainController:nil];
    }
}

- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
//    InfoLog(@"%@", textField);
    if (![NSString isEmptyString:_newPswTextField.text] && ![NSString isEmptyString:_newPswAgainTextField.text]) {
        nextButton.userInteractionEnabled = YES;
        nextButton.selected = YES;
    }
    else{
        nextButton.userInteractionEnabled = NO;
        nextButton.selected = NO;
    }
}

- (void)popToMainController:(id)sender{
    [self.view endEditing:YES];
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            [self showMessageView:@"设置密码成功，请使用新密码重新登录！" delayTime:3.0];
            [self.navigationController popToViewController:vc animated:NO];
//            [(LoginViewController *)vc clickLeftBackButtonItem:nil];
            break;
        }
    }
}

#pragma mark - init & dealloc

- (void)createMainView{
    CGFloat margin = 42;
    
    UILabel * lab = [UIView label:@{V_Parent_View:self.contentView,
                                    V_Margin_Top:strFloat(20.0),
                                    V_Margin_Left:strFloat(margin),
                                    V_Margin_Right:strFloat(margin),
                                    V_Height:@30,
                                    V_Color:darkZongSeColor,
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_NumberLines:@2,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Text:@"设置新密码"
                                    }];
    [self.contentView addSubview:lab];
    
    margin = 20;
    self.newPswTextField = [UIView textFiled:@{V_Parent_View:self.contentView,
                                               V_Last_View:lab,
                                               V_Margin_Left:strFloat(margin),
                                               V_Margin_Right:strFloat(margin),
                                               V_Margin_Top:@20,
                                               V_Height:numFloat(40),
                                               V_Font_Size:num(15),
                                               V_LeftImageMarginLeft:strFloat(15),
                                               V_LeftTextMarginLeft:strFloat(15),
                                               V_Color:darkZongSeColor,
                                               V_tintColor:darkZongSeColor,
                                                V_Font_Family:k_fontName_FZXY,
                                               V_LeftImage:@"login-5-1",
                                               V_Delegate:self,
                                               V_Font_Family:k_fontName_FZXY,
                                               V_IsSecurity:num(SecurityYES),
                                               V_Placeholder:@"请输入新密码"}];
    [self.contentView addSubview:_newPswTextField];
    
    margin = 42;
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:_newPswTextField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Height:@0.5,
                                       V_BGColor:lightZongSeBGColor,
                                       }];
    [self.contentView addSubview:line];
    
    margin = 20;
    self.newPswAgainTextField = [UIView textFiled:@{V_Parent_View:self.contentView,
                                                    V_Last_View:line,
                                                    V_Margin_Left:strFloat(margin),
                                                    V_Margin_Right:strFloat(margin),
                                                    V_Height:numFloat(40),
                                                    V_Font_Size:num(15),
                                                    V_LeftImageMarginLeft:strFloat(15),
                                                    V_LeftTextMarginLeft:strFloat(15),
                                                    V_Color:darkZongSeColor,
                                                     V_Font_Family:k_fontName_FZXY,
                                                    V_tintColor:darkZongSeColor,
                                                    V_LeftImage:@"login-5-1",
                                                    V_Delegate:self,
                                                    V_Font_Family:k_fontName_FZXY,
                                                    V_IsSecurity:num(SecurityYES),
                                                    V_Placeholder:@"请再次输入新密码"}];
    [self.contentView addSubview:_newPswAgainTextField];
    
    margin = 42;
    line = [UIView view_sub:@{V_Parent_View:self.contentView,
                              V_Last_View:_newPswAgainTextField,
                              V_Margin_Left:strFloat(margin),
                              V_Margin_Right:strFloat(margin),
                              V_Height:@0.5,
                              V_BGColor:lightZongSeBGColor,
                              }];
    [self.contentView addSubview:line];
    
    nextButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:_newPswAgainTextField,
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
                                  V_SEL:selStr(@selector(doSave:)),
                                  V_Title:@"确 定"}];
    [self.contentView addSubview:nextButton];
}


@end
