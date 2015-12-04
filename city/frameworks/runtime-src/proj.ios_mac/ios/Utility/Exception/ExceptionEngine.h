//
//  ExceptionEngine.h
//  
//
//  Created by hf on 13-3-27.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//


typedef enum{
    Exception_type_startUp = 0, //启动更新接口异常(无法更新)
    Exception_type_md5,         //md5下载异常
    Exception_type_xml_tag,     //xml页面标签解析异常
    Exception_type_flow_tag,    //flow页面标签解析异常
    Exception_type_cssParser,   //css解析异常
    Exception_type_network,     //网络异常、通讯异常
    Exception_type_security,    //安全校验异常
    Exception_type_pool,        //池模块异常（初始化、状态异常）
    Exception_type_client,      //客户端异常
    Exception_type_hardware,    //连接硬件异常（U盾）
    Exception_type_plugin,      //插件异常（解压、安装）
    Exception_type_json,        //json数据异常（格式错误、json为空）
    Exception_type_exception,   //异常模块本身发生异常
    Exception_type_unknow       //其它异常
}ExceptionType;     //异常类型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ExceptionEngineDelegate;
@class Exception;
@interface ExceptionEngine : NSObject {
    Exception * mException;
    id<ExceptionEngineDelegate> mExceptionDelegate;
    NSString * mMessage;
}
@property(nonatomic, retain) id<ExceptionEngineDelegate> exceptionDelegate;
@property(nonatomic, retain) Exception * exception;
@property(nonatomic, retain) NSString * message;
@property(nonatomic) BOOL isShowErrorMessage;

@property(nonatomic, retain) NSMutableDictionary * inf;

- (void)popMsg:(NSString *)msg;

- (void)didShowErrorMessage:(BOOL)show;

/**
 *create a ExceptionEngine object.
 *@return:object
 */
+ (ExceptionEngine *)shared;

- (void)setInfo:(NSMutableDictionary *)inf;
- (void)resetInf;

#pragma mark -
#pragma mark Exception 异常模块外部接口

/**
 *register exception catcher, the function must be called at first to catch exception.
 *@return:void
 */
- (void)registerExceptionCatcher;


- (BOOL)alertTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate tag:(NSInteger)tag cancelBtn:(NSString *)cancelBtn btn1:(NSString *)btn1 btn2:(NSString *)btn2;

- (BOOL)alertTitle:(NSString *)title code:(NSString *)code delegate:(id /*<UIAlertViewDelegate>*/)delegate tag:(NSInteger)tag cancelBtn:(NSString *)cancelBtn btn1:(NSString *)btn1 btn2:(NSString *)btn2;

- (BOOL)alertTitle:(NSString *)title error:(NSError *)error delegate:(id /*<UIAlertViewDelegate>*/)delegate tag:(NSInteger)tag cancelBtn:(NSString *)cancelBtn btn1:(NSString *)btn1 btn2:(NSString *)btn2;

//重置UIAlertView的提示信息，防止重复提示
+ (void)resetAlertMessage;

- (BOOL)didHasAndHandelErrorMsgWithResponseString:(NSString * )json;
- (BOOL)didHasAndHandelErrorMsgWithResponseDict:(NSDictionary * )jsonDict;

@end



#pragma mark -
#pragma mark ExceptionEngineDelegate

@protocol ExceptionEngineDelegate <NSObject>

@optional
/*
 *代理回调函数，异常模块处理完后回调，通知发生异常的对象
 *delegate callback method,it will be called when the ecxeption be handeled
 *@params:exception:抛出的异常对象
 *@params:owner:发生并抛出异常的对象
 *@params:error
 *@return:void
 */
- (void)Exception:(Exception *)exception exceptionDidPopedToObject:(id)owner error:(NSError *)error;

@end





