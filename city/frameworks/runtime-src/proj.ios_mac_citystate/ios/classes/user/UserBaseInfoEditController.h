//
//  UserBaseInfoEditController.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/28.
//
//
/*
 *[基本资料]编辑页面
 *功能：编辑 用户的名称、个人简介.完成操作
 *
 */

#import "BaseViewController.h"
#import "UserBriefItem.h"

@protocol PassCalloutValueDelegate <NSObject>

- (void)passCalloutValue:(NSString *)value;

@end
typedef enum {
    UserBaseInfoTitleLabelTypeZone,
    UserBaseInfoTitleLabelTypeIntro
} UserBaseInfoTitleLabelType;

@interface UserBaseInfoEditController : BaseViewController
@property (nonatomic, assign) long index;
@property (nonatomic, assign) UserBaseInfoTitleLabelType titleLabelType;
@property (nonatomic, strong) UserBriefItem *userBriefItem;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, weak) NSString * signText;
@property (nonatomic, retain) id<PassCalloutValueDelegate>passValueDelegate;

@end
