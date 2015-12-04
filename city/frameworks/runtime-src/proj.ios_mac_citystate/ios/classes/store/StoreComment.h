//
//  StoreComment.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <Foundation/Foundation.h>

@interface StoreComment : NSObject
@property (nonatomic, assign) long userid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imglink;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, strong) NSArray *thumblink;
@property (nonatomic, strong) NSArray *photolink;
@property (nonatomic, strong) NSArray *photothumb;
@property (nonatomic, copy) NSString *ctime;
@end
