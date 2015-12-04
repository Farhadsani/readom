//
//  HotTagsView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import "HotTagsView.h"
#import "CWDLeftAlignedCollectionViewFlowLayout.h"
#import "HotTagCell.h"
#import "HotTag.h"

@interface HotTagsView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UICollectionView  *tagsView;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, assign) int index;
@end

@implementation HotTagsView
+ (instancetype)hotTagsView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *lineView = [[UIView alloc] init];
        self.lineView = lineView;
        [self addSubview:lineView];
        lineView.backgroundColor = lightZongSeBGColor;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        titleLabel.text = @"热门标签";
        titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:13];
        titleLabel.textColor = darkZongSeColor;
        titleLabel.textAlignment = TextAlignCenter;
        
        CWDLeftAlignedCollectionViewFlowLayout *flowLayout=[[CWDLeftAlignedCollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView *tagsView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) collectionViewLayout:flowLayout];
        self.tagsView = tagsView;
        [self addSubview:tagsView];
        [tagsView setBackgroundColor:[UIColor clearColor]];
        tagsView.dataSource = self;
        tagsView.delegate = self;
        [tagsView registerClass:[HotTagCell class] forCellWithReuseIdentifier:HotTagCell_ID];
        tagsView.contentInset = UIEdgeInsetsMake(0, 10 , 0, 10);
    }
    return self;
}

- (NSMutableArray *)tags
{
    if (!_tags) {
        _tags = [NSMutableArray array];
        
        NSArray *dicts = [[Cache shared].cache_dict objectForKey:HotTagsKey];
        if (dicts != nil) {
            [_tags addObjectsFromArray:[self dicts2Models:dicts]];
        } else {
            NSDictionary * params = @{};
            NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                    @"ver":[Device appBundleShortVersion],
                                    @"params":params,
                                    };
            NSDictionary * d = @{k_r_url:k_api_category_tag_list,
                                 k_r_delegate:self,
                                 k_r_postData:dict,
                                 k_r_loading:num(0),
                                 };
            [[ReqEngine shared] tryRequest:d];
        }
    }
    return _tags;
}


#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_tag_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        [self.tags addObjectsFromArray:[self dicts2Models:dicts]];
        [[Cache shared].cache_dict setValue:dicts forKey:HotTagsKey];
        [[Cache shared].cache_dict setValue:[self.tags valueForKeyPath:@"itemid"] forKey:HotTagsCategoryIds];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tagsView reloadData];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_tag_list]) {
        InfoLog(@"error:%@", error);
    }
}

- (NSArray *)dicts2Models:(NSArray *)dicts
{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in dicts){
        HotTag *hotTag = [[HotTag alloc] init];
        hotTag.name = dict[@"name"];
        hotTag.itemid = [dict[@"tagid"] longValue];
        [models addObject:hotTag];
    }
    return models;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 0, self.width, 0.6);
    
//    CGFloat margin = 10;
    CGFloat titleLabelH = 30;
    self.titleLabel.frame = CGRectMake(0, 0, 80, titleLabelH);
    self.tagsView.frame = CGRectMake(0, titleLabelH, self.width, self.height - titleLabelH);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotTagCell_ID forIndexPath:indexPath];
    cell.hotTag = self.tags[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotTagCell *cell = [[HotTagCell alloc] init];
    cell.hotTag = self.tags[indexPath.item];
    return cell.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(hotTagsView:tagDidOnClick:)]) {
        HotTag *hotTag = self.tags[indexPath.item];
        [self.delegate hotTagsView:self tagDidOnClick:[NSString stringWithFormat:@"%ld", hotTag.itemid]];
    }
}
@end
