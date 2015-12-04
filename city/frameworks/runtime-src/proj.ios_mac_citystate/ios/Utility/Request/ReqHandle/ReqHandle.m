//
//  ReqHandle.m
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import "ReqHandle.h"
#import "Reqest.h"
#import "Cache.h"

static ReqHandle * st_reqHandle = nil;

@implementation ReqHandle

+ (ReqHandle *)shared{
    if (st_reqHandle == nil) {
        st_reqHandle = [[ReqHandle alloc] init];
        st_reqHandle.isShowingLoading = NO;
    }
    return st_reqHandle;
}

#pragma mark - 请求前处理函数

//公共报文头
- (NSDictionary *)getCommonHeadFieldsToPost{
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc] init];
    
    NSMutableString  * user_agent = [[NSMutableString alloc] init];
    
    [user_agent setString:[user_agent stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [mDic setObject:user_agent forKey:@"user-agent"];
    [user_agent release];
    
    
    return [mDic autorelease];
}

- (Reqest *)generateRequest:(NSDictionary *)info{
    if (![NSDictionary isNotEmpty:info]  || [NSString isEmptyString:[info objectOutForKey:k_r_url]]) {
        return nil;
    }
    
    Reqest * req = [[[Reqest alloc] init] autorelease];
    
    [req.data_dict removeAllObjects];
    [req.data_dict setNonEmptyValuesForKeysWithDictionary:info];
    
    //URL
    NSString * url = [info objectOutForKey:k_r_url];
    NSString * baseUrl = [info objectOutForKey:k_r_baseUrl];
    
    req.relativeUrl = url;

    if ([[info objectOutForKey:k_r_url] hasPrefix:@"http"]) {
        req.absoluteUrl = url;
    }
    else{
        if ([NSString isEmptyString:baseUrl]) {
            baseUrl = k_EXTERN_ENDPOINT_SERVER_URL;
        }
        
        if ([baseUrl hasSuffix:@"/"] && [url hasPrefix:@"/"]) {
            req.absoluteUrl = [NSString stringWithFormat:@"%@%@",baseUrl, [url substringFromIndex:1]];
        }
        else if (![baseUrl hasSuffix:@"/"] && ![url hasPrefix:@"/"]){
            req.absoluteUrl = [NSString stringWithFormat:@"%@/%@",baseUrl, url];
        }
        else{
            req.absoluteUrl = [NSString stringWithFormat:@"%@%@",baseUrl, url];
        }
    }
    
    //头部
    [req setHeadFieldWithReplace:[st_reqHandle getCommonHeadFieldsToPost]];
    if ([info objectOutForKey:k_r_head] && [[info objectOutForKey:k_r_head] isKindOfClass:[NSDictionary class]]) {
        [req setHeadFieldWithAddtinal:[info objectOutForKey:k_r_head]];
    }
    
    //资源类型
    if ([req.absoluteUrl hasSuffix:@".png"] || [req.absoluteUrl hasSuffix:@".PNG"] || [req.absoluteUrl hasSuffix:@".jpg"] || [req.absoluteUrl hasSuffix:@".jpeg"] || [req.absoluteUrl hasSuffix:@".bmp"] || [req.absoluteUrl hasSuffix:@".JPG"]) {
        req.resType = ResImage;
    }
    else if ([info objectOutForKey:k_r_resType]) {
        req.resType = (KReqResType)[info objectOutForKey:k_r_resType];
    }
    else{
        req.resType = ResJson;
    }
    [req.data_dict setObject:[NSString stringWithFormat:@"%d",req.resType] forKey:k_r_resType];
    
    //设置请求超时时间
    if ([info objectOutForKey:k_r_timeout]) {
        req.timeoutInterval = [[NSString stringWithFormat:@"%@", [info objectOutForKey:k_r_timeout]] integerValue];
    }
    else{
        req.timeoutInterval = 30.0f;
    }
    
    //请求方式
    if ([info objectOutForKey:k_r_methodType] && [[info objectOutForKey:k_r_methodType] integerValue] == M_GET) {
        req.methodType = M_GET;
    }
    else{
        req.methodType = M_POST;
    }
    
    //请求参数
    id post = nil;
    if ([info objectOutForKey:k_r_postData]) {
        post = [info objectOutForKey:k_r_postData];
    }
    if (post && req.methodType == M_POST) {
        post = [self getPersonalPostString:post method:req.absoluteUrl];
    }
    else{
        if (post && [post isKindOfClass:[NSDictionary class]]) {
            post = [self GETgetPersonalPostStringWithDict:post method:req.absoluteUrl];
        }
    }
    
    id postData = [req.data_dict objectOutForKey:k_r_postData];
    if (postData && [postData isKindOfClass:[NSString class]]) {
        
    }
    else if (postData && [postData isKindOfClass:[NSDictionary class]]){
        postData = [NSString stringWithObjectAsJSON:postData];
    }
    else{
        postData = @"";
    }
    
    post = [NSString stringWithFormat:@"postData=%@", postData];
    
    if (![req.data_dict objectOutForKey:k_r_printLog] || [[req.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
        InfoLog(@"请求参数：%@", post);
    }
    
    //request对象实例
    NSURLRequest * ir = [self urlRequestWithType:req postStr:post];
    req.httpRequest = [TKHTTPRequest requestWithURLRequest:ir];
    req.httpRequest.URL = ir.URL;
//    req.httpRequest.delegate = req;
    req.httpRequest.didStartSelector = @selector(resourceServiceRequestDidStart:);
    req.httpRequest.didReceiveResponseSelector = @selector(resourceServiceRequestDidReceiveResponse:);
    req.httpRequest.didFinishSelector = @selector(resourceServiceRequestDidFinish:);
    req.httpRequest.didFailSelector = @selector(resourceServiceRequestDidFail:);
    req.httpRequest.progressDelegate = req;
    
    //回调代理
    if ([info objectOutForKey:k_r_delegate]) {
        req.delegate = [info objectOutForKey:k_r_delegate];
    }
    
    //ASIHTTPRequest
//    NSURL *Aurl = [NSURL URLWithString:req.absoluteUrl];
//    req.asiRequest = [[[ASIHTTPRequest alloc] initWithURL:Aurl] autorelease];
//    req.asiRequest.delegate = self;
    
    //ASIFormDataRequest
    req.asiFormDataRequest = [self asiFormDataRequestWithType:req postStr:post];
    req.asiFormDataRequest.delegate = req;
    req.asiFormDataRequest.didStartSelector = @selector(resourceServiceRequestDidStart:);
    req.asiFormDataRequest.didReceiveResponseHeadersSelector = @selector(resourceServiceRequestDidReceiveResponse:);
    req.asiFormDataRequest.didFinishSelector = @selector(resourceServiceRequestDidFinish:);
    req.asiFormDataRequest.didFailSelector = @selector(resourceServiceRequestDidFail:);
    
    req.afHTTPRequestOperationManager = [self AFHTTPRequestOperationWithType:req postStr:post];
    
    return req;
}


#pragma mark - Api ---- Loading view

- (void)showLoadingView:(Reqest *)req{
    if (!req || !req.data_dict) {
        return;
    }
    
    if ([req.data_dict objectOutForKey:k_r_loading] && [[req.data_dict objectOutForKey:k_r_loading] integerValue] == 0){
        return;
    }
    else{
        //默认全局Loading
        
        [self hiddenLoadingView:req];
        
        self.isShowingLoading = YES;
        [[LoadingView shared] showLoading:nil message:nil];
    }
}

- (void)hiddenLoadingView:(Reqest *)req{
    if ([req.data_dict objectOutForKey:k_r_loading] && [[req.data_dict objectOutForKey:k_r_loading] integerValue] == 0){
        return;
    }
    if (self.isShowingLoading) {
        [[LoadingView shared] hideLoading];
    }
    self.isShowingLoading = NO;
}


#pragma mark - Util Method

- (NSURLRequest *)urlRequestWithType:(Reqest *)req postStr:(NSString *)postString{
    if(!req.absoluteUrl || !req) return nil;
    NSMutableURLRequest *request;
    if (req.methodType == M_POST) {
//        InfoLog(@"POST request Url:%@", req.absoluteUrl);
        request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:req.absoluteUrl]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                            timeoutInterval:req.timeoutInterval] autorelease];
        if (![NSString isEmptyString:postString]) {
            NSData * postBody = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString * postLength = [NSString stringWithFormat:@"%d",(int)[postBody length]];
            [request setHTTPBody:postBody];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        }
        else{
            [request setHTTPBody:nil];
            [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
        }
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    }
    else{
        NSString *requestURL;
        if ([NSString isEmptyString:postString]) {
            requestURL = req.absoluteUrl;
        }
        else{
            postString = [postString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            requestURL = [NSString stringWithFormat:@"%@?%@",req.absoluteUrl, postString];
        }
        
//        InfoLog(@"GET request Url:%@", requestURL);
        request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:req.absoluteUrl]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                            timeoutInterval:req.timeoutInterval] autorelease];
        [request setHTTPMethod:@"GET"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    }
    
    if (req.headFileds != nil && [req.headFileds count] != 0) {
        for (NSString *key in [req.headFileds allKeys]){
            [request setValue:[req.headFileds objectOutForKey:key] forHTTPHeaderField:[key lowercaseString]];
        }
    }
    //18600405293
//    InfoLog(@"\n【HeaderFileds】:\n%@", [request allHTTPHeaderFields]);
//    if (req.methodType == M_POST) {
//        InfoLog(@"\n【PostString】:\n%@", [NSDictionary dictionaryWithJSON:[[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] autorelease]]);
//    }
    
    return request;
}

