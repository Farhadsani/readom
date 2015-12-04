//
//  Exception.m
//  
//
//  Created by hf on 13-7-22.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

#import "Exception.h"

@implementation Exception
@synthesize owner = mOwner;
@synthesize objectClass = mObjectClass;
@synthesize exceptionType = mExceptionType;


- (NSException *)exceptionWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo{
    self = [super initWithName:name reason:reason userInfo:userInfo];
    if (self) {
        self.exceptionType = Exception_type_unknow;
    }
    return self;
}

- (void)dealloc{
    if (mObjectClass) {
        [mObjectClass release];
        mObjectClass = nil;
    }
    if (mOwner) {
        [mOwner release];
        mOwner = nil;
    }
    
    [super dealloc];
}

@end
