//
//  MyStoreViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/29.
//
//

#import "MyStoreViewController.h"
#import "TitleBar.h"
#import "MyStoreGoodsViewController.h"
#import "MyStoreReportViewController.h"

@interface MyStoreViewController () <TitleBarDelegate>
@property (nonatomic, weak) UIView *showingView;
@property (nonatomic, assign) NSInteger showingIndex;
@end

@implementation MyStoreViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的店铺";
    
    TitleBar *titleBar = [TitleBar titleBarWithTitles:@[@"我的特卖", @"我的报表"] andShowCount:2];
    [self.contentView addSubview:titleBar];
    titleBar.frame = CGRectMake(0, 0, self.contentView.width, 40);
    titleBar.delegate = self;
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(titleBar.frame) + 10, self.contentView.width, self.contentView.height - CGRectGetMaxY(titleBar.frame) - 10);
    
    MyStoreGoodsViewController *myStoreGoodsViewController = [[MyStoreGoodsViewController alloc] init];
    myStoreGoodsViewController.userid = self.userid;
    [self addChildViewController:myStoreGoodsViewController];
    [self.contentView addSubview:myStoreGoodsViewController.view];
    myStoreGoodsViewController.view.frame = frame;
    self.showingView = myStoreGoodsViewController.view;
    self.showingIndex = 0;
    
    MyStoreReportViewController *myStoreReportViewController = [[MyStoreReportViewController alloc] init];
    [self addChildViewController:myStoreReportViewController];
    myStoreReportViewController.view.frame = frame;
}

#pragma mark - TitleBarDelegate
- (BOOL)titleBar:(TitleBar *)titleBar titleBtnWillOnClick:(NSInteger)index{
    if (index == 0) {
        return YES;
    }
    else{
        NSString * url = k_web_store_manage_report;
        [self openWebView:url localXml:nil title:@"我的报表" otherInfo:@{@"openType":@"push",@"hidNav":@"NO"}];
        return NO;
    }
}
- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index{
    if (index == 1) {
        NSString * url = k_web_store_manage_report;
        [self openWebView:url localXml:nil title:@"我的报表" otherInfo:@{@"openType":@"push",@"hidNav":@"NO"}];
    }
    else{
        [self.showingView removeFromSuperview];
        [self.contentView addSubview:((UIViewController *)self.childViewControllers[index]).view];
    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}

@end
