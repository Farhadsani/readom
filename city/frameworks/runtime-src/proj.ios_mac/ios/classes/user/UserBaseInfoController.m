//
//  UserBaseInfoController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

/*
 *[基本资料]页面
 *功能：显示用户的名称、个人简介
 * 登出帐号 功能
 */

#import "UserBaseInfoController.h"
#import "UserManager.h"
#import "UIViewController+Addtion.h"
#import "UserBaseInfoEditController.h"

@interface UserBaseInfoController ()
@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, weak) UILabel *userName;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *zoneLabel;
@property (nonatomic, weak) UILabel *introLabel;
@property (nonatomic, weak) UIButton *logoutBtn;

@property (nonatomic, assign) int index;
@property (nonatomic, assign) long userid;
@property (nonatomic, strong) UserBriefItem *userBriefItem;
@end

@implementation UserBaseInfoController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本资料";
    
    [self setupMainView];
    
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        self.userBriefItem = [UserManager sharedInstance].brief;
    } else {
        self.logoutBtn.hidden = YES;
        
        NSDictionary * params = @{@"userid": @(self.userid)
                                  };
        NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = @{k_r_url:k_api_user_getuser,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateViewInf];
}

#pragma mark - request delegate

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signout]) {
        [self showMessageView:@"您已退出登录!" delayTime:2.0];
        
        [[UserManager sharedInstance] signout];
        
        [self backAndRefresh];
    }  else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *res = result[@"res"];
            UserBriefItem *userBriefItem = [[UserBriefItem alloc] init];
            userBriefItem.name = [res objectForKey:@"name"];
            userBriefItem.intro = [res objectForKey:@"intro"];
            userBriefItem.zone = [res objectForKey:@"zone"];
            userBriefItem.imglink = [res objectForKey:@"imglink"];
            userBriefItem.thumblink = [res objectForKey:@"thumblink"];
            userBriefItem.thumbdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:userBriefItem.thumblink]];
            
            self.userBriefItem = userBriefItem;
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_signout]) {
        InfoLog(@"error:%@", error);
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        InfoLog(@"error:%@", error);
    }
}

#pragma mark - action

