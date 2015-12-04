//
//  BuddyStatusNotePlaceTagView.m
//  qmap
//
//  Created by 小玛依 on 15/8/25.
//
//

#import "BuddyStatusNotePlaceTagsView.h"

@interface BuddyStatusNotePlaceTagsView ()
@property (nonatomic, weak) UIImageView  *placeIcon;
@end

@implementation BuddyStatusNotePlaceTagsView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *placeIcon = [[UIImageView alloc] init];
        self.placeIcon = placeIcon;
        [self addSubview:placeIcon];
        [placeIcon setImage:[UIImage imageNamed:@"placeIcon.png"]];
        placeIcon.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeIcon.frame = CGRectMake(0, 0, 20, BuddyStatusNoteTagsViewH);

    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UICollectionView class]]) {
            CGRect frame = subView.frame;
            frame.origin.x = 20;
            subView.frame = frame;
        }
    }
}
@end
