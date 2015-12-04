//
//  MBProgressHUD+Extension.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)
+ (void)showTopHud:(NSString *)text aboveView:(UIView *)view withTime:(NSTimeInterval)time;
+ (void)showMidHud:(NSString *)text aboveView:(UIView *)view withTime:(NSTimeInterval)time;
+ (void)showBotHud:(NSString *)text aboveView:(UIView *)view withTime:(NSTimeInterval)time;
+ (void)hideHud;
@end
