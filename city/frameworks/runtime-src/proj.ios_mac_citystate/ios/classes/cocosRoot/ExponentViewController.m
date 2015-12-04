//
//  ExponentViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/10.
//
//

#import "ExponentViewController.h"
#import "TitleBar.h"
#import "ExponentItem.h"
#import "ExponentCell.h"
#import "HotTagsView.h"
#import "MoreConsumeExponentViewController.h"

#define CellH 80

@interface ExponentViewController () <TitleBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, HotTagsViewDelegate>
@property (nonatomic, weak) TitleBar *titleBar;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray*lineViewArr; // 存放分割线的数组
@property (nonatomic, strong) NSArray *titles; // 指数字符串数组
@property (nonatomic, strong) NSArray *exponentItems;
@property (nonatomic, strong) NSMutableArray *socialExponentItems;
@property (nonatomic, strong) NSMutableArray *consumeExponentItems;
@property (nonatomic, strong) NSMutableArray *allConsumeExponentItems;
@property (nonatomic, strong) NSMutableArray *consumeExponentItemTypes;
@property (nonatomic, strong) NSMutableArray *consumeExponentItemGroups;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) HotTagsView *hotTagsView;
@end

@implementation ExponentViewController
- (NSMutableArray *)lineViewArr
{
    if (!_lineViewArr) {
        _lineViewArr = [NSMutableArray array];
    }
    return _lineViewArr;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"社交指数", @"消费指数"];
    }
    return _titles;
}

- (NSMutableArray *)socialExponentItems
{
    if (!_socialExponentItems) {
        _socialExponentItems = [NSMutableArray array];
        
        NSArray *dicts = [[Cache shared].cache_dict objectForKey:SocialKey];
        if (dicts != nil) {
            [_socialExponentItems addObjectsFromArray:[self dicts2Models:dicts]];
        } else {
            NSDictionary * params = @{};
            NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                    @"ver":[Device appBundleShortVersion],
                                    @"params":params,
                                    };
            NSDictionary * d = @{k_r_url:k_api_category_social_list,
                                 k_r_delegate:self,
                                 k_r_postData:dict,
                                 };
            [[ReqEngine shared] tryRequest:d];
        }
    }
    return _socialExponentItems;
}

- (NSMutableArray *)consumeExponentItems
{
    if (!_consumeExponentItems) {
        _consumeExponentItems = [NSMutableArray array];
        
        NSArray *dicts = [[Cache shared].cache_dict objectForKey:ConsumeKey];
        if (dicts != nil) {
            [self dict2ConsumeExponentItems:dicts];
        } else {
            NSDictionary * params = @{};
            NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                    @"ver":[Device appBundleShortVersion],
                                    @"params":params,
                                    };
            NSDictionary * d = @{k_r_url:k_api_category_cost_list,
                                 k_r_delegate:self,
                                 k_r_postData:dict,
                                 };
            [[ReqEngine shared] tryRequest:d];
        }

    }
    return _consumeExponentItems;
}

- (NSMutableArray *)allConsumeExponentItems
{
    if (!_allConsumeExponentItems) {
        _allConsumeExponentItems = [NSMutableArray array];
    }
    return _allConsumeExponentItems;
}

- (NSMutableArray *)consumeExponentItemTypes
{
    if (!_consumeExponentItemTypes) {
        _consumeExponentItemTypes = [NSMutableArray array];
    }
    return _consumeExponentItemTypes;
}

