//
//  UserDetailController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

/*
 *[个人详情]页面
 *功能：显示个人一些基本资料（性别、性取向、情感状况、星座）
 * 编辑基本资料
 */

#import "BaseUIViewController.h"
@interface UserDetailController : BaseViewController
- (void) setUserData:(long)userid;
@end
