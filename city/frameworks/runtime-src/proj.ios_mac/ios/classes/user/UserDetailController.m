//
//  UserDetailController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

/*
 *[个人详情]页面
 *功能：显示个人一些基本资料（性别、性取向、情感状况、星座）
 * 编辑基本资料
 */

#import "UserDetailController.h"
#import "UIViewController+Addtion.h"
#import "UserManager.h"

@interface UserDetailController ()
@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, weak) UILabel *userName;
@property (nonatomic, weak) UILabel *userIntro;
@property (nonatomic, weak) UILabel *sexLabel;
@property (nonatomic, weak) UILabel *sexOTLabel;
@property (nonatomic, weak) UILabel *loveLabel;
@property (nonatomic, weak) UILabel *horoLabel;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic , assign) CGFloat baseY;
@property (nonatomic, strong) NSMutableArray *viewsArray;

@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *sexOTArray;
@property (nonatomic, strong) NSArray *loveArray;
@property (nonatomic, strong) NSArray *horoArray;
@property (nonatomic, copy) NSString *selectedType;
@property (nonatomic, weak) UILabel *selectedLabel;

@property (nonatomic, assign) int index;
@property (nonatomic, assign) long userid;
@property (nonatomic, strong) UserDetailItem *userDetailItem;
@property (nonatomic, strong) UserBriefItem *userBriefItem;
@end

@implementation UserDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人详情";

    self.sexArray = [[NSArray alloc] initWithObjects:@"女生", @"男生", @"性别自由切换", @"内心是女生", @"内心是男生", @"现在是女生啦", @"现在是男生啦", @"尚未明确的性别", @"保密", nil];
    self.sexOTArray = [[NSArray alloc] initWithObjects:@"异性恋", @"同志", @"女女", @"性别无关之爱", @"无欲望者", @"二禁恋(只爱二次元)", @"唯物主义", @"宠物恋", @"绝对自恋", @"保密", nil];
    self.loveArray = [[NSArray alloc] initWithObjects:@"单身待解救", @"疯狂找对象", @"疗伤中勿扰", @"备胎收集癖", @"备胎等上位", @"墙角有点松", @"不虐狗难受", @"你管得着吗", @"我是处女座", nil];
    self.horoArray = [[NSArray alloc] initWithObjects:@"白羊座(3.21-4.19)", @"金牛座(4.20-5.20)", @"双子座(5.21-6.21)", @"巨蟹座(6.22-7.22)", @"狮子座(7.23-8.22)", @"处女座(8.23-9.22)", @"天秤座(9.23-10.23)", @"天蝎座(10.24-11.22)", @"射手座(11.23-12.21)", @"摩羯座(12.22-1.19)", @"水瓶座(1.20-2.18)", @"双鱼座(2.19-3.20)", nil];
  
    [self setupMainView];
    
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        self.userBriefItem = [UserManager sharedInstance].brief;
        self.userDetailItem = [UserManager sharedInstance].detail;
    } else {
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

#pragma mark - view init
- (void)setupMainView
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;

    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    CALayer *bgViewLayer = bgView.layer;
    bgViewLayer.borderColor = [UIColor color:green_color].CGColor;
    bgViewLayer.borderWidth = 0.5;
    bgViewLayer.cornerRadius = 5;
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    self.userIcon = userIcon;
    [self.contentView addSubview:userIcon];
    CGFloat userIconWH = 70;
    userIcon.frame = CGRectMake((screenW-userIconWH) * 0.5, 20, userIconWH, userIconWH);
    userIcon.layer.cornerRadius = userIcon.frame.size.width * 0.5;
    userIcon.clipsToBounds = YES;
    if (self.userBriefItem.thumbdata != nil) {
        [userIcon setImage:[UIImage imageWithData:self.userBriefItem.thumbdata]];
    } else {
        [userIcon setImage:[UIImage imageNamed:@"res/user/0.png"]];
    }
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userIcon.frame) + 15, screenW, 25)];
    self.userName = userName;
    [self.contentView addSubview:userName];
    userName.textAlignment = NSTextAlignmentCenter;
//    userName.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    userName.textColor = [UIColor colorWithRed:93.0/255.0 green:73.0/255.0 blue:61.0/255.0 alpha:0.8];
    userName.font = [UIFont fontWithName:k_fontName_FZZY size:13.0];
    
    UILabel *userIntro = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userName.frame) + 10, screenW, 25)];
    self.userIntro = userIntro;
    userIntro.font = [UIFont fontWithName:k_fontName_FZZY size:14.0];
    userIntro.textAlignment = NSTextAlignmentCenter;
