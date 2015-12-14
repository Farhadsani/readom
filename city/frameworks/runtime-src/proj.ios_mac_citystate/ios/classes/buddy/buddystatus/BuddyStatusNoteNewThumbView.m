//
//  BuddyStatusNoteNewThumbView.m
//  qmap
//
//  Created by 石头人6号机 on 15/9/18.
//
//

#import "BuddyStatusNoteNewThumbView.h"
#import "BuddyStatusNoteNewThumbViewCell.h"
#import "UIImageView+WebCache.h"
#import "BuddyStatusNoteNewThumbViewLayout.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SDPhotoBrowser.h"

@interface BuddyStatusNoteNewThumbView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *imageIndexLabel;
@end

@implementation BuddyStatusNoteNewThumbView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[BuddyStatusNoteNewThumbViewLayout alloc] init]];
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [collectionView registerClass:[BuddyStatusNoteNewThumbViewCell class] forCellWithReuseIdentifier:BuddyStatusNoteNewThumbViewCell_ID];
        
        UILabel *imageIndexLabel = [[UILabel alloc] init];
        self.imageIndexLabel = imageIndexLabel;
        [self addSubview:imageIndexLabel];
        imageIndexLabel.textColor = lightgray_color;
        imageIndexLabel.font = BuddyStatusCellImageIndexViewFont;
        imageIndexLabel.textAlignment = NSTextAlignmentCenter;
        imageIndexLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setNoteItem:(BuddyStatusNoteItem *)noteItem
{
    _noteItem = noteItem;
    
    self.imageIndexLabel.text = [NSString stringWithFormat:@"1/%ld", _noteItem.imgs.count];
    
    if (_noteItem.tags.count > 0) {
        self.imageIndexLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    } else {
        self.imageIndexLabel.backgroundColor = [UIColor clearColor];
    }
    
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;

    CGFloat imageIndexLabelW = BuddyStatusNoteImageIndexLabelW;
    CGFloat imageIndexLabelH = BuddyStatusNoteImageIndexLabelH;
    CGFloat imageIndexLabelX = CGRectGetWidth(self.collectionView.frame) - imageIndexLabelW;
    CGFloat imageIndexLabelY = CGRectGetHeight(self.collectionView.frame) - imageIndexLabelH;
    self.imageIndexLabel.frame = CGRectMake(imageIndexLabelX, imageIndexLabelY, imageIndexLabelW, imageIndexLabelH);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.noteItem.imgs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BuddyStatusNoteNewThumbViewCell *cell = [BuddyStatusNoteNewThumbViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    cell.imageUrl = self.noteItem.thumbs[indexPath.item];
    
    if (self.noteItem.selectedIndex == 0) {
        self.noteItem.selectedImageView = cell.imageView;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * _urls = [self.noteItem.imgs copy];
    NSInteger count = _urls.count;
    //封装图片数据
    NSMutableArray * photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_urls[i]]; // 图片路径
        BuddyStatusNoteNewThumbViewCell *cell = (BuddyStatusNoteNewThumbViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        photo.srcImageView = cell.imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    //显示相册
    MJPhotoBrowser * browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = (int)indexPath.item;
    browser.photos = photos;
    [browser show];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.imageIndexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, _noteItem.imgs.count];
    self.noteItem.selectedIndex = index;
    BuddyStatusNoteNewThumbViewCell *cell = (BuddyStatusNoteNewThumbViewCell *)[self collectionView:(UICollectionView *)scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    self.noteItem.selectedImageView = cell.imageView;
}
@end
