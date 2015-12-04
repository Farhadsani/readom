#import "UserManager.h"
#import "LoggerClient.h"
#import "NSString+MD5HMAC.h"
#import "LoginViewController.h"
#import "SlideNavigationViewController.h"
#import "AppController.h"

static UserManager * st_UserManager = nil;

@implementation UserManager
//SYNTHESIZE_SINGLETON_FOR_CLASS(UserManager);

+ (UserManager *)sharedInstance{
    if (st_UserManager == nil) {
        st_UserManager = [[UserManager alloc] init];
    }
    return st_UserManager;
}

- (id)init{
    self = [super init];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *tUserid = [defaults stringForKey:@"SHITOUREN_UD_USERID"];
    if( [tUserid isEqualToString:@"null"] ){
        _userid = 0;
    }else{
        _userid = [tUserid intValue];
    }
    index = 0;
    self.ss = [[UserSsItem alloc] init:_userid];
    self.base = [[UserBaseItem alloc] init:_userid];
    self.brief = [[UserBriefItem alloc] init:_userid];
    self.detail = [[UserDetailItem alloc] init:_userid];
    self.callout1 = [defaults stringForKey:@"SHITOUREN_UD_CALLOUT1"];
    self.callout2 = [defaults stringForKey:@"SHITOUREN_UD_CALLOUT2"];
    self.callout3 = [defaults stringForKey:@"SHITOUREN_UD_CALLOUT3"];
    
    _userLoginStatus = Lstatus_loginOut;
    
    [self initUserDict];
    NSDictionary *user_dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_dict"];
    if ([NSDictionary isNotEmpty:user_dict]) {
        [self.user_dict setNonEmptyValuesForKeysWithDictionary:user_dict];
    }
    
    return self;
}

- (void)saveCallouts:(NSDictionary *)res{
    if ([NSDictionary isNotEmpty:res]) {
        NSString * content1 = [res objectOutForKey:@"content1"];
        if (content1) {
            self.callout1 = content1;
            [[NSUserDefaults standardUserDefaults] setObject:content1 forKey:@"SHITOUREN_UD_CALLOUT1"];
        }
        NSString * content2 = [res objectOutForKey:@"content2"];
        if (content2) {
            self.callout2 = content2;
            [[NSUserDefaults standardUserDefaults] setObject:content2 forKey:@"SHITOUREN_UD_CALLOUT2"];
        }
        NSString * content3 = [res objectOutForKey:@"content3"];
        if (content3) {
            self.callout3 = content3;
            [[NSUserDefaults standardUserDefaults] setObject:content3 forKey:@"SHITOUREN_UD_CALLOUT3"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)initUserDict{
    if (!_user_dict) {
        self.user_dict = [[NSMutableDictionary alloc] init];
    }
}

- (BOOL)isCurrentUser:(long)userId{
    if (_userLoginStatus != Lstatus_loginSuccess) {
        return NO;
    }
    
    if (userId == _userid) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasLogin{
    if (_userLoginStatus == Lstatus_loginSuccess) {
        return YES;
    }
    else{
        return NO;
    }
}

//检查登录（如果未登录默认自动跳转到登录界面）
- (BOOL)tryCheckLogin:(id)vc delegate:(id<LoginDelegate>)del info:(NSDictionary *)inf CallBack:(void (^)(int ret))loginCallBack {
//    if (!vc) return NO;
    
    if (self.userLoginStatus == Lstatus_isInLogining) {
        if (del) {
            self.delegate = del;
        }
        if (loginCallBack) {
            loginCallBack(Lstatus_isInLogining);
        }
        InfoLog(@"正在登录中...");
        return NO;
    }
    
    if (self.userLoginStatus == Lstatus_loginSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginSuccess:)]) {
            [self.delegate didLoginSuccess:[Cache shared].user_dict];
        }
        if (loginCallBack) {
            loginCallBack(Lstatus_loginSuccess);
        }
        return YES;
    }
    
    [self validate: ^(int ret){
        if(ret == 1){  // 登录成功
            [self initUserDict];
            [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
            if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginSuccess:)]) {
                [self.delegate didLoginSuccess:[Cache shared].user_dict];
            }
            loginCallBack(Lstatus_loginSuccess);
        }
        else{
            [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
            
            LoginViewController * loginvc = [[[LoginViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            loginvc.title = @"登录";
//            [vc setCocosCallback:loginCallback];
            if (inf) {
                [loginvc.data_dict setNonEmptyValuesForKeysWithDictionary:inf];
            }
            UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:loginvc] autorelease];
            
            if (vc && [vc isKindOfClass:[UIViewController class]]) {
                [vc presentViewController:nav animated:YES completion:^{}];
            }
            else{
                if (((AppController *)APPLICATION).iosNavController && [((AppController *)APPLICATION).iosNavController isKindOfClass:[UINavigationController class]]) {
                    [((UIViewController *)((AppController *)APPLICATION).iosNavController.topViewController) presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
                else{
                    [APPLICATION.window addSubview:nav.view];
                }
            }
        }
    }];
    
    return NO;
}

#pragma mark - request

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_validate]) {
        [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
        [self initUserDict];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginSuccess:)]) {
            [self.delegate didLoginSuccess:self.user_dict];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signin] ||//登录成功
             [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signup]) {//注册成功（默认已经登录）
        [self setSsssCookie];
        [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
        
        NSDictionary *res = [result objectForKey:@"res"];
        if ([NSDictionary isNotEmpty:res]) {
            [self record:res];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginSuccess:)]) {
            [self.delegate didLoginSuccess:res];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        //发送注册验证码成功
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendSmsSuccess:)]) {
            [self.delegate didSendSmsSuccess:result];
        }
    }
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    InfoLog(@"error:%@", error);
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_validate]) {
        [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginError:)]) {
            [self.delegate didLoginError:error];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signin] ||
             [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signup]) {
        [UserManager sharedInstance].userLoginStatus = Lstatus_loginFailed;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginError:)]) {
            [self.delegate didLoginError:error];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_sendsms]) {
        //发送注册验证码失败
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendSmsError:)]) {
            [self.delegate didSendSmsError:error];
        }
    }
}