- (void)logoutBtnOnClick:(UIButton *)button{
    [self showConfirmSelectedView:@[@"退出登录", @"取消"] SEL:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

- (void)clickSelectedItem:(UIButton *)button{
    [self hiddenSelectedView];
    if ([button.titleLabel.text isEqualToString:@"退出登录"]) {
        NSLog(@"退出登录。。。");
        
        NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                                  };
        NSDictionary * dict = @{@"idx":str(0),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        NSDictionary * d = @{k_r_url:k_api_user_signout,
                             k_r_delegate:self,
                             k_r_postData:dict,
                             };
        [[ReqEngine shared] tryRequest:d];
    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}

- (void)backAndRefresh{
    [self dismissViewControllerAnimated:YES completion:^{
//        [self baseDeckAndNavBack];
//        [self toCocos:0 :nil :nil :nil :nil :nil];
    }];
//    [self baseBack:nil];
    [self baseDeckAndNavBack];
    [self toCocos:0 :@"" :@"" :@"" :@"" :@""];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if( callback ){
//        callback( 1 );
//    }
}

- (void)tapViewOnClick:(UIControl *)tapView{
    UserBaseInfoEditController *editController = [[UserBaseInfoEditController alloc] init];
    if (tapView.tag == 1) {
        editController.titleLabelType = UserBaseInfoTitleLabelTypeZone;
    } else if (tapView.tag == 2) {
        editController.titleLabelType = UserBaseInfoTitleLabelTypeIntro;
    }
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        editController.editable = YES;
    } else {
        editController.editable = NO;
    }
    if (self.userBriefItem != nil) {
        editController.userBriefItem = self.userBriefItem;
        [self.navigationController pushViewController:editController animated:YES];
    }
}

#pragma mark - view init

- (void)setupMainView{
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    CALayer *bgViewLayer = bgView.layer;
    bgViewLayer.borderColor = [UIColor color:green_color].CGColor;
    bgViewLayer.borderWidth = 0.5;
    bgViewLayer.cornerRadius = 5;
    
    CGRect mainRect = [[UIScreen mainScreen]bounds];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    self.userIcon = userIcon;
    [userIcon setImage:[UIImage imageNamed:@"res/user/0.png"]];
    userIcon.frame = CGRectMake((mainRect.size.width-80)/2, 30, 80, 80);
    userIcon.layer.cornerRadius = userIcon.frame.size.width/2;
    userIcon.clipsToBounds = YES;
    
    UILabel *userName = [[UILabel alloc]init];
    self.userName = userName;
//    userName.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    userName.textColor = [UIColor colorWithRed:178.0/255.0 green:148.0/255.0 blue:116.0/255.0 alpha:1];
    userName.font = [UIFont fontWithName:@"FZY3JW--GB1-0 " size:14.0];
    
    [self.contentView addSubview:userIcon];
    [self.contentView addSubview:userName];
    
    self.zoneLabel = [self setItemWithTitleValue:@"个人空间名称" descValue:self.userBriefItem.zone index:1];
    self.introLabel = [self setItemWithTitleValue:@"个人简介" descValue:self.userBriefItem.intro index:2];
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    self.logoutBtn = logoutBtn;
    [self.contentView addSubview:logoutBtn];
    [logoutBtn setTitle:@"登出账号" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor color:green_color] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:14];
//    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    
    [logoutBtn addTarget:self action:@selector(logoutBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *logoutBtnLayer = logoutBtn.layer;
    logoutBtnLayer.cornerRadius = 5;
    logoutBtnLayer.borderWidth = 0.5;
    logoutBtnLayer.borderColor = [UIColor color:green_color].CGColor;
}

- (void)updateViewInf{
    self.zoneLabel.text = self.userBriefItem.zone;
    self.introLabel.text = self.userBriefItem.intro;
}

#pragma mark - other method

- (UILabel *)setItemWithTitleValue:(NSString *)titleValue descValue:(NSString *)descValue index:(long)index{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:k_fontName_FZZY size:14];
//    titleLabel.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    titleLabel.textColor = [UIColor colorWithRed:178.0/255.0 green:148.0/255.0 blue:116.0/255.0 alpha:1];

    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentRight;
    descLabel.font = [UIFont fontWithName:k_fontName_FZXY size:14];
    descLabel.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    descLabel.textColor = [UIColor colorWithRed:178.0/255.0 green:148.0/255.0 blue:116.0/255.0 alpha:1];
    UIButton *button = [[UIButton alloc] init];
    
    CGRect mainRect = [[UIScreen mainScreen]bounds];
    CGSize titleLabelSize = [titleValue sizeWithFont:titleLabel.font];
    
    CGFloat padding = 20;
    CGFloat subviewMargin = 10;
    CGFloat lineHight = 50;
    CGFloat baseY = 120;
    
    CGFloat titleLabelX = padding + subviewMargin;
    CGFloat titleLabelY = baseY + index * lineHight;
    CGFloat titleLabelW = titleLabelSize.width;
    CGFloat titleLabelH = lineHight;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    CGFloat buttonWH = 16;
    CGFloat buttonW = buttonWH + subviewMargin;
    CGFloat buttonH = buttonWH;
    CGFloat buttonX = mainRect.size.width - padding - buttonW;
    CGFloat buttonY = titleLabel.frame.origin.y + (lineHight - buttonH) * 0.5;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    CGFloat descLabelW = mainRect.size.width - CGRectGetMaxX(titleLabel.frame) - padding - buttonW - subviewMargin - 30;
    CGFloat descLabelH = lineHight;
    CGFloat descLabelX = buttonX - subviewMargin - descLabelW + 15;
    CGFloat descLabelY = titleLabelY;
    descLabel.frame = CGRectMake(descLabelX, descLabelY, descLabelW, descLabelH);
    
    if (index != 2) {
        CGFloat lineW = CGRectGetMaxX(button.frame) - titleLabelX;
        CGFloat lineH = 0.5;
        CGFloat lineX = titleLabelX;
        CGFloat lineY = CGRectGetMaxY(titleLabel.frame) - 1;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        line.backgroundColor = [UIColor color:green_color];
        [self.contentView addSubview:line];
    } else {
        CGFloat bgViewX = padding;
        CGFloat bgViewY = baseY + lineHight;
        CGFloat bgViewW = mainRect.size.width - 2 * padding;
        CGFloat bgViewH = index * lineHight;
        self.bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    }
    
    [button setImage:[UIImage imageNamed:@"arr"] forState:UIControlStateNormal];
    
    UIControl *tapView = [[UIControl alloc] init];
    CGFloat tapViewX = padding;
    CGFloat tapViewY = titleLabelY;
    CGFloat tapViewW = mainRect.size.width - 2 * padding;
    CGFloat tapViewH = lineHight;
    tapView.frame = CGRectMake(tapViewX, tapViewY, tapViewW, tapViewH);
    //    tapView.backgroundColor = RandomColor;
    [tapView addTarget:self action:@selector(tapViewOnClick:) forControlEvents:UIControlEventTouchUpInside];
    tapView.tag = index;
    
    titleLabel.text = titleValue;
    descLabel.text = descValue;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:descLabel];
    [self.contentView addSubview:button];
    [self.contentView addSubview:tapView];
    
    return descLabel;
}

- (void)setUserBriefItem:(UserBriefItem *)userBriefItem
{
    _userBriefItem = userBriefItem;
    
    CGRect mainRect = [[UIScreen mainScreen]bounds];

    self.userIcon.frame = CGRectMake((mainRect.size.width-80)/2, 30, 80, 80);
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width/2;
    self.userIcon.clipsToBounds = YES;
    userBriefItem.thumbdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userBriefItem.thumblink]];
    if (userBriefItem.thumbdata) {
        [self.userIcon setImage:[UIImage imageWithData:userBriefItem.thumbdata]];
    } else {
        [self.userIcon setImage:[UIImage imageNamed:@"res/user/0.png"]];
    }
    
    CGSize size = [self.userBriefItem.name sizeWithFont:self.userName.font];
    self.userName.frame = CGRectMake((mainRect.size.width-size.width)/2, 125, size.width, size.height);
    self.userName.text = self.userBriefItem.name;
    
    [self.zoneLabel removeFromSuperview];
    [self.introLabel removeFromSuperview];
    self.zoneLabel = [self setItemWithTitleValue:@"个人空间名称" descValue:self.userBriefItem.zone index:1];
    self.introLabel = [self setItemWithTitleValue:@"个人简介" descValue:self.userBriefItem.intro index:2];
    
    CGFloat padding = 20;
    CGFloat logoutBtnX = padding;
    CGFloat logoutBtnY = 340;
    CGFloat logoutBtnW = mainRect.size.width - padding * 2;
    CGFloat logoutBtnH = 35;
    self.logoutBtn.frame = CGRectMake(logoutBtnX, logoutBtnY, logoutBtnW, logoutBtnH);
}

- (void)setUserData:(long)userID
{
    self.userid = userID;
}
@end
