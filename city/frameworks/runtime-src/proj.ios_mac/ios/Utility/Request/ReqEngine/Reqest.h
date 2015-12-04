//
//  Reqest.h
//  cxy
//
//  Created by hf on 15/6/6.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHTTPRequest.h"
#import "TKNetworkQueue.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AFNetworking.h"

typedef enum KReqResType{
    ResHTML = 0,
    ResImage,
    ResColor,      //专门用来读取图片背景颜色值(七牛网站)
    ResJson
}KReqResType;

typedef enum MethodType{
    M_POST = 0,
    M_GET
}MethodType;

/*************** KEY **************/
#define k_r_url @"url"                      //请求地址
#define k_r_baseUrl @"baseUrl"              //服务器地址
#define k_r_head @"head"                    //请求头部
#define k_r_postData @"postData"            //请求参数数据（string类型 or dictionary类型）

#define k_r_timeout @"timeout"              //超时时间
#define k_r_methodType @"methodType"        //请求方式POST or GET
#define k_r_resType @"resType"              //请求资源类型

#define k_r_delegate @"delegate"            //回调代理设置

typedef enum ReqApiType{
    SysConnectionReqApi = 7,
    ASIReqApi,    //默认
    AFReqApi,
}ReqApiType;
#define k_r_reqApiType @"reqApiType"    //不同的网络请求框架

#define k_r_attchData  @"attchData"     //附件（图片：UIImage对象），注意：k_r_reqApiType必须为AFReqApi
#define k_r_privateCookie  @"privateCookie"     //单独私有的Cookie

#define k_r_cache @"cache"                  //保存到Cache，没有值不保存， 0：不保存，1：保存
#define k_r_cache_key @"cache_key"          //保存到Cache字典的Key值

#define k_r_document @"document"            //没有值不保存，保存到Document, 0：不保存，1：保存
#define k_r_document_path @"document_path"  //保存到本地Document的目录（包括文件名），如：/html/abc.plist

#define k_r_loading @"loading"              //没有值表示默认全局显示loading视图，0：不显示Loading视图，1：表示显示全局loading视图；
#define k_r_showError @"showError"              //没有值表示默认提示错误信息，0：不提示错误信息，1：表示提示错误信息；

#define k_r_fromObj @"fromObj"              //

//发出请求的主体（eg：点击某个按钮发出请求，则主体为该按钮），当发出请求后默认该主体不可点击，当请求回调后，该出体可以点击
#define k_r_clickView @"clickView"
//对应上一个字段，上一个参数中默认点击主体后，在回调之前不可重复点击，次参数可设置可重复点击请求
//定义：k_r_enableClickRepeat的值为0：设置点击后不可重复点击，1：设置点击后可重复点击
#define k_r_enableClickRepeat @"enableClickRepeat"

#define k_r_ @""        //

/*************** End **************/

@protocol ReqestDelegate;
@interface Reqest : NSObject <TKHTTPRequestProgressDelegate,NSURLConnectionDelegate>

@property(nonatomic, strong) id<ReqestDelegate> delegate;

@property(nonatomic, retain) TKHTTPRequest *httpRequest;
@property(nonatomic) NSTimeInterval timeoutInterval;
@property(nonatomic, retain) NSMutableDictionary * headFileds;
@property(nonatomic, retain) NSString * relativeUrl;//请求的相对地址
@property(nonatomic, retain) NSString * absoluteUrl;//完整请求地址

@property(nonatomic, retain) NSURLConnection * connection;
@property(nonatomic, retain) NSMutableData * receivedData;


@property(nonatomic) KReqResType resType;
@property(nonatomic) KReqResType methodType;

@property(nonatomic, retain) NSMutableDictionary * data_dict;//所有的请求数据


@property(nonatomic, retain) ASIHTTPRequest *asiRequest;
@property(nonatomic, retain) ASIFormDataRequest *asiFormDataRequest;
@property(nonatomic, retain) AFHTTPRequestOperationManager * afHTTPRequestOperationManager;

- (id)init;

- (void)startRequest;
- (void)startAsiRequest;
- (void)startAsiFormDataRequest;
- (void)startAFHTTPRequest;

- (void)cancelReq;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (void)setHeadFieldWithReplace:(NSDictionary *)fields;
- (void)setHeadFieldWithAddtinal:(NSDictionary *)fields;

- (void)resourceServiceRequestDidStart:(TKHTTPRequest*)request;
- (void)resourceServiceRequestDidReceiveResponse:(TKHTTPRequest*)request;
- (void)resourceServiceRequestDidFinish:(TKHTTPRequest*)request;
- (void)resourceServiceRequestDidFail:(TKHTTPRequest*)request;

- (NSString *)getParamValue:(NSString *)key;

@end


#pragma mark -
#pragma mark ReqestDelegate

@protocol ReqestDelegate <NSObject>

@optional
/*
 *代理回调函数，开始请求时回调
 *delegate callback method,it will be called when the request start
 *
 *@params:req the resource controller
 *@params:responseData the received data
 *@return:nil
 */
- (void)didStartLoad:(Reqest *)req;

- (void)didReceiveResponse:(Reqest *)req responseHead:(NSDictionary *)heads;


/*
 *代理回调函数，数据请求回来后回调
 *delegate callback method,it will be called when the request data back correct
 *
 *@params:req the resource controller
 *@params:responseData the received data
 *@return:nil
 */
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result;

/*
 *代理回调函数，出错回调
 *delegate callback method,it will be called when error happen
 *
 *@params:req the resource controller
 *@params:error include the error message
 *@return:nil
 */
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error;

/*
 *代理回调函数，通知接收者load进度
 *delegate callback method,it will be called when the request date is comming at half
 *
 *@params:req the resource controller
 *@params:process the process of the total data
 *@return:nil
 */
- (void)didLoading:(Reqest *)req withProcess:(NSString *)process;


@end
