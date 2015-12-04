//
//  BuddyStatusCommentCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import "BuddyStatusCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSString+Extension.h"

#define BuddyStatusCommentCell_ID @"BuddyStatusCommentCell"

@interface BuddyStatusCommentCell ()
@property (nonatomic, weak) UIButton *userIconBtn;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *commentTextLabel;
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UIControl *tapUserBg;
@end

@implementation BuddyStatusCommentCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    BuddyStatusCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:BuddyStatusCommentCell_ID];
    if (cell == nil) {
        cell = [[BuddyStatusCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BuddyStatusCommentCell_ID];
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *userIconBtn = [[UIButton alloc]init];
    self.userIconBtn = userIconBtn;
    [self.contentView addSubview:userIconBtn];
    CALayer *userIconBtnLayer = userIconBtn.layer;
    userIconBtnLayer.masksToBounds = YES;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    userNameLabel.textColor = k_defaultTextColor;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userNameLabel setFont:BuddyStatusCommentCellUserNameFont];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    dateLabel.textColor = k_defaultLightTextColor;
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel setFont:BuddyStatusCommentCellDateFont];
    
    UILabel *commentTextLabel = [[UILabel alloc] init];
    self.commentTextLabel = commentTextLabel;
    [self.contentView addSubview:commentTextLabel];
    commentTextLabel.textColor = k_defaultTextColor;
    commentTextLabel.alpha = 0.7;
    commentTextLabel.backgroundColor = [UIColor clearColor];
    [commentTextLabel setFont:BuddyStatusCommentCellCommentTextFont];
    commentTextLabel.numberOfLines = 0;
    
//    UIControl *tapUserBg = [[UIControl alloc] init];
//    tapUserBg.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:tapUserBg];
//    self.tapUserBg = tapUserBg;
//    [tapUserBg addTarget:self action:@selector(tapUserBgDidOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBuddyStatusCommentFrame:(BuddyStatusCommentFrame *)buddyStatusCommentFrame
{
    _buddyStatusCommentFrame = buddyStatusCommentFrame;
    BuddyStatusComment *buddyStatusComment = buddyStatusCommentFrame.buddyStatusComment;
    
    self.userIconBtn.frame = buddyStatusCommentFrame.userIconFrame;
    self.userIconBtn.layer.cornerRadius = self.userIconBtn.frame.size.width * 0.5;
    [self.userIconBtn sd_setImageWithURL:[NSURL URLWithString:buddyStatusComment.user.thumblink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    self.userIconBtn.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    self.userIconBtn.layer.borderWidth = 0.5;
    
//    NSString * imglink = (buddyStatusComment.user.imglink.length == 0) ? buddyStatusComment.user.imglink : buddyStatusComment.user.imglink;
//    if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
//        [self.userIconBtn setImage:[[Cache shared].pics_dict objectOutForKey:imglink] forState:UIControlStateNormal];
//    }
//    else{
//        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
//        if (img) {
//            [self.userIconBtn setImage:img forState:UIControlStateNormal];
//            [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
//        }
//    }
    
    self.userNameLabel.frame = buddyStatusCommentFrame.userNameFrame;
    self.userNameLabel.text = buddyStatusComment.user.name;
    
    self.dateLabel.frame = buddyStatusCommentFrame.dateFrame;
    self.dateLabel.text = [buddyStatusComment.ctime timeString2DateString];
    
    self.commentTextLabel.frame = buddyStatusCommentFrame.commentTextFrame;
    self.commentTextLabel.text = buddyStatusComment.comment;
    
//    self.tapUserBg.frame = CGRectMake(CGRectGetMinX(self.userIconBtn.frame), CGRectGetMinY(self.userIconBtn.frame), CGRectGetMaxX(self.userNameLabel.frame) - CGRectGetMinX(self.userIconBtn.frame), CGRectGetHeight(self.userIconBtn.frame));
}

//- (void)tapUserBgDidOnClick
//{
//    BuddyStatusUser *user = self.buddyStatusCommentFrame.buddyStatusComment.user;
//    if (![[UserManager sharedInstance] isCurrentUser:user.userid]) {
//        
//    }
//}
@end
