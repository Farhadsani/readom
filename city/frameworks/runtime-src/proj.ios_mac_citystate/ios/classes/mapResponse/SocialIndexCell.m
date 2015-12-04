//
//  SocialIndexCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/23.
//
//

#import "SocialIndexCell.h"
#import "UIButton+WebCache.h"

@interface SocialIndexCell ()
@property (nonatomic, weak) UIButton *userIconBtn;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel *introLabel;
@property (nonatomic, weak) UIImageView *arrowIV;
@property (nonatomic, weak) UIView * line;
@end

@implementation SocialIndexCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    SocialIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:SocialIndexCell_ID];
    if (cell == nil) {
        cell = [[SocialIndexCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SocialIndexCell_ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *userIconBtn = [[UIButton alloc]init];
    self.userIconBtn = userIconBtn;
    [self.contentView addSubview:userIconBtn];
    CALayer *userIconBtnLayer = userIconBtn.layer;
    userIconBtnLayer.masksToBounds = YES;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    userNameLabel.textColor = darkGary_color;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userNameLabel setFont:SocialIndexCellUserNameFont];
    
    UIImageView *arrowIV = [[UIImageView alloc] init];
    self.arrowIV = arrowIV;
    [self.contentView addSubview:arrowIV];
    [arrowIV setImage:[UIImage imageNamed:@"buddystatus_arrow.png"]];
    arrowIV.contentMode = UIViewContentModeCenter;
    
    UILabel *introLabel = [[UILabel alloc] init];
    self.introLabel = introLabel;
    [self.contentView addSubview:introLabel];
    introLabel.textColor = gray_color;
    [introLabel setFont:SocialIndexCellIntroFont];
    
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    self.line = line;
    [self.contentView addSubview:line];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat userIconWH = 45;
    CGFloat userIconX = SocialIndexCellSubviewsMargin * 2;
    CGFloat userIconY = SocialIndexCellSubviewsMargin;
    CGFloat userIconW = userIconWH;
    CGFloat userIconH = userIconWH;
    self.userIconBtn.frame = CGRectMake(userIconX, userIconY, userIconW, userIconH);
    self.userIconBtn.layer.cornerRadius = self.userIconBtn.frame.size.width * 0.5;
    
    CGFloat arrowIVY = userIconY;
    CGFloat arrowIVH = userIconH;
    CGFloat arrowIVW = arrowIVH;
    CGFloat arrowIVX = cellWidth - arrowIVW;
    self.arrowIV.frame = CGRectMake(arrowIVX, arrowIVY, arrowIVW, arrowIVH);
    
    CGFloat userNameX = CGRectGetMaxX(self.userIconBtn.frame) + SocialIndexCellSubviewsMargin;
    CGFloat userNameY = userIconY;
    CGFloat userNameH = userIconH / 2;
    CGFloat userNameW = CGRectGetMidX(self.arrowIV.frame) - CGRectGetMaxX(self.userIconBtn.frame) - 2 * SocialIndexCellSubviewsMargin;
    self.userNameLabel.frame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    
    CGFloat introLabelX = userNameX;
    CGFloat introLabelY = CGRectGetMaxY(self.userNameLabel.frame);
    CGFloat introLabelW = userNameW;
    CGFloat introLabelH = userNameH;
    self.introLabel.frame = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
    
    self.line.frame = CGRectMake(10, userIconWH + 11, cellWidth - 20, 0.5);
    
    if (self.introLabel.text.length == 0) {
        self.introLabel.frame = CGRectMake(introLabelX, introLabelY, introLabelW, 0);
        self.userNameLabel.frame = CGRectMake(userNameX, 0, userNameW, self.height);
    }
}

- (void)setBuddyStatusUser:(BuddyStatusUser *)buddyStatusUser
{
    _buddyStatusUser = buddyStatusUser;
    [self.userIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:buddyStatusUser.imglink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    self.userNameLabel.text = buddyStatusUser.name;
    self.introLabel.text = buddyStatusUser.intro;
}
@end
