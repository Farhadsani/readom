//
//  GuideView.m
//  iBeaconMall
//
//  Created by hf on 14/12/2.
//  Copyright (c) 2014年 hf. All rights reserved.
//

#import "GuideView.h"

@interface GuideView ()

@end

@implementation GuideView

- (void)dealloc{
    [imagesArray release];
    [pageControl release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setupUI];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}
- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}
//- (void)setNeedsStatusBarAppearanceUpdate{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//}

- (void)setupUI{
    container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    container.backgroundColor = [UIColor clearColor];
    container.pagingEnabled = YES;
    container.delegate = self;
    container.showsHorizontalScrollIndicator = NO;
    container.showsVerticalScrollIndicator = NO;
    [self addSubview:container];
    [container release];
    
    imagesArray = [[NSMutableArray alloc] initWithObjects:@"guide1",@"guide2",@"guide3",@"guide4",@"", nil];
    
    int i = 0;
    for (NSString * str in imagesArray) {
//        CGFloat orign_y = 0;
//        if (k_isIphone4s) {
//            orign_y = (568-container.frame.size.height)/2.0;
//        }
//        UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(container.frame.size.width*i, -orign_y, container.frame.size.width, container.frame.size.height+2*orign_y)];
        UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(container.frame.size.width*i, 0, container.frame.size.width, container.frame.size.height)];
        picView.backgroundColor = [UIColor clearColor];
        picView.image = [UIImage imageNamed:str];
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        [container addSubview:picView];
        picView.tag = i;
        picView.userInteractionEnabled = YES;
        
        if (i == 3) {
            enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [enterButton setFrame:CGRectMake(picView.width-120, picView.height-240, 100, 200)];
            [enterButton setTitle:@"" forState:UIControlStateNormal];
            enterButton.backgroundColor = clear_color;
            [picView addSubview:enterButton];
            [enterButton addTarget:self action:@selector(closeV) forControlEvents:UIControlEventTouchUpInside];
        }
        
//        if ([str isEqualToString:[imagesArray lastObject]]) {
//            enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
////            [enterButton setFrame:CGRectMake((picView.frame.size.width-120)/2.0, picView.frame.size.height-50-orign_y, 120, 28)];
//            CGFloat h = (orign_y==0)?35:28;
//            
////            [enterButton setFrame:CGRectMake(picView.frame.size.width-90, picView.frame.size.height-h-10-2*orign_y, 110, h)];
//            [enterButton setFrame:CGRectMake(picView.frame.size.width-90, picView.frame.size.height-h-6-orign_y, 110, h)];
//            [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
//            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [enterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//            enterButton.backgroundColor = yello_color;
//            [enterButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
//            [picView addSubview:enterButton];
//            [enterButton addTarget:self action:@selector(closeV) forControlEvents:UIControlEventTouchUpInside];
//            enterButton.alpha = 0;
//            enterButton.userInteractionEnabled = NO;
//            enterButton.layer.cornerRadius = enterButton.frame.size.height/2.0;
//            enterButton.layer.masksToBounds = YES;
//            
//            UIImageView * logoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(enterButton.frame.size.width-40, 0, 20, enterButton.frame.size.height)];
//            logoImageV.image = [UIImage imageNamed:@"placeOrderArrorIcon"];
//            logoImageV.contentMode = UIViewContentModeCenter;
//            [enterButton addSubview:logoImageV];
//            [logoImageV release];
//            logoImageV.userInteractionEnabled = NO;
//            
//            UIView * vi = [[UIView alloc] initWithFrame:CGRectMake(enterButton.frame.size.width-20, 0, 20, enterButton.frame.size.height)];
//            vi.backgroundColor = [UIColor whiteColor];
//            [enterButton addSubview:vi];
//            [vi release];
//            vi.userInteractionEnabled = NO;
//        }
//        else{
//            UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [nextButton setFrame:CGRectMake(picView.frame.size.width-60, picView.frame.size.height-70, 60, 40)];
//            [nextButton setTitle:@"》》》" forState:UIControlStateNormal];
//            [nextButton setTitleColor:juseColor forState:UIControlStateNormal];
//            nextButton.backgroundColor = [UIColor clearColor];
//            [nextButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
//            [picView addSubview:nextButton];
//            nextButton.tag = i;
//            [nextButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
//        }
        
        [picView release];
        
        i++;
    }
    
//    UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(container.frame.size.width*i, 0, container.frame.size.width, container.frame.size.height)];
//    [container addSubview:picView];
//    picView.tag = i;
//    picView.userInteractionEnabled = YES;
    
    container.contentSize = CGSizeMake([imagesArray count] * container.frame.size.width,container.frame.size.height);
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2.0, kScreenHeight-20, 80, 15)];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 1;
    if ([imagesArray count] > 1) {
        pageControl.numberOfPages = [imagesArray count]-1;
        pageControl.currentPage = 0;
        pageControl.hidesForSinglePage = YES;
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = yello_color;
//        [self addSubview:pageControl];
    }
}

- (void)nextPage:(UIButton *)sender{
    if (sender.tag <= [imagesArray count]-2) {
        [self autoScrollToIndex:sender.tag+1 animation:YES];
    }
}

- (void)autoScrollToIndex:(NSInteger)index animation:(BOOL)hasAnimation{
    [UIView animateWithDuration:(hasAnimation)?0.4:0 animations:^{
        [container setContentOffset:CGPointMake(index * container.frame.size.width, container.contentOffset.y)];
    } completion:^(BOOL finished) {
        if (finished) {
            page = index;
            if (page < [imagesArray count]-1) {
                pageControl.currentPage = page;
            }
            [self showEnterButton];
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    InfoLog(@"width:%f offset:%f", scrollView.contentSize.width, scrollView.contentOffset.x);
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    InfoLog(@"");
    if (scrollView.contentOffset.x >= ([imagesArray count]-2)*kScreenWidth+kScreenWidth/2.0) {
        [self closeV];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    page = (int)floor(ratio);
    InfoLog(@"begin:%d",(int)page);
    if (page < 0) {
        return;
    }
    
//    [self showEnterButton];
    
    if (page < [imagesArray count]-1) {
        pageControl.currentPage = page;
    }
    
    if (page == 4) {
        [self dos];
    }
}

- (void)showEnterButton{
    if (page >= [imagesArray count]-1) {
        [UIView animateWithDuration:0.4 animations:^{
            enterButton.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (finished) {
                enterButton.userInteractionEnabled = YES;
            }
        }];
    }
    else{
        [UIView animateWithDuration:0.4 animations:^{
            enterButton.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                enterButton.userInteractionEnabled = NO;
            }
        }];
    }
}

- (void)closeV{
//    if (!indicator && enterButton && enterButton.alpha == 1) {
//        [enterButton setTitle:@"" forState:UIControlStateNormal];
//        enterButton.userInteractionEnabled = NO;
//        
//        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        indicator.frame = CGRectMake(0, 0, enterButton.frame.size.width, enterButton.frame.size.height);
//        indicator.backgroundColor = [UIColor clearColor];
//        [enterButton addSubview:indicator];
//        [indicator release];
//        [indicator startAnimating];
//    }
    
    [self dos];
}

- (void)dos{
    [self dos2];
    
    if (_delegate && [_delegate respondsToSelector:@selector(guideViewDidClose)]) {
        [_delegate guideViewDidClose];
    }
}

- (void)dos2{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (pageControl) {
        pageControl.hidden = YES;
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
//        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
