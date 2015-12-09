//
//  CollectCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

/*
 *【个人动态】界面 cell展示
 *功能：个人动态 （关注、收藏）判断
 *
 */

#import "CollectCell.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define k_username_height 20
#define k_line_height 10
#define k_userWH 40

@implementation CollectCell{
    UILabel * _noteTextLabel;
    UILabel *_timeLabel;
    UIImageView *_imageViewBG;
    UIImageView *_imageView;
    UIView * _line;
}

@synthesize uiBtnSelect = uiBtnSelect;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _canEdit = NO;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = [UIColor color:white_color];
    CALayer *layer = bgView.layer;
    layer.borderColor = k_defaultLineColor.CGColor;
    layer.borderWidth = 0.5;
    
    [self section1];
    [self section2];
    [self section3];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUIWith:_dataItem];
}

- (void)updateUIWith:(CollectItem *)item {
    self.bgView.frame = CGRectMake(0, 10, self.contentView.width, [CollectCell cellHeightWith:item] - 10);
    CGFloat contentHeight = 0;
    if (item.content.length > 0) {
        contentHeight = [item contentLabelHeight:[CollectCell contentWith]];
    }
    _line.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame) - k_line_height, self.contentView.width, k_line_height);
    _timeLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 90, 16, 80, 20);
    
    CGFloat contentX = CGRectGetMaxX(userIcon.frame) + 10;
    
    content.frame = CGRectMake(contentX, CGRectGetMaxY(userName.frame), [CollectCell contentWith], contentHeight);
    
    _imageViewBG.frame = CGRectMake(contentX, CGRectGetMaxY(content.frame) + 7, CGRectGetWidth(content.frame), item.imageViewBGHeight);
    
    _placeTagsView.frame = CGRectMake(contentX - 5, CGRectGetMaxY(_imageViewBG.frame), CGRectGetWidth(content.frame)+5, [item adressViewBGHeight]);
    
    _tagsView.frame = CGRectMake(contentX - 5, CGRectGetMaxY(_placeTagsView.frame), CGRectGetWidth(content.frame)+5, [item tagsViewBGHeight]);
    
    _toolBar.frame = CGRectMake(contentX + 2 , CGRectGetMaxY(_tagsView.frame) , CGRectGetWidth(self.contentView.bounds), 26);
    
}
- (void)setupUI:(CollectItem *)item frmae:(CGRect)rect{
    self.dataItem = item;
    
    if (uiTypeBackground && uiTypeBackground.superview) {
        return;
    }
    
    [self section2];
    //行间距
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineSpacing = 4.0;
    mParaStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dict  = @{NSFontAttributeName : [UIFont fontWithName:k_fontName_FZXY size:14], NSForegroundColorAttributeName:darkGary_color, NSParagraphStyleAttributeName: mParaStyle};
    NSMutableAttributedString * attText = [[NSMutableAttributedString alloc]initWithString:item.content attributes:dict];
    content.attributedText = attText;
    
    userName.text = item.name;
    [userIcon sd_setImageWithURL:[NSURL URLWithString:item.imglink] placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    _timeLabel.text = [item.ctime timeString2DateString];
    NSInteger count = item.imglinkArr.count;
    for (int idx = 0; idx < 9; idx++) {
        UIImageView *imageView= self.imageArr[idx];
        if (idx < count) {
            NSString *imageUrl = count - 1 >= idx ? item.imglinkArr[idx] : nil;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
            imageView.hidden = !imageUrl;
        } else {
            imageView.hidden = YES;
        }
    }
    self.dataItem.selectedImageView = self.imageArr[0];
    
    self.placeTagsView.tags = item.place;
    self.tagsView.tags = item.tags;
    self.toolBar.noteItem = item;
    
    [self updateUIWith:item];
}

- (OpType)getOpType:(CollectItem *)item{
    InfoLog(@"ERROR:%@", item);
    return note_like;
}

+ (CGFloat)cellHeightWith:(CollectItem *)item{
    return 26 + [item tagsViewBGHeight] + [item adressViewBGHeight] + item.imageViewBGHeight + k_username_height + [item contentLabelHeight:[CollectCell contentWith]] + 10 + k_line_height +10;
}

+ (CGFloat)contentWith {
    return  CGRectGetWidth([UIScreen mainScreen].bounds) - 10 - k_userWH - 10 - 10;
}

- (NSAttributedString *)attrContent:(NSString *)text{
    return [NSAttributedString attrContent:text fontName:k_fontName_FZXY fontsize:13 color:k_defaultTextColor lineHeight:20.0 align:NSTextAlignmentCenter];
}

- (void)section1 {
    userIcon = [UIView imageView:@{V_Parent_View:self.bgView,
                                   V_Frame:rectStr(10, 7, k_userWH, k_userWH),
                                   V_Img:@"res/user/0.png",
                                   V_ContentMode:num(ModeAspectFill),
                                   V_Border_Radius:strFloat(k_userWH /2.0),
                                   V_Border_Width:@0.5,
                                   V_Delegate:self,
                                   V_SEL:selStr(@selector(userLogoAction:)),
                                   V_Border_Color:k_defaultLineColor,
                                   }];
    [self.bgView addSubview:userIcon];
    userIcon.clipsToBounds = YES;

    userName = [UIView label:@{V_Parent_View:self.bgView,
                               V_Margin_Left:strFloat(userIcon.width + 20),
                               V_Margin_Top:@7,
                               V_Width:@150,
                               V_Height:@(k_username_height),
                               V_Text:@"",
                               V_Font_Size:@14,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultTextColor,
                               V_Margin_Right:@10,
                               }];
    [self.bgView addSubview:userName];
    
    UILabel * time = [UIView label:@{V_Parent_View:self.bgView,
                                     V_Left_View:userName,
                                     V_Margin_Right:@10,
                                     V_Margin_Top:@7,
                                     V_Height:@20,
                                     V_Alpha:@0.5,
                                     }];
    time.text = [_dataItem.ctime timeString2DateString];
    time.font = [UIFont fontWithName:k_fontName_FZZY size:10.0];
    time.textAlignment = TextAlignRight;
    [self.contentView addSubview:time];
    _timeLabel = time;
    
    content = [UIView label:@{V_Parent_View:self.bgView,
                              V_Last_View:userName,
                              V_Width:@0,
                              V_Height:@0,
                              V_Color:k_defaultTextColor,
                              V_Font_Size:@13,
                              V_Alpha:@0.7,
                              V_Text:@"",
                              V_Font_Family:k_fontName_FZZY,
                              }];
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.numberOfLines = 0;
    [self.bgView addSubview:content];
}

- (void)section2{
    if (!_imageViewBG || !_imageViewBG.superview) {
        _imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageViewBG.clipsToBounds = YES;
        _imageViewBG.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:_imageViewBG];
    }
    
    [_imageViewBG removeAllSubviews];
    
    [self initImgArrs];
}