#pragma mark - 

#pragma mark - ----------登录方法(账号密码登录)----------

- (void)signinWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd {
    self.userLoginStatus = Lstatus_isInLogining;
    NSDictionary * params = @{@"from":@"phone",
                              @"phone":pPhone,
                              @"passwd":[pPasswd MD5HMACWithKey:k_encryptCode],
                              };
    NSDictionary * dict = @{@"idx":strFloat((++index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_signin,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - ----------登录方法(微信账号登录)----------

- (void)signinWithWXLoginInfo:(WXLoginInfo *)pWXLoginInfo{
    NSDictionary * params = @{@"from":@"weixin",
                              @"unionid":pWXLoginInfo.unionId,
                              };
    NSDictionary * dict = @{@"idx":strFloat((++index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_signin,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark ----------发送手机验证码(注册)----------

- (void)signupVerify:(NSString *)pPhone{
    NSDictionary * params = @{@"phone":pPhone,
                              @"type":@"register"
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

#pragma mark - ---------注册方法----------

- (void)signupWithPhone:(NSString *)pPhone passwd:(NSString *)pPasswd verify:(NSString *)pVerify WXLoginInfo:(WXLoginInfo *)pWXLoginInfo{
    NSDictionary * params = @{@"from":@"weixin",
                              @"phone":pPhone,
                              @"passwd":[pPasswd MD5HMACWithKey:k_encryptCode],
                              @"verify":pVerify,
                              @"name":pWXLoginInfo.nickName,
                              @"headurl":pWXLoginInfo.headUrl,
                              @"openid":pWXLoginInfo.openId,
                              @"unionid":pWXLoginInfo.unionId,
                              };
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_signup,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (BOOL)validate:(void (^)(int ret)) loginCallback {
    if( [_ss.ssid_check isEqualToString:@""] || [_ss.ssid_verify isEqualToString:@""] ) {
        Log(@"no record");
        loginCallback(0);
        return NO;
    }
//    loginCallback(1);
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_USER_VALIDATE] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *dictCookies = [[UserManager sharedInstance] getDictCookies:nil flag:YES];

    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             [self setSsssCookie];
             
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     loginCallback(1);
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
             } else {
                 Log(@"request err");
             }
         }
         loginCallback(0);
     }];
//    printBlock(0);
    return YES;
}

//更新用户数据
- (void)updateUserData:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) {
        return;
    }
    [self record:inf];
}

-(void)record:(NSDictionary *)resRes{
    if (![NSDictionary isNotEmpty:resRes]) {
        return;
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
    [self.user_dict setNonEmptyValuesForKeysWithDictionary:resRes];
    
    [defaults setObject:self.user_dict forKey:@"user_dict"];
    
    long resUserid = (long)[[_user_dict objectForKey:@"userid"] longLongValue];
    self.userid = resUserid;
    _ss.userid = resUserid;
    _base.userid = resUserid;
    _base.phone = [_user_dict objectForKey:@"phone"];
    _base.passwd = @"";
    _brief.userid = resUserid;
    _brief.name = [_user_dict objectForKey:@"name"];
    _brief.intro = [_user_dict objectForKey:@"intro"];
    _brief.zone = [_user_dict objectForKey:@"zone"];
    _brief.imglink = [_user_dict objectForKey:@"imglink"];
    _brief.thumblink = [_user_dict objectForKey:@"thumblink"];
    _brief.thumbdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:_brief.thumblink]];
    _detail.userid = resUserid;
    _detail.sex = [_user_dict objectForKey:@"sex"];
    _detail.sexot = [_user_dict objectForKey:@"sexot"];
    _detail.love = [_user_dict objectForKey:@"love"];
    _detail.horo = [_user_dict objectForKey:@"horo"];
    [defaults setObject:[NSString stringWithFormat:@"%ld",_ss.userid] forKey:@"SHITOUREN_UD_USERID"];
    [defaults setObject:_ss.ssid_check forKey:@"SHITOUREN_UD_SSID_CHECK"];
    [defaults setObject:_ss.ssid_verify forKey:@"SHITOUREN_UD_SSID_VERIFY"];
    [defaults setObject:_base.phone forKey:@"SHITOUREN_UD_PHONE"];
    [defaults setObject:_brief.name forKey:@"SHITOUREN_UD_NAME"];
    [defaults setObject:_brief.intro forKey:@"SHITOUREN_UD_INTRO"];
    [defaults setObject:_brief.zone forKey:@"SHITOUREN_UD_ZONE"];
    [defaults setObject:_brief.imglink forKey:@"SHITOUREN_UD_IMGLINK"];
    [defaults setObject:_brief.thumblink forKey:@"SHITOUREN_UD_THUMBLINK"];
    [defaults setObject:_brief.thumbdata forKey:@"SHITOUREN_UD_THUMBDATA"];
    [defaults setObject:_detail.sex forKey:@"SHITOUREN_UD_SEX"];
    [defaults setObject:_detail.sexot forKey:@"SHITOUREN_UD_SEXOT"];
    [defaults setObject:_detail.love forKey:@"SHITOUREN_UD_LOVE"];
    [defaults setObject:_detail.horo forKey:@"SHITOUREN_UD_HORO"];
    Log ( @"userid=%ld,phone=%@,name=%@,sex=%@",self.userid,_base.phone,_brief.name,_detail.sex);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)signout{
    [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
    self.userid = 0;
    _ss.userid = 0;
    _ss.ssid_check = @"";
    _ss.ssid_verify = @"";
    _base.userid = 0;
    _base.phone = @"";
    _base.passwd = @"";
    _brief.userid = 0;
    _brief.name = @"";
    _brief.intro = @"";
    _brief.zone = @"";
    _brief.imglink = @"";
    _brief.thumblink = @"";
    _brief.thumbdata = nil;
    _detail.userid = 0;
    _detail.sex = @"";
    _detail.sexot = @"";
    _detail.love = @"";
    _detail.horo = @"";
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PASSWD"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SSID_CHECK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SSID_VERIFY"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PHONE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PASSWD"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_NAME"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_INTRO"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_ZONE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_IMGLINK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_THUMBLINK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_THUMBDATA"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SEX"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SEXOT"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_LOVE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_HORO"];
    SendNotify(@"SHITOUREN_USER_SIGNOUT_POST_SUCC",self);
    
    [defaults removeObjectForKey:@"user_dict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setSsssCookie{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if( [[cookie name] isEqualToString:@"shitouren_check"] ){
            _ss.ssid_check = [cookie value];
//            InfoLog(@"test1 --- %@", [cookie value]);
        }
        if( [[cookie name] isEqualToString:@"shitouren_verify"] ){
            _ss.ssid_verify = [cookie value];
//            InfoLog(@"test2 --- %@", [cookie value]);
        }
    }
}

- (NSDictionary *)getDictCookies:(NSDictionary *)privateCookies flag:(BOOL)isAdd{
    NSArray * arr = [self getRequestCookies:privateCookies flag:isAdd];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arr];
    return dictCookies;
}

- (NSArray *)getRequestCookies:(NSDictionary *)privateCookies flag:(BOOL)isAdd{
    if (privateCookies && !isAdd) {
        NSHTTPCookie * Cookies = [NSHTTPCookie cookieWithProperties:privateCookies];
        return [NSArray arrayWithObjects: Cookies,nil];
    }
    
    NSString *ssid = self.ss.ssid;
    NSString *ssid_check = self.ss.ssid_check;
    NSString *ssid_verify = self.ss.ssid_verify;
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    if (privateCookies && isAdd) {
        NSHTTPCookie * Cookies = [NSHTTPCookie cookieWithProperties:privateCookies];
        arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,Cookies,nil];
    }
    
    return arrCookies;
}

@end
