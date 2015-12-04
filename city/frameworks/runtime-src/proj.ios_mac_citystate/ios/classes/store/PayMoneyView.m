//
//  PayMoneyView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import "PayMoneyView.h"

#define PayMoneyViewFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface PayMoneyView ()
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;
@end

@implementation PayMoneyView
+ (instancetype)payMoneyView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PayMoneyView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.moneyCountLabel.font = PayMoneyViewFont;
    self.moneyCountLabel.textColor = darkRed_color;
    
    [self.zhifubaoPayBtn setTitleColor:darkGary_color forState:UIControlStateNormal];
    self.zhifubaoPayBtn.titleLabel.font = PayMoneyViewFont;
    
    [self.weixinPayBtn setTitleColor:darkGary_color forState:UIControlStateNormal];
    self.weixinPayBtn.titleLabel.font = PayMoneyViewFont;
}

- (void)setGoodsOrder:(GoodsOrder *)goodsOrder
{
    _goodsOrder = goodsOrder;
    
    self.moneyCountLabel.text = [NSString stringWithFormat:@"需要支付:￥%@", goodsOrder.totalPrice];
    self.moneyCountLabel.text = [self.moneyCountLabel.text stringByReplacingOccurrencesOfString:@"￥￥" withString:@"￥"];
    self.moneyCountLabel.text = [self.moneyCountLabel.text stringByReplacingOccurrencesOfString:@"¥¥" withString:@"￥"];
    self.moneyCountLabel.text = [self.moneyCountLabel.text stringByReplacingOccurrencesOfString:@"¥ ¥" withString:@"￥"];
}

- (IBAction)zhifubaoPayBtnDidOnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(payMoneyView:zhifubaoPayBtnDidOnClick:)]) {
        [self.delegate payMoneyView:self zhifubaoPayBtnDidOnClick:sender];
    }
}

- (IBAction)weixinPayBtnDidOnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(payMoneyView:weixinPayBtnDidOnClick:)]) {
        [self.delegate payMoneyView:self weixinPayBtnDidOnClick:sender];
    }
}
@end
