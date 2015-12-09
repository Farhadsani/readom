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
    _userid = 0;
    if(tUserid && ![tUserid isEqualToString:@"null"] ){
        _userid = (long)[tUserid longLongValue];
    }
    index = 0;
    
    
    self.ss = [[UserSsItem alloc] init:_userid];
    self.base = [[UserBaseItem alloc] init:_userid];
    self.brief = [[UserBriefItem alloc] init:_userid];
    self.detail = [[UserDetailItem alloc] init:_userid];
    
    [self initCallout];
    
    self.city = [[[NSString alloc] init] autorelease];
    self.serverCity = [[[NSString alloc] init] autorelease];
    
    _userLoginStatus = Lstatus_loginOut;
    
    [self initUserDict];
    
    if (_brief.role && _brief.role == 1) {
        self.userRole = Role_Store;
    }
    else{
        self.userRole = Role_Normal;
    }
    
    return self;
}

- (void)initServerCity:(NSString *)cityName{
    if (![NSString isEmptyString:cityName]) {
        self.serverCity = cityName;
        self.city = cityName;
    }
}

- (void)initUserDict{
    if (!_user_dict) {
        self.user_dict = [[NSMutableDictionary alloc] init];
    }
    NSDictionary *user_dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_dict"];
    if ([NSDictionary isNotEmpty:user_dict]) {
        [self.user_dict setNonEmptyValuesForKeysWithDictionary:user_dict];
    }
}

//获得当前登录用户的角色类型
- (UserRoleType)getUserRole{
    if (self.brief.role && self.brief.role == Role_Store) {
        return Role_Store;//商家用户
    }
    else{
        return Role_Normal;//普通用户
    }
}

#pragma mark 判断一个用户ID是否为当前登录用户

- (BOOL)isCurrentUser:(long)userId{
    if (_userLoginStatus != Lstatus_loginSuccess) {
        return NO;
    }
    
    if (userId && userId!= 0 && userId == _userid) {
        return YES;
    }
    
    return NO;
}

#pragma mark 判断当前用户的登录状态

- (BOOL)hasLogin{
    if (_userLoginStatus == Lstatus_loginSuccess) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - 检查登录，如果未登录将自动跳转到登录界面

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
            if (loginCallBack) {
                loginCallBack(Lstatus_loginSuccess);
            }
            
        }
        else{
            [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
            
            LoginViewController * loginvc = [[[LoginViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//            loginvc.title = @"登录";
//            [vc setCocosCallback:loginCallback];
            if (vc) {
                loginvc.loginVCDelegate = vc;
            }
            if (inf) {
                [loginvc.data_dict setNonEmptyValuesForKeysWithDictionary:inf];
            }
            UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:loginvc] autorelease];
            
            if (vc && [vc isKindOfClass:[UIViewController class]]) {
                [vc presentViewController:nav animated:YES completion:^{}];
            }
            else{
                UIViewController * vc = [((AppController *)APPLICATION) getVisibleViewController];
                if (vc) {
                    [vc presentViewController:nav animated:YES completion:^{
                        
                    }];
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
        
        if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signin]) {
            if ([NSDictionary isNotEmpty:res]) {
                NSString * from = [[[req.data_dict objectOutForKey:@"postData"] objectOutForKey:@"params"] objectOutForKey:@"from"];
                if (from && [from isEqualToString:@"phone"]) {
                    [self record:res];
                }
                else {
                    if (![NSString isEmptyString:[res objectOutForKey:@"phone"]]) {
                        [self record:res];
                    }
                }
            }
        }
        else{
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
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_location_update]) {
        //更新用户位置成功
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
        InfoLog(@"no record");
        loginCallback(0);
//        [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
        [self signout];
//        [self removeUserData];
        return NO;
    }
//    loginCallback(1);
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_USER_VALIDATE] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *dictCookies = [[UserManager sharedInstance] getDictCookies:nil flag:YES];
    
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             [self setSsssCookie];
             
             if (resRet == 0 ) {
                 [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
                 if ( resIdx == index ) {
                     loginCallback(1);
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 [self signout];
//                 [self removeUserData];
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 InfoLog(@"request timeout");
             } else {
                 InfoLog(@"request err");
             }
         }
         loginCallback(0);
     }];
//    printBlock(0);
    return YES;
}

