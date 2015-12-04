//
//  ExceptionEngine.m
//  
//
//  Created by lion on 13-3-27.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

#import "ExceptionEngine.h"
#import "FileManager.h"
#import "Exception.h"

static ExceptionEngine *st_exceptionEngine = nil;


@interface ExceptionEngine ()

- (void)popupAlertView;
//- (void)popupAlertViewWithMsg:(NSString *)msg;

//异常信息
- (NSString *)getExceptionTypeString:(ExceptionType)type;
- (NSString *)exceptionTitle;           //异常标题
- (NSString *)exceptionReason;          //异常信息（原因、发生的对象、对象所在的类等）

//异常处理方式
- (void)printExceptionMessageToConsole; //详细的堆栈信息打印到console上
- (void)writeExceptionMessageToLogFile; //异常信息输出到log文件中
- (void)writeExceptionMessageToLogFile:(NSString *)msg;
- (void)alertToUserView;                //弹出提示框提示给用户
- (void)notifyToOwner;                  //代理回调通知发生异常的对象

@end


@implementation ExceptionEngine
@synthesize exception = mException;
@synthesize exceptionDelegate = mExceptionDelegate;
@synthesize message = mMessage;

+ (ExceptionEngine *)shared{
    @synchronized(self) {
        if (nil == st_exceptionEngine) {
            st_exceptionEngine = [[ExceptionEngine alloc] init];
            st_exceptionEngine.message = [NSString string];
            st_exceptionEngine.isShowErrorMessage = YES;
        }
    }
    
    return st_exceptionEngine;
}

- (void)setInfo:(NSMutableDictionary *)inf{
    if ([NSDictionary isNotEmpty:inf]) {
        if (!self.inf) {
            self.inf = [[[NSMutableDictionary alloc] init] autorelease];
        }
        [self.inf removeAllObjects];
        
        [self.inf setNonEmptyValuesForKeysWithDictionary:inf];
    }
}

- (void)resetInf{
    if (self.inf) {
        [self.inf removeAllObjects];
    }
}

- (void)didShowErrorMessage:(BOOL)show{
    if (self.isShowErrorMessage == show) {
        return;
    }
    self.isShowErrorMessage = show;
}

//- (NSString*)createStringWithDescription:(NSString*)description extra:(NSString*)extra{
//    NSDate *now = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
//    NSString *time = [formatter stringFromDate:now];
//    
//    NSString *version = [[UIDevice currentDevice] systemVersion];
//    NSString *modal = [[UIDevice currentDevice] model];
//    NSString *fmt = @"\nexceptionTime:%@\ndevice:%@\niosVersion:%@\nDescription:%@\nextraMessage:%@";
//    NSString *str = [NSString stringWithFormat:fmt, time, modal, version, description, extra];
//    
//    [formatter release];
//    
//    return str;
//}

//注册异常捕获
- (void)registerExceptionCatcher{
    //set crash report
//    CrashController * crash = [CrashController sharedInstance];
//    crash.delegate = self;
//    [crash sendCrashReportsToBugzScoutURL:nil withUser:nil password:nil forProject:@"TDR_iPhone" withArea:@"China"];
}

- (void)onCrash:(NSDictionary*)userInfo{
//    NSMutableDictionary * infoDict = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
//    [infoDict setObject:[NSThread  callStackSymbols] forKey:@"Callstack"];    
//    NSString * exceptionInfo = [self createStringWithDescription:[infoDict objectOutForKey:@"Title"] extra:[infoDict description]];
//    InfoLog(@"Exception Message%@", exceptionInfo);
//    [self popupAlertViewWithMsg:exceptionInfo];
//    [self writeExceptionMessageToLogFile:exceptionInfo];
//    [infoDict release];
}

- (void)popupAlertView{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:mException.name message:mException.reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertV show];
    [alertV release];
}

- (void)popMsg:(NSString *)msg{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertV show];
    [alertV release];
}

#pragma mark - 异常异常信息

- (NSString *)getExceptionTypeString:(ExceptionType)type{
    NSArray * typesArray = [NSArray arrayWithObjects:@"Exception_type_startUp",@"Exception_type_xml_tag",@"Exception_type_flow_tag",@"Exception_type_cssParser",@"Exception_type_network",@"Exception_type_security",@"Exception_type_pool",@"Exception_type_client",@"Exception_type_hardware",@"Exception_type_plugin",@"Exception_type_json",@"Exception_type_exception",@"Exception_type_unknow", nil];
    if (type < [typesArray count]) {
        return [typesArray objectAtExistIndex:type];
    }
    else{
        return @"Unknow Exception Type";
    }
}

- (NSString *)exceptionReason{
    return [NSString stringWithFormat:@"type:%@\n class:%@\n reason:%@\n function callStack:%@",[self getExceptionTypeString:self.exception.exceptionType], self.exception.objectClass, self.exception.reason, [NSThread  callStackSymbols]];
}

