//
//  FMUIWebViewBridge.h
//  qmap
//
//  Created by 石头人6号机 on 15/5/20.
//
//

#ifndef qmap_FMUIWebViewBridge_h
#define qmap_FMUIWebViewBridge_h

#import "Foundation/Foundation.h"
#import "CoreLocation/CoreLocation.h"
#import "UIKit/UIKit.h"
#import "FMLayerWebView.h"

@interface FMUIWebViewBridge : NSObject<UIWebViewDelegate,UIAlertViewDelegate> {
    
    FMLayerWebView * mLayerWebView;
    
    UIView *mView;
    
    UIWebView *mWebView;
    
    UIToolbar *mToolbar;
    
    UIBarButtonItem *mBackButton;
    UIButton *baseBackBtn;
    
    UIActivityIndicatorView *activityIndicatorView;
}

-(void) setLayerWebView : (FMLayerWebView*) iLayerWebView URLString:(const char*) urlString;

-(void) backClicked:(id)sender;

@end

#endif
