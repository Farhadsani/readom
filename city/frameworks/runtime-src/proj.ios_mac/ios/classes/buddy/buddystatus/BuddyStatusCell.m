//
//  BuddyStatusCell.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "BuddyStatusCell.h"
#import "BuddyStatusNoteTagsView.h"
//#import "BuddyStatusNoteThumbView.h"
#import "BuddyStatusNoteNewThumbView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TagItem.h"
#import "BuddyStatusNotePlaceTagsView.h"
//#import "ZDProgressView.h"

#define BuddyStatusCell_ID @"BuddyStatusCell"

@interface BuddyStatusCell ()
@property (nonatomic, weak) UIButton *userIconBtn;
@property (nonatomic, weak) UILabel *userNameLabel;
//@property (nonatomic, weak) ZDProgressView *completePV;
//@property (nonatomic, weak) UILabel *completeLabel;
@property (nonatomic, weak) UILabel *userIntroLabel;
//@property (nonatomic, weak) BuddyStatusNoteThumbView *thumbView;
@property (nonatomic, weak) BuddyStatusNoteNewThumbView *thumbView;
@property (nonatomic, weak) BuddyStatusNoteTagsView *tagsView;
@property (nonatomic, weak) UILabel *noteTextLabel;
@property (nonatomic, weak) BuddyStatusNotePlaceTagsView *placeTagsView;
@property (nonatomic, weak) UILabel *topicTextLabel;
@property (nonatomic, weak) UIButton *likedBtn;
@property (nonatomic, weak) UIView *bgView; // 背景图片
@property (nonatomic, weak) UIImageView *arrowIV;

@property (nonatomic, assign) int index;
@end

