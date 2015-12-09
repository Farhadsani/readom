//
//  Reqest.m
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import "Reqest.h"
#import "ReqHandle.h"
//#import "BaseViewController.h"

@implementation Reqest
@synthesize delegate = _delegate;

@synthesize httpRequest = _httpRequest;

@synthesize headFileds = _headFileds;
@synthesize relativeUrl = _relativeUrl;
@synthesize absoluteUrl = _absoluteUrl;

@synthesize resType = _resType;
@synthesize timeoutInterval;

@synthesize data_dict = _data_dict;

- (void)dealloc{
    self.delegate = nil;
    k_RELEASE_SAFELY(_httpRequest);
    
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        //default settings
        if (_headFileds == nil) {
            _headFileds = [[NSMutableDictionary alloc] init];
        }
        if (_data_dict == nil) {
            _data_dict = [[NSMutableDictionary alloc] init];
        }
        if (_relativeUrl == nil) {
            _relativeUrl = [[NSString alloc] init];
        }
        if (_absoluteUrl == nil) {
            _absoluteUrl = [[NSString alloc] init];
        }
    }
    return self;
}

#pragma mark - request
- (void)startRequest{
    if ([NSString isEmptyString:self.absoluteUrl]) {
        NSError * error = [NSError errorWithDomain:@"请求地址错误" code:-1 userInfo:nil];
        [self doAfterRequestFailed:error];
        return;
    }
    
//#ifdef k_LOCAL_REQUEST_TEST_MODEL
//    [self GetResponseInDebugMode:self.httpRequest];
//#else
//    [_httpRequest startAsynchronous];
//#endif
    
    _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.absoluteUrl]] delegate:self];
    [self.connection start];
    [[ReqHandle shared] showLoadingView:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self setClickEnable];
    
    if (_receivedData) {
        [_receivedData release];
    }
    _receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self doAfterReceivedData:_receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self doAfterRequestFailed:error];
}

- (void)startAsiRequest{
    if (_asiRequest) {
        [_asiRequest startAsynchronous];
    }
}

- (void)startAsiFormDataRequest{
    if (_asiFormDataRequest) {
        [_asiFormDataRequest startAsynchronous];
    }
    else if (_asiRequest) {
        [_asiRequest startAsynchronous];
    }
}

- (void)cancelReq{
    [self.data_dict setNonEmptyObject:@0 forKey:k_r_showError];//不再提示错误信息
    NSInteger reqApiType = [[self.data_dict objectOutForKey:k_r_reqApiType] integerValue];
    if (reqApiType == AFReqApi) {
    }
    else if (reqApiType == SysConnectionReqApi) {
        if (self.connection) {
            [self.connection cancel];
        }
    }
    else{
        [self cancelAsiRequest];
    }
}

- (void)cancelAsiRequest{
    if (_asiFormDataRequest) {
        [_asiFormDataRequest cancel];
    }
    else if (_asiRequest) {
        [_asiRequest cancel];
    }
}

- (void)startAFHTTPRequest{
    if (_afHTTPRequestOperationManager) {
        
        NSDictionary *dictCookies = [[UserManager sharedInstance] getDictCookies:[self.data_dict objectOutForKey:k_r_privateCookie] flag:YES];
        [_afHTTPRequestOperationManager.requestSerializer setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
        
        //postData:必须是字符串
        id postData = [self.data_dict objectOutForKey:k_r_postData];
        NSDictionary *params = nil;
        if (postData && [postData isKindOfClass:[NSString class]]) {
            params = @{@"postData": postData};
        }
        else if (postData && [postData isKindOfClass:[NSDictionary class]]){
//            NSString * str = [NSString postStringWithDictionary:postData];
//            NSString * str2 = [NSString GETpostStringWithDictionary:postData];
            params = @{@"postData": [NSString stringWithObjectAsJSON:postData]};
        }
        else{
            postData = @"";
            params = @{@"postData": postData};
        }
        
        if (![self.data_dict objectOutForKey:k_r_printLog] || [[self.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
            InfoLog(@"请求参数：%@", params);
        }
        
        [self setClickEnable];
        
        [[ReqHandle shared] showLoadingView:self];
        
        [_afHTTPRequestOperationManager POST:self.absoluteUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            id attch = [self.data_dict objectOutForKey:k_r_attchData];
            if (attch) {
                NSArray * images = nil;
                if ([attch isKindOfClass:[UIImage class]]) {
                    images = [NSArray arrayWithObject:attch];
                }
                else if ([NSArray isNotEmpty:attch]){
                    images = (NSArray *)attch;
                }
                
                if (images) {
                    UIImage *image = nil;
                    NSString *name = nil;
                    NSString *imageName = nil;
                    for (int i = 0; i < images.count; i++) {
                        image = images[i];
                        name = [NSString stringWithFormat:@"file[%d]", i];
                        imageName = [NSString stringWithFormat:@"%@.jpg", name];
                        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:name fileName:imageName mimeType:@"image/jpeg"];
                    }
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self doAfterReceivedData:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self doAfterRequestFailed:error];
//            [self baseShowMidHud:@"网络请求失败!"];
        }];
    }
    else{
        [self startAsiFormDataRequest];
    }
}

#pragma mark - delegate
#pragma mark TKHTTPRequestDelegate


- (void)resourceServiceRequestDidStart:(ASIFormDataRequest*)request{
    [[ReqHandle shared] showLoadingView:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartLoad:)]) {
        [self.delegate didStartLoad:self];
    }
}

