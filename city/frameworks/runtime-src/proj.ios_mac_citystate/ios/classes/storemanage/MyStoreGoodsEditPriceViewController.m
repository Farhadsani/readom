//
//  MyStoreGoodsEditPriceViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/2.
//
//

#import "MyStoreGoodsEditPriceViewController.h"

#define MyStoreGoodsEditPriceViewFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface MyStoreGoodsEditPriceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *opriceFeild;
@property (weak, nonatomic) IBOutlet UITextField *priceFeild;
@end

@implementation MyStoreGoodsEditPriceViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view sendSubviewToBack:self.contentView];
    self.opriceFeild.font = MyStoreGoodsEditPriceViewFont;
    self.opriceFeild.textColor = gray_color;
    self.opriceFeild.text =self.storeGoodsDetail.oprice;
    self.priceFeild.font = MyStoreGoodsEditPriceViewFont;
    self.priceFeild.textColor = gray_color;
    self.priceFeild.text = self.storeGoodsDetail.price;
    
    [self setupRightBackButtonItem:@"保存" img:nil del:self sel:@selector(clickRightItem:)];
}

- (void)clickRightItem:(id)sender
{
    if (self.opriceFeild.text.length == 0 || self.priceFeild.text.length == 0) {
        [self showMessageView:@"请填写价格!"  delayTime:3.0];
    } else {
        self.storeGoodsDetail.price = self.priceFeild.text;
        self.storeGoodsDetail.oprice =self.opriceFeild.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
