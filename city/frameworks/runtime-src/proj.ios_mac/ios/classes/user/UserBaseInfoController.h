//
//  UserBaseInfoController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
/*
 *[基本资料]页面
 *功能：显示用户的名称、个人简介
 * 登出帐号 功能
 */

#import "BaseUIViewController.h"
#import "UserBriefItem.h"
#import "UserBaseInfoView.h"

@interface UserBaseInfoController : BaseViewController
- (void)setUserData:(long)userID;
@end
