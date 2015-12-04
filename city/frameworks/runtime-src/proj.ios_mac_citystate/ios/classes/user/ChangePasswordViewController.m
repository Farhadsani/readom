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
@property(nonatomic, retain) UIView * changePassView;
@end


@implementation ChangePasswordViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButtonItem:@"" img:@"left_w_bg" action:@selector(clickLeftBackButtonItem:)];
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
                              @"verify":self.verifyNum,
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
    self.changePassView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                             V_BGColor:milky_color,
                                             }];
    [self.contentView addSubview:_changePassView];
    
    CGFloat half_hei = kScreenHeight/2.0 - 64;
    CGFloat margin = 35;
    
    CGFloat top = 80;
    CGFloat marginLeft = 35;
    CGFloat lineHeight = 40;
    CGFloat spaceTop = 30;
    
    UILabel * bLabel = [UIView label:@{V_Parent_View:self.changePassView,
                                       V_Height:strFloat(half_hei/2.0 - 35),
                                       V_TextAlign:num(TextAlignCenter),
                                       V_Color:darkGary_color,
                                       V_Font_Family:k_fontName_FZZY,
                                       V_Font_Weight:num(FontWeightBold),
                                       V_Font_Size:@18,
                                       V_Text:@"修改密码",
                                       }];
    [self.changePassView addSubview:bLabel];
    
        UILabel * cLabel = [UIView label:@{V_Parent_View:self.changePassView,
                                           V_Last_View:bLabel,
                                           V_Margin_Top:strFloat(bLabel.y - 30),
                                           V_TextAlign:num(TextAlignCenter),
                                           V_Height:@40,
                                           V_Color:k_defaultLightTextColor,
                                           V_Alpha:@0.5,
                                           V_Font_Family:k_fontName_FZXY,
                                           V_Font_Size:@10,
                                           V_Font_Weight:num(FontWeightBold),
                                           V_Text:@"请注意区分大小写",
                                           }];
        [bLabel addSubview:cLabel];

    
    UILabel * country = [UIView label:@{V_Parent_View:_changePassView,
                                        V_Margin_Top:strFloat(top),
                                        V_Margin_Left:strFloat(marginLeft+10),
                                        V_Height:strFloat(lineHeight),
                                        V_Color:darkGary_color,
                                        V_Font_Size:@15,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Text:@"国家和地区",
                                        }];
    [self.changePassView addSubview:country];
    
    UILabel * city = [UIView label:@{V_Parent_View:_changePassView,
                                     V_Margin_Top:strFloat(top),
                                     V_Margin_Right:strFloat(marginLeft+10),
                                     V_Color:yello_color,
                                     V_Font_Size:@15,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Text:@"中国",
                                     V_TextAlign:num(TextAlignRight),
                                     }];
    [self.changePassView addSubview:city];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:_changePassView,
                                        V_Last_View:country,
                                        V_Margin_Top:@-8,
                                        V_Margin_Top:strFloat(country.y - 5),
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_BGColor:yello_color,
                                        }];
    [_changePassView addSubview:line1];
    
    
    CGFloat filed = 35;
    
    self.newPswTextField = [UIView textFiled:@{V_Parent_View:_changePassView,
                                                   V_Last_View:country,
                                                   V_Margin_Left:strFloat(margin),
                                                   V_Margin_Right:strFloat(margin),                                               V_Height:strFloat(filed),
                                                   V_Margin_Top:strFloat(spaceTop-8),
                                                   V_Font_Size:num(16),
                                                   V_LeftImageMarginLeft:strFloat(0),
                                                   V_LeftTextMarginLeft:strFloat(0),
                                                   V_Color:darkGary_color,
                                                   V_tintColor:darkGary_color,
                                                   V_Tag:@20,
                                                   V_Font_Family:k_fontName_FZZY,
                                                   V_KeyboardType:num(Number),
                                                   V_Delegate:self,
                                                   V_Placeholder:@"请输入新密码"}];
    [self.contentView addSubview:_newPswTextField];
    
    
    UIView * line2 = [UIView view_sub:@{V_Parent_View:_changePassView,
                                        V_Last_View:_newPswTextField,
                                        V_Margin_Top:@-8,
                                        V_Margin_Left:strFloat(margin),
                                        V_Margin_Right:strFloat(margin),
                                        V_Height:@1,
                                        V_BGColor:yello_color,
                                        }];
    [_changePassView addSubview:line2];

    self.newPswAgainTextField = [UIView textFiled:@{V_Parent_View:self.changePassView,
                                                V_Last_View:line2,
                                                V_Margin_Top:strFloat(spaceTop - 8),
                                                V_Margin_Left:strFloat(margin),
                                                V_Margin_Right:strFloat(margin),
                                                V_Height:@40,
                                                V_Font_Size:num(16),
                                                V_Color:darkZongSeColor,
                                                V_tintColor:darkZongSeColor,
                                                V_Delegate:self,
                                                V_KeyboardType:num(Number),
                                                V_Font_Weight:num(FontWeightBold),
                                                V_Font_Family:k_fontName_FZZY,
                                                V_Placeholder:@"再次输入"}];
    [self.contentView addSubview:_newPswAgainTextField];
    
    margin = 35;
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:_newPswAgainTextField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Margin_Top:@-8,
                                       V_Height:@1,
                                       V_BGColor:yello_color,
                                       }];
    [self.contentView addSubview:line];
    
    
    
    lineHeight = 50;
    
    nextButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:_newPswAgainTextField,
                                  V_Height:numFloat(lineHeight),
                                  V_Margin_Top:@40,
                                  V_Margin_Left:numFloat(marginLeft),
                                  V_Margin_Right:numFloat(marginLeft),
                                  V_Color:white_color,
                                  V_BGColor:yello_color,
                                  V_Font_Size:num(16),
                                  V_Font_Weight:num(FontWeightBold),
                                  V_Font_Family:k_fontName_FZZY,
                                  V_Border_Radius:strFloat(lineHeight/2.0),
                                  V_Border_Color:yello_color,
                                  V_Border_Width:@1,
                                  V_Delegate:self,
                                  V_SEL:selStr(@selector(doSave:)),
                                  V_Title:@"立即修改"}];
    [self.contentView addSubview:nextButton];
    
    
}

@end
