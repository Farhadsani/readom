//
//  SendMsgController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/28.
//
//

/*
 *好友空间中 [消息]界面
 *功能：给好友的个人空间中发送消息
 */

#import "BaseUIViewController.h"

@interface SendMsgController : BaseViewController<UITextViewDelegate>
-(void)setUserInfo:(long)userID;
@end