- (ASIFormDataRequest *)asiFormDataRequestWithType:(Reqest *)req postStr:(NSString *)postString{
    if(!req.absoluteUrl || !req) return nil;
    
    ASIFormDataRequest *request = nil;
    
    if (req.methodType == M_POST) {
        if (![req.data_dict objectOutForKey:k_r_printLog] || [[req.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
            InfoLog(@"POST request Url:%@", req.absoluteUrl);
        }
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:req.absoluteUrl]];
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:req.timeoutInterval];
        [request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:k_User_Agent forKey:@"User-Agent"]];
        [request setRequestCookies:[NSMutableArray arrayWithArray:[[UserManager sharedInstance] getRequestCookies:nil flag:YES]]];
        //处理POST请求
        if (![NSString isEmptyString:postString]) {
            NSDictionary * params = [NSString postDictionaryWithString:postString];
            
//            //postData:必须是字符串
//            id postData = [req.data_dict objectOutForKey:k_r_postData];
//            NSDictionary *params = nil;
//            if (postData && [postData isKindOfClass:[NSString class]]) {
//                params = @{@"postData": postData};
//            }
//            else if (postData && [postData isKindOfClass:[NSDictionary class]]){
//                params = @{@"postData": [NSString stringWithObjectAsJSON:postData]};
//            }
//            else{
//                postData = @"";
//                params = @{@"postData": postData};
//            }
            
            NSArray *keys = [params allKeys];
            for (int i = 0; i < keys.count; i++) {
                NSString *key = [keys objectAtExistIndex:i];
                NSString *value = [params objectForKey:key];
                if ([value isKindOfClass:[UIImage class]]) {
//                      NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test4" ofType:@"gif"];
//                      NSData*  data=[NSData dataWithContentsOfFile:filePath];
//                    NSData *imageData=UIImageJPEGRepresentation((UIImage *)value, 1.0);
                    NSData *imageData=UIImagePNGRepresentation((UIImage *)value);
                    [request addData:imageData forKey:key];
                }
                else{
                    [request setPostValue:value forKey:key];
                }
            }
        }
    }
    else{
        NSString *requestURL;
        if ([NSString isEmptyString:postString]) {
            requestURL = req.absoluteUrl;
        }
        else{
            postString = [postString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//中文转码
            
            requestURL = [NSString stringWithFormat:@"%@?%@",req.absoluteUrl, postString];
        }
        
        if (![req.data_dict objectOutForKey:k_r_printLog] || [[req.data_dict objectOutForKey:k_r_printLog] integerValue] == 1){
            InfoLog(@"GET request Url:%@", requestURL);
        }
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        [request setRequestMethod:@"GET"];
        [request setTimeOutSeconds:req.timeoutInterval];
    }
    
    return request;
}

