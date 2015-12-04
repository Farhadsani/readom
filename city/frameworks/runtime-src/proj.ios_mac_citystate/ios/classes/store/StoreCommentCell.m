//
//  StoreCommentCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreCommentCell.h"
#import "UIButton+WebCache.h"
#import "NSString+Extension.h"
#import "RatingView.h"
#import "StoreCommentImgsView.h"

@interface StoreCommentCell ()
@property (nonatomic, weak) UIButton *userIconBtn;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) RatingView *startReate;
@property (nonatomic, weak) UILabel *startReateLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) StoreCommentImgsView *commentImgsView;
@end

@implementation StoreCommentCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    StoreCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreCommentCell_ID];
    if (cell == nil) {
        cell = [[StoreCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoreCommentCell_ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle= UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    UIButton *userIconBtn = [[UIButton alloc]init];
    userIconBtn.contentMode = UIViewContentModeScaleAspectFill;
    userIconBtn.clipsToBounds = YES;
    self.userIconBtn = userIconBtn;
    [self.contentView addSubview:userIconBtn];
    [userIconBtn addTarget:self action:@selector(userIconBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *userIconBtnLayer = userIconBtn.layer;
    userIconBtnLayer.masksToBounds = YES;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    userNameLabel.textColor = k_defaultTextColor;
    [userNameLabel setFont:StoreCommentCellUserNameFont];
    
    RatingView *startReate = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 100, StoreCommentCellStartReateH)];
    startReate.star_height = StoreCommentCellStartReateH;
    startReate.userInteractionEnabled = NO;
    startReate.space_width = 5.0;
    [startReate setImagesDeselected:@"store_star_gray" partlySelected:@"store_star_grayyellow" fullSelected:@"store_star_yellow" andDelegate:nil];
    self.startReate = startReate;
    [self addSubview:startReate];
    
    UILabel *startReateLabel = [[UILabel alloc] init];
    self.startReateLabel = startReateLabel;
    [self.contentView addSubview:startReateLabel];
    startReateLabel.textColor = k_defaultTextColor;
    [startReateLabel setFont:StoreCommentCellStartReateLabelFont];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    timeLabel.textColor = gray_color;
    [timeLabel setFont:StoreCommentCellTimeLabelFont];
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    contentLabel.textColor = gray_color;
    [contentLabel setFont:StoreCommentCellContentFont];
    contentLabel.numberOfLines = 0;
    
    StoreCommentImgsView *commentImgsView = [[StoreCommentImgsView alloc] init];
    [self.contentView addSubview:commentImgsView];
    self.commentImgsView = commentImgsView;
}

- (void)setStoreCommentFrame:(StoreCommentFrame *)storeCommentFrame
{
    _storeCommentFrame = storeCommentFrame;
    StoreComment *storeComment = storeCommentFrame.storeComment;
    
    self.userIconBtn.frame = storeCommentFrame.userIconFrame;
    self.userIconBtn.layer.cornerRadius = self.userIconBtn.frame.size.width * 0.5;
    [self.userIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:storeComment.imglink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    
    self.userNameLabel.frame = storeCommentFrame.userNameFrame;
    self.userNameLabel.text = storeComment.name;

    self.startReate.frame = storeCommentFrame.startReateFrame;
    [self.startReate displayRating:[storeComment.rate floatValue]];
    
    self.startReateLabel.frame = storeCommentFrame.startReateLabelFrame;
    self.startReateLabel.text = [NSString stringWithFormat:@"%@分", storeComment.rate];
    
    self.timeLabel.frame = storeCommentFrame.timeLabelFrame;
    self.timeLabel.text = [storeComment.ctime timeString2DateString];
    
    if (storeComment.comment.length > 0) {
        self.contentLabel.hidden = NO;
        self.contentLabel.frame = storeCommentFrame.contentLabelFrame;
        self.contentLabel.text = storeComment.comment;
    } else {
        self.contentLabel.hidden = YES;
    }
    if (storeComment.photolink.count > 0) {
        self.commentImgsView.hidden = NO;
        self.commentImgsView.frame = storeCommentFrame.commentImgsViewFrame;
        self.commentImgsView.storeComment = storeComment;
    } else {
        self.commentImgsView.hidden = YES;
    }
}


- (void)userIconBtnDidOnClick:(UIButton *)button
{
//    BuddyStatusUser *user = self.noteItemFrame.noteItem.user;
//    if (![[UserManager sharedInstance] isCurrentUser:user.userid]) {
//        if ([self.delegate respondsToSelector:@selector(buddyStatusCell:userIconBtnDidOnClick:)]) {
//            [self.delegate buddyStatusCell:self userIconBtnDidOnClick:button];
//        }
//    }
}

@end
