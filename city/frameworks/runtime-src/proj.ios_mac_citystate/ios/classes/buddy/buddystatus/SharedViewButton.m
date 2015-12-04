//
//  SharedViewButton.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/12.
//
//

#import "SharedViewButton.h"

@implementation SharedViewButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin = CGPointMake((self.width - self.imageView.width) * 0.5, 0);
    self.imageView.frame = imageViewFrame;
    
    CGRect titleLabelFrame = self.titleLabel.frame;
    titleLabelFrame.size = CGSizeMake(self.width, self.height - self.imageView.height);
    titleLabelFrame.origin = CGPointMake(0, self.imageView.height);
    self.titleLabel.frame = titleLabelFrame;
}
@end