- (NSMutableArray *)consumeExponentItemGroups
{
    if (!_consumeExponentItemGroups) {
        _consumeExponentItemGroups = [NSMutableArray array];
    }
    return _consumeExponentItemGroups;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.titles[0];
    
    TitleBar *titleBar = [TitleBar titleBarWithTitles:self.titles andShowCount:self.titles.count];
    self.titleBar = titleBar;
    [self.contentView addSubview:titleBar];
    titleBar.frame = CGRectMake(0, 0, self.view.width, 40);
    titleBar.delegate = self;
    
    self.exponentItems = self.socialExponentItems;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width * 0.5, CellH);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    CGRect collectionViewFrame = CGRectMake(0, 50, self.view.frame.size.width, (self.exponentItems.count + 1) / 2 * CellH);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled =  NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[ExponentCell class] forCellWithReuseIdentifier:ExponentCell_ID];
    collectionView.layer.borderColor = lightgray_color.CGColor;
    collectionView.layer.borderWidth = 0.3;
    
    self.hotTagsView.hidden = NO;
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_cost_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        [self dict2ConsumeExponentItems:dicts];
        [[Cache shared].cache_dict setValue:dicts forKey:ConsumeKey];
        [[Cache shared].cache_dict setValue:[self.consumeExponentItems valueForKeyPath:@"categoryid"] forKey:ConsumeCategoryIds];
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_social_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        [self.socialExponentItems addObjectsFromArray:[self dicts2Models:dicts]];
        [[Cache shared].cache_dict setValue:dicts forKey:SocialKey];
        [[Cache shared].cache_dict setValue:[self.socialExponentItems valueForKeyPath:@"categoryid"] forKey:SocialCategoryIds];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 修改collectionView的frame，刷新数据
        self.collectionView.frame = CGRectMake(0, 50, self.view.frame.size.width, (self.exponentItems.count + 1) / 2 * CellH);
        [self.collectionView reloadData];
    });
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_cost_list]) {
        InfoLog(@"error:%@", error);
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_social_list]) {
        InfoLog(@"error:%@", error);
    }
}

- (void)dict2ConsumeExponentItems:(NSArray *)dicts
{
    [self.allConsumeExponentItems addObjectsFromArray:[self dicts2Models:dicts]];
    
    [self.allConsumeExponentItems enumerateObjectsUsingBlock:^(ExponentItem *item, NSUInteger idx, BOOL *stop) {
        if (item.major) {
            [self.consumeExponentItems addObject:item];
        }
        if (item.type.length != 0) {
            if (![self.consumeExponentItemTypes containsObject:item.type] ) {
                [self.consumeExponentItemTypes addObject:item.type];
                [self.consumeExponentItemGroups addObject:[NSMutableArray array]];
            }
            [self.consumeExponentItemGroups[[self.consumeExponentItemTypes indexOfObject:item.type]] addObject:item];
        }
    }];
    ExponentItem *exponentItem2 = [[ExponentItem alloc] init];
    exponentItem2.imglink = @"exponent_more";
    exponentItem2.imglinkhight = @"exponent_more_sel";
    exponentItem2.name = @"More";
    exponentItem2.cname = @"更多";
    [self.consumeExponentItems addObject:exponentItem2];
}

- (NSArray *)dicts2Models:(NSArray *)dicts
{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in dicts){
        ExponentItem *exponentItem = [[ExponentItem alloc] init];
        exponentItem.imglink = dict[@"imglink"];
        exponentItem.imglinkhight = dict[@"hlimglink"];
        exponentItem.name = dict[@"name"];
        exponentItem.cname = dict[@"cname"];
        exponentItem.categoryid = [dict[@"categoryid"] longValue];
        exponentItem.major = [dict[@"major"] boolValue];
        exponentItem.type = dict[@"type"];
        [models addObject:exponentItem];
    }
    ExponentItem *exponentItem1 = [[ExponentItem alloc] init];
    exponentItem1.imglink = @"exponent_default";
    exponentItem1.imglinkhight = @"exponent_default_sel";
    exponentItem1.name = @"Default";
    exponentItem1.cname = @"默认";
    exponentItem1.major = YES;
    [models insertObject:exponentItem1 atIndex:0];
    return models;
}

