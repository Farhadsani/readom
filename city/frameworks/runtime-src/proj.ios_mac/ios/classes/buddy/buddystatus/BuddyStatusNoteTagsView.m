//
//  BuddyStatusNoteTagsView.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

/*
 *【好友动态】界面
 *功能：view的界面展示
 * BuddyStatusNoteTagsViewCell 展示 TagItem中的text。
 */

#import "BuddyStatusNoteTagsView.h"
#import "CWDLeftAlignedCollectionViewFlowLayout.h"
#import "BuddyStatusNoteTagsViewCell.h"
#import "TagItem.h"

@interface BuddyStatusNoteTagsView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIView  *tagsBg;
@property (nonatomic, weak) UICollectionView  *tagsView;
@end

@implementation BuddyStatusNoteTagsView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *tagsBg = [[UIView alloc] init];
        self.tagsBg = tagsBg;
        [self addSubview:tagsBg];
        tagsBg.backgroundColor = [UIColor blackColor];
        tagsBg.alpha = 0.4;
        
        CWDLeftAlignedCollectionViewFlowLayout *flowLayout=[[CWDLeftAlignedCollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *tagsView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.tagsView = tagsView;
        [self addSubview:tagsView];
        [tagsView setScrollEnabled:NO];
        [tagsView setBackgroundColor:[UIColor clearColor]];
        tagsView.dataSource = self;
        tagsView.delegate = self;
        [tagsView registerClass:[BuddyStatusNoteTagsViewCell class] forCellWithReuseIdentifier:BuddyStatusNoteTagsViewCell_ID];
        tagsView.contentInset = UIEdgeInsetsMake(5, 5, 0, 5);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tagsBg.frame =  self.bounds;
    self.tagsView.frame = self.bounds;
    
//    // 设置圆角
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.tagsBg.bounds;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tagsBg.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
//    maskLayer.path = maskPath.CGPath;
//    self.tagsBg.layer.mask = maskLayer;
}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    [self.tagsView reloadData];
}

- (void)setTagsBgColor:(UIColor *)tagsBgColor
{
    _tagsBgColor = tagsBgColor;
    
    self.tagsBg.backgroundColor = tagsBgColor;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = BuddyStatusNoteTagsViewCell_ID;
    BuddyStatusNoteTagsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    TagItem *tagItem = self.tags[indexPath.item];
    cell.text = tagItem.text;
//    cell.text = self.tags[indexPath.item];
    cell.textColor = self.tagsColor ? self.tagsColor : [UIColor color:green_color];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusNoteTagsViewCell *cell = [[BuddyStatusNoteTagsViewCell alloc] init];
    TagItem *tagItem = self.tags[indexPath.item];
    cell.text = tagItem.text;
    //    cell.text = self.tags[indexPath.item];

    return cell.frame.size;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
@end