- (BOOL)UserID:(long)userid getUserInfo:(void (^)(NSDictionary* info)) callback {
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"userid\":%ld}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", k_EXTERN_ENDPOINT_SERVER_URL, k_api_user_getuser];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *dictCookies = [[UserManager sharedInstance] getDictCookies:nil flag:YES];
    
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         BOOL isSuccess = NO;
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             if (resRet == 0 ) {
                 isSuccess = YES;
                 callback([resDict objectOutForKey:@"res"]);
             }
         }
         if (!isSuccess) {
             callback(nil);
         }
     }];
    return YES;
}

- (BOOL)isStoreUser:(UserBriefItem *)item{
    if (item && item.role && item.role == Role_Store) {
        return YES;
    }
    else{
        return NO;
    }
}

//更新用户数据
- (void)updateUserData:(id)inf{
    if (!inf) {
        return;
    }
    
    BOOL needSave = NO;
    if ([NSDictionary isNotEmpty:inf]) {
        if ([_user_dict objectOutForKey:@"userid"] && ![self isCurrentUser:[[_user_dict objectOutForKey:@"userid"] longLongValue]]) {
            return;
        }
        [self record:inf];
    }
    else if ([inf isKindOfClass:[UserBaseItem class]]){
        if (((UserBaseItem *)inf).userid && ![self isCurrentUser:((UserBaseItem *)inf).userid]) {
            return;
        }
        self.base = (UserBaseItem *)inf;
        needSave = YES;
    }
    else if ([inf isKindOfClass:[UserBriefItem class]]){
        if (((UserBriefItem *)inf).userid && ![self isCurrentUser:((UserBriefItem *)inf).userid]) {
            return;
        }
        self.brief = (UserBriefItem *)inf;
        if (![self isStoreUser:self.brief] && ((UserBriefItem *)inf).phone && self.base.phone) {
            self.base.phone = ((UserBriefItem *)inf).phone;
        }
        needSave = YES;
    }
    else if ([inf isKindOfClass:[UserDetailItem class]]){
        if (((UserDetailItem *)inf).userid && ![self isCurrentUser:((UserDetailItem *)inf).userid]) {
            return;
        }
        self.detail = (UserDetailItem *)inf;
        needSave = YES;
    }
    else if ([inf isKindOfClass:[UserSsItem class]]){
        if (((UserSsItem *)inf).userid && ![self isCurrentUser:((UserSsItem *)inf).userid]) {
            return;
        }
        self.ss = (UserSsItem *)inf;
        needSave = YES;
    }
    
    if (needSave) {
        [self saveUserData];
    }
}

