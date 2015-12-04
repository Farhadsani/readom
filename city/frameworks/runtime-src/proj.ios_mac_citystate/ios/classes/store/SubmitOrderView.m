//
//  SubmitOrderView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/16.
//
//

#import "SubmitOrderView.h"

#define SubmitOrderViewFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface SubmitOrderView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *goodsCountField;
@property (weak, nonatomic) IBOutlet UIButton *delCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *goPayBtn;
@end

@implementation SubmitOrderView
+ (instancetype)submitOrderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SubmitOrderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [self.goodsCountField addTarget:self action:@selector(goodsCountFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.goodsNameLabel.font = SubmitOrderViewFont;
    self.goodsNameLabel.textColor = gray_color;
    
    self.goodsPriceLabel.font = SubmitOrderViewFont;
    self.goodsPriceLabel.textColor = yello_color;

    self.countTitleLabel.font = SubmitOrderViewFont;
    self.countTitleLabel.textColor = gray_color;

    self.goodsCountField.font = SubmitOrderViewFont;
    self.goodsCountField.textColor = darkGary_color;

    self.totalPriceTitleLabel.font = SubmitOrderViewFont;
    self.totalPriceTitleLabel.textColor = gray_color;

    self.totalPriceLabel.font = SubmitOrderViewFont;
    self.totalPriceLabel.textColor = darkRed_color;

    self.phoneTitleLabel.font = SubmitOrderViewFont;
    self.phoneTitleLabel.textColor = darkGary_color;

    self.phoneLabel.font = SubmitOrderViewFont;
    self.phoneLabel.textColor = darkGary_color;
    self.phoneLabel.text = [UserManager sharedInstance].base.phone;
    
    self.bindPhoneBtn.titleLabel.font = SubmitOrderViewFont;
    [self.bindPhoneBtn setTitleColor:darkGary_color forState:UIControlStateNormal];
    
    self.goPayBtn.titleLabel.font = SubmitOrderViewFont;
    [self.goPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)delCountBtnDidOnClick:(UIButton *)sender
{
    self.goodsCountField.text = [NSString stringWithFormat:@"%d", [self.goodsCountField.text intValue] - 1];
    [self goodsCountCheck];
}

- (IBAction)addCountBtnDidOnClick:(UIButton *)sender
{
    self.goodsCountField.text = [NSString stringWithFormat:@"%d", [self.goodsCountField.text intValue] + 1];
    [self goodsCountCheck];
}

- (IBAction)bindPhoneBtnDidOnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(submitOrderView:bindPhoneBtnDidOnClick:)]) {
        [self.delegate submitOrderView:self bindPhoneBtnDidOnClick:sender];
    }
}

- (IBAction)goPayBtnDidOnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(submitOrderView:goPayBtnDidOnClick:)]) {
        [self.delegate submitOrderView:self goPayBtnDidOnClick:sender];
    }
}

- (void)goodsCountFieldChanged:(UITextField *)textField
{
    [self goodsCountCheck];
}

- (void)setGoodsOrder:(GoodsOrder *)goodsOrder
{
    _goodsOrder = goodsOrder;
    
    self.goodsNameLabel.text = goodsOrder.name;
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"%@元", goodsOrder.price];
    self.goodsCountField.text = @"1";
    self.phoneLabel.text = [goodsOrder.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

    
    [self goodsCountCheck];
}

/**
 *  数量校验
 */
- (void)goodsCountCheck
{
    if ([self.goodsCountField.text intValue] <= 1) {
        self.goodsCountField.text = @"1";
        self.goodsOrder.count = 1;
        self.delCountBtn.enabled = NO;
    } else {
        self.goodsOrder.count = [self.goodsCountField.text intValue];
        self.delCountBtn.enabled = YES;
    }
    
    CGFloat totalPrice = [self.goodsOrder.price floatValue] * [self.goodsCountField.text intValue];
    NSString *totalPriceStr = [NSString stringWithFormat:@"￥%.2f", totalPrice];
    self.totalPriceLabel.text = totalPriceStr;
    self.goodsOrder.totalPrice = totalPriceStr;
}
@end
