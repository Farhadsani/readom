//
//  StoreDetailCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreDetailCell.h"
#import "RatingView.h"
#import "NSString+Extension.h"
#import "UIButton+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface StoreDetailCell ()
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UIButton *picView;
@property (nonatomic, weak) UILabel *picCountView;
@property (nonatomic, weak) UILabel *storeNameLabel;
@property (nonatomic, weak) UIButton *followBtn;
@property (nonatomic, weak) RatingView *startReate;
@property (nonatomic, weak) UILabel *startReateLabel;
@property (nonatomic, weak) UIButton *addressIconView;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UIButton *phoneBtn;
@property (nonatomic, weak) UIView *lineView1;
@property (nonatomic, weak) UIView *lineView2;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation StoreDetailCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    StoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreDetailCell_ID];
    if (cell == nil) {
        cell = [[StoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoreDetailCell_ID];
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
    UIButton *picView = [[UIButton alloc]init];
    self.picView = picView;
    [self.contentView addSubview:picView];
    [picView addTarget:self action:@selector(picViewDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [picView setImage:[UIImage imageNamed:@"buddystatus_defaultnotenewthumbview"] forState:UIControlStateNormal];
    picView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *picCountView = [[UILabel alloc] init];
    self.picCountView = picCountView;
    [self.contentView addSubview:picCountView];
    picCountView.textColor = lightgray_color;
    picCountView.textAlignment = NSTextAlignmentCenter;
    [picCountView setFont:StoreDetailCellPicCountViewFont];
    picCountView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    picCountView.layer.cornerRadius = 5;
    picCountView.layer.masksToBounds = YES;
    
    UILabel *storeNameLabel = [[UILabel alloc] init];
    self.storeNameLabel = storeNameLabel;
    [self.contentView addSubview:storeNameLabel];
    storeNameLabel.textColor = k_defaultTextColor;
    [storeNameLabel setFont:StoreDetailCellStoreNameLabelFont];
    
    UIButton *followBtn = [[UIButton alloc]init];
    self.followBtn = followBtn;
    [self.contentView addSubview:followBtn];
    [followBtn addTarget:self action:@selector(followBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [followBtn setImage:[UIImage imageNamed:@"store_unfollow.png"] forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"store_follow.png"] forState:UIControlStateSelected];
    
    RatingView *startReate = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 100, StoreDetailCellStartReateH)];
    startReate.star_height = StoreDetailCellStartReateH;
    startReate.userInteractionEnabled = NO;
    startReate.space_width = 5.0;
    [startReate setImagesDeselected:@"store_star_gray" partlySelected:@"store_star_grayyellow" fullSelected:@"store_star_yellow" andDelegate:nil];
    self.startReate = startReate;
    [self addSubview:startReate];
    
    UILabel *startReateLabel = [[UILabel alloc] init];
    self.startReateLabel = startReateLabel;
    [self.contentView addSubview:startReateLabel];
    startReateLabel.textColor = k_defaultTextColor;
    [startReateLabel setFont:StoreDetailCellStartReateLabelFont];

    UIButton *addressIconView = [[UIButton alloc] init];
    self.addressIconView = addressIconView;
    [self addSubview:addressIconView];
    [addressIconView setImage:[UIImage imageNamed:@"store_location.png"] forState:UIControlStateNormal];

    UILabel *addressLabel = [[UILabel alloc] init];
    self.addressLabel = addressLabel;
    [self.contentView addSubview:addressLabel];
    addressLabel.textColor = rgb(180,180,180);
    [addressLabel setFont:StoreDetailCellAddressLabelFont];
    
    UIButton *phoneBtn = [[UIButton alloc]init];
    self.phoneBtn = phoneBtn;
    [self.contentView addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(phoneBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setImage:[UIImage imageNamed:@"store_phone.png"] forState:UIControlStateNormal];
    
    UIView *lineView1 = [[UIView alloc] init];
    [self addSubview:lineView1];
    self.lineView1 = lineView1;
    lineView1.backgroundColor = k_defaultLineColor;
    
    UIView *lineView2 = [[UIView alloc] init];
    [self addSubview:lineView2];
    self.lineView2 = lineView2;
    lineView2.backgroundColor = k_defaultLineColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = StoreDetailCellSubViewMargin * 2;
    
    self.picView.frame = CGRectMake(0, 0, StoreDetailCellPicViewH * 2, StoreDetailCellPicViewH);
    
    CGFloat storeNameLabelY = CGRectGetMaxY(self.picView.frame) + StoreDetailCellSubViewMargin;
    CGFloat storeNameLabelH = StoreDetailCellStoreNameLabelH;
    CGFloat followBtnW = 40;
    CGFloat followBtnH = storeNameLabelH;
    CGFloat followBtnX = self.width - margin - followBtnW;
    CGFloat followBtnY = storeNameLabelY;
    self.followBtn.frame = CGRectMake(followBtnX, followBtnY, followBtnW, followBtnH);
    
    CGFloat storeNameLabelX = margin;
    CGFloat storeNameLabelW = CGRectGetMinX(self.followBtn.frame) - margin - StoreDetailCellSubViewMargin;
    self.storeNameLabel.frame = CGRectMake(storeNameLabelX, storeNameLabelY, storeNameLabelW, storeNameLabelH);
    
    CGFloat startReateX = storeNameLabelX;
    CGFloat startReateY = CGRectGetMaxY(self.storeNameLabel.frame);
    self.startReate.frame = (CGRect){{startReateX, startReateY}, self.startReate.frame.size};
    
    CGFloat startReateLabelX = CGRectGetMaxX(self.startReate.frame) + StoreDetailCellSubViewMargin;
    CGFloat startReateLabelY = startReateY + 4;
    CGFloat startReateLabelH = self.startReate.height - 4;
    CGFloat startReateLabelW = 40;
    self.startReateLabel.frame = CGRectMake(startReateLabelX, startReateLabelY, startReateLabelW, startReateLabelH);

    CGFloat addressIconViewX = StoreDetailCellSubViewMargin;
    CGFloat addressIconViewY = CGRectGetMaxY(self.startReate.frame) + StoreDetailCellSubViewMargin;
    CGFloat addressIconViewWH = StoreDetailCellAddressIconViewH;
    self.addressIconView.frame = CGRectMake(addressIconViewX, addressIconViewY, addressIconViewWH, addressIconViewWH);

    CGFloat phoneBtnW = StoreDetailCellAddressIconViewH * 1.5;
    CGFloat phoneBtnH = StoreDetailCellAddressIconViewH;
    CGFloat phoneBtnX = self.width - margin - phoneBtnW;
    CGFloat phoneBtnY = CGRectGetMaxY(self.startReate.frame) + StoreDetailCellSubViewMargin;
    self.phoneBtn.frame = CGRectMake(phoneBtnX, phoneBtnY, phoneBtnW, phoneBtnH);
    
    CGFloat addressLabelX = CGRectGetMaxX(self.addressIconView.frame);
    CGFloat addressLabelY = CGRectGetMaxY(self.startReate.frame) + StoreDetailCellSubViewMargin;
    CGFloat addressLabelH = StoreDetailCellAddressIconViewH;
    CGFloat addressLabelW = CGRectGetMinX(self.phoneBtn.frame) - CGRectGetMaxX(self.addressIconView.frame) - StoreDetailCellSubViewMargin * 2;
    self.addressLabel.frame = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
    
    self.lineView1.frame = CGRectMake(margin, CGRectGetMaxY(self.startReate.frame) + StoreDetailCellSubViewMargin * 0.5, self.width - margin * 2, 0.6);
    self.lineView2.frame = CGRectMake(CGRectGetMinX(self.phoneBtn.frame) - StoreDetailCellSubViewMargin, CGRectGetMaxY(self.lineView1.frame), 0.6, StoreDetailCellAddressIconViewH + StoreDetailCellSubViewMargin * 1.5);

    CGFloat picCountViewW = followBtnW;
    CGFloat picCountViewH = 20;
    CGFloat picCountViewX = self.width - margin - picCountViewW;
    CGFloat picCountViewY = CGRectGetMaxY(self.picView.frame) - StoreDetailCellSubViewMargin - picCountViewH;
    self.picCountView.frame = CGRectMake(picCountViewX, picCountViewY, picCountViewW, picCountViewH);
}

- (void)setStoreIntro:(StoreIntro *)storeIntro
{
    _storeIntro = storeIntro;
    
    if (storeIntro.imglink.count > 0) {
        [self.picView sd_setImageWithURL:[NSURL URLWithString:storeIntro.imglink[0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"buddystatus_defaultnotenewthumbview"]];
    }
    self.picCountView.text = [NSString stringWithFormat:@"%ld张",(unsigned long)storeIntro.imglink.count];
    self.storeNameLabel.text = (storeIntro.storename)?storeIntro.storename:storeIntro.name;
    self.followBtn.selected = storeIntro.liked;
    if ([UserManager sharedInstance].brief.userid == storeIntro.userid) {
        self.followBtn.hidden = YES;
    } else {
        self.followBtn.hidden = NO;
    }
    [self.startReate displayRating:[storeIntro.rate floatValue]];
    self.startReateLabel.text = [NSString stringWithFormat:@"%@分", storeIntro.rate];
    self.addressLabel.text = storeIntro.address;
}

- (void)picViewDidOnClick:(UIButton *)button
{
    if (self.storeIntro.imglink.count == 0) return;
    
    self.picView.imageView.frame = self.picView.bounds;
    
    NSArray * _urls = [self.storeIntro.imglink copy];
    NSInteger count = _urls.count;
    NSMutableArray * photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_urls[i]];
        photo.srcImageView = self.picView.imageView;
        [photos addObject:photo];
    }
    
    MJPhotoBrowser * browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = photos;
    [browser show];
}

- (void)followBtnDidOnClick:(UIButton *)button
{
    NSString *uri = nil;
    if (self.followBtn.selected == NO) {
        uri = k_api_store_like_post;
    } else {
        uri = k_api_user_unfollow;
    }
    
    NSDictionary * params = @{@"userid":@(self.storeIntro.userid),
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

- (void)phoneBtnDidOnClick:(UIButton *)button
{
    NSString *phoneStr = nil;
    if (self.storeIntro.telephone) {
        phoneStr = [NSString stringWithFormat:@"tel:%@", self.storeIntro.telephone];
    }
    else if (self.storeIntro.phone){
        phoneStr = [NSString stringWithFormat:@"tel:%@", self.storeIntro.phone];
    }
    if (phoneStr) {
        NSURL *url = [NSURL URLWithString:phoneStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result
{
    [[Cache shared] setNeedRefreshData:3 value:1];//设置个人动态页面刷新
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_post]) {
        self.storeIntro.liked = YES;
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        self.storeIntro.liked = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.followBtn.selected = self.storeIntro.liked;
    });
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error
{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_post] || [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        InfoLog(@"error:%@", error);
    }
}
@end
