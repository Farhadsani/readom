//
//  StoreNoCommentView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/19.
//
//

#import "StoreNoCommentView.h"

@interface StoreNoCommentView ()
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation StoreNoCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UITextField *textField = [[UITextField alloc] init];
        [self addSubview:textField];
        self.textField = textField;
        textField.text = @"暂无评论";
        textField.font = [UIFont fontWithName:k_fontName_FZZY size:17];
        textField.textColor = gray_color;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.enabled = NO;
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        self.lineView = lineView;
        lineView.backgroundColor = k_defaultLineColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textField.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.height - 0.6, self.width, 0.6);
}
@end
