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
//#import "InputVerCodeViewController.h"
#import "ChangePasswordViewController.h"

#define k_MaxTime 60

@interface ResetPasswordViewController (){
    UIButton * nextButton;
    UIButton * timeButton;
    UIButton * beginButton;
    NSInteger count;
    NSTimer * leaseTimer;

}

@property(nonatomic, retain) UITextField * phoneInputTextField;
@property(nonatomic, retain) UITextField * varCodeTextField;
@property(nonatomic, retain) UIView * passWordView;
@property(nonatomic, retain) NSString *verify;

@end

@implementation ResetPasswordViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"找回密码";
    count = k_MaxTime;
    [self setupLeftBackButtonItem:@"" img:@"left_w_bg" action:@selector(clickLeftBackButtonItem:)];
    [self createMainView];
}


#pragma mark - request
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_findpwdverify]) {
        if ([[result objectOutForKey:@"ret"] intValue] == 0) { // 验证码正确，，跳转到修改密码界面，开始修改密码
            ChangePasswordViewController * vc = [[[ChangePasswordViewController alloc] initWithNibName:nil bundle:nil]autorelease];
            [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.data_dict];
            [vc.data_dict setNonEmptyValuesForKeysWithDictionary:self.post_dict];
            vc.verifyNum = self.verify;
            [self.navigationController pushViewController:vc animated:YES];
        } else { // 验证码错误
            [[ExceptionEngine shared] popMsg:[result objectOutForKey:@"msg"]];
        }
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
        [self requestSendsms];
    }
    else{
        [[ExceptionEngine shared] popMsg:@"请输入有效的手机号"];
    }
}

- (void)doSave:(id)sender{
    if (_varCodeTextField.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入验证码"];
    }
    else{
        [self requestFindpwdverify];
    }
}

