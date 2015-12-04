//
//  MoreConsumeExponentViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/3.
//
//

#import "MoreConsumeExponentViewController.h"
#import "MoreConsumeExponentCell.h"
#import "ExponentViewController.h"

@interface MoreConsumeExponentViewController ()<UITableViewDataSource, UITableViewDelegate, MoreConsumeExponentCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@end

@implementation MoreConsumeExponentViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    if ([self.delegate respondsToSelector:@selector(ViewController:didSelectedIndexType:indexID:)]) {
        [self.delegate ViewController:nil didSelectedIndexType:MapIndexType_consume indexID:[NSString stringWithFormat:@"%ld", button.item.categoryid]];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
