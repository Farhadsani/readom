//
//  RequstPassWordViewController.m
//  citystate
//
//  Created by 小生 on 15/10/22.
//
//

#import "RequstPassWordViewController.h"

@interface RequstPassWordViewController ()
@property (nonatomic, retain)UIButton * nextButton;
@property (nonatomic,retain)UITextField * currentField;
@property (nonatomic,retain)UITextField * newpassWord;
@property (nonatomic,retain)UITextField * anginPassWord;


@end

@implementation RequstPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.contentView.backgroundColor = [UIColor color:k_defaultViewControllerBGColor];
    [self stupMainView];
}


- (void)doSave:(id)sender{
    if (_currentField.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入当前密码"];
    }
    else if (_newpassWord.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请输入新密码"];
    }
    else if (_anginPassWord.text.length == 0) {
        [[ExceptionEngine shared] popMsg:@"请再次输入新密码"];
    }
    else{
        [self requestResetpwd];
    }
}
#pragma mark -----
- (void)requestResetpwd{
    NSDictionary * params = @{@"oldpasswd":[_currentField.text MD5HMACWithKey:k_encryptCode],
                              @"newpasswd":[_newpassWord.text MD5HMACWithKey:k_encryptCode],
                              @"renewpasswd":[_anginPassWord.text MD5HMACWithKey:k_encryptCode],
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_editpwd,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark request

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_editpwd]) {
        [MessageView showMessageView:@"修改密码成功" delayTime:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_editpwd]) {
        [MessageView showMessageView:@"修改密码失败" delayTime:2.0];
    }
}

- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify{
    //    InfoLog(@"%@", textField);
    if (![NSString isEmptyString:_currentField.text]&& ![NSString isEmptyString:_newpassWord.text] && ![NSString isEmptyString:_anginPassWord.text]) {
        _nextButton.userInteractionEnabled = YES;
        _nextButton.selected = YES;
    }
    else{   
        _nextButton.userInteractionEnabled = NO;
        _nextButton.selected = NO;
    }
}

- (void)stupMainView{
    
    UIView * bgView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                     V_Margin_Top:@10,
                                     V_Width:strFloat(self.contentView.width),
                                     V_Height:@165,
                                     V_BGColor:white_color,
                                     V_Border_Width:@0.5,
                                     V_Border_Color:k_defaultLineColor,
                                     }];
    [self.contentView addSubview:bgView];
    
    self.currentField = [UIView textFiled:@{V_Parent_View:bgView,
                                                     V_Margin_Top:@10,
                                                     V_Margin_Left:@10,
                                                     V_Width:strFloat(self.contentView.width -20),
                                                     V_Height:@40,
                                                     V_Font_Size:@15,
                                                     V_Font_Family:k_fontName_FZZY,
                                                     V_Placeholder:@"请输入当前密码",
                                                     V_Color:k_defaultTextColor,
                                                    V_IsSecurity:num(SecurityYES),
                                                     }];
    [bgView addSubview:_currentField];
    
    UIView * line = [UIView view_sub:@{V_Parent_View:bgView,
                                       V_Last_View:_currentField,
                                       V_Margin_Left:@10,
                                       V_Width:strFloat(self.contentView.width -10),
                                       V_Height:@0.5,
                                       V_Margin_Top:@5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [bgView addSubview:line];
    
    self.newpassWord = [UIView textFiled:@{V_Parent_View:bgView,
                                                    V_Last_View:line,
                                                     V_Margin_Top:@10,
                                                     V_Margin_Left:@10,
                                                     V_Width:strFloat(self.contentView.width -20),
                                                     V_Height:@40,
                                                    V_Font_Size:@15,
                                                    V_Font_Family:k_fontName_FZZY,
                                                     V_Placeholder:@"请输入新密码",
                                                     V_Color:k_defaultTextColor,
                                                    V_IsSecurity:num(SecurityYES),
                                                     }];
    [bgView addSubview:_newpassWord];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:bgView,
                                       V_Last_View:_newpassWord,
                                       V_Margin_Left:@10,
                                       V_Width:strFloat(self.contentView.width -10),
                                       V_Height:@0.5,
                                       V_Margin_Top:@5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [bgView addSubview:line1];
    
    self.anginPassWord = [UIView textFiled:@{V_Parent_View:bgView,
                                                    V_Last_View:line1,
                                                    V_Margin_Top:@10,
                                                    V_Margin_Left:@10,
                                                    V_Width:strFloat(self.contentView.width -20),
                                                    V_Height:@40,
                                                    V_Placeholder:@"请再次输入新密码",
                                                      V_Font_Size:@15,
                                                      V_Font_Family:k_fontName_FZZY,
                                                    V_Color:k_defaultTextColor,
                                                     V_IsSecurity:num(SecurityYES),
                                                    }];
    [bgView addSubview:_anginPassWord];
    
    CGFloat lineHeight = 50;
    CGFloat marginLeft = 35;

     self.nextButton = [UIView button:@{V_Parent_View:self.contentView,
                                  V_Last_View:bgView,
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
                                  V_Title:@"确认修改"}];
    [self.contentView addSubview:_nextButton];
    [_nextButton release];

}

- (void)dealloc{
    [super dealloc];
}
@end
