//
//  WebViewController.h
//  
//
//  Created by lion on 14-5-28.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface WebViewController : BaseViewController <UIWebViewDelegate>

@property(nonatomic, retain) UIWebView * myWebView;
@property(nonatomic, retain) NSMutableString * myTitle;
@property(nonatomic, retain) NSMutableString * urlString;
@property(nonatomic, retain) NSMutableString * localXmlPath;//文件名称，在bundle目录下
@property(nonatomic, retain) NSMutableDictionary * otherInfo;

@property(nonatomic) BOOL shouldSetCommonCookies;

@property(nonatomic) BOOL isPush;

@property(nonatomic) BOOL isNavBarHidden; //设置本webview的navBar的显隐

@property(nonatomic) BOOL fatherNavBarHiddenStatus;//记录原来的vc的navBar的显隐状态

@end
