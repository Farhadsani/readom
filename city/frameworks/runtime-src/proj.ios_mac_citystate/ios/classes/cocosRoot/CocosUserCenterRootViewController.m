//
//  CocosUserCenterRootViewController.m
//  citystate
//
//  Created by hf on 15/10/8.
//
//

#import "CocosUserCenterRootViewController.h"
#import "UserBarcodeViewController.h"
#import "OrdersViewController.h"

@interface CocosUserCenterRootViewController ()

@end

@implementation CocosUserCenterRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavBar];
    [self setupLeftBackButtonItem:nil img:@"barcode_black" action:@selector(clickLeftItem:)];
    [self setupRightBackButtonItem:nil img:@"wallet_black" del:self sel:@selector(clickRightItem:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setCocosResume];  //
    
    
    if (![self.view.subviews containsObject:[CocosManager shared].cocosView]) {
        [self backUserHome:0];
        [[CocosManager shared] addCocosUserCenterView:self];
    }
}

- (void)setNavBar{
    [self setupLeftButton:@"二维码" leftImg:nil leftSEL:@selector(clickLeftItem:) navTitle:@"我的" rightButton:@"订单" rightImg:nil rightSEL:@selector(clickRightItem:)];
}

- (void)clickLeftItem:(id)sender{
    UserBarcodeViewController * vc = [[[UserBarcodeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.title = @"我的二维码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickRightItem:(id)sender{
    if ([[UserManager sharedInstance] hasLogin]) {
        [self jumpToOrdersVC];
    }
    else{
        [[UserManager sharedInstance] tryCheckLogin:self delegate:nil info:nil CallBack:^(int ret) {
            [self jumpToOrdersVC];
        }];
    }
}

- (void)jumpToOrdersVC{
    OrdersViewController * vc = [[[OrdersViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.title = @"订单";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didLoginSuccessInLoginVC:(NSDictionary *)result{
    InfoLog(@"");
    [self jumpToOrdersVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
