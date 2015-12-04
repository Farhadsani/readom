//
//  ConsumeExponentButton.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/3.
//
//

#import "ConsumeExponentButton.h"

@interface ConsumeExponentButton ()
@property (nonatomic, weak) UIImageView *iv;
@end

@implementation ConsumeExponentButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CALayer *layer = self.layer;
        layer.borderColor = lightgray_color.CGColor;
        layer.borderWidth = 0.3;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"consumeexponent_sel"]];
        self.iv = iv;
        [self addSubview:iv];
        iv.hidden = YES;
        
        self.titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
        [self setTitleColor:k_defaultTextColor forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iv.frame = CGRectMake(self.width - self.iv.width - 4, 4, self.iv.width, self.iv.height);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.iv.hidden = !selected;
}

- (void)setItem:(ExponentItem *)item
{
    _item = item;
    [self setTitle:item.cname forState:UIControlStateNormal];
}
@end