- (AFHTTPRequestOperationManager *)AFHTTPRequestOperationWithType:(Reqest *)req postStr:(NSString *)postString{
    if(!req.absoluteUrl || !req) return nil;
    
//    AFHTTPRequestOperationManager *request = nil;
    AFHTTPRequestOperationManager *request = [AFHTTPRequestOperationManager manager];
    request.responseSerializer = [AFHTTPResponseSerializer serializer];
    [request.requestSerializer setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置超时时间
    [request.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    request.requestSerializer.timeoutInterval = 20.f;
    [request.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    NSDictionary *dictCookies = [[UserManager sharedInstance] getDictCookies];
//    [request.requestSerializer setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
//
//    NSDictionary *params = @{@"postData": postString};
//    
//    if (req.methodType == M_POST) {
//        InfoLog(@"POST request Url:%@", req.absoluteUrl);
////        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:req.absoluteUrl]];
////        [request setRequestMethod:@"POST"];
////        [request setTimeOutSeconds:req.timeoutInterval];
//        
//        //处理POST请求
//        if (![NSString isEmptyString:postString]) {
//            NSDictionary * params = [NSString postDictionaryWithString:postString];
//            NSArray *keys = [params allKeys];
//            for (int i = 0; i < keys.count; i++) {
//                NSString *key = [keys objectAtIndex:i];
//                NSString *value = [params objectForKey:key];
//                if ([value isKindOfClass:[UIImage class]]) {
//                    //                      NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test4" ofType:@"gif"];
//                    //                      NSData*  data=[NSData dataWithContentsOfFile:filePath];
//                    //                    NSData *imageData=UIImageJPEGRepresentation((UIImage *)value, 1.0);
//                    NSData *imageData=UIImagePNGRepresentation((UIImage *)value);
//                    [request addData:imageData forKey:key];
//                }
//                else{
//                    [request setPostValue:value forKey:key];
//                }
//            }
//        }
//    }
//    else{
//        NSString *requestURL;
//        if ([NSString isEmptyString:postString]) {
//            requestURL = req.absoluteUrl;
//        }
//        else{
//            postString = [postString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//中文转码
//            
//            requestURL = [NSString stringWithFormat:@"%@?%@",req.absoluteUrl, postString];
//        }
//        
//        InfoLog(@"GET request Url:%@", requestURL);
////        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
//        [request setRequestMethod:@"GET"];
//        [request setTimeOutSeconds:req.timeoutInterval];
//    }
    
    return request;
}

/*
-(void)method4{
    NSURL *uploadURL;
    //文件路径处理(随意)
    InfoLog(@"请求路径为%@",uploadURL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        //body
        NSData *body = [self prepareDataForUpload];
        //request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:uploadURL];
        [request setHTTPMethod:@"POST"];
        
        // 以下2行是关键，NSURLSessionUploadTask不会自动添加Content-Type头
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            InfoLog(@"message: %@", message);
            
            [session invalidateAndCancel];
        }];
        
        [uploadTask resume];
    });
}
//生成bodyData
-(NSData*) prepareDataForUpload
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtExistIndex:0];
    NSString *uploadFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString *lastPathfileName = [uploadFilePath lastPathComponent];
    
    NSMutableData *body = [NSMutableData data];
    
    NSData *dataOfFile = [[NSData alloc] initWithContentsOfFile:uploadFilePath];
    
    if (dataOfFile) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileParam, lastPathfileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:dataOfFile];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}*/
//返回nil：不保存
//返回一个对象：保存，返回值为保存的Key值
- (NSString *)shouldSaveToCache:(Reqest *)req data:(NSData *)resData{
    if (!req.data_dict) {
        return nil;
    }
    
    if ([req.data_dict objectOutForKey:k_r_cache] && [[req.data_dict objectOutForKey:k_r_cache] integerValue] == 1 && [req.data_dict objectOutForKey:k_r_cache_key]){
        NSString * key = [NSString stringWithFormat:@"%@", [req.data_dict objectOutForKey:k_r_cache_key]];
        [self saveResToCache:resData toPath:key :req];
        return key;
    }
    else{
        return nil;
    }
}

//保存本地资源
- (BOOL)saveResToCache:(NSData *)resData toPath:(NSString *)path :(Reqest *)req{
    if (!path) return NO;
    
    if (req.resType == ResImage) {
        [[[Cache shared] pics_dict] setValue:[UIImage imageWithData:resData] forKey:path];
    }
    else if (req.resType == ResJson || req.resType == ResHTML){
        NSString *responseString = [[[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding] autorelease];
        [[[Cache shared] cache_dict] setValue:responseString forKey:path];
    }
    
    return YES;
}

//返回nil：不保存
//返回一个对象：保存，返回值为保存的路径
- (NSString *)shouldSaveToDocument:(Reqest *)req data:(NSData *)resData{
    if (!req.data_dict) {
        return nil;
    }
    
    if ([req.data_dict objectOutForKey:k_r_document] && [[req.data_dict objectOutForKey:k_r_document] integerValue] == 1){
        NSString * path = nil;
        if ([req.data_dict objectOutForKey:k_r_document_path]) {
            path = [NSString stringWithFormat:@"%@", [req.data_dict objectOutForKey:k_r_document_path]];
        }
        else{
            path = [NSString stringWithFormat:@"%@", [NSString trimFileNameOfPath:req.absoluteUrl]];
        }
        [self saveResourceToDocument:resData toPath:path];
        return path;
    }
    else{
        return nil;
    }
}

//保存本地资源
- (BOOL)saveResourceToDocument:(NSData *)resData toPath:(NSString *)path{
    if (!path) return NO;
    NSData * data = [[resData retain] autorelease];
    BOOL isSuccess = [[FileManager shared] writeToDocumentWithData:data toPath:path];
    
    return isSuccess;
}

- (NSString *)getPersonalPostString:(id)string method:(NSString *)url{
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    if (string && [string isKindOfClass:[NSDictionary class]]) {
        NSDictionary * tmpdict = [NSDictionary dictionaryWithDictionary:string];
        for (NSString * str in [tmpdict allKeys]) {
            [dict setObject:[tmpdict objectOutForKey:str] forKey:str];
        }
    }
    else if (string && [string isKindOfClass:[NSString class]]) {
        NSString * tmpstr = [NSString stringWithFormat:@"%@", string];
        if (tmpstr && tmpstr.length>0) {
            NSDictionary * md = [NSString postDictionaryWithString:tmpstr];
            if (md && [md count]>0) {
                for (NSString * str in [md allKeys]) {
                    [dict setObject:[md objectOutForKey:str] forKey:str];
                }
            }
        }
    }
    
    return [[NSString stringWithObjectAsJSON:dict] stringByReplacingOccurrencesOfString:@"\"null\"" withString:@"null"];

//    NSString * post = [NSString organizeToJsonStyleWithParams:dict method:[NSString trimFileNameOfPath:url]];
//    [dict release];
//    return post;
}

- (NSString *)GETgetPersonalPostStringWithDict:(id)string method:(NSString *)url{
    if (string && [string isKindOfClass:[NSDictionary class]]) {
        return [NSString GETpostStringWithDictionary:string];
    }
    else if (string && [string isKindOfClass:[NSString class]]) {
        return string;
    }
    return string;
}

- (BOOL)flagOfShowLoading:(Reqest *)req{
    if (!req || !req.data_dict) {
        return NO;
    }
    
    if ([req.data_dict objectOutForKey:k_r_loading] && [[req.data_dict objectOutForKey:k_r_loading] integerValue] == 0){
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)flagOfShowError:(Reqest *)req{
    if (!req || !req.data_dict) {
        return YES;
    }
    
    if ([req.data_dict objectOutForKey:k_r_showError] && [[req.data_dict objectOutForKey:k_r_showError] integerValue] == 0){
        return NO;
    }
    else{
        return YES;
    }
}

- (id)getFromObject:(Reqest *)req{
    if (!req.data_dict) {
        return nil;
    }
    
    if ([req.data_dict objectOutForKey:k_r_fromObj] && ![[req.data_dict objectOutForKey:k_r_fromObj] isKindOfClass:[NSNull class]]){
        return [req.data_dict objectOutForKey:k_r_fromObj];
    }
    else{
        return nil;
    }
}

@end