#pragma mark action
- (void)requestSendsms{
    [self beginTimer];
    NSDictionary * params = @{@"phone":_phoneInputTextField.text,
                              @"type":@"find",
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_sendsms,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [self.data_dict setNonEmptyValuesForKeysWithDictionary:params];
    [[ReqEngine shared] tryRequest:d];
}

- (void)requestFindpwdverify{
    NSString *phone = [self.data_dict objectOutForKey:@"phone"];
    self.verify = _varCodeTextField.text;
    if (phone.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入有效的手机号"];
        return ;
    }
    NSDictionary * params = @{@"phone":phone,
                              @"verify":self.verify,
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_findpwdverify,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [self.data_dict setNonEmptyValuesForKeysWithDictionary:params];
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - init & dealloc

- (void)createMainView{
    self.passWordView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                          V_BGColor:milky_color,
                                          }];
    [self.contentView addSubview:_passWordView];
    
    CGFloat half_hei = kScreenHeight/2.0 - 64;
    CGFloat margin = 35;
    
    CGFloat top = 80;
    CGFloat marginLeft = 35;
    CGFloat lineHeight = 40;
    CGFloat spaceTop = 30;
    
    UILabel * bLabel = [UIView label:@{V_Parent_View:self.passWordView,
                                       V_Height:strFloat(half_hei/2.0 - 35),
                                       V_TextAlign:num(TextAlignCenter),
                                       V_Color:darkGary_color,
                                       V_Font_Family:k_fontName_FZZY,
                                       V_Font_Weight:num(FontWeightBold),
                                       V_Font_Size:@18,
                                       V_Text:@"找回密码",
                                       }];
    [self.passWordView addSubview:bLabel];


    UILabel * country = [UIView label:@{V_Parent_View:_passWordView,
                                        V_Margin_Top:strFloat(top),
                                        V_Margin_Left:strFloat(marginLeft+10),
                                        V_Height:strFloat(lineHeight),
                                        V_Color:darkGary_color,
                                        V_Font_Size:@15,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Text:@"国家和地区",
                                        }];
    [self.passWordView addSubview:country];

    UILabel * city = [UIView label:@{V_Parent_View:_passWordView,
                                     V_Margin_Top:strFloat(top),
                                     V_Margin_Right:strFloat(marginLeft+10),
                                     V_Color:yello_color,
                                     V_Font_Size:@15,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Text:@"中国",
                                     V_TextAlign:num(TextAlignRight),
                                     }];
    [self.passWordView addSubview:city];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:_passWordView,
                                        V_Last_View:country,
                                        V_Margin_Top:@-8,
                                        V_Margin_Top:strFloat(country.y - 5),
                                        V_Margin_Left:strFloat(marginLeft),
                                        V_Margin_Right:strFloat(marginLeft),
                                        V_Height:@1,
                                        V_BGColor:yello_color,
                                        }];
    [_passWordView addSubview:line1];
    
    UILabel * cityNum = [UIView label:@{V_Parent_View:_passWordView,
                                        V_Last_View:line1,
                                        V_Margin_Left:strFloat(marginLeft+10),
                                        V_Height:strFloat(lineHeight),
                                        V_Margin_Top:strFloat(spaceTop - 8),
                                        V_Width:@90,
                                        V_Color:darkGary_color,
                                        V_Font_Weight:num(FontWeightBold),
                                        V_Font_Size:@24,
                                        V_Font_Family:k_defaultFontName,
                                        V_Text:@"+86",
                                        V_TextAlign:num(TextAlignCenter),
                                        }];
    [self.passWordView addSubview:cityNum];
    
    UIView * li = [UIView view_sub:@{V_Parent_View:cityNum,
                                     V_BGColor:yello_color,
                                     V_Width:@1,
                                     V_Height:strFloat(cityNum.height - 7),
                                     V_Margin_Top:@-1,
                                     V_Margin_Left:strFloat(cityNum.width - 15),
                                     }];
    [cityNum addSubview:li];
    
    CGFloat filed = 35;
    
    self.phoneInputTextField = [UIView textFiled:@{V_Parent_View:_passWordView,
                                             V_Last_View:country,
                                             V_Left_View:li,
                                             V_Margin_Left:strFloat(li.width + 45),
                                             V_Height:strFloat(filed),
                                             V_Margin_Top:strFloat(spaceTop-12),
                                             V_Font_Size:num(16),
                                             V_LeftImageMarginLeft:strFloat(0),
                                             V_LeftTextMarginLeft:strFloat(0),
                                             V_Color:darkGary_color,
                                             V_tintColor:darkGary_color,
                                             V_Tag:@20,
                                             V_Font_Family:k_fontName_FZZY,
                                             V_KeyboardType:num(Number),
                                             V_Delegate:self,
                                             V_Placeholder:@"请填写手机号码"}];
    [self.passWordView addSubview:_phoneInputTextField];

    
    UIView * line2 = [UIView view_sub:@{V_Parent_View:_passWordView,
                                        V_Last_View:cityNum,
                                        V_Margin_Top:@-8,
                                        V_Margin_Left:strFloat(margin),
                                        V_Margin_Right:strFloat(margin),
                                        V_Height:@1,
                                        V_BGColor:yello_color,
                                        }];
    [_passWordView addSubview:line2];
    
    self.varCodeTextField = [UIView textFiled:@{V_Parent_View:self.passWordView,
                                                V_Last_View:line2,
                                                V_Width:@150,
                                                V_Margin_Top:strFloat(spaceTop -8),
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
                                                V_Placeholder:@"验证码"}];
    [self.passWordView addSubview:_varCodeTextField];
    
    CGFloat butHeight = 45;
    
    beginButton = [UIView button:@{V_Parent_View:self.contentView,
                                   V_Last_View:line2,
                                   V_Height:numFloat(butHeight/ 2.0),
                                   V_Width:numFloat(80),
                                   V_Margin_Top:strFloat(spaceTop - 3),
                                   //                                   V_Margin_Left:numFloat(marginLeft),
                                   V_Margin_Right:numFloat(marginLeft + 10),
                                   V_Color:white_color,
                                   V_BGColor:yello_color,
                                   V_Font_Size:num(12),
                                   V_Font_Weight:num(FontWeightBold),
                                   V_Font_Family:k_fontName_FZZY,
                                   V_Border_Radius:strFloat(butHeight/4.0),
                                   V_Border_Color:yello_color,
                                   V_Border_Width:@1,
                                   V_Delegate:self,
                                   V_Font_Family:k_fontName_FZZY,
                                   V_SEL:selStr(@selector(doSend:)),
                                   V_Title_S:@"再次发送",
                                   V_Title:@"发送验证码"
                                   }];
    [self.passWordView addSubview:beginButton];
    
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:_varCodeTextField,
                                       V_Margin_Left:strFloat(margin),
                                       V_Margin_Right:strFloat(margin),
                                       V_Margin_Top:@-8,
                                       V_Height:@1,
                                       V_BGColor:yello_color,
                                       }];
    [self.passWordView addSubview:line];

    
    
    lineHeight = 50;

    nextButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:line,
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
                                  V_Title:@"立即找回"}];
    [self.passWordView addSubview:nextButton];


}

- (void)beginTimer{
//    [self stopTimer];
    
    if (!leaseTimer) {
        leaseTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginCount:) userInfo:nil repeats:YES];
    }
}

- (void)beginCount:(NSTimer *)timer{
    count--;
    if (count <= 0) {
        beginButton.userInteractionEnabled = YES;
        beginButton.selected = YES;
        
        [self stopTimer];
    }
    else{
        beginButton.userInteractionEnabled = NO;
        beginButton.selected = NO;
        [beginButton setTitle:[NSString stringWithFormat:@"再次发送(%d)", (int)count] forState:UIControlStateNormal];
    }
}

- (void)stopTimer{
    if (leaseTimer) {
        [leaseTimer invalidate];
        leaseTimer = nil;
    }
    count = k_MaxTime;
    [beginButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
}

@end
