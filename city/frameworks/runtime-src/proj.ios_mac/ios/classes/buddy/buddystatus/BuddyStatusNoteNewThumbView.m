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
#import "SDPhotoBrowser.h"//图片浏览器
#import "BuddyStatusNoteNewThumbViewLayout.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface BuddyStatusNoteNewThumbView () <UICollectionViewDataSource, UICollectionViewDelegate,SDPhotoBrowserDelegate>
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
        imageIndexLabel.textColor = [UIColor whiteColor];
        imageIndexLabel.font = BuddyStatusCellImageIndexViewFont;
        imageIndexLabel.textAlignment = NSTextAlignmentCenter;
        imageIndexLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setNoteItem:(BuddyStatusNoteItem *)noteItem
{
    _noteItem = noteItem;
    
    self.imageIndexLabel.text = [NSString stringWithFormat:@"1/%ld", _noteItem.thumbs.count];
    
    if (_noteItem.tags.count > 0) {
        self.imageIndexLabel.backgroundColor = [UIColor blackColor];
        self.imageIndexLabel.alpha = 0.4;
    } else {
        self.imageIndexLabel.backgroundColor = [UIColor clearColor];
        self.imageIndexLabel.alpha = 1.0;
    }
    
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;

    CGFloat imageIndexLabelW = BuddyStatusNoteImageIndexLabelW;
    CGFloat imageIndexLabelH = BuddyStatusNoteImageIndexLabelH;
    CGFloat imageIndexLabelX = CGRectGetWidth(self.collectionView.frame) - imageIndexLabelW - BuddyStatusCellPadding;
    CGFloat imageIndexLabelY = CGRectGetHeight(self.collectionView.frame) - imageIndexLabelH;
    self.imageIndexLabel.frame = CGRectMake(imageIndexLabelX, imageIndexLabelY, imageIndexLabelW, imageIndexLabelH);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.noteItem.imgs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BuddyStatusNoteNewThumbViewCell *cell = [BuddyStatusNoteNewThumbViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    cell.imageUrl = self.noteItem.imgs[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 点击大图,进入图片浏览页面
//    NSMutableArray *temp = [NSMutableArray array];
//    for (int i = 0; i < self.noteItem.imgs.count; ++i) {
//        SDPhotoItem *item = [[SDPhotoItem alloc] init];
//        item.HD_pic = [self.noteItem.imgs objectAtExistIndex:i];
//        [temp addObject:item];
//    }
//    
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.sourceImagesContainerView = [collectionView cellForItemAtIndexPath:indexPath]; // 原图的父控件
//    browser.imageCount = [temp count]; // 图片总数
//    browser.HDPhotoItems = temp;
//    browser.currentImageIndex = (int)indexPath.item;
//    browser.delegate = self;
//    [browser show];
//}

#pragma mark - MJPhotoBrowser
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
    return;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.imageIndexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, _noteItem.thumbs.count];
    //    self.collectionView.contentSize = CGSizeMake(self.collectionView.frame.size.width * 0.5, 0);
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    BuddyStatusNoteNewThumbViewCell *oldCell = (BuddyStatusNoteNewThumbViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return oldCell.imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = [[browser.HDPhotoItems objectAtExistIndex:index] HD_pic];
    return [NSURL URLWithString:urlStr];
}

- (void)photoBrowser:(SDPhotoBrowser *)browser currentImageIndex:(NSInteger)index
{
    // 滚动collectionView
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.imageIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, _noteItem.thumbs.count];
}
@end