- (void)resourceServiceRequestDidReceiveResponse:(ASIFormDataRequest*)request{
    [self setClickEnable];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveResponse:responseHead:)]) {
        [self.delegate didReceiveResponse:self responseHead:request.responseHeaders];
    }
}

- (void)request:(ASIFormDataRequest*)request didReceiveTotalBytes:(NSInteger)received ofExpectedBytes:(NSInteger)total{
    if (total == -1) {
        if ([request.responseHeaders objectOutForKey:@"Size"] && [[request.responseHeaders objectOutForKey:@"Size"] integerValue] > 0) {
            total = [[request.responseHeaders objectOutForKey:@"Size"] integerValue];
        }
    }
    
    NSString * process = @"0%";
    if (total >= received) {
        NSInteger percent = (int)(((float)received/total)*100);
        process = [NSString stringWithFormat:@"%d%%", (int)percent];
    }
    
    Assert(self.delegate != nil);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoading:withProcess:)]) {
        [self.delegate didLoading:self withProcess:process];
    }
}

- (void)resourceServiceRequestDidFinish:(ASIFormDataRequest*)request{
    NSData * data = [request responseData];
    [self doAfterReceivedData:data];
}

- (void)resourceServiceRequestDidFail:(ASIFormDataRequest*)request{
    if (![self.data_dict objectOutForKey:k_r_printLog] || [[self.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
        InfoLog(@"%s", __FUNCTION__);
    }
    
    [self doAfterRequestFailed:request.error];
}


#pragma mark - Util

- (void)doAfterReceivedData:(NSData *)data{
    [[ReqHandle shared] hiddenLoadingView:self];
    
    [self resetClickEnable];
    
    NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if (self.resType == ResImage || [UIImage imageWithData:data]) {
        UIImage * img = [UIImage imageWithData:data];
        if (!img) {
            //            [self resourceServiceRequestDidFail:request];
        }
        else{
            [self retureDelegate:data result:img];
        }
        
        [[ExceptionEngine shared] didShowErrorMessage:YES];
        
        if (![self.data_dict objectOutForKey:k_r_printLog] || [[self.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
            InfoLog(@"responseString:%@", responseString);
        }
        
        [[ReqEngine shared].reqestCollects removeObject:self];
        return;
    }
    
    if ([self.data_dict objectOutForKey:k_r_showError] && [[self.data_dict objectOutForKey:k_r_showError] integerValue] == 0){
        [[ExceptionEngine shared] didShowErrorMessage:NO];
    }
    
    if ([[ReqHandle shared] getFromObject:self] && [[[ReqHandle shared] getFromObject:self] isKindOfClass:[NSString class]] && ([((NSString *)[[ReqHandle shared] getFromObject:self]) hasPrefix:@"auto"])) {
        [[ExceptionEngine shared] didShowErrorMessage:NO];
    }
    
    if ([responseString rangeOfString:@"<html>"].location != NSNotFound && [responseString rangeOfString:@"</html>"].location != NSNotFound) {
        [self doAfterRequestFailed:[NSError errorWithDomain:@"网络错误（Code：404）" code:404 userInfo:nil]];
//        [self retureDelegate:data result:responseString];
        [[ExceptionEngine shared] didShowErrorMessage:NO];
        return;
    }
    
    NSDictionary * jsonDict = [NSDictionary dictionaryWithJSON:responseString];

//    InfoLog(@"【【【response json:】】】%@", jsonDict);

    if (![self.data_dict objectOutForKey:k_r_printLog] || [[self.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
        InfoLog(@"\n==== URL:%@ ====\n【【【Post data】】】:\n%@\n【【【response json】】】:\n%@", self.absoluteUrl,[self.data_dict objectOutForKey:k_r_postData],jsonDict);
    }
    
//    k_api_location_update
    if (self.data_dict && [self.data_dict objectOutForKey:k_r_url] && [[self.data_dict objectOutForKey:k_r_url] isEqualToString:k_api_location_update]) {
        //该接口不进行自动登录提示
    }
    else{
        if ([jsonDict objectOutForKey:@"ret"] && [[jsonDict objectOutForKey:@"ret"] integerValue] == -3){
            NSString * msg = [jsonDict objectOutForKey:@"msg"];
            msg = ([NSString isEmptyString:msg])?@"您需要登录后才能继续操作!":msg;
            if ([msg rangeOfString:@"登录"].location != NSNotFound ||
                [msg rangeOfString:@"登陆"].location != NSNotFound) {
                if ([[ReqEngine shared].reqestCollects containsObject:self]) {
                    [[ReqEngine shared].reqestCollects removeObject:self];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didfailedLoad:withError:)]) {
                        [self.delegate didfailedLoad:self withError:[NSError errorWithDomain:msg code:[[jsonDict objectOutForKey:@"ret"] integerValue] userInfo:nil]];
                    }
                }
                [[ExceptionEngine shared] alertTitle:nil message:msg delegate:self tag:-100 cancelBtn:@"取消" btn1:@"登录" btn2:nil];
                return;
            }
        }
    }
    
    if (![[ExceptionEngine shared] didHasAndHandelErrorMsgWithResponseDict:jsonDict]) {
//        [self retureDelegate:data result:[NSString getNormalResult:jsonDict]];
        [self retureDelegate:data result:jsonDict];
    }
    else{
        NSError * error = nil;
        NSDictionary * errDict = [NSString getErrorResult:jsonDict];
        if (errDict && [errDict isKindOfClass:[NSDictionary class]]) {
            error = [NSError errorWithDomain:([errDict objectOutForKey:k_msg])?[errDict objectOutForKey:k_msg]:@"" code:[[errDict objectOutForKey:@"ret"] integerValue] userInfo:errDict];
        }
        else{
            error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
        }
        
        if ([[ReqEngine shared].reqestCollects containsObject:self]) {
            [[ReqEngine shared].reqestCollects removeObject:self];
            Assert(self.delegate != nil);
            if (self.delegate && [self.delegate respondsToSelector:@selector(didfailedLoad:withError:)]) {
                [self.delegate didfailedLoad:self withError:error];
            }
        }
        
        [[ExceptionEngine shared] didShowErrorMessage:YES];
    }
    
    [[ReqEngine shared].reqestCollects removeObject:self];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
    if (alertView.tag == -100 && buttonIndex == k_buttonIndex_btn1) {
        //登录超时,需要重新登录
        [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
        [[UserManager sharedInstance] tryCheckLogin:self delegate:nil info:@{@"from":@"endpoint"} CallBack:nil];
//        [[UserManager sharedInstance] tryCheckLogin:[self.data_dict objectOutForKey:k_r_delegate] delegate:nil info:@{@"from":@"endpoint"} CallBack:nil];
        return;
        
//        if (self.delegate && [self.delegate isKindOfClass:[BaseViewController class]]) {
//            //登录超时,需要重新登录
//            [UserManager sharedInstance].userLoginStatus = Lstatus_loginOut;
//            [(BaseViewController *)self.delegate tryCheckLogin];
//            return;
//        }
    }
}

- (void)didLoginSuccessInLoginVC:(NSDictionary *)result{
    InfoLog(@"后台返回未登录状态，客户端自动跳转到登录界面登录后的回调！");
    InfoLog(@"！！！重新自动发出请求！！！");
    [[ReqEngine shared] tryRequest:self.data_dict];
}

- (void)didLoginErrorInLoginVC:(NSError *)error{
    InfoLog(@"后台返回未登录状态，客户端自动跳转到登录界面登录后的回调！");
}

- (void)retureDelegate:(NSData *)data result:(id)result{
    [[ReqHandle shared] shouldSaveToCache:self data:data];
    [[ReqHandle shared] shouldSaveToDocument:self data:data];
    
    if ([[ReqEngine shared].reqestCollects containsObject:self]) {
        [[ReqEngine shared].reqestCollects removeObject:self];
        Assert(self.delegate != nil);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad:responseData:result:)]) {
            [self.delegate didFinishLoad:self responseData:data result:result];
        }
    }
}

- (void)doAfterRequestFailed:(NSError *)error{
    [[ReqHandle shared] hiddenLoadingView:self];
    
    [self resetClickEnable];
    
    if (![self.data_dict objectOutForKey:k_r_printLog] || [[self.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
        InfoLog(@"\n==== URL:%@ ====\n【【【Post data】】】:\n%@\n【【【Error】】】:\n%@", self.absoluteUrl,[self.data_dict objectOutForKey:k_r_postData],error);
    }
    
    if (self.resType != ResImage) {
        if ([[ReqHandle shared] flagOfShowError:self]) {
            [[ExceptionEngine shared] alertTitle:nil error:error delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
        }
    }
    
    if ([[ReqEngine shared].reqestCollects containsObject:self]) {
        [[ReqEngine shared].reqestCollects removeObject:self];
        Assert(self.delegate != nil);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didfailedLoad:withError:)]) {
            [self.delegate didfailedLoad:self withError:error];
        }
    }
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    if (_headFileds == nil) {
        _headFileds = [[NSMutableDictionary alloc] initWithObjectsAndKeys:value,field, nil];
    }
    else{
        [_headFileds setObject:value forKey:field];
    }
}

- (void)setHeadFieldWithReplace:(NSDictionary *)fields{
    if (_headFileds == nil) {
        _headFileds = [[NSMutableDictionary alloc] initWithDictionary:fields];
    }
    else{
        [_headFileds removeAllObjects];
        [_headFileds setDictionary:fields];
    }
}

- (void)setHeadFieldWithAddtinal:(NSDictionary *)fields{
    if (_headFileds == nil) {
        _headFileds = [[NSMutableDictionary alloc] initWithDictionary:fields];
    }
    else{
        for (NSString *key in [fields allKeys]){
            [_headFileds setObject:[fields objectOutForKey:key] forKey:key];
        }
    }
}

- (void)GetResponseInDebugMode:(TKHTTPRequest *)request{
#ifdef k_LOCAL_REQUEST_TEST_MODEL
    NSData * data = nil;
    NSString * filename = [NSString trimFileNameOfPath:self.absoluteUrl];
    if ([filename rangeOfString:@"."].location == NSNotFound) {
        filename = [NSString stringWithFormat:@"%@.json", filename];
    }
    
    data = [FileManager readBundleFile:filename type:nil];
    if (data) {
        NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        InfoLog(@"responseString:%@", responseString);
        NSDictionary * jsonDict = [NSDictionary dictionaryWithJSON:responseString];
        InfoLog(@"dict:%@", jsonDict);
        if (![[ExceptionEngine shared] didHasAndHandelErrorMsgWithResponseDict:jsonDict]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad:responseData:result:)]) {
                [self.delegate didFinishLoad:self responseData:data result:(self.resType != ResImage) ? [NSString getNormalResult:jsonDict] : nil];
            }
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didfailedLoad:withError:)]) {
        [self.delegate didfailedLoad:self withError:request.error];
    }
