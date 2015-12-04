//
//  AboutViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/15.
//
//

/*
 *【关于城邦】界面
 *功能：城邦简介、分享应用、好评、反馈意见
 *
 */
#import "AboutViewController.h"
#import "UserManager.h"
#import "FeedBackController.h"
#import "SharedView.h"
#import "ExceptionEngine.h"

#define CellHeight 44
#define text_Color             rgb(104, 104, 104)
@implementation FollowItem
@synthesize strCaption, callBack;
- (id)init:(NSString*)title :(SEL) s
{
    self = [super init];
    if (self) {
        strCaption = title;
        callBack = s;
    }
    return self;
}
@end

@interface AboutViewController () <UIAlertViewDelegate>
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *iconLabel;
@property (nonatomic, weak) UILabel *introTitleLabel;
@property (nonatomic, weak) UILabel *introLabel;
@property (nonatomic, weak) UILabel *followTitleLabel;
@property (nonatomic, weak) UITableView *followTV;

@property (nonatomic, strong) NSMutableArray *followArray;
@end

@implementation AboutViewController

NSString *strIntro = @"城邦是一款城市在线手绘地图，拥有全国热门旅游目的地城市20个，一键查询目的地热门景点游览信息。直观可视化的了解景点路线分布。";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:k_defaultViewControllerBGColor];
    self.title = @"关于";
    
    _followArray = [[NSMutableArray alloc]init];
    [_followArray addObject:[[FollowItem alloc]init:@"分享应用" :@selector(share)]];
    [_followArray addObject:[[FollowItem alloc]init:@"微信" :@selector(wx)]];
    [_followArray addObject:[[FollowItem alloc]init:@"微博" :@selector(wb)]];
    [_followArray addObject:[[FollowItem alloc]init:@"给个好评" :@selector(judge)]];
    [_followArray addObject:[[FollowItem alloc]init:@"反馈" :@selector(feedBack)]];
    
    [self setupMainView];
}

#pragma mark - view init
- (void)setupMainView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];

    CGFloat imageViewWH = 65;
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, imageViewWH, imageViewWH)];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    iconView.image = [UIImage imageNamed:@"icon-100"];
    [iconView.layer setCornerRadius:15];
    iconView.clipsToBounds = YES;
    iconView.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    iconView.layer.borderWidth = 0.5;
    
    UILabel *iconLabel = [[UILabel alloc]init];
    self.iconLabel = iconLabel;
    [self.contentView addSubview:iconLabel];
    [iconLabel setTextAlignment:NSTextAlignmentCenter];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"城邦 v%@", version];
    CGSize labeSize = [versionString sizeWithFont:iconLabel.font];
    iconLabel.text = versionString;
    iconLabel.textColor = text_Color;
    CGFloat iconH = imageViewWH /2;
    iconLabel.frame = CGRectMake(iconView.width + 15,iconH, applicationFrame.size.width, labeSize.height);
    iconLabel.textAlignment = TextAlignLeft;
    iconLabel.font = [UIFont fontWithName:k_fontName_FZZY size:14];
    
    CGFloat  lineH = imageViewWH +20;
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(10, lineH, applicationFrame.size.width - 10 * 2, 0.4);
    line1.backgroundColor = k_defaultLineColor;
    [self.contentView addSubview:line1];

    
    UILabel *introTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineH + 5 , 100, 20)];
    self.introTitleLabel = introTitleLabel;
    [self.contentView addSubview:introTitleLabel];
    introTitleLabel.text = @"简介";
    introTitleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
    introTitleLabel.textColor = k_defaultTextColor;
    
    CGFloat introH = lineH + introTitleLabel.height;
    UILabel *introLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,introH +5, applicationFrame.size.width-24, 65)];
    self.introLabel = introLabel;
    [self.contentView addSubview:introLabel];
    introLabel.backgroundColor = [UIColor whiteColor];
    introLabel.numberOfLines = 3;
    introLabel.textAlignment = TextAlignLeft;
    //行间距
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineSpacing = 6.0;
    mParaStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dict  = @{NSFontAttributeName : [UIFont fontWithName:k_fontName_FZXY size:13], NSForegroundColorAttributeName:text_Color, NSParagraphStyleAttributeName: mParaStyle};
    NSMutableAttributedString * attText = [[NSMutableAttributedString alloc]initWithString:strIntro attributes:dict];
    self.introLabel.attributedText = attText;

    bgView.frame = CGRectMake(0, 0, self.contentView.width, introH + introLabel.height+5);
    
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(0, bgView.height, applicationFrame.size.width, 0.5);
    line2.backgroundColor = k_defaultLineColor;
    [self.contentView addSubview:line2];


    //FZY1JW--GB1-0 方正细圆    FZY3JW--GB1-0  方正准圆
    UIView *line3 = [[UIView alloc] init];
    line3.frame = CGRectMake(0, CGRectGetMaxY(introLabel.frame)+5, applicationFrame.size.width, 0.5);
    line3.backgroundColor = k_defaultLineColor;
    [self.contentView addSubview:line3];
    
    UILabel *followTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(introLabel.frame)+5.5, self.contentView.width, 30)];
    self.followTitleLabel = followTitleLabel;
    followTitleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
    followTitleLabel.text = @"   关注城邦";
    followTitleLabel.textColor = k_defaultTextColor;
    followTitleLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:followTitleLabel];

    UITableView *followTV = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(followTitleLabel.frame), applicationFrame.size.width, 5 * CellHeight)];
    self.followTV = followTV;
    [followTV setBackgroundColor:white_color];
    followTV.separatorStyle = NO;
    followTV.scrollEnabled = NO;
    followTV.separatorColor = [UIColor clearColor];
    followTV.delegate = self;
    followTV.dataSource = self;
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:followTV,
                                       V_Width:strFloat(self.contentView.width),
                                       V_Height:@0.5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [self.contentView addSubview:line];

    [self.contentView addSubview:followTV];
    
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowItem *item = [_followArray objectAtExistIndex:indexPath.row];
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CalloutViewCell"];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, 30),
                                             V_Img:@"buddystatus_arrow",
                                             V_ContentMode:num(ModeCenter),
                                             }];
    NSArray * imageIcon = [NSArray arrayWithObjects:[UIImage imageNamed:@"share"],[UIImage imageNamed:@"wechat"],[UIImage imageNamed:@"sina"],[UIImage imageNamed:@"feedback"],[UIImage imageNamed:@"praise"], nil];
    cell.imageView.image = [imageIcon objectAtIndex:indexPath.row];

    cell.textLabel.text = item.strCaption;
    cell.textLabel.textColor = text_Color;
    cell.textLabel.font = [UIFont fontWithName:k_fontName_FZXY size:14];
    
    if (indexPath.row != (imageIcon.count ==0 ) ) {
        [cell.contentView addSubview:[UIView view_sub:@{V_Parent_View:cell,
                                                        V_Margin_Left:@40,
                                                        V_Height:@0.5,
                                                        V_BGColor:k_defaultLineColor,
                                                        }]];

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowItem *item = [_followArray objectAtExistIndex:indexPath.row];
    if (item.callBack) {
        [self performSelector:item.callBack];
    }
    return;
}