- (void)updateUserImageUrl:(NSString *)url {
    if (!url) {
        return;
    }
    _brief.thumbdata = nil;
    _brief.imglink = url;
//    _brief.headurl = url;
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"SHITOUREN_UD_IMGLINK"];
    
    UIImage * img = [self getRealLogoImageFromBrifItem:_brief];
    if (img) {
        _brief.thumbdata = UIImagePNGRepresentation(img);
        if (!_brief.thumbdata) {
            _brief.thumbdata = UIImageJPEGRepresentation(img, 0);
        }
    }
    if (_brief.thumbdata) {
        [[NSUserDefaults standardUserDefaults] setObject:_brief.thumbdata forKey:@"SHITOUREN_UD_THUMBDATA"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 登录成功后调用

- (void)record:(NSDictionary *)resRes{
    if (![NSDictionary isNotEmpty:resRes]) {
        return;
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [UserManager sharedInstance].userLoginStatus = Lstatus_loginSuccess;
    [self.user_dict setNonEmptyValuesForKeysWithDictionary:resRes];
    
    [defaults setObject:self.user_dict forKey:@"user_dict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    long resUserid = (long)[[_user_dict objectForKey:@"userid"] longLongValue];
    self.userid = resUserid;
    _ss.userid = resUserid;
    
    _base.userid = resUserid;
    _base.phone = [_user_dict objectForKey:@"phone"];
    _base.passwd = @"";
    
    _brief.userid = resUserid;
    _brief.name = [_user_dict objectForKey:@"name"];
    _brief.phone = [_user_dict objectForKey:@"phone"];
    if (!_brief.phone) {
        _brief.phone = _base.phone;
    }
    _brief.intro = [_user_dict objectForKey:@"intro"];
    _brief.imglink = [_user_dict objectForKey:@"imglink"];
    _brief.thumblink = [_user_dict objectForKey:@"thumblink"];
    _brief.photolink = [_user_dict objectForKey:@"photolink"];
    _brief.photothumb = [_user_dict objectForKey:@"photothumb"];
    _brief.hobby = [_user_dict objectForKey:@"hobby"];
    _brief.music = [_user_dict objectForKey:@"music"];
    
    if ([_user_dict objectOutForKey:@"fans"]) {
        _brief.fans = [[_user_dict objectOutForKey:@"fans"] integerValue];
    }
    else{
        _brief.fans = 0;
    }
    
    if ([_user_dict objectOutForKey:@"follow"]) {
        _brief.follow = [[_user_dict objectOutForKey:@"follow"] integerValue];
    }
    else{
        _brief.follow = 0;
    }
    
    _brief.role = (int)[[_user_dict objectOutForKey:@"role"] integerValue];
    _brief.address = [_user_dict objectForKey:@"address"];
    _brief.telephone = [_user_dict objectForKey:@"telephone"];
    _brief.categories = [_user_dict objectForKey:@"categories"];
    UIImage * img = [self getRealLogoImageFromBrifItem:_brief];
    if (img) {
        _brief.thumbdata = UIImagePNGRepresentation(img);
        if (!_brief.thumbdata) {
            _brief.thumbdata = UIImageJPEGRepresentation(img, 0);
        }
    }
    _detail.userid = resUserid;
    _detail.sex = [_user_dict objectForKey:@"sex"];
    _detail.sexot = [_user_dict objectForKey:@"sexot"];
    _detail.love = [_user_dict objectForKey:@"love"];
    _detail.horo = [_user_dict objectForKey:@"horo"];
    
    if (_brief.role && _brief.role == 1) {
        self.userRole = Role_Store;
    }
    else{
        self.userRole = Role_Normal;
    }
    
    [self saveUserData];
}

#pragma mark 退出登录后调用

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
    _brief.phone = @"";
    _brief.intro = @"";
    _brief.imglink = @"";
    _brief.thumblink = @"";
    _brief.photolink = @[];
    _brief.photothumb = @[];
    _brief.thumbdata = nil;
    _brief.fans = 0;
    _brief.follow = 0;
    _brief.role = 0;
    _brief.address = @"";
    _brief.telephone = @"";
    _brief.hobby = @"";
    _brief.music = @"";
    _brief.categories = @[];
    
    _detail.userid = 0;
    _detail.sex = @"";
    _detail.sexot = @"";
    _detail.love = @"";
    _detail.horo = @"";
    
    [self removeUserData];
}

#pragma mark 用户数据保存或清除

- (void)saveUserData{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%ld",(long)(_ss.userid)] forKey:@"SHITOUREN_UD_USERID"];
    [defaults setObject:_ss.ssid_check forKey:@"SHITOUREN_UD_SSID_CHECK"];
    [defaults setObject:_ss.ssid_verify forKey:@"SHITOUREN_UD_SSID_VERIFY"];
    [defaults setObject:_brief.phone forKey:@"SHITOUREN_UD_PHONE"];
    [defaults setObject:_base.phone forKey:@"SHITOUREN_UD_PHONE"];
    [defaults setObject:_brief.name forKey:@"SHITOUREN_UD_NAME"];
    [defaults setObject:_brief.intro forKey:@"SHITOUREN_UD_INTRO"];
    [defaults setObject:_brief.imglink forKey:@"SHITOUREN_UD_IMGLINK"];
    [defaults setObject:_brief.thumblink forKey:@"SHITOUREN_UD_THUMBLINK"];
    [defaults setObject:_brief.photolink forKey:@"SHITOUREN_UD_PHOTOLINK"];
    [defaults setObject:_brief.photothumb forKey:@"SHITOUREN_UD_PHOTOTHUMB"];
    [defaults setObject:_brief.thumbdata forKey:@"SHITOUREN_UD_THUMBDATA"];
    [defaults setObject:_brief.address forKey:@"SHITOUREN_UD_ADDRESS"];
    [defaults setObject:_brief.telephone forKey:@"SHITOUREN_UD_TELEPHONE"];
    [defaults setObject:_brief.categories forKey:@"SHITOUREN_UD_CATEGORIES"];
    [defaults setObject:_brief.hobby forKey:@"SHITOUREN_UD_HOBBY"];
    [defaults setObject:_brief.music forKey:@"SHITOUREN_UD_MUSIC"];
    [defaults setObject:[NSString stringWithFormat:@"%ld",(long)( _brief.role)] forKey:@"SHITOUREN_UD_ROLE"];
    [defaults setObject:[NSString stringWithFormat:@"%d",(int)(_brief.fans)] forKey:@"SHITOUREN_UD_FANS"];
    [defaults setObject:[NSString stringWithFormat:@"%d",(int)(_brief.follow)] forKey:@"SHITOUREN_UD_FOLLOW"];
    [defaults setObject:_detail.sex forKey:@"SHITOUREN_UD_SEX"];
    [defaults setObject:_detail.sexot forKey:@"SHITOUREN_UD_SEXOT"];
    [defaults setObject:_detail.love forKey:@"SHITOUREN_UD_LOVE"];
    [defaults setObject:_detail.horo forKey:@"SHITOUREN_UD_HORO"];
    InfoLog( @"userid=%ld,role=%@,phone=%@,name=%@,sex=%@",self.userid,(self.brief.role==Role_Normal)?@"普通用户":@"商家用户",_base.phone,_brief.name,_detail.sex);
    [defaults synchronize];
    
    InfoLog(@"保存到用户本地数据! userid：%ld", _ss.userid);
}

- (void)removeUserData{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_USERID"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PASSWD"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SSID_CHECK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SSID_VERIFY"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PHONE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PASSWD"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_NAME"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_INTRO"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_IMGLINK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PHOTOLINK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_THUMBLINK"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_PHOTOTHUMB"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_ROLE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_CATEGORIES"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_FANS"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_FOLLOW"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_RELATIONNMUM"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_THUMBDATA"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SEX"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_SEXOT"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_LOVE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_HORO"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_ADDRESS"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_TELEPHONE"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_HOBBY"];
    [defaults setObject:@"null" forKey:@"SHITOUREN_UD_MUSIC"];
    SendNotify(@"SHITOUREN_USER_SIGNOUT_POST_SUCC",self);
    
    [defaults removeObjectForKey:@"user_dict"];
    [defaults synchronize];
    
    [self removeAllCallouts];
    InfoLog(@"删除用户本地数据! userid：%ld  %ld", _ss.userid, self.userid);
}

#pragma mark 请求 - 公共Cookie

- (void)setSsssCookie{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if( [[cookie name] isEqualToString:k_NSHTTPCookieName_CHECK] ){
            _ss.ssid_check = [cookie value];
        }
        if( [[cookie name] isEqualToString:k_NSHTTPCookieName_VERIFY] ){
            _ss.ssid_verify = [cookie value];
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
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
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

#pragma mark 更新用户位置

- (void)updateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation && [NSString isLocationInChina:userLocation.location.coordinate]) {
        [self updateUserLocationPt:userLocation.location.coordinate];
    }
}

- (void)updateUserLocationPt:(CLLocationCoordinate2D)pt{
    if ([NSString isLocationInChina:pt]) {
        self.pt = pt;
        [self turnGPSToAddress];
        //上传用户GPS坐标
        [self requestLocationUpdate];
    }
}

#pragma mark 喊话内容 - 初始化、保存、删除

- (void)initCallout{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"SHITOUREN_UD_CALLOUT1"]) {
        self.callout1 = [defaults stringForKey:@"SHITOUREN_UD_CALLOUT1"];
    }
    else{
        self.callout1 = @"";
    }
    
    if ([defaults stringForKey:@"SHITOUREN_UD_CALLOUT2"]) {
        self.callout1 = [defaults stringForKey:@"SHITOUREN_UD_CALLOUT2"];
    }
    else{
        self.callout1 = @"";
    }
    
    if ([defaults stringForKey:@"SHITOUREN_UD_CALLOUT3"]) {
        self.callout1 = [defaults stringForKey:@"SHITOUREN_UD_CALLOUT3"];
    }
    else{
        self.callout1 = @"";
    }
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

- (void)removeAllCallouts{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SHITOUREN_UD_CALLOUT1"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SHITOUREN_UD_CALLOUT2"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SHITOUREN_UD_CALLOUT3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前登录用户的头像
- (UIImage *)getCurrentLoginHeadLogo{
    UIImage * img = nil;
    if (_userLoginStatus == Lstatus_loginSuccess) {
        if (self.userid && self.userid != 0 && self.brief) {
            img = [self getLogoImageFromBrifItem:self.brief];
        }
    }
    
    if (!img) {
        img = [UIImage imageNamed:@"res/user/0.png"];
    }
    
    return img;
}

//获取指定用户的头像
- (UIImage*)getUserHeadLogo:(long)userid brifItem:(UserBriefItem *)item{
    UIImage * img = nil;
    long user_id = 0;
    
    if (userid && userid != 0) {
        user_id = userid;
    }
    else if (item && item.userid && item.userid != 0){
        user_id = item.userid;
    }
    
    if (user_id != 0) {
        if ([self isCurrentUser:user_id]) {
            img = [self getLogoImageFromBrifItem:self.brief];
            self.brief.thumbdata = UIImagePNGRepresentation(img);
            if (!self.brief.thumbdata) {
                self.brief.thumbdata = UIImageJPEGRepresentation(img, 0);
            }
            if (self.brief.thumbdata) {
                [[NSUserDefaults standardUserDefaults] setObject:_brief.thumbdata forKey:@"SHITOUREN_UD_THUMBDATA"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else if (item) {
            img = [self getRealLogoImageFromBrifItem:item];
            if (img) {
                item.thumbdata = UIImagePNGRepresentation(img);
                if (!item.thumbdata) {
                    item.thumbdata = UIImageJPEGRepresentation(img, 0);
                }
            }
        }
        else{
            //TODO:需要请求user_id对应的用户的用户信息
        }
    }
    
    if (!img) {
        img = [UIImage imageNamed:@"res/user/0.png"];
    }
    
    return img;
}

- (UIImage *)getLogoImageFromBrifItem:(UserBriefItem *)item{
    UIImage * img = [self getRealLogoImageFromBrifItem:item];
    if (!img) {
        img = [UIImage imageNamed:@"res/user/0.png"];
    }
    return img;
}

//获取指定用户的头像(没有默认值)
- (UIImage *)getRealLogoImageFromBrifItem:(UserBriefItem *)item{
    if (!item) {
        return nil;
    }
    
    NSString * imgname = nil;
//    if (item.headurl && [item.headurl isKindOfClass:[NSString class]] && item.headurl.length > 0) {
//        imgname = item.headurl;
//    }
//    else
    if (item.imglink && [item.imglink isKindOfClass:[NSString class]] && ((NSString *)(item.imglink)).length > 0) {
        imgname = (NSString *)item.imglink;
    }
    else if (item.thumblink && [item.thumblink isKindOfClass:[NSString class]] && ((NSString *)(item.thumblink)).length > 0) {
        imgname = (NSString *)item.thumblink;
    }
    
    if (imgname && [[Cache shared].cache_dict objectOutForKey:imgname] && [[[Cache shared].cache_dict objectOutForKey:imgname] isKindOfClass:[UIImage class]]) {
        return [[Cache shared].cache_dict objectOutForKey:imgname];
    }
    
    UIImage * img = nil;
    if (item.thumbdata && item.thumbdata.length > 0) {
        img = [UIImage imageWithData:item.thumbdata];
    }
    else if (imgname) {
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgname]]];
        [[Cache shared].cache_dict setNonEmptyObject:img forKey:imgname];
    }
    
    return img;
}


#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result.address) {
        [UserManager sharedInstance].address = result.address;
    }
    if (result.addressDetail.city) {
        [UserManager sharedInstance].city = result.addressDetail.city;
    }
}

- (void)turnGPSToAddress{
    if (![NSString isLocationInChina:self.pt]) {
        return;
    }
    
    [self createGeoCodeSearch];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];//反向编码（经纬度转换成地理位置）
    [reverseGeocodeSearchOption release];
    
    if(!flag){
        NSLog(@"反geo检索发送失败");
    }
}

- (void)createGeoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
}

#pragma mark request method
//上传用户GPS坐标
- (void)requestLocationUpdate{
    if (!self.userid || self.userid==0 || ![self hasLogin]) {
        return;
    }
    
//    return;
    
    NSDictionary * params = @{@"userid":@(self.userid),
                              @"lat":strFloat(self.pt.latitude),
                              @"lng":strFloat(self.pt.longitude),
                              };
    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_location_update,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         k_r_printLog:num(0),
//                         k_r_showError:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

@end
