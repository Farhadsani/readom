//
//  UIView+Category.h
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
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

- (UIView *)setupRightBackButtonItem:(NSString *)str img:(NSString *)imgName del:(id)del sel:(SEL)action;


- (void)showConfirmSelectedView:(NSArray *)titleList action:(SEL)selector hasBackColor:(BOOL)isHas clickBackDismiss:(BOOL)clickBackHidden animation:(BOOL)isAnimate;
- (void)showConfirmSelectedView:(NSArray *)titleList defaultSelected:(NSString *)defaultTitle action:(SEL)selector hasBackColor:(BOOL)isHas clickBackDismiss:(BOOL)clickBackHidden animation:(BOOL)isAnimate;

- (void)hiddenSelectedView;


#define k_ToView @"toView"          //父view（*必填）
#define k_OffsetY @"offsetY"        //Y轴的偏移（可不填，有默认值）
#define k_ShowMsg @"showMsg"        //提示的文字（*必填）
#define k_ShowImgName @"showImgName"//提示的图片名称（可不填，有默认图片）
#define k_ListCount @"listCount"    //判断是否显示的条件（接口返回的数据个数）（*必填）
- (void)showTipView:(NSDictionary *)inf;

@end
