//
//  MyStoreGoodsEditDayViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/2.
//
//

#import "MyStoreGoodsEditDayViewController.h"
#import "MyStoreGoodsEditCell.h"

@interface MyStoreGoodsEditDayViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *descArr;
@property (nonatomic, assign) NSInteger seletedIndex;
@end

@implementation MyStoreGoodsEditDayViewController
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"起始日期", @"结束日期", @"周末法定假日通用"];
    }
    return _titleArr;
}

- (NSMutableArray *)descArr
{
    if (!_descArr) {
        _descArr = [NSMutableArray arrayWithCapacity:3];
        if (self.storeGoodsDetail) {
            [_descArr addObject:[self nillStr:self.storeGoodsDetail.startdate]];
            [_descArr addObject:[self nillStr:self.storeGoodsDetail.enddate]];
            [_descArr addObject:@(self.storeGoodsDetail.holidaysvalidate)];
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
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dataPickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.seletedIndex = 0;
    NSString *dayStr = self.descArr[self.seletedIndex];
    if (dayStr.length != 0) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        datePicker.date = [fmt dateFromString:dayStr];
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyStoreGoodsEditCell *cell = [MyStoreGoodsEditCell cellForTableView:tableView];
        cell.title = self.titleArr[indexPath.row];
        cell.desc = (self.descArr[indexPath.row] == nil) ? @"" : self.descArr[indexPath.row];
        return cell;
    } else  if (indexPath.row == 1) {
        MyStoreGoodsEditCell *cell = [MyStoreGoodsEditCell cellForTableView:tableView];
        cell.title = self.titleArr[indexPath.row];
        cell.desc = (self.descArr[indexPath.row] == nil) ? @"" : self.descArr[indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
        cell.textLabel.textColor = darkGary_color;
        cell.textLabel.text= self.titleArr[indexPath.row];
        UISwitch *accessoryView = [[UISwitch alloc] init];
        accessoryView.onTintColor = yello_color;
        [accessoryView addTarget:self action:@selector(accessoryViewValueChanged:) forControlEvents:UIControlEventValueChanged];
        accessoryView.on = (self.descArr[indexPath.row] == nil) ? NO : [self.descArr[indexPath.row] boolValue];
        cell.accessoryView = accessoryView;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        self.seletedIndex = indexPath.row;
        NSString *dayStr = self.descArr[self.seletedIndex];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        if (dayStr.length == 0) {
            dayStr = [fmt stringFromDate:[NSDate date]];
        }
        self.datePicker.date = [fmt dateFromString:dayStr];
    }
}

- (void)accessoryViewValueChanged:(UISwitch *)sender
{
    self.descArr[2] = @(sender.isOn);
}

- (void)dataPickerValueChanged:(UIDatePicker *)datepicker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    self.descArr[self.seletedIndex] =  [fmt stringFromDate:datepicker.date];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.seletedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickRightItem:(id)sender
{
    if ([self.descArr[0] isEqualToString:@""] || [self.descArr[1] isEqualToString:@""]) {
        [self showMessageView:@"请填写内容!"  delayTime:3.0];
    } else {
        self.storeGoodsDetail.startdate = self.descArr[0];
        self.storeGoodsDetail.enddate = self.descArr[1];
        self.storeGoodsDetail.holidaysvalidate = [self.descArr[2] boolValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
