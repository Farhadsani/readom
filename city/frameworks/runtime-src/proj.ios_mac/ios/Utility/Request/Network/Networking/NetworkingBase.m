//
//  NetworkingBase.m
//  iPIS
//
//  Created by 特里尼斯 北京 on 12-8-3.
//  Copyright (c) 2012年 北京特里尼斯石油技术有限公司. All rights reserved.
//

#import "NetworkingBase.h"
#import "ASIFormDataRequest.h"
NSString* const kPISServerURL=@"http://10.100.24.12:8080/pis/httpservice.do?method=";


@implementation NetworkingBase 
//@synthesize request=_request; 

/**
 *使用完整的URL初始化
 *
 **/
-(id)initWithUrl:(NSString*) urlStr{
    self=[super init];
    if(self){ 
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIHTTPRequest *asiRequest=[[ASIHTTPRequest alloc]initWithURL:url];
        _request= [asiRequest retain];
        [asiRequest release];
        _request.delegate=self;
    }
    return self;
}

-(id)initWithMethodName:(NSString *)methodName {
    NSMutableString* url =[[NSMutableString alloc]initWithFormat:@"%@%@",kPISServerURL,methodName]; 
     self= [self initWithUrl:url]; 
    [url release];
    return self;
}

/*
 * 使用参数初始化
 */
-(id)initWithMethodName:(NSString *)methodName param:(NSDictionary *)dictParam{
    NSMutableString* url =[[NSMutableString alloc]initWithFormat:@"%@%@",kPISServerURL,methodName];
    NSEnumerator* enumeratorKey=[dictParam keyEnumerator];
    for (NSObject *key in enumeratorKey) {
        NSObject* value =[dictParam objectForKey:key];
        [url appendFormat:@"&%@=%@",key,value];
    } 
    self=[self initWithUrl:url];
    [url release];
    return self;    
}

-(void)changeMethodName:(NSString *)methodName param:(NSDictionary *)dictParam{
    NSMutableString* url =[[NSMutableString alloc]initWithFormat:@"%@%@",kPISServerURL,methodName];
    
    NSEnumerator* enumeratorKey=[dictParam keyEnumerator];
    for (NSObject *key in enumeratorKey) {
        NSObject* value =[dictParam objectForKey:key];
        [url appendFormat:@"&%@=%@",key,value];
    }
    NSURL *URL = [NSURL URLWithString:url];
//    NSLog(url);
    [url release];
//    [_request setURL:URL];

    ASIHTTPRequest *asiRequest=[[ASIHTTPRequest alloc]initWithURL:URL];
    if(_request!=nil){
        [_request release];
    }
    _request= [asiRequest retain];
    [asiRequest release];
    _request.delegate=self;    
}

#pragma mark TODO:编写一个错误处理机制
//
-(id)getResult{     
        //开始同步请求
   [_request startSynchronous];
    NSError *error = [_request error];
    
//    NSLog(response);
    if (!error) {
       NSString *response = [_request responseString];
            // NSLog(response);
            //返回的应答里字符串如果前缀为“err”，则出现了业务逻辑错误
        if([response hasPrefix:@"err"]){
                // @throw [[NSException alloc]initWithName:@"请求PIS服务器错误" reason:@"" userInfo:nil];
        }
        else{
            NSLog(@"%@",response);
            return response;
//            return  [response JSONValue]; 
        }
    }
    else{
        return nil;
            //@throw [[NSException alloc]initWithName:@"请求PIS服务器错误" reason:@"" userInfo:nil];
    }
    return nil;
}
 
-(void)dealloc{
    [super dealloc];
    [_request release];
    _request=nil;    
}

@end
