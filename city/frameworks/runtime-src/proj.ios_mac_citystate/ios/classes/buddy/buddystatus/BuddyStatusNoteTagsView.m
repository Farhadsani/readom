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
#import "BuddyStatusNoteTagsViewCell.h"
#import "CWDLeftAlignedCollectionViewFlowLayout.h"
#import "TagItem.h"

@interface BuddyStatusNoteTagsView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIImageView  *iconView;
@property (nonatomic, weak) UICollectionView  *tagsView;
@end

@implementation BuddyStatusNoteTagsView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self addSubview:iconView];
        iconView.contentMode = UIViewContentModeCenter;
        
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
        tagsView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(0, 0, self.height-3, self.height);
    self.tagsView.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame), 0, self.width - CGRectGetMaxX(self.iconView.frame), self.height);
}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    [self.tagsView reloadData];
}

- (void)setTagsFont:(UIFont *)tagsFont
{
    _tagsFont = tagsFont;
    
    [self.tagsView reloadData];
}
- (void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    
    [self.iconView setImage:[UIImage imageNamed:iconName]];
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
    cell.textFont = self.tagsFont;
    cell.text = tagItem.text;
    // cell.text = self.tags[indexPath.item];
    cell.textColor = self.tagsColor ? self.tagsColor : [UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusNoteTagsViewCell *cell = [[BuddyStatusNoteTagsViewCell alloc] init];
    TagItem *tagItem = self.tags[indexPath.item];
    cell.textFont = self.tagsFont;
    cell.text = tagItem.text;
    // cell.text = self.tags[indexPath.item];
    return cell.frame.size;
}
@end
