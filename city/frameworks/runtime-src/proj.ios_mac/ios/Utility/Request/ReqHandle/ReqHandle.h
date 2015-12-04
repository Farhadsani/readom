//
//  ReqHandle.h
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingView.h"

@class Reqest, Cache;
@interface ReqHandle : NSObject

@property(nonatomic) BOOL isShowingLoading;

+ (ReqHandle *)shared;

- (Reqest *)generateRequest:(NSDictionary *)info;

- (NSString *)shouldSaveToCache:(Reqest *)req data:(NSData *)resData;
- (NSString *)shouldSaveToDocument:(Reqest *)req data:(NSData *)resData;

- (void)showLoadingView:(Reqest *)req;

- (void)hiddenLoadingView:(Reqest *)req;

//公共报文头
- (NSDictionary *)getCommonHeadFieldsToPost;

- (BOOL)flagOfShowError:(Reqest *)req;
- (BOOL)flagOfShowLoading:(Reqest *)req;
- (id)getFromObject:(Reqest *)req;

@end
