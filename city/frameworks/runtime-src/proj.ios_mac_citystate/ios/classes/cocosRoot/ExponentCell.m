//
//  ExponentCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/10.
//
//

#import "ExponentCell.h"
#import "UIButton+WebCache.h"

#define IconViewWH 50
#define NameLabelW 90
#define NameLabelH 25

@interface ExponentCell ()
@property (nonatomic, weak) UIButton *iconView;
@property (nonatomic, weak) UILabel *cnNameLabel;
@property (nonatomic, weak) UILabel *enNameLabel;
@end

@implementation ExponentCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *iconView = [[UIButton alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        iconView.userInteractionEnabled = NO;
        
        UILabel *cnNameLabel = [[UILabel alloc] init];
        [self addSubview:cnNameLabel];
        self.cnNameLabel = cnNameLabel;
        cnNameLabel.font = [UIFont fontWithName:k_fontName_FZZY size:16];
        cnNameLabel.textColor = k_defaultTextColor;

        UILabel *enNameLabel = [[UILabel alloc] init];
        [self addSubview:enNameLabel];
        self.enNameLabel = enNameLabel;
        enNameLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
        enNameLabel.textColor = gray_color;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setExponentItem:(ExponentItem *)exponentItem
{
    _exponentItem = exponentItem;
    
    if ([exponentItem.imglink hasPrefix:@"http"]) {
        [self.iconView sd_setBackgroundImageWithURL:[NSURL URLWithString:_exponentItem.imglink] forState:UIControlStateNormal];
        [self.iconView sd_setBackgroundImageWithURL:[NSURL URLWithString:_exponentItem.imglinkhight] forState:UIControlStateHighlighted];
    } else {
        [self.iconView setBackgroundImage:[UIImage imageNamed:_exponentItem.imglink] forState:UIControlStateNormal];
        [self.iconView setBackgroundImage:[UIImage imageNamed:_exponentItem.imglinkhight] forState:UIControlStateHighlighted];
    }
    self.cnNameLabel.text = _exponentItem.cname;
    self.enNameLabel.text = _exponentItem.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconViewX = 30;
    CGFloat iconViewY = (self.frame.size.height - IconViewWH) * 0.5;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, IconViewWH, IconViewWH);
    
    CGFloat margin = 5;
    CGFloat cnNameLabelX = CGRectGetMaxX(self.iconView.frame) + margin;
    CGFloat cnNameLabelY = iconViewY;
    CGFloat cnNameLabelW = NameLabelW;
    CGFloat cnNameLabelH = NameLabelH;
    self.cnNameLabel.frame = CGRectMake(cnNameLabelX, cnNameLabelY, cnNameLabelW, cnNameLabelH);
    
    CGFloat enNameLabelX = cnNameLabelX;
    CGFloat enNameLabelY = cnNameLabelY + NameLabelH;
    CGFloat enNameLabelW = NameLabelW;
    CGFloat enNameLabelH = NameLabelH;
    self.enNameLabel.frame = CGRectMake(enNameLabelX, enNameLabelY, enNameLabelW, enNameLabelH);
}
@end