- (void)initImgArrs{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] initWithCapacity:_imageArr.count];
    }
    [_imageArr removeAllObjects];
    
    CGFloat pitcureW = 80;//15距离边  图片间距20px
    for (int j = 0; j < 9; j++) {
        NSInteger a = j % 3, b = j / 3;
        _imageView =[[UIImageView alloc] init];
        [_imageView setFrame:CGRectMake(a * (pitcureW + 5) , 0 + b *(pitcureW + 5),pitcureW,pitcureW)];
        _imageView.tag = j;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds=YES;
        _imageView.layer.borderColor = k_defaultLineColor.CGColor;
        _imageView.layer.borderWidth = 0.5;
        _imageView.layer.cornerRadius = 2;
        _imageView.userInteractionEnabled = YES;
        _imageViewBG.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgActions:)];
        [_imageView addGestureRecognizer:tapg];
        [_imageViewBG addSubview:_imageView];
        [_imageArr addObject:_imageView];
        
    }
}

- (void)tapgActions:(UITapGestureRecognizer *)tapg{
    NSArray * urls = [self.dataItem.imglinkArr copy];
    NSInteger count = _dataItem.imglinkArr.count;
    //封装图片数据
    NSMutableArray * photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:urls[i]]; // 图片路径
        [photos addObject:photo];
        photo.srcImageView = _imageViewBG; // 来源于哪个UIImageView
    }
    //显示相册
    MJPhotoBrowser * browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = ((UIImageView *)tapg.view).tag;
    browser.photos = photos;
    [browser show];
    
}
- (void)section3{
    BuddyStatusNoteTagsView *placeTagsView = [[BuddyStatusNoteTagsView alloc] init];
    placeTagsView.clipsToBounds = YES;
    self.placeTagsView = placeTagsView;
    [self.bgView addSubview:placeTagsView];
    placeTagsView.tagsColor =  [UIColor colorWithHue:68.0/255.0 saturation:68.0/255.0 brightness:68.0/255.0 alpha:0.5];
    placeTagsView.tagsFont = [UIFont fontWithName:k_fontName_FZZY size:12];
    placeTagsView.iconName = @"buddystatus_location";
    
    
    BuddyStatusNoteTagsView *tagsView = [[BuddyStatusNoteTagsView alloc] init];
    tagsView.clipsToBounds = YES;
    self.tagsView = tagsView;
    [self.bgView addSubview:tagsView];
    tagsView.tagsColor =  [UIColor colorWithHue:68.0/255.0 saturation:68.0/255.0 brightness:68.0/255.0 alpha:0.5];
    tagsView.tagsFont = [UIFont fontWithName:k_fontName_FZZY size:12];
    tagsView.iconName = @"biaoqianhuise";
    
    CollectBarView *toolBar = [CollectBarView toolBar];
    [self.bgView addSubview:toolBar];
    self.toolBar = toolBar;
}


- (void)doHide:(id)sender{
    BOOL s = uiBtnHide.selected;
    uiBtnHide.selected = !s;
}

- (void)userLogoAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectCell" object:nil userInfo:@{@"cell": self}];
}
@end
