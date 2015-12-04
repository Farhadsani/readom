/*
 *[绑定手机号]页面
 *
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BaseUIViewController.h"
#import "WXLogin.h"

@interface RegisterViewController : BaseViewController <UITextFieldDelegate, LoginDelegate>{
    
}

@property (nonatomic, retain) WXLoginInfo *loginInfo;

@end