#pragma mark - TitleBarDelegate
- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index
{
    self.navigationItem.title = self.titles[index];

    if (index == 0) {
        self.exponentItems = self.socialExponentItems;
        self.hotTagsView.hidden = NO;
    } else if (index == 1) {
        self.exponentItems = self.consumeExponentItems;
        self.hotTagsView.hidden = YES;
    }
    // 修改collectionView的frame，刷新数据
    self.collectionView.frame = CGRectMake(0, 50, self.view.frame.size.width, (self.exponentItems.count + 1) / 2 * CellH);
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self setupLine]; // 设置分割线
    return self.exponentItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExponentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ExponentCell_ID forIndexPath:indexPath];
    cell.exponentItem = self.exponentItems[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        if ([self.delegate respondsToSelector:@selector(ViewController:didSelectedIndexType:indexID:)]) {
            [self.delegate ViewController:nil didSelectedIndexType:MapIndexType_sight indexID:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    if ([self.exponentItems isEqual:self.consumeExponentItems]) { // 消费指数
        if (self.exponentItems.count == indexPath.item + 1) { // 更多
            MoreConsumeExponentViewController *moreConsumeExponentViewController = [[MoreConsumeExponentViewController alloc] init];
            moreConsumeExponentViewController.consumeExponentItemGroups = self.consumeExponentItemGroups;
            moreConsumeExponentViewController.title = @"更多";
            moreConsumeExponentViewController.delegate = self.delegate;
            [self.navigationController pushViewController:moreConsumeExponentViewController animated:YES];
        } else {
            if ([self.delegate respondsToSelector:@selector(ViewController:didSelectedIndexType:indexID:)]) {
                ExponentItem *item = self.exponentItems[indexPath.item];
                [self.delegate ViewController:nil didSelectedIndexType:MapIndexType_consume indexID:[NSString stringWithFormat:@"%ld", item.categoryid]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } else { // 社交指数
        if ([self.delegate respondsToSelector:@selector(ViewController:didSelectedIndexType:indexID:)]) {
            ExponentItem *item = self.exponentItems[indexPath.item];
            [self.delegate ViewController:nil didSelectedIndexType:MapIndexType_social indexID:[NSString stringWithFormat:@"%ld", item.categoryid]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

/**
 *  设置分割线
 */
- (void)setupLine
{
    [self.lineViewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lineViewArr removeAllObjects];
    
    NSInteger count = self.exponentItems.count;
    NSInteger row = (count + 1) / 2;

    CGFloat margin = 10;
    for (NSInteger i = 0; i < row; i++) {
        UIView *centerLineView = [[UIView alloc] init];
        centerLineView.backgroundColor = [UIColor blackColor];
        centerLineView.alpha = 0.3;
        centerLineView.frame = CGRectMake(self.collectionView.width * 0.5, margin + CellH * i, 0.5, CellH - margin * 2);
        [self.collectionView addSubview:centerLineView];
        [self.lineViewArr addObject:centerLineView];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = [UIColor blackColor] ;
        bottomLineView.alpha = 0.3;
        bottomLineView.frame = CGRectMake(margin, CellH * (i + 1), self.collectionView.width - margin * 2, 0.5);
        [self.collectionView addSubview:bottomLineView];
        [self.lineViewArr addObject:bottomLineView];
    }
}

- (HotTagsView *)hotTagsView
{
    if (!_hotTagsView) {
        _hotTagsView = [HotTagsView hotTagsView];
        _hotTagsView.delegate = self;
        [self.view addSubview:_hotTagsView];
        CGFloat hight = 140;
        _hotTagsView.frame = CGRectMake(0, self.view.height - hight - 64, self.view.width, hight);
    }
    return _hotTagsView;
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [self clickLeftBarButtonItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hotTagsView:(HotTagsView *)view tagDidOnClick:(NSString *)hotTagId
{
    if ([self.delegate respondsToSelector:@selector(ViewController:didSelectedIndexType:indexID:)]) {
        [self.delegate ViewController:nil didSelectedIndexType:MapIndexType_hotTag indexID:hotTagId];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
