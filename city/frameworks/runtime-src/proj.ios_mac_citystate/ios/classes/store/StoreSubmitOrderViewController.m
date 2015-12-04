//
//  StoreSubmitOrderViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/16.
//
//

#import "StoreSubmitOrderViewController.h"
#import "SubmitOrderView.h"
#import "StorePayMoneyViewController.h"
#import "StoreBindNewPhoneNumberViewController.h"

@interface StoreSubmitOrderViewController () <SubmitOrderViewDelegate>
@property (nonatomic, weak) SubmitOrderView *submitOrderView;
@end

@implementation StoreSubmitOrderViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"提交订单";
    
    SubmitOrderView *submitOrderView = [SubmitOrderView submitOrderView];
    [self.contentView addSubview:submitOrderView];
    self.submitOrderView = submitOrderView;
    CGRect frame = submitOrderView.frame;
    frame.size = CGSizeMake(self.contentView.width, 340);
    submitOrderView.frame = frame;
    submitOrderView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.submitOrderView.goodsOrder = self.goodsOrder;
}

#pragma mark - SubmitOrderViewDelegate
- (void)submitOrderView:(SubmitOrderView *)view bindPhoneBtnDidOnClick:(UIButton *)button
{
    StoreBindNewPhoneNumberViewController *storeBindNewPhoneNumberViewController = [[StoreBindNewPhoneNumberViewController alloc] init];
    storeBindNewPhoneNumberViewController.goodsOrder = self.goodsOrder;
    storeBindNewPhoneNumberViewController.backBlk = ^(NSString *phone) {
        self.goodsOrder.phone = phone;
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:storeBindNewPhoneNumberViewController animated:YES];
}

- (void)submitOrderView:(SubmitOrderView *)view goPayBtnDidOnClick:(UIButton *)button
{
    StorePayMoneyViewController *storePayMoneyViewController = [[StorePayMoneyViewController alloc] init];
    storePayMoneyViewController.goodsOrder = self.goodsOrder;
    [self.navigationController pushViewController:storePayMoneyViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
    if (alertView.tag == -13 && buttonIndex == k_buttonIndex_btn1) {
        [[UserManager sharedInstance] tryCheckLogin:self delegate:nil info:nil CallBack:^(int ret) {

        }];
    }
}
@end