//    userIntro.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    userIntro.textColor = [UIColor colorWithRed:93.0/255.0 green:73.0/255.0 blue:61.0/255.0 alpha:0.8];

    [self.contentView addSubview:userIntro];

    self.viewsArray = [NSMutableArray array];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
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
            
            UserDetailItem *userDetaiItem = [[UserDetailItem alloc] init];
            userDetaiItem.sex = [res objectForKey:@"sex"];
            userDetaiItem.sexot = [res objectForKey:@"sexot"];
            userDetaiItem.love = [res objectForKey:@"love"];
            userDetaiItem.horo = [res objectForKey:@"horo"];
            self.userDetailItem = userDetaiItem;
        });
        
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatedetail]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *params = [req.data_dict objectOutForKey:k_r_postData][@"params"];
            // 更新UserManager的数据
            [[UserManager sharedInstance] updateUserData:params];
            // 更新用户界面数据
            UILabel *label = self.selectedLabel;
            if (label != nil) {
                NSString *value = params[self.selectedType];
                CGSize labelSize = [value sizeWithFont:label.font];
                CGRect labelFrame = label.frame;
                labelFrame.origin.x  -= (labelSize.width - labelFrame.size.width);
                labelFrame.size.width = labelSize.width;
                label.frame = labelFrame;
//                label.font = [UIFont fontWithName:@"FZY3JW—GB1-0" size:12];
                label.text = value;
            }
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        InfoLog(@"error:%@", error);
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_updatedetail]) {
        InfoLog(@"error:%@", error);
    }
}

#pragma mark - action
- (void)setUserBriefItem:(UserBriefItem *)userBriefItem
{
    _userBriefItem = userBriefItem;
    
    
    if (userBriefItem.thumbdata) {
        [self.userIcon setImage:[UIImage imageWithData:userBriefItem.thumbdata]];
    } else {
        [self.userIcon setImage:[UIImage imageNamed:@"res/user/0.png"]];
    }
    self.userName.text = userBriefItem.name;
    self.userIntro.text = userBriefItem.intro;
}

/**
 *  重写UserDetailItem的setter方法，同时创建修改详情行控件
 */
- (void)setUserDetailItem:(UserDetailItem *)userDetailItem
{
    _userDetailItem = userDetailItem;
    
    [self.viewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewsArray removeAllObjects];
    self.sexLabel = [self setUserItemWithCaptionValue:@"性别" LabelValue:userDetailItem.sex index:1 NSArray:self.sexArray];
    self.sexOTLabel = [self setUserItemWithCaptionValue:@"性取向" LabelValue:userDetailItem.sexot index:2 NSArray:self.sexOTArray];
    self.loveLabel = [self setUserItemWithCaptionValue:@"情感状态" LabelValue:userDetailItem.love index:3 NSArray:self.loveArray];
    self.horoLabel = [self setUserItemWithCaptionValue:@"星座" LabelValue:userDetailItem.horo index:4 NSArray:self.horoArray];
}

/**
 *  创建详情条目
 */
