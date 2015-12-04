/*
 *[登录]页面
 *功能：用户进行登录
 *获取微信登录
 */

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "WXLogin.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate, LoginDelegate>{
    
}

-(void)wxCallback:(WXLoginInfo*)pWXLoginInfo;


- (void)clickLeftBackButtonItem:(UIButton *)sender;

@end
