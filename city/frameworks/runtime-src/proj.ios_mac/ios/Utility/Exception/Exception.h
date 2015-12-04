//
//  ExceException_typeion.h
//  
//
//  Created by hf on 13-7-22.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exception : NSException{
    ExceptionType mExceptionType;
    NSString * mObjectClass;
    id mOwner;
}
@property(nonatomic, retain) id owner;
@property(nonatomic, retain) NSString * objectClass;
@property(nonatomic) ExceptionType exceptionType;

/**
 *初始化异常对象
 *init Exception object
 *
 *@params:type:ecxeption type
 *@params:objClass: the current class name who throw exception
 *@params:name:the exception title
 *@params:reason:the exception reason
 *@params:owner:the current class name who throw exception(maybe nil)
 *@params:info:th exceptoin messsage
 *@return:self
 */
- (id)initWithType:(ExceptionType)type objectClass:(NSString *)objClass name:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;

- (id)initWithException:(NSException *)exp type:(ExceptionType)type objectClass:(NSString *)objClass;

@end


