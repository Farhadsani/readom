//
//  MyStoreGoodsEditNameRuleViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/11/2.
//
//

#import "BaseViewController.h"
#import "StoreGoodsDetail.h"

typedef void (^ChangeValue)(NSString *newValue);

@interface MyStoreGoodsEditNameRuleViewController : BaseViewController
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, copy) ChangeValue changeValue;
@end
