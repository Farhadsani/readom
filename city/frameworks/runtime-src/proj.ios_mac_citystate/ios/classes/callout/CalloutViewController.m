//
//  CalloutViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/5.
//
//

/*
 *【喊话内容】界面
 *功能：发布三句话题内容显示到主界面
 *
 */

#import "CalloutViewController.h"
#import "UserManager.h"
#import "BRPlaceholderTextView.h"
#import "NSString+Extension.h"
#import "EditCalloutViewController.h"

@interface CalloutViewController ()<UITableViewDataSource,UITableViewDelegate,PassCalloutValueDelegate>
@property (nonatomic, strong) NSMutableArray * textArray;
@property (nonatomic, strong) UITableView * callTable;
@property (nonatomic, strong) NSString * textValue;
@end

@implementation CalloutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"喊话内容";
    self.textArray = [[NSMutableArray alloc]init];
    
    [self requestCalloutList];

    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}
- (NSString *)nilToStr:(NSString *)str
{
    if (str.length == 0) {
        return @"";
    } else {
        return str;
    }
}
- (void)requestCalloutList{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid]
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_shout_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_showError:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}


- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_update]) {
        [[UserManager sharedInstance] saveCallouts:[result objectOutForKey:@"res"]];
        [self arrayAddObject];
        [_callTable reloadData];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_list]) {
        NSDictionary * res = [result objectOutForKey:@"res"];
        if (res) {
            [[UserManager sharedInstance] saveCallouts:res];
            [self arrayAddObject];
        }
        [_callTable reloadData];
    }
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_update]) {
    }
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_list]) {
        
    }
}

- (void)arrayAddObject{
    [self.textArray removeAllObjects];
    [self.textArray addObject:[self nilToStr:[UserManager sharedInstance].callout1]];
    [self.textArray addObject:[self nilToStr:[UserManager sharedInstance].callout2]];
    [self.textArray addObject:[self nilToStr:[UserManager sharedInstance].callout3]];
}

- (void)createTableView{
    self.callTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, self.view.height)];
    _callTable.backgroundColor = [UIColor color:milky_color];
    _callTable.scrollEnabled = NO;
    _callTable.separatorStyle = NO;
    _callTable.separatorColor = [UIColor clearColor];
    _callTable.delegate = self;
    _callTable.dataSource = self;
    UIView * line = [UIView view_sub:@{V_Parent_View:_callTable,
                                       V_Height:@0.5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    _callTable.tableFooterView = line;
    [self.view addSubview:_callTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = _callTable.height / 12;
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CalloutViewCell"];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, 30),
                                             V_Img:@"buddystatus_arrow",
                                             V_ContentMode:num(ModeCenter),
                                             }];
    
    NSArray * name = @[@"喊话1",@"喊话2",@"喊话3"];
    cell.textLabel.text = [name objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15.0];
    cell.textLabel.textColor = [UIColor color:k_defaultTextColor];
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"SindexPath"];
    if (_textValue == nil) {
        cell.detailTextLabel.text = [self.textArray objectAtIndex:indexPath.row];
    }
    else{
        cell.detailTextLabel.text = [self.textArray objectAtIndex:indexPath.row];
        NSString * indexPathrow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        if ([indexPathrow isEqualToString:index]) {
            cell.detailTextLabel.text = _textValue;
        }
    }
    
    cell.detailTextLabel.font = [UIFont fontWithName:k_fontName_FZZY size:13.0];
    cell.detailTextLabel.textColor = [UIColor color:k_defaultLightTextColor];
    cell.detailTextLabel.alpha = 0.6;
    
    [cell.contentView addSubview:[UIView view_sub:@{V_Parent_View:cell,
                                                    V_Height:@0.5,
                                                    V_BGColor:k_defaultLineColor,
                                                    }]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditCalloutViewController * vc = [[EditCalloutViewController alloc]init];
    vc.userid = [UserManager sharedInstance].userid;
    NSArray * name = @[@"喊话1",@"喊话2",@"喊话3"];
    vc.titleName = [name objectAtIndex:indexPath.row];
    vc.num = indexPath.row;
    vc.passValueDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    NSString * index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
     [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"SindexPath"];
    
}

- (void)passCalloutValue:(NSString *)value{
    _textValue = value;
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"SindexPath"];
    self.textArray[[index integerValue]] = value;
    [_callTable reloadData];
}
@end
