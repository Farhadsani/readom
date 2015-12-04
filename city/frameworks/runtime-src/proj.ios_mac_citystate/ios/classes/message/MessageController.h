//
//  MessageController.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/28.
//
//

/*
 *【消息】界面
 *功能：查看[我的消息]、[宠物消息]、[收到的赞]、[系统消息]
 *
 */

#import "BaseUIViewController.h"
#import "TitleBar.h"
#import "MyMsgViewController.h"
#import "PetMsgViewController.h"
#import "ReceivedPraiseViewController.h"
#import "SysMsgViewController.h"

@interface MessageController : BaseViewController<TitleBarDelegate>

@property (nonatomic, retain) NSArray * tName;
@property (nonatomic, retain) TitleBar * titleBar;
@property (nonatomic, retain) UIView *selectedView;

@end
