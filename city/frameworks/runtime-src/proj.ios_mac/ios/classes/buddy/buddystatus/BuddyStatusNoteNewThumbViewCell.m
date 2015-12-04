//
//  BuddyStatusNoteNewThumbViewCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/9/18.
//
//

#import "BuddyStatusNoteNewThumbViewCell.h"
#import "UIImageView+WebCache.h"

@interface BuddyStatusNoteNewThumbViewCell ()
@property (nonatomic, strong) UIImage *placeholderImage;
@end

@implementation BuddyStatusNoteNewThumbViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
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
    static NSString *ID = BuddyStatusNoteNewThumbViewCell_ID;
    BuddyStatusNoteNewThumbViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.placeholderImage];
}
@end
