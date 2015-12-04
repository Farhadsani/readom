//
//  StoreSectionView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreSectionView.h"

@interface StoreSectionView ()
@property (nonatomic, weak) UIView *lineView1;
@property (nonatomic, weak) UIView *lineView2;
@property (nonatomic, weak) UITextField *titleField;
@end

@implementation StoreSectionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UITextField *titleField = [[UITextField alloc] init];
        self.titleField = titleField;
        [self addSubview:titleField];
        titleField.enabled = NO;
        titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        titleField.font = [UIFont fontWithName:k_fontName_FZZY size:13];
        titleField.textColor = gray_color;
        titleField.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView1 = [[UIView alloc] init];
        [self addSubview:lineView1];
        self.lineView1 = lineView1;
        lineView1.backgroundColor = k_defaultLineColor;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self addSubview:lineView2];
        self.lineView2 = lineView2;
        lineView2.backgroundColor = k_defaultLineColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView1.frame = CGRectMake(0, 0, self.width, 0.6);
    self.lineView2.frame = CGRectMake(0, self.height * 0.45, self.width, 0.4);
    self.titleField.frame = CGRectMake(0, self.height * 0.45, self.width, self.height * 0.55);
}

- (void)setString:(NSString *)string
{
    _string = [string copy];
    
    self.titleField.text = _string;
}
@end
