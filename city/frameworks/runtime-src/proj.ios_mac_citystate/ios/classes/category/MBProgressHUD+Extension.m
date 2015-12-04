//
//  MBProgressHUD+Extension.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)
static MBProgressHUD *_hub;

+ (void)initialize
{
    _hub = [[MBProgressHUD alloc] init];
    _hub.mode = MBProgressHUDModeText;
    _hub.removeFromSuperViewOnHide = YES;
}

+ (void)showHud:(NSString *)text view:(UIView *)view time:(NSTimeInterval)time offset:(CGFloat)offset
{
    _hub.labelText = text;
    [view addSubview:_hub];
    _hub.yOffset = offset;
    _hub.opacity = 0.7;
    [_hub show:YES];
    if (time >= 0) {
        [_hub hide:YES afterDelay:time];
    }
}

+ (void)showTopHud:(NSString *)text aboveView:(UIView *)view withTime:(NSTimeInterval)time
{
    [self showHud:text view:view time:time offset:-180.0f];
}

+ (void)showMidHud:(NSString *)text aboveView:(UIView *)view withTime:(NSTimeInterval)time
{
    [self showHud:text view:view time:time offset:0];
}

+ (void)showBotHud:(NSString *)text aboveView:(UIView *)view withTime:(NSTimeInterval)time
{
    [self showHud:text view:view time:time offset:180.0f];
}

+ (void)hideHud
{
    [_hub hide:YES];
}
@end
