//
//  NetworkingBase.h
//  iPIS
//
//  Created by 特里尼斯 北京 on 12-8-3.
//  Copyright (c) 2012年 北京特里尼斯石油技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
//#import "SBJSON.h"
/*
 *功能：网络请求基类
 */
extern  NSString*  const kPISServerURL;//PIS服务请求URL

@interface NetworkingBase : NSObject<ASIHTTPRequestDelegate>{
@private  
    ASIHTTPRequest* _request;
} 


-(id)initWithUrl:(NSString*) url;
-(id)initWithMethodName:(NSString *)methodName;
-(id)initWithMethodName:(NSString*) methodName param:(NSDictionary*) dictParam;
-(void)changeMethodName:(NSString *)methodName param:(NSDictionary *)dictParam;
-(id)getResult;
@end