- (NSString *)exceptionTitle{
    if (self.exception.name.length > 0) {
        return [NSString stringWithFormat:@"Exception\n name:%@\n",self.exception.name];
    }
    else{
        return @"Unknow Exception";
    }
}


#pragma mark - 异常处理方式

//异常信息输出到log文件中
- (void)writeExceptionMessageToLogFile{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *time = [formatter stringFromDate:now];
    [formatter release];
    
    NSString * file = [[FileManager shared] readStringAtDocumentAtPath:@"exception.log" error:nil];
    NSMutableString * ms = [[NSMutableString alloc] init];
    if (file) {
        [ms appendString:file];
    }
    [ms appendFormat:@"{Exception:\n time:%@\n title:%@\n message:[\n %@ ]\n};\n",time,[self exceptionTitle], [self exceptionReason]];
    
    [[FileManager shared] writeToDocumentWithString:ms toPath:@"exception.log"];
    [ms release];
}

//异常信息输出到log文件中
- (void)writeExceptionMessageToLogFile:(NSString *)msg{
    NSString * file = [[FileManager shared] readStringAtDocumentAtPath:@"exception.log" error:nil];
    NSMutableString * ms = [[NSMutableString alloc] init];
    if (file) {
        [ms appendString:file];
    }
    [ms appendFormat:@"{Exception:\n message:[\n %@ ]\n}", msg];
    
    [[FileManager shared] writeToDocumentWithString:ms toPath:@"exception.log"];
    [ms release];
}

//详细的堆栈信息打印到console上
- (void)printExceptionMessageToConsole{
    //打印调用栈
    InfoLog(@"【异常】函数调用栈:");
//    NSArray *syms = [NSThread  callStackSymbols];
//    InfoLog(@"Function Caller:%@", syms);
//    if ([syms count] > 1) {
//        InfoLog(@"<%@ %p> %@ - caller: %@ ", [self class], self, NSStringFromSelector(_cmd),[syms objectAtExistIndex:1]);
//    } else {
//        InfoLog(@"<%@ %p> %@", [self class], self, NSStringFromSelector(_cmd));
//    }
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *time = [formatter stringFromDate:now];
    [formatter release];
    
    InfoLog(@"print exception message:\n%@", [NSString stringWithFormat:@"{Exception:\n time:%@\n title:%@\n message:[\n %@ ]\n}",time,[self exceptionTitle], [self exceptionReason]]);
}

