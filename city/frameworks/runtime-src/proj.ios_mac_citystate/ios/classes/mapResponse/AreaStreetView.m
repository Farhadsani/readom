//
//  AreaStreetView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/22.
//
//

#import "AreaStreetView.h"
#import "AreaStreetCell.h"
#import "AppController.h"

#define AreaStreetKey [NSString stringWithFormat:@"api_area_street_list.json_%ld", self.areaid]

@interface AreaStreetView ()  <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, assign) NSInteger areaid;
@property (nonatomic, strong) NSMutableArray *areaStreetItemArr;
@property (nonatomic, weak) UICollectionView  *tagsView;
@property (nonatomic, weak) UIControl *bgControl;
@end

@implementation AreaStreetView
+ (instancetype)areaStreetViewWithAreaId:(NSInteger)areaid
{
    AreaStreetView *areaStreetView = [[self alloc] init];
    areaStreetView.areaid = areaid;
    [areaStreetView areaStreetItemArr];
    areaStreetView.backgroundColor = RandomColor;
    return areaStreetView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        UICollectionView *tagsView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) collectionViewLayout:flowLayout];
        self.tagsView = tagsView;
        [self addSubview:tagsView];
        [tagsView setBackgroundColor:milky_color];
        tagsView.dataSource = self;
        tagsView.delegate = self;
        [tagsView registerClass:[AreaStreetCell class] forCellWithReuseIdentifier:AreaStreetCell_ID];
        tagsView.showsVerticalScrollIndicator = NO;
        CGFloat margin = 5;
        tagsView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 5;
    self.tagsView.frame = self.bounds;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.tagsView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake((self.tagsView.width - 2 * margin) / 3, 43);
}

- (void)show
{
    UINavigationController *vc = [(AppController *)APPLICATION getVisibleViewController].navigationController;
    UIControl *bgControl = [[UIControl alloc] init];
    self.bgControl = bgControl;
    [vc.view insertSubview:bgControl belowSubview:vc.navigationBar];
    bgControl.frame = [UIScreen mainScreen].bounds;
    [bgControl addTarget:self action:@selector(bgControlDidOnClick) forControlEvents:UIControlEventTouchUpInside];
    bgControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    [vc.view insertSubview:self belowSubview:vc.navigationBar];
    
    CGRect frame = self.frame;
    frame.origin.y -= self.height;
    self.frame = frame;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.frame;
        f.origin.y += self.height;
        self.frame = f;
        self.bgControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}

- (void)hide
{
    [self.bgControl removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.frame;
        f.origin.y -= self.height;
        self.frame = f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        CGRect f = self.frame;
        f.origin.y += self.height;
        self.frame = f;
    }];
}

- (void)bgControlDidOnClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(areaStreetViewHide:)]) {
        [self.delegate areaStreetViewHide:self];
    }
}

- (NSMutableArray *)areaStreetItemArr
{
    if (!_areaStreetItemArr) {
        _areaStreetItemArr = [NSMutableArray array];
        
        NSArray *dicts = [[Cache shared].cache_dict objectForKey:AreaStreetKey];
        if (dicts != nil) {
            [_areaStreetItemArr addObjectsFromArray:[AreaStreetItem objectArrayWithKeyValuesArray:dicts]];
            AreaStreetItem *item = [[AreaStreetItem alloc] init];
            item.streetid = 0;
            item.name = @"全部";
            [self.areaStreetItemArr insertObject:item atIndex:0];
        } else {
            NSDictionary * params = @{@"areaid": @(self.areaid)};
            NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                    @"ver":[Device appBundleShortVersion],
                                    @"params":params,
                                    };
            NSDictionary * d = @{k_r_url:k_api_street_list,
                                 k_r_delegate:self,
                                 k_r_postData:dict,
                                 };
            [[ReqEngine shared] tryRequest:d];
        }
    }
    return _areaStreetItemArr;
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_street_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        [self.areaStreetItemArr addObjectsFromArray:[AreaStreetItem objectArrayWithKeyValuesArray:dicts]];
        AreaStreetItem *item = [[AreaStreetItem alloc] init];
        item.streetid = 0;
        item.name = @"全部";
        [self.areaStreetItemArr insertObject:item atIndex:0];
        [[Cache shared].cache_dict setValue:dicts forKey:AreaStreetKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tagsView reloadData];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_street_list]) {
        InfoLog(@"error:%@", error);
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.areaStreetItemArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaStreetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AreaStreetCell_ID forIndexPath:indexPath];
    cell.areaStreetItem = self.areaStreetItemArr[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaStreetItem *areaStreetItem = self.areaStreetItemArr[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(areaStreetView:didSelectItem:)]) {
        [self.delegate areaStreetView:self didSelectItem:areaStreetItem];
    }
    [self bgControlDidOnClick];
}
@end
