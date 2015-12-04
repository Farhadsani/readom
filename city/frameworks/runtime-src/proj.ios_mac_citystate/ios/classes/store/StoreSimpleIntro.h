//
//  StoreIntro.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <Foundation/Foundation.h>
#import "StoreGoods.h"
#import "StoreComment.h"

@interface StoreSimpleIntro : NSObject
@property (nonatomic, assign) long userid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, assign) Boolean liked;
@property (nonatomic, strong) NSString *imglink;
@end