#endif
}

#pragma mark - GET Params


- (void)setClickEnable{
    if ([self.data_dict objectOutForKey:k_r_clickView] && [[self.data_dict objectOutForKey:k_r_clickView] isKindOfClass:[UIView class]]) {
        if ([self.data_dict objectOutForKey:k_r_enableClickRepeat] && [[self.data_dict objectOutForKey:k_r_enableClickRepeat] integerValue] == 1) {
            [(UIView *)[self.data_dict objectOutForKey:k_r_clickView] setUserInteractionEnabled:YES];
        }
        else{
            [(UIView *)[self.data_dict objectOutForKey:k_r_clickView] setUserInteractionEnabled:NO];
        }
    }
}

- (void)resetClickEnable{
    if ([self.data_dict objectOutForKey:k_r_clickView] && [[self.data_dict objectOutForKey:k_r_clickView] isKindOfClass:[UIView class]]) {
        [(UIView *)[self.data_dict objectOutForKey:k_r_clickView] setUserInteractionEnabled:YES];
    }
}

- (NSString *)getParamValue:(NSString *)key{
    if ([NSString isEmptyString:key]) {
        return nil;
    }
    
    id value = [self.data_dict objectOutForKey:key];
    if (value) {
        return value;
    }
    
    if ([[self.data_dict objectOutForKey:k_r_postData] objectOutForKey:key]) {
        return value;
    }
    
    id params = [[self.data_dict objectOutForKey:k_r_postData] objectOutForKey:@"params"];
    if ([NSDictionary isNotEmpty:params]) {
        value = [params objectOutForKey:key];
        if (value) {
            return value;
        }
    }
    
    if (!value) {
        if ([key isEqualToString:@"userid"]) {
            return [self getParamValue:@"userId"];
        }
        if ([key isEqualToString:@"userId"]) {
            return [self getParamValue:@"userID"];
        }
    }
    
    return nil;
}

@end
