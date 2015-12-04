//
//  StoreBindNewPhoneNumberViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import "StoreBindNewPhoneNumberViewController.h"
#import "BindNewPhoneNumberView.h"

@interface StoreBindNewPhoneNumberViewController () <BindNewPhoneNumberViewDelegate>

@end

@implementation StoreBindNewPhoneNumberViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"绑定新号";
    
    BindNewPhoneNumberView *bindNewPhoneNumberView = [BindNewPhoneNumberView bindNewPhoneNumberView];
    CGRect frame = bindNewPhoneNumberView.frame;
    frame.size = CGSizeMake(self.contentView.width, 200);
    bindNewPhoneNumberView.frame = frame;
    [self.contentView addSubview:bindNewPhoneNumberView];
    bindNewPhoneNumberView.delegate = self;
}

#pragma mark - BindNewPhoneNumberViewDelegate
- (void)bindNewPhoneNumberView:(BindNewPhoneNumberView *)view withSuccessPhoneNumber:(NSString *)phone
{
//    [self showMessageView:@"绑定新号成功！" delayTime:3.0];
    [[ExceptionEngine shared] alertTitle:[NSString stringWithFormat:@"已成功绑定新号：%@", phone] message:nil delegate:nil tag:-1 cancelBtn:@"确定" btn1:nil btn2:nil];
    if (self.backBlk) {
        self.backBlk(phone);
    }
}
@end
