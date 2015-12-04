//
//  EditStoreCategoryViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/3.
//
//

#import "EditStoreCategoryViewController.h"
#import "MoreConsumeExponentCell.h"
#import "ExponentViewController.h"

#define ConsumeKey @"api_category_list_store.json"
#define MaxCount 3

@interface EditStoreCategoryViewController ()<UITableViewDataSource, UITableViewDelegate, MoreConsumeExponentCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *consumeExponentItems;
@property (nonatomic, strong) NSMutableArray *consumeExponentItemTypes;
@property (nonatomic, strong) NSMutableArray *consumeExponentItemGroups;
@property (nonatomic, strong) NSMutableArray *selectedExponentItems;

@property (nonatomic, strong) NSMutableArray *selectedExponentItemsTmp;

@end

@implementation EditStoreCategoryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRightBackButtonItem:@"确定" img:nil del:self sel:@selector(clickRightItem:)];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableView.tableFooterView = tableViewFooterView;
}

- (NSMutableArray *)consumeExponentItems
{
    if (!_consumeExponentItems) {
        _consumeExponentItems = [NSMutableArray array];
    }
    return _consumeExponentItems;
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
    return _consumeExponentItemGroups;
}

- (NSMutableArray *)selectedExponentItems
{
    if (!_selectedExponentItems) {
        _selectedExponentItems = [NSMutableArray array];
    }
    return _selectedExponentItems;
}

- (NSMutableArray *)selectedExponentItemsTmp
{
    if (!_selectedExponentItemsTmp) {
        _selectedExponentItemsTmp = [NSMutableArray array];
    }
    return _selectedExponentItemsTmp;
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
    return models;
}


- (void)dict2ConsumeExponentItems:(NSArray *)dicts
{
    [self.consumeExponentItems addObjectsFromArray:[self dicts2Models:dicts]];
    
    [self.consumeExponentItems enumerateObjectsUsingBlock:^(ExponentItem *item, NSUInteger idx, BOOL *stop) {
        if (item.type.length != 0) {
            if (![self.consumeExponentItemTypes containsObject:item.type] ) {
                [self.consumeExponentItemTypes addObject:item.type];
                [self.consumeExponentItemGroups addObject:[NSMutableArray array]];
            }
            [self.consumeExponentItemGroups[[self.consumeExponentItemTypes indexOfObject:item.type]] addObject:item];
        }
    }];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_cost_list]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        [self dict2ConsumeExponentItems:dicts];
        [[Cache shared].cache_dict setValue:dicts forKey:ConsumeKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_updatecategory]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeStoreCategory:)]) {
            [self.delegate didChangeStoreCategory:self.selectedExponentItemsTmp];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_category_cost_list]) {
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_manage_updatecategory]) {
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.consumeExponentItemGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreConsumeExponentCell *cell = [[MoreConsumeExponentCell alloc] init];
    cell.consumeExponentItem = self.consumeExponentItemGroups[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreConsumeExponentCell *cell = (MoreConsumeExponentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:k_fontName_FZZY size:15];
    label.textColor = gray_color;
    ExponentItem *item = self.consumeExponentItemGroups[section][0];
    label.text = [NSString stringWithFormat:@"    %@", item.type];
    return label;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= 30 && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= 30) {
            scrollView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
        }
    }
}

- (void)moreConsumeExponentCell:(MoreConsumeExponentCell *)cell btnDidOnClick:(ConsumeExponentButton *)button
{
    if (button.selected) {
        button.selected = NO;
        [self.selectedExponentItems removeObject:@(button.item.categoryid)];
        
        for (NSDictionary * dic in self.selectedExponentItemsTmp) {
            if ((long)[[dic objectOutForKey:@"categoryid"] longLongValue] == button.item.categoryid) {
                [self.selectedExponentItemsTmp removeObjectAtIndex:[self.selectedExponentItemsTmp indexOfObject:dic]];
                break;
            }
        }
    }
    else {
        if (self.selectedExponentItems.count < MaxCount) {
            button.selected = !button.isSelected;
            [self.selectedExponentItems addObject:@(button.item.categoryid)];
            
            NSMutableDictionary * md = [[NSMutableDictionary alloc] init];
            [md setNonEmptyObject:@(button.item.categoryid) forKey:@"categoryid"];
            [md setNonEmptyObject:button.item.name forKey:@"name"];
            [md setNonEmptyObject:button.item.cname forKey:@"cname"];
            [self.selectedExponentItemsTmp addObject:md];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"店铺分类最多选择3个!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)clickRightItem:(id)sender
{
    NSDictionary * params = @{@"categoryids":[self.selectedExponentItems componentsJoinedByString:@","]};
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_manage_updatecategory,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}
@end
