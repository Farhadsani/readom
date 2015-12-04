//
//  StoreCommentImgsView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreCommentImgsView.h"
#import "StoreCommentImgsViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define StoreCommentImgsViewCell_ID @"StoreCommentImgsViewCell"

@interface StoreCommentImgsView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation StoreCommentImgsView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(StoreCommentImgsViewCellWH, StoreCommentImgsViewCellWH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 10;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[StoreCommentImgsViewCell class] forCellWithReuseIdentifier:StoreCommentImgsViewCell_ID];
    }
    return self;
}

- (void)setStoreComment:(StoreComment *)storeComment
{
    _storeComment = storeComment;
    
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.storeComment.photothumb.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCommentImgsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreCommentImgsViewCell_ID forIndexPath:indexPath];
    cell.imageUrl = self.storeComment.photothumb[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * _urls = [self.storeComment.photolink copy];
    NSInteger count = _urls.count;
    //封装图片数据
    NSMutableArray * photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_urls[i]]; // 图片路径
        StoreCommentImgsViewCell *cell = (StoreCommentImgsViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        photo.srcImageView = cell.imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    //显示相册
    MJPhotoBrowser * browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = (int)indexPath.item;
    browser.photos = photos;
    [browser show];
}
@end
