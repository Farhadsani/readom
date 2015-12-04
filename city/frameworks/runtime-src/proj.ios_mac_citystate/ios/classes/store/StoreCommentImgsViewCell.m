//
//  StoreCommentImgsViewCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreCommentImgsViewCell.h"
#import "UIImageView+WebCache.h"

@interface StoreCommentImgsViewCell ()
@property (nonatomic, strong) UIImage *placeholderImage;
@end

@implementation StoreCommentImgsViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        CALayer *layer = imageView.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 5;
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

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.placeholderImage];
}
@end
