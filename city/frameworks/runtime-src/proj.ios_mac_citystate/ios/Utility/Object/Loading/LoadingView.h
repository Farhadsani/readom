//
//  LoadingView.h
//  iBeaconMall
//
//  Created by hf on 14-9-10.
//  Copyright (c) 2014年 hf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{
    NSTimer * timer;
}

@property (nonatomic) BOOL isFullScreen;

+ (LoadingView *)shared;

//修改提示语
- (void)setShowingMessage:(NSString *)msg;

- (void)showLoading:(NSString *) type message:(NSString *)msg;

- (void)hideLoading;

@end