- (UILabel *)setUserItemWithCaptionValue:(NSString*)strCaption LabelValue:(NSString*)strValue index:(long)index NSArray:(NSArray*)array
{
    UILabel *caption = [[UILabel alloc]init];
    UILabel *label = [[UILabel alloc]init];
    UIButton *button = [[UIButton alloc]init];
    
    //FZY1JW--GB1-0 方正细圆    FZY3JW--GB1-0  方正准圆
    caption.font = [UIFont fontWithName:k_fontName_FZZY size:18.0];
    caption.textColor = UIColorFromRGB(0xb29474, 1.0f);
    label.font = [UIFont fontWithName:k_fontName_FZXY size:16.0];
    
    label.textColor = UIColorFromRGB(0xb29474, 1.0f);
    CGSize captionSize = [strCaption sizeWithFont:caption.font];
    CGSize labelSize = [strValue sizeWithFont:label.font];
    CGRect mainRect = [[UIScreen mainScreen]bounds];
    
    CGFloat padding = 20;
    CGFloat subviewMargin = 10;
    CGFloat lineHight = 56;
    CGFloat imageWH = 22;
    
    CGFloat baseY = 140;
    if (self.userBriefItem.intro == nil) {
        baseY = 100;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_%ld.png", index]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat imageViewW = imageWH;
    CGFloat imageViewH = imageWH;
    CGFloat imageViewX = padding + subviewMargin;
    CGFloat imageViewY = baseY + (lineHight - imageViewH) * 0.5 + index * lineHight;
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.contentView addSubview:imageView];
    
    CGFloat captionX = CGRectGetMaxX(imageView.frame) + subviewMargin;
    CGFloat captionY = baseY + index * lineHight;
    CGFloat captionW = captionSize.width;
    CGFloat captionH = lineHight;
    caption.frame = CGRectMake(captionX, captionY, captionW, captionH);
    caption.text = strCaption;
    
    CGFloat buttonWH = 16;
    CGFloat buttonW = buttonWH + subviewMargin;
    CGFloat buttonH = buttonWH;
    CGFloat buttonX = mainRect.size.width - padding - buttonW;
    CGFloat buttonY = caption.frame.origin.y + (lineHight - buttonH) * 0.5;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setImage:[UIImage imageNamed:@"arr.png"] forState:UIControlStateNormal];
    
    CGFloat labelW = labelSize.width;
    CGFloat labelH = lineHight;
    CGFloat labelX = buttonX - subviewMargin - labelW;
    CGFloat labelY = captionY;
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    label.text = strValue;
    
    if (index != 4) {
        CGFloat lineW = CGRectGetMaxX(button.frame) - captionX;
        CGFloat lineH = 0.5;
        CGFloat lineX = captionX;
        CGFloat lineY = CGRectGetMaxY(caption.frame) - 1;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        line.backgroundColor = [UIColor color:green_color];
        [self.contentView addSubview:line];
        [self.viewsArray addObject:line];
    } else {
        CGFloat bgViewX = padding;
        CGFloat bgViewY = baseY + lineHight;
        CGFloat bgViewW = mainRect.size.width - 2 * padding;
        CGFloat bgViewH = index * lineHight;
        self.bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    }
    
    [button setImage:[UIImage imageNamed:@"arr"] forState:UIControlStateNormal];
    
    caption.text = strCaption;
    label.text = strValue;
    
    [self.contentView addSubview:caption];
    [self.viewsArray addObject:caption];
    [self.contentView addSubview:label];
    [self.viewsArray addObject:label];
    [self.contentView addSubview:button];
    [self.viewsArray addObject:button];
    
    // 给详情行增加一个遮罩，使得整行可以被点击
    UIControl *tapView = [[UIControl alloc] init];
    tapView.tag = index;
    CGFloat tapViewX = padding;
    CGFloat tapViewY = captionY;
    CGFloat tapViewW = mainRect.size.width - 2 * padding;
    CGFloat tapViewH = lineHight;
    tapView.frame = CGRectMake(tapViewX, tapViewY, tapViewW, tapViewH);
    [tapView addTarget:self action:@selector(tapViewOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tapView];
    [self.viewsArray addObject:tapView];
    if (self.userid == [UserManager sharedInstance].detail.userid) {
        tapView.userInteractionEnabled = YES;
    } else {
        tapView.userInteractionEnabled = NO;
    }
    
    return label;
}

/**
 *  处理详情行点击
 */
-(void)tapViewOnClick:(UIControl *)tapView
{
    NSMutableArray *arr = [NSMutableArray array];
    __block NSString *defaultSelected = @"";
    switch (tapView.tag) {
        case 1:
            [arr addObjectsFromArray:self.sexArray];
            defaultSelected = [UserManager sharedInstance].detail.sex;
            self.selectedType = @"sex";
            self.selectedLabel = self.sexLabel;
            break;
        case 2:
            [arr addObjectsFromArray:self.sexOTArray];
            defaultSelected = [UserManager sharedInstance].detail.sexot;
            self.selectedType = @"sexot";
            self.selectedLabel = self.sexOTLabel;
            break;
        case 3:
            [arr addObjectsFromArray:self.loveArray];
            defaultSelected = [UserManager sharedInstance].detail.love;
            self.selectedType = @"love";
            self.selectedLabel = self.loveLabel;
            break;
        case 4:
            [arr addObjectsFromArray:self.horoArray];
            [self.horoArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
                if ([str hasPrefix:[UserManager sharedInstance].detail.horo]) {
                    defaultSelected = str;
                    stop = YES;
                }
            }];
            self.selectedType = @"horo";
            self.selectedLabel = self.horoLabel;
            break;
        default:
            break;
    }
    [arr addObject:@"取消"];
    [self showConfirmSelectedView:arr defaultSelected:defaultSelected SEL:@selector(clickSelectedItem:) hasBackColor:YES clickBackDismiss:YES animation:YES];
}

/**
 *  处理弹出对话框中的点击事件
 */
- (void)clickSelectedItem:(id)sender{
    [self hiddenSelectedView];
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        return ;
    }
    
    // 网络请求，更新选择结果
    NSString *value = btn.titleLabel.text;
    if (self.selectedLabel == self.horoLabel) {
        value = [value substringToIndex:3];
    }
    NSDictionary * params = @{self.selectedType:value,
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_updatedetail,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - other method
- (void)setUserData:(long)userID
{
    self.userid = userID;
}

- (void)baseBack:(id)sender
{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if( callback ){
//        callback( 1 );
//    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}
@end
