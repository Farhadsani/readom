//
//  BuddyStatusNoteThumbViewCell.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "BuddyStatusNoteThumbViewCell.h"
#import "UIImageView+WebCache.h"

@interface BuddyStatusNoteThumbViewCell ()
@property (nonatomic, strong) UIImage *placeholderImage;
@end

@implementation BuddyStatusNoteThumbViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        CALayer *imageLayer = imageView.layer;
        imageLayer.cornerRadius = 3;
        imageLayer.masksToBounds = YES;
        imageLayer.borderWidth = 1.0;
        imageLayer.borderColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        CGSize imageSize = self.imageView.frame.size;
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor grayColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        _placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _placeholderImage;
}

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath
{
    static NSString *ID = BuddyStatusNoteThumbViewCell_ID;
    BuddyStatusNoteThumbViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.placeholderImage];
}

- (void)setSelect:(BOOL)select
{
    if (select) {
        self.imageView.layer.borderColor = [UIColor color:green_color].CGColor;
    } else {
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
@end
