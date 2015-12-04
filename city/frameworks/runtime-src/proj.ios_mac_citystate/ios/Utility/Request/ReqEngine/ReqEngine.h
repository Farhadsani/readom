//
//  ReqEngine.h
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reqest.h"

@interface ReqEngine : NSObject

@property(nonatomic, retain) Reqest * reqest;
@property(nonatomic, retain) NSMutableArray * reqestCollects;//请求缓存

+ (ReqEngine *)shared;

//请求接口
- (void)tryRequest:(NSDictionary *)params;

- (void)cancelRequests;

@end
