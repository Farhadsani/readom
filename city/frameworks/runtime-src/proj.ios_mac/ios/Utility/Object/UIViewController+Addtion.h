//
//  UIView+Category.h
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface UIViewController (Addtion)

//webView打开页面
- (void)openWebView:(NSString *)urlStr localXml:(NSString *)path title:(NSString *)title otherInfo:(NSDictionary *)info;

//打电话
- (void)callTelephone:(NSString *)teleNumber;
- (void)sendmail:(id)del;

- (void)setBackButtonDescription:(NSString *)str;

- (void)clickLeftBarButtonItem;
- (void)setupLeftBackButtonItem:(NSString *)str img:(NSString *)imgName action:(SEL)action;

- (void)setupRightBackButtonItem:(NSString *)str img:(NSString *)imgName del:(id)del sel:(SEL)action;


- (void)showConfirmSelectedView:(NSArray *)titleList SEL:(SEL)selector hasBackColor:(BOOL)isHas clickBackDismiss:(BOOL)clickBackHidden animation:(BOOL)isAnimate;
- (void)showConfirmSelectedView:(NSArray *)titleList defaultSelected:(NSString *)defaultTitle SEL:(SEL)selector hasBackColor:(BOOL)isHas clickBackDismiss:(BOOL)clickBackHidden animation:(BOOL)isAnimate;

- (void)hiddenSelectedView;


#define k_ToView @"toView"
#define k_OffsetY @"offsetY"
#define k_ShowMsg @"showMsg"
#define k_ListCount @"listCount"
- (void)showTipView:(NSDictionary *)inf;

@end
