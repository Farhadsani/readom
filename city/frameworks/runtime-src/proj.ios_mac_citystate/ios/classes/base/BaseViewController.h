//
//  BaseViewController.h
//  cxy
//
//  Created by hf on 15/6/5.
//  Copyright (c) 2015年 hf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "UIViewController+Addtion.h"
#import "Reqest.h"

@protocol ReqestDelegate;
@interface BaseViewController : BaseUIViewController <ReqestDelegate, UIScrollViewDelegate>{
    UIView * messageView;//信息提示view
    NSTimeInterval delayTimeOfHiddenMessage;//信息提示view
}
@property(nonatomic) BOOL hasLeftNavBackButton;
@property(nonatomic) BOOL hidTopStatusBar;//屏幕顶部状态栏（显示时间、电池、运营商标识的状态栏）
@property(nonatomic) BOOL hidTabbarBar;//tabbar

@property(nonatomic, retain) UIScrollView * contentView;
@property(nonatomic) CGFloat contentViewHeight;

@property(nonatomic, retain) NSMutableDictionary * data_dict; //VC页面的数据源（字典类型）

@property(nonatomic, retain) NSMutableDictionary * post_dict; //当前VC界面上传的数据



- (void)variableInit;

//根据view的子视图重新计算view的高度
- (void)resetFrameHeightOfView:(UIView *)view;

#pragma mark 检查当前登录状态，未登录则跳转到登录界面
- (void)tryCheckLogin;

- (void)showMessageView:(NSString *)msg delayTime:(NSTimeInterval)time;
- (void)showMessageView:(NSString *)msg;
- (void)hiddenMessageView;
@end
