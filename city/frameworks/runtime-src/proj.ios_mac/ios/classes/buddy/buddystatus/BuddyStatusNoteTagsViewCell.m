//
//  BuddyStatusNoteTagsViewCell.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "BuddyStatusNoteTagsViewCell.h"
#import "NSString+Extension.h"

#define TagLabelFont [UIFont fontWithName:k_fontName_FZXY size:13]

@interface BuddyStatusNoteTagsViewCell ()
@property (nonatomic, weak) UILabel  *tagLabel;
@end

@implementation BuddyStatusNoteTagsViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *tagLabel = [[UILabel alloc] init];
        self.tagLabel = tagLabel;
        [self addSubview:tagLabel];
        [tagLabel setBackgroundColor:[UIColor clearColor]];
        [tagLabel setFont:TagLabelFont];
        tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath
{
    static NSString *ID = BuddyStatusNoteTagsViewCell_ID;
    BuddyStatusNoteTagsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.tagLabel.text = _text;
    
    // 计算文字大小
    CGFloat Margin = 5;
    CGSize tageLabelSize = [text sizeWithFont:TagLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.tagLabel.frame = CGRectMake(0, 0, tageLabelSize.width + Margin, tageLabelSize.height + Margin);
    
    CGRect frame = self.frame;
    frame.size = self.tagLabel.frame.size;
    self.frame = frame;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    self.tagLabel.textColor = textColor;
    
    CALayer *layer = self.tagLabel.layer;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0;
    layer.borderColor = textColor.CGColor;
}
@end
