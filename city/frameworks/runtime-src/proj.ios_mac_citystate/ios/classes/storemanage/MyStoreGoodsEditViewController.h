//
//  MyStoreGoodsEditViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/30.
//
//

#import "BaseViewController.h"
#import "StoreGoodsDetail.h"

typedef void (^BackBlock)(StoreGoodsDetail *detail);
typedef void (^AddBackBlock)(StoreGoodsDetail *detail);

@interface MyStoreGoodsEditViewController : BaseViewController
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@property (nonatomic, copy) BackBlock back;
@property (nonatomic, copy) AddBackBlock addBackBlock;
@end