@implementation BuddyStatusCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    BuddyStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:BuddyStatusCell_ID];
    if (cell == nil) {
        cell = [[BuddyStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BuddyStatusCell_ID];
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
//[好友动态]页面cell
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    // self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    bgView.layer.cornerRadius = 8;
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];

    
    UIButton *userIconBtn = [[UIButton alloc]init];
    self.userIconBtn = userIconBtn;
    [self.contentView addSubview:userIconBtn];
    [userIconBtn addTarget:self action:@selector(userIconBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *userIconBtnLayer = userIconBtn.layer;
    userIconBtnLayer.masksToBounds = YES;
    userIconBtnLayer.borderWidth = 2.0;
    userIconBtnLayer.borderColor = [UIColor whiteColor].CGColor;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    userNameLabel.textColor = UIColorFromRGB(0x666666, 1.0f);
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userNameLabel setFont:BuddyStatusCellUserNameFont];
    
    //cell中进度条控件
//    ZDProgressView *completePV = [[ZDProgressView alloc] init];
//    self.completePV = completePV;
//    [self.contentView addSubview:completePV];
//    completePV.noColor = [UIColor clearColor];
//    completePV.prsColor = [UIColor orangeColor];
//    completePV.alpha = 0.5;
//    CALayer *completePVLayer = completePV.layer;
//    completePVLayer.cornerRadius = 4;
//    completePVLayer.masksToBounds = YES;
//    completePVLayer.borderWidth = 1;
//    completePVLayer.borderColor = [UIColor orangeColor].CGColor;
//    
//    UILabel *completeLabel = [[UILabel alloc] init];
//    self.completeLabel = completeLabel;
//    [self.contentView addSubview:completeLabel];
//    completeLabel.textColor = [UIColor orangeColor];
//    completeLabel.backgroundColor = [UIColor clearColor];
//    completeLabel.textAlignment = NSTextAlignmentCenter;
//    [completeLabel setFont:BuddyStatusCellCompleteTextFont];
    
    UIImageView *arrowIV = [[UIImageView alloc] init];
    self.arrowIV = arrowIV;
    [self.contentView addSubview:arrowIV];
    [arrowIV setImage:[UIImage imageNamed:@"buddystatus_back.png"]];
    arrowIV.contentMode = UIViewContentModeCenter;
    
    UILabel *userIntroLabel = [[UILabel alloc] init];
    self.userIntroLabel = userIntroLabel;
    [self.contentView addSubview:userIntroLabel];
    userIntroLabel.textColor = UIColorFromRGB(0xe6be78, 1.0f);
    userIntroLabel.backgroundColor = [UIColor clearColor];
    [userIntroLabel setFont:BuddyStatusCellUserIntroFont];
    
    //cell中图片展示
//    BuddyStatusNoteThumbView *thumbView = [[BuddyStatusNoteThumbView alloc] init];
    BuddyStatusNoteNewThumbView *thumbView = [[BuddyStatusNoteNewThumbView alloc] init];
    self.thumbView = thumbView;
    [self.contentView addSubview:thumbView];
    thumbView.backgroundColor = [UIColor clearColor];
    
    BuddyStatusNoteTagsView *tagsView = [[BuddyStatusNoteTagsView alloc] init];
    self.tagsView = tagsView;
    [self addSubview:tagsView];
    
    UILabel *noteTextLabel = [[UILabel alloc] init];
    self.noteTextLabel = noteTextLabel;
    [self.contentView addSubview:noteTextLabel];
    noteTextLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    noteTextLabel.backgroundColor = [UIColor clearColor];
    [noteTextLabel setFont:BuddyStatusCellNoteTextFont];
    noteTextLabel.numberOfLines = 0;
    
    BuddyStatusNotePlaceTagsView *placeTagsView = [[BuddyStatusNotePlaceTagsView alloc] init];
    self.placeTagsView = placeTagsView;
    [self.contentView addSubview:placeTagsView];
    placeTagsView.tagsColor = [UIColor orangeColor];
    placeTagsView.tagsBgColor = [UIColor clearColor];
    
    UILabel *topicTextLabel = [[UILabel alloc] init];
    self.topicTextLabel = topicTextLabel;
    [self.contentView addSubview:topicTextLabel];
    topicTextLabel.textColor = UIColorFromRGB(0x5d493d, 1.0f);
    topicTextLabel.backgroundColor = [UIColor clearColor];
    [topicTextLabel setFont:BuddyStatusCellTopicTextFont];
    
    
    UIButton *likedBtn = [[UIButton alloc] init];
    self.likedBtn = likedBtn;
    [self.contentView addSubview:likedBtn];
    likedBtn.backgroundColor = [UIColor clearColor];
    [likedBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [likedBtn setTitle:@"0" forState:UIControlStateNormal];
    [likedBtn setTitleColor:UIColorFromRGB(0xa4866c, 1.0f) forState:UIControlStateNormal];
    [likedBtn setImage:[UIImage imageNamed:@"buddystatus_delliked"] forState:UIControlStateNormal];
    [likedBtn setImage:[UIImage imageNamed:@"buddystatus_liked"] forState:UIControlStateSelected];
    [likedBtn addTarget:self action:@selector(likeBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    likedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    likedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
}

- (void)setNoteItemFrame:(BuddyStatusNoteItemFrame *)noteItemFrame
{
    _noteItemFrame = noteItemFrame;
    BuddyStatusNoteItem *noteItem = noteItemFrame.noteItem;

    self.userIconBtn.frame = noteItemFrame.userIconFrame;
    self.userIconBtn.layer.cornerRadius = self.userIconBtn.frame.size.width * 0.5;
    [self.userIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:noteItem.user.thumblink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    
    self.userNameLabel.frame = noteItemFrame.userNameFrame;
    self.userNameLabel.text = noteItem.user.name;
    
//    self.completePV.frame = noteItemFrame.completePVFrame;
//    self.completePV.progress = noteItem.complete / 100.0;
//    
//    self.completeLabel.frame = self.noteItemFrame.completeTextFrame;
//    self.completeLabel.text = [NSString stringWithFormat:@"%d%%", noteItem.complete];
    
    self.arrowIV.frame = noteItemFrame.arrowIVFrame;
    
    if (noteItem.user.intro.length > 0) {
        self.userIntroLabel.hidden = NO;
        self.userIntroLabel.frame = self.noteItemFrame.userIntroFrame;
        self.userIntroLabel.text = noteItem.user.intro;
    } else {
        self.userIntroLabel.hidden = YES;
    }
    
    if (noteItem.thumbs.count > 0) {
        self.thumbView.hidden = NO;
        self.thumbView.frame = noteItemFrame.thumbFrame;
        self.thumbView.noteItem = noteItem;
        self.tagsView.tagsBgColor = [UIColor blackColor];
    } else {
        self.thumbView.hidden = YES;
        self.tagsView.tagsBgColor = [UIColor clearColor];
    }
    
    if (noteItem.tags.count > 0) {
        self.tagsView.hidden = NO;
        self.tagsView.frame = noteItemFrame.tagsFrame;
        self.tagsView.tags = noteItem.tags;
    } else {
        self.tagsView.hidden = YES;
    }
    
    if (noteItem.note.length > 0) {
        self.noteTextLabel.hidden = NO;
        self.noteTextLabel.frame = noteItemFrame.noteTextFrame;
        self.noteTextLabel.text = noteItem.note;
    } else {
        self.noteTextLabel.hidden = YES;
    }
    
    if (noteItem.place.count > 0) {
        self.placeTagsView.hidden = NO;
        self.placeTagsView.frame = noteItemFrame.placeTagFrame;
        self.placeTagsView.tags = noteItem.place;
    } else {
        self.placeTagsView.hidden = YES;
    }
    
    self.topicTextLabel.frame = noteItemFrame.topicTextFrame;
    self.topicTextLabel.text = [NSString stringWithFormat:@"#%@#", noteItem.topic];
    
    self.likedBtn.frame = noteItemFrame.likedFrame;
    self.likedBtn.selected = noteItem.liked;
    [self.likedBtn setTitle:[NSString stringWithFormat:@"%zd", noteItem.like_count] forState:UIControlStateNormal];
    self.likedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
//    self.likedBtn.backgroundColor = RandomColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize cellSize = self.frame.size;
    self.bgView.frame = CGRectMake(BuddyStatusCellPadding / 2, BuddyStatusCellPadding / 2, cellSize.width - BuddyStatusCellPadding, cellSize.height - BuddyStatusCellPadding);
}

- (void)userIconBtnDidOnClick:(UIButton *)button
{
    BuddyStatusUser *user = self.noteItemFrame.noteItem.user;
    if (![[UserManager sharedInstance] isCurrentUser:user.userid]) {
        if ([self.delegate respondsToSelector:@selector(buddyStatusCell:userIconBtnDidOnClick:)]) {
            [self.delegate buddyStatusCell:self userIconBtnDidOnClick:button];
        }
    }
}

- (void)likeBtnDidOnClick:(UIButton *)button
{
    NSString *uri = nil;
    if (button.selected == NO) { // 没有点赞，切换到点赞
        uri = k_api_note_like_post;
    } else {
        uri = k_api_note_like_del;
    }
    
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"noteid":@(self.noteItemFrame.noteItem.noteid)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:uri,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}
//刷新好友动态数据
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_like_post] || [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_like_del]) {
        NSDictionary *res = [result objectOutForKey:@"res"];
        if (res) {
            [[Cache shared] setNeedRefreshData:3 value:1];//设置个人动态页面刷新
            BuddyStatusNoteItem *noteItem = self.noteItemFrame.noteItem;
            if ([res[@"liked"] boolValue]) {
                noteItem.like_count++;
                noteItem.liked = YES;
            } else {
                noteItem.like_count--;
                noteItem.liked = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.likedBtn setTitle:[NSString stringWithFormat:@"%zd", noteItem.like_count] forState:UIControlStateNormal];
                self.likedBtn.selected = noteItem.liked;
            });
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_like_post]) {
        InfoLog(@"error:%@", error);
    }
}
@end
