//
//  MessageTabController.m
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

#import "MessageTabController.h"

@interface MessageTabController ()

@end

@implementation MessageTabController

- (void)variableInit{
    [super variableInit];
    self.hasLeftNavBackButton = NO;
    self.hidTabbarBar = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabBar:NO animation:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([((UINavigationController *)self.navigationController).viewControllers count] > 1) {
        [self hideTabBar:YES animation:YES];
    }
}

@end
