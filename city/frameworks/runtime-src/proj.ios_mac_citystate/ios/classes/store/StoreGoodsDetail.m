//
//  StoreGoodsDetail.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import "StoreGoodsDetail.h"

@implementation StoreGoodsDetail
- (id)copyWithZone:(NSZone *)zone
{
    StoreGoodsDetail *storeGoodsDetail = [[[self class] allocWithZone:zone] init];
    storeGoodsDetail.userid = _userid;
    storeGoodsDetail.storename = [_storename copy];
    storeGoodsDetail.sold = _sold;
    storeGoodsDetail.rate = [_rate copy];
    storeGoodsDetail.address = [_address copy];
    storeGoodsDetail.phone = [_phone copy];
    storeGoodsDetail.notice = [_notice copy]; // 废弃
    storeGoodsDetail.goodsid = _goodsid;
    storeGoodsDetail.name = [_name copy];
    storeGoodsDetail.oprice = [_oprice copy];
    storeGoodsDetail.price = [_price copy];
    storeGoodsDetail.startdate = [_startdate copy];
    storeGoodsDetail.enddate = [_enddate copy];
    storeGoodsDetail.starttime = [_starttime copy];
    storeGoodsDetail.endtime = [_endtime copy];
    storeGoodsDetail.rule = [_rule copy];
    storeGoodsDetail.imglink = [_imglink copy];
    storeGoodsDetail.holidaysvalidate = _holidaysvalidate;
    return storeGoodsDetail;
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"phone": @"telephone"};
}
@end
