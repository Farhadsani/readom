//
//  ReqEngine.m
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import "ReqEngine.h"
#import "ReqHandle.h"

static ReqEngine * st_reqEngine = nil;

@implementation ReqEngine
@synthesize reqest = _reqest;

+ (ReqEngine *)shared{
    if (st_reqEngine == nil) {
        st_reqEngine = [[ReqEngine alloc] init];
        [st_reqEngine variableInit];
    }
    return st_reqEngine;
}
- (void)variableInit{
    self.reqestCollects = [[[NSMutableArray alloc] init] autorelease];
}

#pragma mark - life Cycle

- (void)tryRequest:(NSDictionary *)params{
    if (![NSDictionary isNotEmpty:params]) return;
    
    Reqest * req = [[ReqHandle shared] generateRequest:params]; //创建请求对象
    if (!req) {
        [[ExceptionEngine shared] alertTitle:@"" message:@"请求参数为空" delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
        return;
    }
    
    NSInteger reqApiType = [[params objectOutForKey:k_r_reqApiType] integerValue];
    if ([params objectOutForKey:k_r_url] && [[params objectOutForKey:k_r_url] hasPrefix:@"http"]) {
        if ([[params objectOutForKey:k_r_url] hasSuffix:@".jpg"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".JPG"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".jpeg"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".JPEG"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".bmp"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".BMP"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".png"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".PNG"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".gif"] ||
            [[params objectOutForKey:k_r_url] hasSuffix:@".GIF"]) {
            reqApiType = SysConnectionReqApi;
        }
    }
    else if([params objectOutForKey:k_r_attchData]){
        reqApiType = AFReqApi;
    }
    
    [req.data_dict setNonEmptyObject:num(reqApiType) forKey:k_r_reqApiType];
    
    [self.reqestCollects addNonEmptyObject:req];
    
    if (reqApiType == AFReqApi) {
        [req startAFHTTPRequest];
    }
    else if (reqApiType == SysConnectionReqApi) {
        [req startRequest];
    }
    else{
        [req startAsiFormDataRequest];
    }
}

- (void)cancelRequests{
    if ([NSArray isNotEmpty:self.reqestCollects]) {
        for (Reqest * req in self.reqestCollects) {
            [req cancelReq];
        }
        [self.reqestCollects removeAllObjects];
        [[LoadingView shared] hideLoading];
    }
}

#pragma mark - delegate (CallBack)

#pragma mark - init & dealloc

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark

@end
