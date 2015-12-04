/*
 *[登录]页面
 *功能：用户进行登录
 *获取微信登录
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WXLogin.h"
#import "UserManager.h"

#pragma mark -
#pragma mark LoginVCDelegate

@protocol LoginVCDelegate <NSObject>

//调用自动登录接口：[[UserManager sharedInstance] tryCheckLogin:param1 delegate:param2 info:param3 CallBack:param4]，
//其中设置参数param1后，会自动设置登录成功或者失败回调代理（实现下列代理函数即可自动回调），本代理使用在自动登录成功后需要自动刷新页面的情况
@optional
- (void)didLoginSuccessInLoginVC:(NSDictionary *)result;
- (void)didLoginErrorInLoginVC:(NSError *)error;


@end


@protocol LoginDelegate;
@interface LoginViewController : BaseViewController <LoginDelegate>{
    
}
@property(nonatomic, assign) id<LoginVCDelegate> loginVCDelegate;

- (void)wxCallback:(WXLoginInfo*)pWXLoginInfo;


- (void)clickLeftBackButtonItem:(UIButton *)sender;

@end



