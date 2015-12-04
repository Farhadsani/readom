//
//  MyStoreGoodsEditNameRuleViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/2.
//
//

#import "MyStoreGoodsEditNameRuleViewController.h"

@interface MyStoreGoodsEditNameRuleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation MyStoreGoodsEditNameRuleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightBackButtonItem:@"保存" img:nil del:self sel:@selector(clickRightItem:)];
    
    self.textView.text = self.defaultValue;
    [self.view bringSubviewToFront:self.textView];
    CALayer *layer = self.textView.layer;
    layer.borderColor = lightgray_color.CGColor;
    layer.borderWidth = 0.6;
    self.textView.font = [UIFont fontWithName:k_fontName_FZZY size:14];
    self.textView.textColor = gray_color;
}

- (void)clickRightItem:(id)sender
{
    NSString *text = self.textView.text;
    if (text.length == 0) {
        [self showMessageView:@"请填写内容!"  delayTime:3.0];
        return;
    }
    if (self.changeValue) {
        self.changeValue(text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
