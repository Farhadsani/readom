//
//  OrderScanResultViewController.m
//  citystate
//
//  Created by hf on 15/11/19.
//
//

#import "OrderScanResultViewController.h"

@interface OrderScanResultViewController ()

@end

@implementation OrderScanResultViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView.backgroundColor = k_defaultViewControllerBGColor;
    
    UILabel *label1 = [[UILabel alloc] init];
    [self.contentView addSubview:label1];
    label1.textColor = lightgray_color;
    label1.backgroundColor = [UIColor clearColor];
    [label1 setFont:[UIFont fontWithName:k_fontName_FZZY size:18]];
    label1.text = @"特卖券已成功结算";
    label1.frame = CGRectMake(0, self.contentView.height * 0.5 - 44 - 30, self.contentView.width, 30);
    label1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc] init];
    [self.contentView addSubview:label2];
    label2.textColor = lightgray_color;
    label2.backgroundColor = [UIColor clearColor];
    [label2 setFont:[UIFont fontWithName:k_fontName_FZZY size:18]];
    label2.text = [NSString stringWithFormat:@"结算金额：￥%@", self.totalPrice];
    label2.frame = CGRectMake(0, self.contentView.height * 0.5 - 44, self.contentView.width, 30);
    label2.textAlignment = NSTextAlignmentCenter;
}
@end
