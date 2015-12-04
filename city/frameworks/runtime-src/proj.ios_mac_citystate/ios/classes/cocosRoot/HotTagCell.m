//
//  HotTagCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import "HotTagCell.h"
#import "NSString+Extension.h"

#define TagViewFont [UIFont fontWithName:k_fontName_FZZY size:14]

@interface HotTagCell ()
@property (nonatomic, weak) UIButton *tagView;
@end

@implementation HotTagCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *tagView = [[UIButton alloc] init];
        self.tagView = tagView;
        [self addSubview:tagView];
        tagView.titleLabel.font = TagViewFont;
        tagView.adjustsImageWhenHighlighted = NO;
        tagView.userInteractionEnabled = NO;

        [tagView setTitleColor:darkZongSeColor forState:UIControlStateNormal];
        [tagView setTitleColor:yello_color forState:UIControlStateHighlighted];

        tagView.titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:13];
        [tagView addTarget:self action:@selector(btnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setHotTag:(HotTag *)hotTag
{
    _hotTag = hotTag;
    
    [self.tagView setTitle:_hotTag.name forState:UIControlStateNormal];
    
    // 计算文字大小
    CGFloat Margin = 5;
    CGSize tageLabelSize = [_hotTag.name sizeWithFont:TagViewFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if(tageLabelSize.width < 30) {
        tageLabelSize.width = 30;
    }
    self.tagView.frame = CGRectMake(0, 0, tageLabelSize.width + Margin * 2, tageLabelSize.height + Margin);
    
    CGRect frame = self.frame;
    frame.size = self.tagView.frame.size;
    self.frame = frame;
    
    [self.tagView setBackgroundImage: [[UIImage imageNamed:@"hottag_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(self.tagView.height * 0.5, self.tagView.width * 0.5, self.tagView.height * 0.5, self.tagView.width * 0.5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.tagView setBackgroundImage: [[UIImage imageNamed:@"hottag_bg_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(self.tagView.height * 0.5, self.tagView.width * 0.5, self.tagView.height * 0.5, self.tagView.width * 0.5) ] forState:UIControlStateHighlighted];
}
@end
