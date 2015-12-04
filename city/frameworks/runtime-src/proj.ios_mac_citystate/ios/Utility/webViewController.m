//
//  WebViewController.m
//  
//
//  Created by lion on 14-5-28.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)dealloc{
    self.myWebView = nil;
    if (_urlString) {
        self.urlString = nil;
    }
    if (_localXmlPath) {
        self.localXmlPath = nil;
    }
    if (_otherInfo) {
        self.otherInfo = nil;
    }
    if (_myTitle) {
        self.myTitle = nil;
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self inits];
    }
    return self;
}

- (void)variableInit{
    [super variableInit];
    
    [self inits];
}

- (void)inits{
    _myTitle = [[NSMutableString alloc] init];
    _urlString = [[NSMutableString alloc] init];
    _localXmlPath = [[NSMutableString alloc] init];
    _otherInfo = [[NSMutableDictionary alloc] init];
    _isNavBarHidden = NO;
    _isPush = YES;
    _shouldSetCommonCookies = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self hideTabBar:YES animation:YES];
    [self setupLeftBackButtonItem:nil img:nil action:nil];
    
    _fatherNavBarHiddenStatus = self.navigationController.navigationBarHidden;
    
    if (k_NO_LESS_THAN_IOS(7.0)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.view.backgroundColor = [UIColor color:white_color];
    
    self.navigationController.navigationBarHidden = _isNavBarHidden;
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    _myWebView.delegate = self;
    _myWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myWebView.backgroundColor = [UIColor whiteColor];
//    _myWebView.scalesPageToFit = YES;
    _myWebView.contentMode = UIViewContentModeScaleAspectFit;
    _myWebView.opaque = YES;
    
    if ([NSString isEmptyString:_urlString]) {
        if (![NSString isEmptyString:_localXmlPath]) {
//            NSString *path = nil;
//            NSArray * nameA = [_localXmlPath componentsSeparatedByString:@"."];
//            if ([NSArray isNotEmpty:nameA] && [nameA count] == 2) {
//                path = [[NSBundle mainBundle] pathForResource:[nameA objectAtIndex:0] ofType:[nameA objectAtIndex:1]];
//            }
//            else{
//                path = [[NSBundle mainBundle] pathForResource:_localXmlPath ofType:@"html"];
//            }
//            [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];

            //加载本地的html文件
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            NSString *filePath = [resourcePath stringByAppendingPathComponent:_localXmlPath];
            //以utf8的编码格式加载html内容
            NSString *htmlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            //self.wbProblems.scalesPageToFit = YES;
            //将文字内容显示到webview控件上
            [_myWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            [htmlString release];
        }
    }
    else{
        if ((![_urlString hasPrefix:@"http://"]) && (![_urlString hasPrefix:@"https://"])) {
            if (![_urlString hasPrefix:@"/"]) {
                [_urlString setString:[NSString stringWithFormat:@"/%@", _urlString]];
            }
            [_urlString setString:[NSString stringWithFormat:@"%@%@", k_EXTERN_ENDPOINT_SERVER_URL, _urlString]];
        }
        NSString *encodedString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL * reqUrl = [NSURL URLWithString:encodedString];
        
        // 定义 cookie 要设定的 host
        NSURL *cookieHost = [NSURL URLWithString:k_EXTERN_ENDPOINT_SERVER_URL];
        
        NSString *ssid = [UserManager sharedInstance].ss.ssid;
        NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
        NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
        
        NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                        k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                        ssid, NSHTTPCookieValue,
                                        [cookieHost path], NSHTTPCookiePath,
                                        [cookieHost host], NSHTTPCookieDomain,
                                        nil];
        NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookiessid];
        
        NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                         k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                         ssid_check, NSHTTPCookieValue,
                                         [cookieHost path], NSHTTPCookiePath,
                                         [cookieHost host], NSHTTPCookieDomain,
                                         nil];
        NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookiecheck];
        
        NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                          k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
                                          ssid_verify, NSHTTPCookieValue,
                                          [cookieHost path], NSHTTPCookiePath,
                                          [cookieHost host], NSHTTPCookieDomain,
                                          nil];
        NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieverify];
        
//        // 设定 cookie
//        for (NSHTTPCookie * cookie in [[UserManager sharedInstance] getRequestCookies:nil flag:YES]) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            NSLog(@"cookie%@", cookie);
//        }
        [_myWebView loadRequest:[NSURLRequest requestWithURL:reqUrl]];
    }
    
    [self.contentView addSubview:_myWebView];
    
    if (_isNavBarHidden) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10, 30, 35, 35)];
        [backButton setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.6]];
        [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.view addSubview:backButton];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        backButton.layer.cornerRadius = backButton.frame.size.height/2.0;
        backButton.layer.masksToBounds = YES;
        
        UIImageView * imgViewtmp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backButton.frame.size.height, backButton.frame.size.height)];
        imgViewtmp.contentMode = UIViewContentModeCenter;
        if (_isPush) {
            imgViewtmp.image = [UIImage imageNamed:@"arrows_big_white_small"];
        }
        else{
            imgViewtmp.image = [UIImage imageNamed:@"arrows_big_white_small"];
        }
        [backButton addSubview:imgViewtmp];
        [imgViewtmp release];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideTabBar:YES animation:YES];
    self.navigationController.navigationBarHidden = _isNavBarHidden;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = _fatherNavBarHiddenStatus;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.myWebView stopLoading];
    [[LoadingView shared] hideLoading];
    
    ///sss
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender{
    [self.myWebView stopLoading];
    [[LoadingView shared] hideLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //sss
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [LoadingView shared].isFullScreen = NO;
    [[LoadingView shared] showLoading:nil message:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([NSString isEmptyString:_myTitle]) {
        self.title = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    else{
        self.title = _myTitle;
    }
    [[LoadingView shared] hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[LoadingView shared] hideLoading];
}

@end
