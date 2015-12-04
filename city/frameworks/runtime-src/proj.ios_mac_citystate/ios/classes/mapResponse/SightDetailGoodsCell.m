//
//  SightDetailGoodsCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/21.
//
//

#import "SightDetailGoodsCell.h"
#import "RatingView.h"
#import "NSString+Extension.h"
#import "UIButton+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"

@interface SightDetailGoodsCell ()
@property (nonatomic, weak) UIView *bgView;
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
@property (nonatomic, weak) UIImageView *picView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *oldPriceLabel;
@property (nonatomic, weak) UIView *oldPriceLineView;
@property (nonatomic, weak) UIButton *quickBuyBtn;
@property (nonatomic, assign) int index;
@end

@implementation SightDetailGoodsCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    SightDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:SightDetailGoodsCell_ID];
    if (cell == nil) {
        cell = [[SightDetailGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SightDetailGoodsCell_ID];
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
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = bgView.layer;
    layer.borderColor = k_defaultLineColor.CGColor;
    layer.borderWidth = 0.5;
    
    UILabel *storeNameLabel = [[UILabel alloc] init];
    self.storeNameLabel = storeNameLabel;
    [self.contentView addSubview:storeNameLabel];
    storeNameLabel.textColor = k_defaultTextColor;
    [storeNameLabel setFont:SightDetailGoodsCellStoreNameLabelFont];
    
    UIButton *followBtn = [[UIButton alloc]init];
    self.followBtn = followBtn;
    [self.contentView addSubview:followBtn];
    [followBtn addTarget:self action:@selector(followBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [followBtn setImage:[UIImage imageNamed:@"store_unfollow"] forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"store_follow"] forState:UIControlStateSelected];
    
    RatingView *startReate = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 100, SightDetailGoodsCellStartReateH)];
    startReate.star_height = SightDetailGoodsCellStartReateH;
    startReate.userInteractionEnabled = NO;
    startReate.space_width = 5.0;
    [startReate setImagesDeselected:@"store_star_gray" partlySelected:@"store_star_grayyellow" fullSelected:@"store_star_yellow" andDelegate:nil];
    self.startReate = startReate;
    [self addSubview:startReate];
    
    UILabel *startReateLabel = [[UILabel alloc] init];
    self.startReateLabel = startReateLabel;
    [self.contentView addSubview:startReateLabel];
    startReateLabel.textColor = k_defaultTextColor;
    [startReateLabel setFont:SightDetailGoodsCellStartReateLabelFont];
    
    UIButton *addressIconView = [[UIButton alloc] init];
    self.addressIconView = addressIconView;
    [self addSubview:addressIconView];
    [addressIconView setImage:[UIImage imageNamed:@"store_location.png"] forState:UIControlStateNormal];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    self.addressLabel = addressLabel;
    [self.contentView addSubview:addressLabel];
    addressLabel.textColor = gray_color;
    [addressLabel setFont:SightDetailGoodsCellAddressLabelFont];
    
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
    
    
    self.picView = [UIView imageView:@{V_Parent_View:self.contentView,
                                       V_SEL:selStr(@selector(picViewDidOnClick:)),
                                       V_Delegate:self,
                                       V_ContentMode:num(ModeAspectFill),
                                       }];
    [self.contentView addSubview:_picView];
    _picView.clipsToBounds = YES;
//    UIButton *picView = [[UIButton alloc]init];
//    self.picView = picView;
//    [self.contentView addSubview:picView];
//    [picView addTarget:self action:@selector(picViewDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    nameLabel.textColor = k_defaultTextColor;
    nameLabel.font = SightDetailGoodsCellNameLabelFont;
    nameLabel.numberOfLines = 0;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    priceLabel.textColor = yello_color;
    priceLabel.font = SightDetailGoodsCellPriceLabelFont;
    
    UILabel *oldPriceLabel = [[UILabel alloc] init];
    self.oldPriceLabel = oldPriceLabel;
    [self.contentView addSubview:oldPriceLabel];
    oldPriceLabel.textColor = gray_color;
    oldPriceLabel.font = SightDetailGoodsCellOldPriceLabelFont;
    
    UIView *oldPriceLineView = [[UIView alloc] init];
    [self.oldPriceLabel addSubview:oldPriceLineView];
    self.oldPriceLineView = oldPriceLineView;
    oldPriceLineView.backgroundColor = darkGary_color;
    
    UIButton *quickBuyBtn = [[UIButton alloc] init];
    self.quickBuyBtn = quickBuyBtn;
    [self addSubview:quickBuyBtn];
    [quickBuyBtn addTarget:self action:@selector(quickBuyBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [quickBuyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    quickBuyBtn.titleLabel.font = SightDetailGoodsCellQuickBuyBtnFont;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = SightDetailGoodsCellSubViewMargin * 2;
    
    CGFloat storeNameLabelY = margin + SightDetailGoodsCellSubViewMargin;
    CGFloat storeNameLabelH = SightDetailGoodsCellStoreNameLabelH;
    CGFloat followBtnW = 40;
    CGFloat followBtnH = storeNameLabelH;
    CGFloat followBtnX = self.width - margin - followBtnW;
    CGFloat followBtnY = storeNameLabelY;
    self.followBtn.frame = CGRectMake(followBtnX, followBtnY, followBtnW, followBtnH);
    
    CGFloat storeNameLabelX = margin;
    CGFloat storeNameLabelW = CGRectGetMinX(self.followBtn.frame) - margin - SightDetailGoodsCellSubViewMargin;
    self.storeNameLabel.frame = CGRectMake(storeNameLabelX, storeNameLabelY, storeNameLabelW, storeNameLabelH);
    
    CGFloat startReateX = storeNameLabelX;
    CGFloat startReateY = CGRectGetMaxY(self.storeNameLabel.frame);
    self.startReate.frame = (CGRect){{startReateX, startReateY}, self.startReate.frame.size};
    
    CGFloat startReateLabelX = CGRectGetMaxX(self.startReate.frame) + SightDetailGoodsCellSubViewMargin;
    CGFloat startReateLabelY = startReateY + 4;
    CGFloat startReateLabelH = self.startReate.height - 4;
    CGFloat startReateLabelW = 40;
    self.startReateLabel.frame = CGRectMake(startReateLabelX, startReateLabelY, startReateLabelW, startReateLabelH);
    
    CGFloat addressIconViewX = SightDetailGoodsCellSubViewMargin;
    CGFloat addressIconViewY = CGRectGetMaxY(self.startReate.frame) + SightDetailGoodsCellSubViewMargin;
    CGFloat addressIconViewWH = SightDetailGoodsCellAddressIconViewH;
    self.addressIconView.frame = CGRectMake(addressIconViewX, addressIconViewY, addressIconViewWH, addressIconViewWH);
    
    CGFloat phoneBtnW = SightDetailGoodsCellAddressIconViewH * 1.5;
    CGFloat phoneBtnH = SightDetailGoodsCellAddressIconViewH;
    CGFloat phoneBtnX = self.width - margin - phoneBtnW;
    CGFloat phoneBtnY = CGRectGetMaxY(self.startReate.frame) + SightDetailGoodsCellSubViewMargin;
    self.phoneBtn.frame = CGRectMake(phoneBtnX, phoneBtnY, phoneBtnW, phoneBtnH);
    
    CGFloat addressLabelX = CGRectGetMaxX(self.addressIconView.frame);
    CGFloat addressLabelY = CGRectGetMaxY(self.startReate.frame) + SightDetailGoodsCellSubViewMargin;
    CGFloat addressLabelH = SightDetailGoodsCellAddressIconViewH;
    CGFloat addressLabelW = CGRectGetMinX(self.phoneBtn.frame) - CGRectGetMaxX(self.addressIconView.frame) - SightDetailGoodsCellSubViewMargin * 2;
    self.addressLabel.frame = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
    
    self.lineView1.frame = CGRectMake(margin, CGRectGetMaxY(self.startReate.frame) + SightDetailGoodsCellSubViewMargin * 0.5, self.width - margin * 2, 0.6);
    self.lineView2.frame = CGRectMake(CGRectGetMinX(self.phoneBtn.frame) - SightDetailGoodsCellSubViewMargin, CGRectGetMaxY(self.lineView1.frame), 0.6, SightDetailGoodsCellAddressIconViewH + SightDetailGoodsCellSubViewMargin);
    
    self.picView.frame = CGRectMake(0, CGRectGetMaxY(self.addressIconView.frame) + SightDetailGoodsCellSubViewMargin, SightDetailGoodsCellPicViewH * 2, SightDetailGoodsCellPicViewH);
    UIView * sv = [self.picView.subviews objectAtExistIndex:0];
    if (sv && [sv isKindOfClass:[UIControl class]]) {
        sv.frame = CGRectMake(sv.x, sv.y, sv.width, self.picView.height);
    }
    
    CGFloat nameLabelX = margin;
    CGFloat nameLabelY =  CGRectGetMaxY(self.picView.frame) + SightDetailGoodsCellSubViewMargin;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:SightDetailGoodsCellNameLabelFont andMaxSize:CGSizeMake(self.width - nameLabelX - margin * 2, MAXFLOAT)];
    self.nameLabel.frame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    CGSize priceLabelSize = [self.priceLabel.text sizeWithFont:SightDetailGoodsCellPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat priceLabelX = nameLabelX;
    CGFloat priceLabelY = self.height - SightDetailGoodsCellSubViewMargin - priceLabelSize.height;
    self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};
    
    CGSize oldPriceLabelSize = [self.oldPriceLabel.text sizeWithFont:SightDetailGoodsCellOldPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat oldPriceLabelX = CGRectGetMaxX(self.priceLabel.frame) + margin;
    CGFloat oldPriceLabelY = self.height - SightDetailGoodsCellSubViewMargin - oldPriceLabelSize.height;
    self.oldPriceLabel.frame = (CGRect){{oldPriceLabelX, oldPriceLabelY}, oldPriceLabelSize};
    
    self.oldPriceLineView.frame = CGRectMake(0, self.oldPriceLabel.height * 0.5, self.oldPriceLabel.width, 0.6);
    
    CGFloat quickBuyBtnW = SightDetailGoodsCellQuickBuyBtnH * 2.5;
    CGFloat quickBuyBtnH = SightDetailGoodsCellQuickBuyBtnH;
    CGFloat quickBuyBtnX = self.width - margin - quickBuyBtnW;
    CGFloat quickBuyBtnY = self.height - margin - quickBuyBtnH;
    self.quickBuyBtn.frame = CGRectMake(quickBuyBtnX, quickBuyBtnY, quickBuyBtnW, quickBuyBtnH);
    
    [self.quickBuyBtn setBackgroundImage: [[UIImage imageNamed:@"store_quickbuy.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(self.quickBuyBtn.height * 0.5, self.quickBuyBtn.width * 0.5, self.quickBuyBtn.height * 0.5, self.quickBuyBtn.width * 0.5) ] forState:UIControlStateNormal];
    
    self.bgView.frame = CGRectMake(0, margin, self.width, self.height - SightDetailGoodsCellSubViewMargin);
}

- (void)setSightDetailGoods:(SightDetailGoods *)sightDetailGoods
{
    _sightDetailGoods = sightDetailGoods;
    
    self.storeNameLabel.text = sightDetailGoods.store.name;
    if (sightDetailGoods.store.rate) {
        [self.startReate displayRating:[sightDetailGoods.store.rate floatValue]];
        self.startReateLabel.text = [NSString stringWithFormat:@"%@分", sightDetailGoods.store.rate];
    }
    self.followBtn.selected = sightDetailGoods.store.liked;
    if ([UserManager sharedInstance].brief.userid == sightDetailGoods.store.userid) {
        self.followBtn.hidden = YES;
    } else {
        self.followBtn.hidden = NO;
    }
    self.addressLabel.text = sightDetailGoods.store.address;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:sightDetailGoods.imglink] placeholderImage:[UIImage imageNamed:@"buddystatus_defaultnotenewthumbview"]];
//    self.picView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sightDetailGoods.imglink]]];
//    [self.picView sd_setBackgroundImageWithURL:[NSURL URLWithString:sightDetailGoods.imglink] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:nil]];
    self.nameLabel.text = sightDetailGoods.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", sightDetailGoods.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@", sightDetailGoods.oprice];
}

- (void)picViewDidOnClick:(UIButton *)button
{
//    self.picView.imageView.frame = self.picView.bounds;
//    self.picView.frame = 
    
    NSArray * _urls = @[self.sightDetailGoods.imglink];
    NSInteger count = _urls.count;
    NSMutableArray * photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_urls[i]];
//        photo.srcImageView = self.picView.imageView;
        photo.srcImageView = self.picView;
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
    
    NSDictionary * params = @{@"userid":@(self.sightDetailGoods.store.userid),
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

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result
{
    [[Cache shared] setNeedRefreshData:3 value:1];//设置个人动态页面刷新
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_post]) {
        self.sightDetailGoods.store.liked = YES;
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        self.sightDetailGoods.store.liked = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.followBtn.selected = self.sightDetailGoods.store.liked;
    });
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error
{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_post] || [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        InfoLog(@"error:%@", error);
    }
}

- (void)phoneBtnDidOnClick:(UIButton *)button
{
    NSString *phoneStr = nil;
    if (self.sightDetailGoods.store.telephone) {
        phoneStr = [NSString stringWithFormat:@"tel:%@", self.sightDetailGoods.store.telephone];
    }
    else if (self.sightDetailGoods.store.phone) {
        phoneStr = [NSString stringWithFormat:@"tel:%@", self.sightDetailGoods.store.phone];
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

- (void)quickBuyBtnDidOnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(sightDetailGoodsCell:quickBuyBtnDidOnClickWithSightDetailGoods:)]) {
        [self.delegate sightDetailGoodsCell:self quickBuyBtnDidOnClickWithSightDetailGoods:self.sightDetailGoods];
    }
}
@end
