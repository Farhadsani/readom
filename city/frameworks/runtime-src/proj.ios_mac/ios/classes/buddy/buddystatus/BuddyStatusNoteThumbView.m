//
//  BuddyStatusNoteThumbView.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "BuddyStatusNoteThumbView.h"
#import "BuddyStatusNoteTagsView.h"
#import "BuddyStatusNoteThumbViewCell.h"
#include "UIImageView+WebCache.h"
#import "TagItem.h"

#import "SDPhotoBrowser.h"//图片浏览器

@interface BuddyStatusNoteThumbView () <UICollectionViewDataSource, UICollectionViewDelegate,SDPhotoBrowserDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UICollectionView *collectionView;
/**
 *  展位图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;
/**
 *  当前选中图片的index
 */
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

@implementation BuddyStatusNoteThumbView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 3;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidOnClick:)]];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[BuddyStatusNoteThumbViewCell class] forCellWithReuseIdentifier:BuddyStatusNoteThumbViewCell_ID];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageViewX = BuddyStatusNoteThumbViewPadding;
    CGFloat imageViewY = BuddyStatusNoteThumbViewPadding;
    CGFloat imageViewW = screenWidth - 2 * BuddyStatusNoteThumbViewPadding - 2 * BuddyStatusCellPadding;
    CGFloat imageViewH = imageViewW * 0.5;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    CGFloat collectionViewX = imageViewX;
    CGFloat collectionViewY = CGRectGetMaxY(self.imageView.frame) + BuddyStatusNoteThumbViewSubviewsMargin;
    CGFloat collectionViewW = imageViewW;
    CGFloat collectionViewH = 50;
    self.collectionView.frame = CGRectMake(collectionViewX, collectionViewY, collectionViewW, collectionViewH);
}

- (void)setNoteItem:(BuddyStatusNoteItem *)noteItem{
    _noteItem = noteItem;
    
    if (noteItem.imgs.count > 0) {
        [self.collectionView reloadData];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteItem.imgs[0]] placeholderImage:self.placeholderImage];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.noteItem.thumbs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BuddyStatusNoteThumbViewCell *cell = [BuddyStatusNoteThumbViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    cell.imageUrl = self.noteItem.thumbs[indexPath.row];
    
    if (self.noteItem.thumbs.count > 0 && indexPath.item == self.selectedIndex) { // 默认第一个图片选中
        cell.select = YES;
        cell.userInteractionEnabled = NO;
    } else {
        cell.select = NO;
        cell.userInteractionEnabled = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(BuddyStatusNoteThumbViewCellWH, BuddyStatusNoteThumbViewCellWH);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item != self.selectedIndex) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.noteItem.imgs[indexPath.row]] placeholderImage:self.placeholderImage];
        
        BuddyStatusNoteThumbViewCell *oldCell = (BuddyStatusNoteThumbViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
        oldCell.select = NO;
        oldCell.userInteractionEnabled = YES;
        BuddyStatusNoteThumbViewCell *newCell = (BuddyStatusNoteThumbViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        newCell.select = YES;
        newCell.userInteractionEnabled = NO;
        self.selectedIndex = indexPath.item;
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        CGRect mainFrame = self.frame;
        int imgWidth = mainFrame.size.width-10*2;
        int imgHeight = imgWidth / 2;
        CGSize imageSize = CGSizeMake(imgWidth, imgHeight);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor grayColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        _placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _placeholderImage;
}

#pragma mark - 点击大图 - 进入图片浏览页面

- (void)imageViewDidOnClick:(UIImageView *)imageView{
    NSInteger count = self.noteItem.thumbs.count;

    InfoLog(@"%s", __func__);
    InfoLog(@"%ld %ld %@ %@", self.noteItem.topicid,self.noteItem.noteid, self.noteItem.topic, self.noteItem.note);
    InfoLog(@"%@ %@", self.noteItem.thumbs, self.noteItem.imgs);
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = [self.noteItem.thumbs objectAtExistIndex:i];
        item.HD_pic = [self.noteItem.imgs objectAtExistIndex:i];
        [temp addObject:item];
    }
    //SDPhotoBrowser
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.imageView; // 原图的父控件
    browser.imageCount = [temp count]; // 图片总数
    browser.HDPhotoItems = temp;
    browser.currentImageIndex = (int)_selectedIndex;
    browser.delegate = self;
    [browser show];
}


#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    BuddyStatusNoteThumbViewCell *oldCell = (BuddyStatusNoteThumbViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return oldCell.imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = [[browser.HDPhotoItems objectAtExistIndex:index] HD_pic];
    InfoLog(@"%@", urlStr);
    return [NSURL URLWithString:urlStr];
}

+ (CGSize)size
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = screenWidth - 2 * BuddyStatusNoteThumbViewPadding - 2 * BuddyStatusCellPadding;
    CGFloat height = BuddyStatusNoteThumbViewPadding + width * 0.5 + BuddyStatusNoteThumbViewSubviewsMargin + BuddyStatusNoteThumbViewCellWH + BuddyStatusNoteThumbViewPadding;
    return CGSizeMake(width, height);
}
@end