#pragma mark - action
- (void)share{
    InfoLog(@"分享");
    
    SharedView *sharedView = [SharedView sharedview];
    [sharedView show];
}

- (void)wx{
    InfoLog(@"微信");
    [[UIPasteboard generalPasteboard] setString:@"石头人"];
    [[ExceptionEngine shared]alertTitle:@"已复制微信公众号" message:@"跳转到微信关注我们" delegate:self tag:100 cancelBtn:@"取消" btn1:@"确定" btn2:nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已复制微信公众号，跳转到微信关注我们" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 100;
//    [alert show];
}

- (void)wb{
    InfoLog(@"微博");
    [[UIPasteboard generalPasteboard] setString:@"城邦"];
    [[ExceptionEngine shared]alertTitle:@"已复制微博帐号" message:@"跳转到微博关注我们" delegate:self tag:200 cancelBtn:@"取消" btn1:@"确定" btn2:nil];
//     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已复制微博账号，跳转到微博关注我们" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 200;
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 && buttonIndex == 1) { // 微信
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
    } else if (alertView.tag == 200 && buttonIndex == 1) { // 微博
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weibo://"]];
    }
}

- (void)judge{
    InfoLog(@"给个好评");
//    [self showAppInApp:@"992730518"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cheng-shi-da-ren/id992730518?mt=8"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cheng-bang/id1058188800?mt=8"]];
}

- (void)feedBack{
    InfoLog(@"反馈");
    
    FeedBackController *fbvc = [[FeedBackController alloc] init];
    [self.navigationController pushViewController:fbvc animated:YES];
}

#pragma mark - other method
- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)showAppInApp:(NSString *)_appId {
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        [[LoadingView shared] showLoading:nil message:@"正在打开评论页面..."];
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    [[LoadingView shared] hideLoading];
                                                    if (result) {
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                    }
                                                    else{
                                                        NSLog(@"%@",error);
                                                    }
                                                }];
    }
    else{
        //低于iOS6没有这个类
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cheng-bang/id1058188800?mt=8"]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cheng-shi-da-ren/id992730518?mt=8"]];
//        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",_appId];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate

//对视图消失的处理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
}

@end
