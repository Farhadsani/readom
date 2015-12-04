//
//  MoreConsumeExponentCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/10.
//
//

#import "MoreConsumeExponentCell.h"

#define ButtonH 46
#define ButtonW ([UIScreen mainScreen].bounds.size.width / 4)

@implementation MoreConsumeExponentCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer *layer = self.layer;
        layer.borderColor = lightgray_color.CGColor;
        layer.borderWidth = 0.3;
    }
    return self;
}

- (void)setConsumeExponentItem:(NSArray *)consumeExponentItem
{
    _consumeExponentItem = consumeExponentItem;
    
    for (NSInteger i = 0; i < consumeExponentItem.count; i++) {
        ExponentItem *exponentItem = _consumeExponentItem[i];
        ConsumeExponentButton *btn = [[ConsumeExponentButton alloc] init];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake((i % 4) * ButtonW, (i / 4) * ButtonH, ButtonW, ButtonH);
        [btn setItem:exponentItem];
        [btn addTarget:self action:@selector(btnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    NSInteger count = (self.consumeExponentItem.count + 3) / 4;
//    if (count != 0) {
//        for (NSInteger i = 0; i <= count; i++) {
//            UIView *lineView = [[UIView alloc] init];
//            lineView.backgroundColor = [UIColor blackColor];
//            lineView.alpha = 0.3;
//            lineView.frame = CGRectMake(0, ButtonH * i, [UIScreen mainScreen].bounds.size.width, 0.3);
//            [self.contentView addSubview:lineView];
//        }
//    }
//    
//    if (count != 0) {
//        for (NSInteger i = 1; i < 4; i++) {
//            UIView *centerLineView = [[UIView alloc] init];
//            centerLineView.backgroundColor = [UIColor blackColor];
//            centerLineView.alpha = 0.3;
//            centerLineView.frame = CGRectMake(i * ButtonW, 0, 0.3, ButtonH * count);
//            [self.contentView addSubview:centerLineView];
//        }
//    }
}

- (CGFloat)cellHeight
{
    NSInteger count = (self.consumeExponentItem.count + 3) / 4;
    return ButtonH * count;
}

- (void)btnDidOnClick:(ConsumeExponentButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(moreConsumeExponentCell:btnDidOnClick:)]) {
        [self.delegate moreConsumeExponentCell:self btnDidOnClick:btn];
    }
}
@end
