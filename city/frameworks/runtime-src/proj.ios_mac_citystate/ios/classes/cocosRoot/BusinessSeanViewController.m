//
//  BusinessSeanViewController.m
//  citystate
//
//  Created by 小生 on 15/11/11.
//
//

#import "BusinessSeanViewController.h"
#import "OrderScanResultViewController.h"

@interface BusinessSeanViewController ()
@property (nonatomic, weak) UITextField *field;
@end

@implementation BusinessSeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单号";
    [self setupRightBackButtonItem:@"提交" img:nil del:self sel:@selector(submitRightButtonItem:)];
    [self stupMainView];
}

- (void)submitRightButtonItem:(id)sender{
    
    NSString *code = self.field.text;
    if (code.length == 0) {
        return ;
    }
    
    NSDictionary * params = @{@"promocode":@([code integerValue])
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_proimid_check,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mainView
- (void)stupMainView{
    UIView * bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 10, self.contentView.width,50);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    bgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bgView];
    
    UITextField * field = [[UITextField alloc]init];
    field.frame = CGRectMake(10, 5 , self.contentView.width -10, 40);
    field.placeholder = @"请输入订单号";
    field.textColor = [UIColor color:k_defaultTextColor];
    field.font = [UIFont fontWithName:k_defaultFontName size:15];
    field.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:field];
    self.field = field;
}


- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
 if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_proimid_check]) {
        [self pushProimidScanResult:[result objectOutForKey:@"res"]];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_proimid_check]) {
        NSLog(@"error......");
    }
}

- (void)pushProimidScanResult:(NSDictionary *)info{
    OrderScanResultViewController * vc = [[OrderScanResultViewController alloc]init];
    vc.title = @"特卖劵";
    vc.totalPrice = info[@"price"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
