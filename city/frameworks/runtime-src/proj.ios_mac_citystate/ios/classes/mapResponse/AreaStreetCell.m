//
//  AreaStreetCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/23.
//
//

#import "AreaStreetCell.h"
#import "NSString+Extension.h"

#define AreaStreetFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface AreaStreetCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation AreaStreetCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        titleLabel.font = AreaStreetFont;
        [titleLabel setTextColor:darkGary_color];
        titleLabel.backgroundColor = rgb(246,246,246);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        CALayer *layer = titleLabel.layer;
        layer.cornerRadius = 16;
        layer.borderColor = lightgray_color.CGColor;
        layer.borderWidth = 1;
        layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 5;
    self.titleLabel.frame = CGRectMake(margin, margin, self.width - margin * 2, self.height - margin * 2);
}

- (void)setAreaStreetItem:(AreaStreetItem *)areaStreetItem
{
    _areaStreetItem = areaStreetItem;
    
    self.titleLabel.text = areaStreetItem.name;
}
@end