//提示用户
- (void)alertToUserView{
    dispatch_async(dispatch_get_main_queue(), ^{
        //perform on the main thread.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self exceptionTitle] message:[self exceptionReason] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

//通知代理
- (void)notifyToOwner{
    if (self.exceptionDelegate && [self.exceptionDelegate respondsToSelector:@selector(Exception:exceptionDidPopedToObject:error:)]) {
        [self.exceptionDelegate Exception:mException exceptionDidPopedToObject:mException.owner error:nil];
    }
}

#pragma mark - 异常接口

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
}

- (BOOL)alertTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate tag:(NSInteger)tag cancelBtn:(NSString *)cancelBtn btn1:(NSString *)btn1 btn2:(NSString *)btn2{
    if (!message || message.length == 0) {
        message = tanslateLocalCode(@"000001", @"localizable", nil);
    }
    
    //防止弹出相同的提示信息
    if ([ExceptionEngine shared].message && [ExceptionEngine shared].message.length > 0 && [[ExceptionEngine shared].message isEqualToString:message]) {
        return YES;
    }
    
    if ([ExceptionEngine shared].isShowErrorMessage) {
        id del = delegate;
        if (!delegate) {
            del = [ExceptionEngine shared];
        }
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:(!title)?@"":title message:message delegate:del cancelButtonTitle:cancelBtn otherButtonTitles:btn1,btn2,nil];
        alert.tag = tag;
        [alert show];
        [alert release];
        
        [ExceptionEngine shared].message = message;
    }
    else{
        [[ExceptionEngine shared] didShowErrorMessage:YES];
    }
    
    return YES;
}

- (BOOL)alertTitle:(NSString *)title code:(NSString *)code delegate:(id /*<UIAlertViewDelegate>*/)delegate tag:(NSInteger)tag cancelBtn:(NSString *)cancelBtn btn1:(NSString *)btn1 btn2:(NSString *)btn2{
    if (!code || code.length == 0) {
        return NO;
    }
    
    NSString * msg = tanslateLocalCode(code, @"localizable", nil);
//#ifdef __SHOW_ERROR_CODE__
//    if (![msg hasPrefix:code] && [msg rangeOfString:@"("].location != NSNotFound) {
//        msg = [msg substringToIndex:[msg rangeOfString:@"("].location];
//        msg = tanslateLocalCode(msg, @"localizable", nil);
//    }
//#else
//    if (![msg isEqualToString:code]) {
//        msg = tanslateLocalCode(msg, @"localizable", nil);
//    }
//#endif
    
    if (!msg || msg.length == 0) {
#ifdef __SHOW_ERROR_CODE__
        msg = [NSString stringWithFormat:@"错误码000001，错误提示：操作失败，请重新尝试（原编号%@）。",code];
#else
        msg = [NSString stringWithFormat:@"操作失败，请重新尝试"];
#endif
//        return NO;
    }
    else if ([msg hasPrefix:code]){
        msg = [NSString stringWithFormat:@"操作失败，请重新尝试(Code:%d)", (int)[code integerValue]];
    }
    [self alertTitle:title message:msg delegate:delegate tag:tag cancelBtn:cancelBtn btn1:btn1 btn2:btn2];
    return YES;
}

- (BOOL)alertTitle:(NSString *)title error:(NSError *)error delegate:(id /*<UIAlertViewDelegate>*/)delegate tag:(NSInteger)tag cancelBtn:(NSString *)cancelBtn btn1:(NSString *)btn1 btn2:(NSString *)btn2{
    
    NSString * code = [NSString stringWithFormat:@"%d", (int)error.code];
    if (![self alertTitle:title code:code delegate:delegate tag:tag cancelBtn:cancelBtn btn1:btn1 btn2:btn2]) {
        [self alertTitle:title message:error.localizedDescription delegate:delegate tag:tag cancelBtn:cancelBtn btn1:btn1 btn2:btn2];
    }
    
    return YES;
}

- (BOOL)hasErrorWithHttpResponse:(NSString *)json{
    if (!json) {
        return YES;
    }
    
    NSDictionary * jsonDict = [NSDictionary dictionaryWithJSON:json];
    if (jsonDict) {
        return [NSString hasErrorMessage:jsonDict];
    }
    return YES;
}

- (BOOL)didHasAndHandelErrorMsgWithResponseString:(NSString * )json{
    if (!json) {
//        [self alertTitle:nil message:@"请求数据错误！" delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
        return YES;
    }
    
    NSDictionary * jsonDict = [NSDictionary dictionaryWithJSON:json];
    return [self didHasAndHandelErrorMsgWithResponseDict:jsonDict];
}

- (BOOL)didHasAndHandelErrorMsgWithResponseDict:(NSDictionary * )jsonDict{
    if (!jsonDict) {
//        NSError * error = [NSError errorWithDomain:@"服务器返回数据错误" code:0 userInfo:nil];
//        [[ExceptionEngine shared] alertTitle:nil error:error delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
        return YES;
    }
    
    if (jsonDict) {
        id errorMsg = [NSString getErrorResult:jsonDict];
        if (errorMsg && [errorMsg isKindOfClass:[NSDictionary class]]) {
            if ([errorMsg objectOutForKey:k_msg]){
                NSString * msg = [errorMsg objectOutForKey:k_msg];
                if (msg) {
                    if (st_exceptionEngine.isShowErrorMessage == YES) {
                        if ([[ExceptionEngine shared] alertTitle:nil message:msg delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil]) {
                            return YES;
                        }
                    }
                    else{
                        [[ExceptionEngine shared] didShowErrorMessage:YES];
                    }
                    return YES;
                }
            }
            
            if ([errorMsg objectOutForKey:@"ret"]) {
                id code = [errorMsg objectOutForKey:@"ret"];
                if (code) {
                    if (st_exceptionEngine.isShowErrorMessage == YES) {
                        if ([[ExceptionEngine shared] alertTitle:nil code:[NSString stringWithFormat:@"%@", code] delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil]) {
                            return YES;
                        }
                    }
                    else{
                        [[ExceptionEngine shared] didShowErrorMessage:YES];
                    }
                    return YES;
                }
            }
        }
        else{
            return NO;
//            id resultDic = [[jsonDict objectOutForKey:@"resultlist"] objectOutForKey:@"result"];
//            id result = [jsonDict objectOutForKey:@"result"];
//            if (result && [result isKindOfClass:[NSDictionary class]]) {
//                return NO;
//            }
//            if (result && [result isKindOfClass:[NSArray class]]) {
//                return NO;
//            }
//            if (result && [strObj(result) integerValue] == 1) {
//                return NO;
//            }
//            id success = [jsonDict objectOutForKey:@"success"];
//            if (success && [strObj(success) integerValue] == 1) {
//                return NO;
//            }
            
//            id normalMsg = [NSString getNormalResult:jsonDict];
//            if (normalMsg && [normalMsg isKindOfClass:[NSDictionary class]]) {
//                return NO;
//            }
        }
    }
    
//    [self alertTitle:nil message:@"请求数据错误！" delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
    return YES;
}


+ (void)resetAlertMessage{
    [ExceptionEngine shared].message = @"";
    [[ExceptionEngine shared] didShowErrorMessage:YES];
}

#pragma mark - NSObject method
+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if (st_exceptionEngine == nil) {
            st_exceptionEngine = [super allocWithZone:zone];
            return st_exceptionEngine;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)retain{
    return self;
}

- (oneway void)release{
    
}

- (id)autorelease{
    return self;
}

- (void)dealloc{
    [super dealloc];
}

@end


