//
//  TitleBar.h
//  TitleBarDemo
//
//  Created by 石头人6号机 on 15/9/24.
//  Copyright (c) 2015年 石头人6号机. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TitleBar;

@protocol TitleBarDelegate <NSObject>

@optional
- (BOOL)titleBar:(TitleBar *)titleBar titleBtnWillOnClick:(NSInteger)index;

@required
- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index;

@end

@interface TitleBar : UIView
/**
 *  创建一个TitleBar
 *
 *  @param titles    标题字符串数组
 *  @param showCount 需要显示的标题个数
 */
+ (instancetype)titleBarWithTitles:(NSArray *)titles andShowCount:(NSInteger)showCount;
@property (nonatomic, weak) id<TitleBarDelegate> delegate;
@end
