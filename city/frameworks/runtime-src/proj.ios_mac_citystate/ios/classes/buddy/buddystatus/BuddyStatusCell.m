//
//  BuddyStatusCell.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import "BuddyStatusCell.h"
#import "BuddyStatusNoteTagsView.h"
#import "BuddyStatusNoteNewThumbView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TagItem.h"
#import "NSString+Extension.h"

#define BuddyStatusCell_ID @"BuddyStatusCell"

@interface BuddyStatusCell ()
@property (nonatomic, weak) UIButton *userIconBtn;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UIImageView *arrowIV;
@property (nonatomic, weak) BuddyStatusNoteNewThumbView *thumbView;
@property (nonatomic, weak) BuddyStatusNoteTagsView *tagsView;
@property (nonatomic, weak) UILabel *noteTextLabel;
@property (nonatomic, weak) BuddyStatusNoteTagsView *placeTagsView;
@property (nonatomic, weak) BuddyStatusToolBar *toolBar;
@property (nonatomic, weak) UIView *bgView; // 背景图片
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UIControl *tapUserBg;
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
    self.backgroundColor = k_defaultViewControllerBGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = bgView.layer;
    layer.borderColor = k_defaultLineColor.CGColor;
    layer.borderWidth = 0.5;
    
    UIButton *userIconBtn = [[UIButton alloc]init];
    self.userIconBtn = userIconBtn;
    [self.contentView addSubview:userIconBtn];
    userIconBtn.layer.masksToBounds = YES;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    [self.contentView addSubview:userNameLabel];
    userNameLabel.textColor = darkGary_color;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userNameLabel setFont:BuddyStatusCellUserNameFont];
    
    UIImageView *arrowIV = [[UIImageView alloc] init];
    self.arrowIV = arrowIV;
    [self.contentView addSubview:arrowIV];
    [arrowIV setImage:[UIImage imageNamed:@"buddystatus_arrow.png"]];
    arrowIV.contentMode = UIViewContentModeCenter;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    dateLabel.textColor = gray_color;
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel setFont:BuddyStatusCellDateFont];
    
    //cell中图片展示
    BuddyStatusNoteNewThumbView *thumbView = [[BuddyStatusNoteNewThumbView alloc] init];
    self.thumbView = thumbView;
    [self.contentView addSubview:thumbView];
    thumbView.backgroundColor = [UIColor clearColor];
    
    BuddyStatusNoteTagsView *tagsView = [[BuddyStatusNoteTagsView alloc] init];
    self.tagsView = tagsView;
    [self addSubview:tagsView];
    tagsView.tagsColor = k_defaultNavBGColor;
    tagsView.tagsFont = [UIFont fontWithName:k_fontName_FZZY size:13];
    tagsView.iconName = @"buddystatus_tag.png";
    
    UILabel *noteTextLabel = [[UILabel alloc] init];
    self.noteTextLabel = noteTextLabel;
    [self.contentView addSubview:noteTextLabel];
    noteTextLabel.textColor = darkGary_color;
    noteTextLabel.backgroundColor = [UIColor clearColor];
    [noteTextLabel setFont:BuddyStatusCellNoteTextFont];
    noteTextLabel.numberOfLines = 0;
    
    BuddyStatusNoteTagsView *placeTagsView = [[BuddyStatusNoteTagsView alloc] init];
    self.placeTagsView = placeTagsView;
    [self.contentView addSubview:placeTagsView];
    placeTagsView.tagsColor = [UIColor grayColor];
    placeTagsView.tagsFont = [UIFont fontWithName:k_fontName_FZZY size:12];
    placeTagsView.iconName = @"buddystatus_location.png";
    
    BuddyStatusToolBar *toolBar = [BuddyStatusToolBar toolBar];
    self.toolBar = toolBar;
    [self.contentView addSubview:toolBar];
    toolBar.back = ^{
        if ([self.delegate respondsToSelector:@selector(buddyStatusCellrequestComment:)]) {
            [self.delegate buddyStatusCellrequestComment:self.noteItemFrame.noteItem.feedid];
        }
    };
    
    UIControl *tapUserBg = [[UIControl alloc] init];
    tapUserBg.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tapUserBg];
    self.tapUserBg = tapUserBg;
    [tapUserBg addTarget:self action:@selector(tapUserBgDidOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNoteItemFrame:(BuddyStatusNoteItemFrame *)noteItemFrame
{
    _noteItemFrame = noteItemFrame;
    BuddyStatusNoteItem *noteItem = noteItemFrame.noteItem;

    self.userIconBtn.frame = noteItemFrame.userIconFrame;
    self.userIconBtn.layer.cornerRadius = self.userIconBtn.frame.size.width * 0.5;
//    [self.userIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:noteItem.user.imglink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    [self.userIconBtn setImage:[UIImage imageNamed:@"register-done-2-1.png"] forState:UIControlStateNormal];
    NSString * imglink = (noteItem.user.imglink.length == 0) ? noteItem.user.imglink : noteItem.user.imglink;
//    InfoLog(@"imglink:%@", imglink);
//    InfoLog(@"thumblink:%@", noteItem.user.thumblink);
    if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
        [self.userIconBtn setImage:[[Cache shared].pics_dict objectOutForKey:imglink] forState:UIControlStateNormal];
    }
    else{
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
        if (img) {
            [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
            [self.userIconBtn setImage:img forState:UIControlStateNormal];
        }
    }
    
    self.userNameLabel.frame = noteItemFrame.userNameFrame;
    self.userNameLabel.text = noteItem.user.name;
    
    self.arrowIV.frame = noteItemFrame.arrowIVFrame;
    
    self.dateLabel.frame = self.noteItemFrame.dateFrame;
    self.dateLabel.text = [noteItem.ctime timeString2DateString];
    
    if (noteItem.imgs.count > 0) {
        self.thumbView.hidden = NO;
        self.thumbView.frame = noteItemFrame.thumbFrame;
        self.thumbView.noteItem = noteItem;
        self.tagsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    } else {
        self.thumbView.hidden = YES;
        self.tagsView.backgroundColor = [UIColor clearColor];
    }
    
    if (noteItem.tags.count > 0) {
        self.tagsView.hidden = NO;
        self.tagsView.frame = noteItemFrame.tagsFrame;
        self.tagsView.tags = noteItem.tags;
    } else {
        self.tagsView.hidden = YES;
    }
    
    if (noteItem.content.length > 0) {
        self.noteTextLabel.hidden = NO;
        self.noteTextLabel.frame = noteItemFrame.noteTextFrame;
        self.noteTextLabel.text = noteItem.content;
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
    
    self.toolBar.frame = noteItemFrame.toolBarFrame;
    self.toolBar.noteItem = noteItemFrame.noteItem;
    
    self.tapUserBg.frame = CGRectMake(CGRectGetMinX(self.userIconBtn.frame), CGRectGetMinY(self.userIconBtn.frame), CGRectGetMaxX(self.arrowIV.frame) - CGRectGetMinX(self.userIconBtn.frame), CGRectGetHeight(self.userIconBtn.frame));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize cellSize = self.frame.size;
    self.bgView.frame = CGRectMake(0, BuddyStatusCellPadding, cellSize.width, cellSize.height - BuddyStatusCellPadding);
}

- (void)tapUserBgDidOnClick
{
    BuddyStatusUser *user = self.noteItemFrame.noteItem.user;
    if (![[UserManager sharedInstance] isCurrentUser:user.userid]) {
        if ([self.delegate respondsToSelector:@selector(buddyStatusCell:userIconBtnDidOnClick:)]) {
            [self.delegate buddyStatusCell:self userIconBtnDidOnClick:nil];
        }
    }
}
@end
