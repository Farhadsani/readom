//
//  SettingViewController.m
//  citystate
//
//  Created by hf on 15/10/22.
//
//

#import "SettingViewController.h"
#import "UserManager.h"
#import "StoreBindNewPhoneNumberViewController.h"
#import "RequstPassWordViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView * tableView;
@end

@implementation SettingViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.contentView.backgroundColor = [UIColor color:k_defaultViewControllerBGColor];
    [self setupMainView];
    
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate

#pragma mark other delegate

#pragma mark - action such as: click touch tap slip ...

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.contentView.width, 100) style:UITableViewStylePlain]autorelease];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setBackgroundColor:[UIColor color:clear_color]];
    [self.contentView addSubview:_tableView];
    _tableView.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    _tableView.layer.borderWidth = 0.5;
    _tableView.scrollEnabled = NO;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeTagCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"placeTagCell"];
    }
    [cell.contentView removeAllSubviews];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, 30),
                                             V_Img:@"buddystatus_arrow",
                                             V_ContentMode:num(ModeCenter),
                                             }];
    NSArray * imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"bangdingshoujihao"],[UIImage imageNamed:@"xiugaimima"], nil];
//    [defaults setObject:_base.phone forKey:@"SHITOUREN_UD_PHONE"];
    
    NSString * phone = [UserManager sharedInstance].base.phone;
    phone = [NSString stringWithFormat:@"已经绑定的手机号%@****%@", [phone substringToIndex:3],[phone substringFromIndex:phone.length-4]];
    cell.imageView.image = [imageArray objectAtIndex:indexPath.row];
    NSArray * nameArray = @[phone,@"修改账号密码"];
    
    cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:k_fontName_FZZY size:14.0];
    cell.textLabel.textColor = [UIColor color:k_defaultTextColor];
    
    NSArray * numArray = @[@"更改",@"修改"];
    cell.detailTextLabel.text = [numArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont fontWithName:k_fontName_FZZY size:14.0];
    cell.detailTextLabel.textColor = [UIColor color:k_defaultLightTextColor];

    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {
        StoreBindNewPhoneNumberViewController * vc = [[[StoreBindNewPhoneNumberViewController alloc]init]autorelease];
//        vc.backBlk = ^(NSString *phone){
//            BaseViewController * baseVC = [[BaseViewController alloc]init];
//            [baseVC showMessageView:@"绑定新号成功！" delayTime:3.0];
//            LoginViewController * loginView = [[LoginViewController alloc]init];
//            [self.navigationController pushViewController:loginView animated:YES];
//        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row ==1){
        RequstPassWordViewController * pwVc = [[[RequstPassWordViewController alloc]init]autorelease];
        [self.navigationController pushViewController:pwVc animated:YES];
    }
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark
@end
