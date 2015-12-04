//
//  SightDetailIntroCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/20.
//
//

#import "SightDetailIntroCell.h"

#define SightDetailIntroCellSubViewMargin 10
#define SightDetailIntroCellTitleLabelFont [UIFont fontWithName:k_fontName_FZZY size:15]
#define SightDetailIntroCellContentLabelFont [UIFont fontWithName:k_fontName_FZZY size:14]

@interface SightDetailIntroCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@end

@implementation SightDetailIntroCell
+ (instancetype)sightDetailIntroCell
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {        
        UIImageView *iconView = [[UIImageView alloc]init];
        self.iconView = iconView;
        [self addSubview:iconView];
        [iconView setContentMode:UIViewContentModeCenter];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        titleLabel.textColor = darkGary_color;
        titleLabel.font = SightDetailIntroCellTitleLabelFont;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        self.contentLabel = contentLabel;
        [self addSubview:contentLabel];
        contentLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setSightDetailIntroItem:(SightDetailIntroItem *)sightDetailIntroItem
{
    _sightDetailIntroItem = sightDetailIntroItem;
    
    self.iconView.image = [UIImage imageNamed:sightDetailIntroItem.icon];
    self.titleLabel.text = sightDetailIntroItem.desc;
    if (sightDetailIntroItem.content.length > 0) {
        NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
        mParaStyle.lineSpacing = 6.0;
        mParaStyle.alignment = NSTextAlignmentRight;
        NSDictionary *dict  = @{NSFontAttributeName : SightDetailIntroCellContentLabelFont, NSForegroundColorAttributeName:gray_color, NSParagraphStyleAttributeName: mParaStyle};
        NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:sightDetailIntroItem.content attributes:dict];
        self.contentLabel.attributedText = mAttrStr;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = SightDetailIntroCellSubViewMargin;
    CGFloat iconViewWH = 22;
    CGFloat iconViewX = margin * 2;
    CGFloat iconViewY = margin;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    CGFloat titleLabelX = CGRectGetMaxX(self.iconView.frame) + margin;
    CGFloat titleLabelY = iconViewY;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, 80, iconViewWH);
    
    CGFloat contentLabelX = CGRectGetMaxX(self.titleLabel.frame) + margin;
    CGFloat contentLabelMaxW = self.width - CGRectGetMaxX(self.titleLabel.frame) - margin * 2;
    
    CGSize contentLabelSize = [self.contentLabel.attributedText boundingRectWithSize:CGSizeMake(contentLabelMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGFloat contentLabelY = 0;
    if (contentLabelSize.height > iconViewWH) {
        NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
        mParaStyle.lineSpacing = 6.0;
        mParaStyle.alignment = NSTextAlignmentLeft;
        NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentLabel.attributedText];
        [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0, self.contentLabel.text.length - 1)];
        self.contentLabel.attributedText = mAttrStr;
        
        contentLabelY = iconViewY;
    } else {
        contentLabelY = (iconViewWH - contentLabelSize.height) * 0.5 + iconViewY;
    }
    self.contentLabel.frame = CGRectMake(contentLabelX, contentLabelY, contentLabelMaxW, contentLabelSize.height);
    
    CGRect frame = self.frame;
    frame.size.height = MAX(CGRectGetMaxY(self.iconView.frame), CGRectGetMaxY(self.contentLabel.frame)) + margin;
    self.frame = frame;
}
@end
