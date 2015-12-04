//
//  BuddyStatusNoteNewThumbViewLayout.m
//  qmap
//
//  Created by 石头人6号机 on 15/9/21.
//
//

#import "BuddyStatusNoteNewThumbViewLayout.h"

@implementation BuddyStatusNoteNewThumbViewLayout
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(BuddyStatusNoteNewThumbViewCellW, BuddyStatusNoteNewThumbViewCellH);
    self.minimumLineSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect rect = (CGRect){proposedContentOffset, self.collectionView.frame.size};
    NSArray *array = [self layoutAttributesForElementsInRect:rect];
    CGFloat centerX = proposedContentOffset.x + self.collectionView.center.x;
    CGFloat offset = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array) {
        if (ABS(centerX - attr.center.x) < ABS(offset)) {
            offset = attr.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + offset, proposedContentOffset.y);
}
@end
