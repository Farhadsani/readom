//
//  FMUIWebViewBridge.m
//  qmap
//
//  Created by 石头人6号机 on 15/5/20.
//
//

#import "FMUIWebViewBridge.h"

#import "platform/ios/CCEAGLView-ios.h"

@implementation FMUIWebViewBridge

- (id)init{
    
    self = [super init];
    
    if (self) {
        
        // init code here.
        
    }
    
    return self;
    
}

- (void)dealloc{
    
    [baseBackBtn release];
    [mBackButton release];
    
    
    [mToolbar release];
    
    [mWebView release];
    
    [mView release];
    
    [super dealloc];
    
}


-(void) setLayerWebView : (FMLayerWebView*) iLayerWebView URLString:(const char*) urlString{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    mLayerWebView = iLayerWebView;
    
    cocos2d::Size size = mLayerWebView->getContentSize();
    
    mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width , size.height)];
    [mView setBackgroundColor:[UIColor blackColor]];
//    mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 , 200)];

    
    // create webView
    
    //Bottom size
    
//    int wBottomMargin = size.height*0.10;
    
//    int wWebViewHeight = size.height - wBottomMargin;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect barRect = [[UIApplication sharedApplication] statusBarFrame];
    
    int toolBarHeight = 60;
    
//    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, wWebViewHeight)];
//    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, 415, 640)];
    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,toolBarHeight,applicationFrame.size.width, applicationFrame.size.height-toolBarHeight +barRect.size.height)];
//    [mWebView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    mWebView.delegate = self;
    
    NSString *urlBase = [NSString stringWithCString:urlString encoding:NSUTF8StringEncoding];
    
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlBase ]]];
    
    [mWebView setUserInteractionEnabled:NO]; //don't let the user scroll while things are
    
    //create a tool bar for the bottom of the screen to hold the back button
    
    mToolbar = [UIToolbar new];
    
//    [mToolbar setFrame:CGRectMake(0, wWebViewHeight, size.width, wBottomMargin)];
    [mToolbar setFrame:CGRectMake(0, 20, size.width, toolBarHeight-20)];
    
    mToolbar.barStyle = UIBarStyleBlackOpaque;
//    [mToolbar setBackgroundColor:[UIColor whiteColor]];
    [mToolbar setBarTintColor:[UIColor whiteColor]];
    
    //Create a button
    
//    mBackButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"webBack.png"]
//                                                style: UIBarButtonItemStylePlain
//                                                  target: self
//                                                  action:@selector(backClicked:)];
    
    baseBackBtn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, toolBarHeight-25)];
    [baseBackBtn setTitle:@"" forState:UIControlStateNormal];
//    [baseBackBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-5,0,0)];
//    [baseBackBtn setTitleColor:UIColorFromRGB(0x7F7F7F, 1.0f) forState:UIControlStateNormal];
    [baseBackBtn setImage:[UIImage imageNamed:@"webBack.png"] forState:UIControlStateNormal];
    [baseBackBtn setImageEdgeInsets:UIEdgeInsetsMake(5,-10,5,0)];
    [baseBackBtn addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    mBackButton = [[UIBarButtonItem alloc] initWithCustomView:baseBackBtn];
    
    
    
//    [mBackButton set:CGRectMake(0.0, 0.0, 95.0, 34.0)];
    
    [mToolbar setItems:[NSArray arrayWithObjects:mBackButton,nil] animated:YES];
    
    [mView addSubview:mToolbar];
    
    //[mToolbar release];
    
    // add the webView to the view
    
    [mView addSubview:mWebView];
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: mView.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [mView addSubview : activityIndicatorView] ;

    
    
    cocos2d::GLView *glview = cocos2d::Director::getInstance()->getOpenGLView();
    
    if (glview)
    {
        CCEAGLView *eaglview = (CCEAGLView*) glview->getEAGLView();
        
        if (eaglview)
        {
            [eaglview addSubview:mView];
        }
    }

//    [[CCEAGLView sharedEGLView] addSubview:mView];
    
    }


- (void)webViewDidStartLoad:(UIWebView *)thisWebView {
    [activityIndicatorView startAnimating] ;
}


- (void)webViewDidFinishLoad:(UIWebView *)thisWebView{
    
    [mWebView setUserInteractionEnabled:YES];
    
    mLayerWebView->webViewDidFinishLoad();
    [activityIndicatorView stopAnimating];
}


- (void)webView:(UIWebView *)thisWebView didFailLoadWithError:(NSError *)error {
    
    if ([error code] != -999 && error != NULL) { //error -999 happens when the user clicks on something before it's done loading.
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to load the page. Please keep network connection."
                              
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        
        [alert release];
        
    }
    
}

-(void) backClicked:(id)sender {
    
    mWebView.delegate = nil; //keep the webview from firing off any extra messages
    
    //remove items from the Superview...just to make sure they're gone
    
    [mToolbar removeFromSuperview];
    
    [mWebView removeFromSuperview];
    
    [mView removeFromSuperview];
    
    mLayerWebView->onBackbuttonClick();
    
}

@end