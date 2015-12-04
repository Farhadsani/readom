//
//  MessageView.m
//  qmap
//
//  Created by 石头人6号机 on 15/9/8.
//
//

#import "MessageView.h"

@implementation MessageView
static UIView *_contentView;

+ (void)showMessageView:(NSString *)msg delayTime:(NSTimeInterval)time
{
    [_contentView removeFromSuperview];
    
    CGFloat msgWidth = [msg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}].width;
    NSInteger lines = 1;    
    if (msgWidth > (kScreenWidth-40)) {
        msgWidth = kScreenWidth-40;
        lines = [NSString numberOfLineWithText:msg font:[UIFont systemFontOfSize:15.0] superWidth:(kScreenWidth-40-10) breakLineChar:nil];
    } else {
        msgWidth += 40;
    }
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, msgWidth, (lines>1)?lines*20:40)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5.0;
    _contentView.center = CGPointMake(APPLICATION.window.center.x, APPLICATION.window.center.y-130);
    _contentView.clipsToBounds = YES;
    _contentView.userInteractionEnabled = NO;
    _contentView.layer.borderColor = rgb(185, 164, 143).CGColor;
    _contentView.layer.borderWidth = 0.5;
    [APPLICATION.window addSubview:_contentView];

    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _contentView.frame.size.width-10, _contentView.frame.size.height)];
    lab.text = msg;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14.0];
    lab.textColor = rgb(185, 164, 143);
    lab.numberOfLines = lines;
    [_contentView addSubview:lab];
    
    [self performSelector:@selector(hiddenMessageView) withObject:nil afterDelay:time];
}

+ (void)showMessageView:(NSString *)msg
{
    [self showMessageView:msg delayTime:1.0];
}

+ (void)hiddenMessageView
{
    [UIView animateWithDuration:0.4f animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_contentView removeFromSuperview];
            _contentView = nil;
        }
    }];
}
@end
