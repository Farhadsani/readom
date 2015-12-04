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


+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath*)indexPath
{
    static NSString *ID = BuddyStatusNoteNewThumbViewCell_ID;
    BuddyStatusNoteNewThumbViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"buddystatus_defaultnotenewthumbview"]];
}
@end
