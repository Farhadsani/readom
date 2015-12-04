//
//  JDGuideViewController.h
//  iBeaconMall
//
//  Created by hf on 14/12/2.
//  Copyright (c) 2014年 hf. All rights reserved.
//

//引导界面

#import <UIKit/UIKit.h>
@protocol GuideVDelegate;

@interface GuideView : UIView<UIScrollViewDelegate>{
    UIScrollView * container;
    
    UIButton * enterButton;
    NSMutableArray * imagesArray;
    
    UIPageControl * pageControl;
    
    UIActivityIndicatorView *indicator;
    
    NSInteger page;
}

@property(nonatomic, assign) id<GuideVDelegate> delegate;

@end

@protocol GuideVDelegate <NSObject>

@optional
//引导结束时回调
- (void)guideViewDidClose;

@end
