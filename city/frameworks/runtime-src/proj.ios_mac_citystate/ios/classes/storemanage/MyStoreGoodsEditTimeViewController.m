//
//  MyStoreGoodsEditTimeViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/2.
//
//

#import "MyStoreGoodsEditTimeViewController.h"
#import "MyStoreGoodsEditCell.h"

@interface MyStoreGoodsEditTimeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *descArr;
@property (nonatomic, assign) NSInteger seletedIndex;
@end

@implementation MyStoreGoodsEditTimeViewController
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"起始时间", @"结束时间"];
    }
    return _titleArr;
}

- (NSMutableArray *)descArr
{
    if (!_descArr) {
        _descArr = [NSMutableArray arrayWithCapacity:2];
        if (self.storeGoodsDetail) {
            [_descArr addObject:[self nillStr:self.storeGoodsDetail.starttime]];
            [_descArr addObject:[self nillStr:self.storeGoodsDetail.endtime]];
        }
    }
    return _descArr;
}

- (NSString *)nillStr:(NSString *)str
{
    return str.length == 0 ? @"" : str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRightBackButtonItem:@"保存" img:nil del:self sel:@selector(clickRightItem:)];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = CGRectMake(0, 10, self.contentView.width, self.contentView.height - 10);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    
    UIView *tableViewHeaderView = [[UIView alloc] init];
    CGRect frame = tableViewHeaderView.frame;
    frame.size.height = 0.6;
    tableViewHeaderView.frame = frame;
    tableViewHeaderView.backgroundColor = lightgray_color;
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.frame = frame;
    tableViewFooterView.backgroundColor = lightgray_color;
    self.tableView.tableFooterView = tableViewFooterView;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [self.contentView addSubview:datePicker];
    self.datePicker = datePicker;
    datePicker.frame = CGRectMake(0, self.contentView.height - 180, self.contentView.width, 200);
    datePicker.backgroundColor = [UIColor whiteColor];
    CALayer *layer = datePicker.layer;
    layer.borderColor = lightgray_color.CGColor;
    layer.borderWidth = 0.6;
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(dataPickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.seletedIndex = 0;
    NSString *timeStr = self.descArr[self.seletedIndex];
    if (timeStr.length != 0) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"HH:mm";
        datePicker.date = [fmt dateFromString:self.descArr[self.seletedIndex]];
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStoreGoodsEditCell *cell = [MyStoreGoodsEditCell cellForTableView:tableView];
    cell.title = self.titleArr[indexPath.row];
    cell.desc = (self.descArr[indexPath.row] == nil) ? @"" : self.descArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.seletedIndex = indexPath.row;
    NSString *timeStr = self.descArr[self.seletedIndex];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    if (timeStr.length == 0) {
        timeStr = [fmt stringFromDate:[NSDate date]];
    }
    self.datePicker.date = [fmt dateFromString:timeStr];
}

- (void)dataPickerValueChanged:(UIDatePicker *)datepicker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    self.descArr[self.seletedIndex] = [fmt stringFromDate:datepicker.date];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.seletedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickRightItem:(id)sender
{
    if ([self.descArr[0] isEqualToString:@""] || [self.descArr[1] isEqualToString:@""]) {
        [self showMessageView:@"请填写内容!"  delayTime:3.0];   
    } else {
        self.storeGoodsDetail.starttime = self.descArr[0];
        self.storeGoodsDetail.endtime = self.descArr[1];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end