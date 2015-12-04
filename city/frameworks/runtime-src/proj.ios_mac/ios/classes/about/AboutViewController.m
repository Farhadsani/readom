//
//  AboutViewController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/15.
//
//

/*
 *【关于城市达人】界面
 *功能：城市达人简介、分享应用、好评、反馈意见
 *
 */
#import "AboutViewController.h"
#import "UserManager.h"
#import "FeedBackController.h"
#import "SharedView.h"

#define CellHeight 44

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

NSString *strIntro = @"城市达人是一款城市在线手绘地图，拥有全国热门旅游目的地城市20个，一键查询目的地热门景点游览信息。直观可视化的了解景点路线分布。";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0f)];
    self.title = @"关于城市达人";
    
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
    CGFloat imageViewWH = 75;
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(applicationFrame.size.width/2 - imageViewWH * 0.5, 15, imageViewWH, imageViewWH)];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    iconView.image = [UIImage imageNamed:@"icon-100"];
    [iconView.layer setCornerRadius:imageViewWH * 0.5];
    iconView.clipsToBounds = YES;
    
    UILabel *iconLabel = [[UILabel alloc]init];
    self.iconLabel = iconLabel;
    [self.contentView addSubview:iconLabel];
    [iconLabel setTextAlignment:NSTextAlignmentCenter];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"城市达人 V%@", version];
    CGSize labeSize = [versionString sizeWithFont:iconLabel.font];
    iconLabel.text = versionString;
    iconLabel.textColor = UIColorFromRGB(0xb29474, 1.0f);
    iconLabel.frame = CGRectMake(0, 100, applicationFrame.size.width, labeSize.height);
    iconLabel.font = [UIFont fontWithName:@"FZY1JW—-GB1-0" size:12];
    iconLabel.alpha = 0.7;
    
    UILabel *introTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 100, 30)];
    self.introTitleLabel = introTitleLabel;
    [self.contentView addSubview:introTitleLabel];
    introTitleLabel.text = @"简介";
    introTitleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
    introTitleLabel.textColor = UIColorFromRGB(0xb29474, 1.0f);
    
    UILabel *introLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 160, applicationFrame.size.width-24, 50)];
    self.introLabel = introLabel;
    [self.contentView addSubview:introLabel];
    introLabel.font = [UIFont fontWithName:k_fontName_FZXY size:11];
    introLabel.text = strIntro;
    introLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    introLabel.numberOfLines = 0;
    CGSize introSize = [strIntro sizeWithFont:introLabel.font forWidth:applicationFrame.size.width-24 lineBreakMode:NSLineBreakByWordWrapping];
    
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(10, 130, applicationFrame.size.width - 10 * 2, 0.4);
    line1.backgroundColor = UIColorFromRGB(0xd1c2b2, 1.0f);
    [self.contentView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(10, 200 +introSize.height, applicationFrame.size.width - 10 * 2, 0.4);
    line2.backgroundColor = UIColorFromRGB(0xd1c2b2, 1.0f);
    [self.contentView addSubview:line2];
    
    //FZY1JW--GB1-0 方正细圆    FZY3JW--GB1-0  方正准圆
    UILabel *followTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(introLabel.frame)+10, 100, 30)];
    self.followTitleLabel = followTitleLabel;
    [self.contentView addSubview:followTitleLabel];
    followTitleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:15];
    followTitleLabel.text = @"关注我们";
    followTitleLabel.textColor = UIColorFromRGB(0xb29474, 1.0f);
    
    UITableView *followTV = [[UITableView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(followTitleLabel.frame) + 5, applicationFrame.size.width-24, 5 * CellHeight)];
    self.followTV = followTV;
    [self.contentView addSubview:followTV];
    [followTV setBackgroundColor:UIColorFromRGB(0xf7f8f9, 1.0f)];
    followTV.layer.cornerRadius = 5;
    followTV.layer.borderColor = UIColorFromRGB(0x99d472, 1.0f).CGColor;
    followTV.layer.borderWidth = 0.5;
    followTV.delegate = self;
    followTV.dataSource = self;
    followTV.scrollEnabled = NO;
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowItem *item = [_followArray objectAtExistIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, pTableView.frame.size.width, CellHeight)];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = item.strCaption;
    cell.textLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    cell.textLabel.font = [UIFont fontWithName:k_fontName_FZXY size:14];
    CGFloat imageViewH = 15;
    CGFloat imageViewW = 10;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(pTableView.frame.size.width-25, (CellHeight - imageViewH) * 0.5, imageViewW, imageViewH)];
    [imgView setImage:[UIImage imageNamed:@"base-3-1.png"]];
    [cell addSubview:imgView];
    return cell;
}

-(void)tableView:(UITableView *)pTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已复制微信公众号，跳转到微信关注我们" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
}

- (void)wb{
    InfoLog(@"微博");
    [[UIPasteboard generalPasteboard] setString:@"城市达人APP"];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已复制微博账号，跳转到微博关注我们" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 200;
    [alert show];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cheng-shi-da-ren/id992730518?mt=8"]];
}

- (void)feedBack{
    InfoLog(@"反馈");
    
    FeedBackController *fbvc = [[FeedBackController alloc] init];
    [self.navigationController pushViewController:fbvc animated:YES];
}

#pragma mark - other method
- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if(callback){
//        callback( 1 );
//    }
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cheng-shi-da-ren/id992730518?mt=8"]];
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
