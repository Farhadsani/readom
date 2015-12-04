//
//  StoreGoodsDetailSectionOneView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import "StoreGoodsDetailSectionOneView.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"

@interface StoreGoodsDetailSectionOneView ()
@property (nonatomic, weak) UIImageView *picView;
@property (nonatomic, weak) UILabel *storeNameLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIView *nameBg;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *priceFlagLabel;
@property (nonatomic, weak) UILabel *oldPriceLabel;
@property (nonatomic, weak) UIButton *quickBuyBtn;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation StoreGoodsDetailSectionOneView
+ (instancetype)storeGoodsDetailSectionOneView
{
    return [[StoreGoodsDetailSectionOneView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = lightgray_color.CGColor;
    self.layer.borderWidth = 0.6;
    
    UIImageView *picView = [[UIImageView alloc] init];
    picView.clipsToBounds = YES;
    picView.contentMode = UIViewContentModeScaleAspectFill;
    self.picView = picView;
    [self addSubview:picView];
    
    UIView *nameBg = [[UIView alloc] init];
    self.nameBg = nameBg;
    [self addSubview:nameBg];
    nameBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UILabel *storeNameLabel = [[UILabel alloc] init];
    self.storeNameLabel = storeNameLabel;
    [self addSubview:storeNameLabel];
    storeNameLabel.textColor = [UIColor whiteColor];
    storeNameLabel.font = StoreGoodsDetailSectionOneViewStoreNameLabelFont;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    nameLabel.textColor = lightgray_color;
    nameLabel.font = StoreGoodsDetailSectionOneViewNameLabelFont;
    
    UILabel *priceFlagLabel = [[UILabel alloc] init];
    self.priceFlagLabel = priceFlagLabel;
    [self addSubview:priceFlagLabel];
    priceFlagLabel.textColor = yello_color;
    priceFlagLabel.font = StoreGoodsDetailSectionOneViewOldPriceLabelFont;
    priceFlagLabel.text = @"￥";
    priceFlagLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabel = priceLabel;
    [self addSubview:priceLabel];
    priceLabel.textColor = yello_color;
    priceLabel.font = StoreGoodsDetailSectionOneViewPriceLabelFont;

    UILabel *oldPriceLabel = [[UILabel alloc] init];
    self.oldPriceLabel = oldPriceLabel;
    [self addSubview:oldPriceLabel];
    oldPriceLabel.textColor = darkGary_color;
    oldPriceLabel.font = StoreGoodsDetailSectionOneViewOldPriceLabelFont2;

    UIButton *quickBuyBtn = [[UIButton alloc] init];
    self.quickBuyBtn = quickBuyBtn;
    [self addSubview:quickBuyBtn];
    [quickBuyBtn addTarget:self action:@selector(quickBuyBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [quickBuyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    quickBuyBtn.titleLabel.font = StoreGoodsDetailSectionOneViewQuickBuyBtnFont;
    
    UIView *lineView = [[UIView alloc] init];
    [self.oldPriceLabel addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = gray_color;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.picView.frame = CGRectMake(0, 0, StoreGoodsDetailSectionOneViewPicViewH * 2, StoreGoodsDetailSectionOneViewPicViewH);
    
    CGFloat nameLabelW = self.width - StoreGoodsDetailSectionOneViewPadding * 2;
    CGFloat nameLabelH = 18;
    CGFloat nameLabelX = StoreGoodsDetailSectionOneViewPadding;
    CGFloat nameLabelY = CGRectGetMaxY(self.picView.frame) - nameLabelH;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    CGFloat storeNameLabelW = self.width - StoreGoodsDetailSectionOneViewPadding * 2;
    CGFloat storeNameLabelH = 22;
    CGFloat storeNameLabelX = StoreGoodsDetailSectionOneViewPadding;
    CGFloat storeNameLabelY = CGRectGetMinY(self.nameLabel.frame) - storeNameLabelH;
    self.storeNameLabel.frame = CGRectMake(storeNameLabelX, storeNameLabelY, storeNameLabelW, storeNameLabelH);
    
    self.nameBg.frame = CGRectMake(0, CGRectGetMinY(self.storeNameLabel.frame), self.width, CGRectGetMaxY(self.nameLabel.frame) - CGRectGetMinY(self.storeNameLabel.frame));
    
    CGFloat priceFlagLabelX = StoreGoodsDetailSectionOneViewPadding;
    CGFloat priceFlagLabelWH = 20;
    CGFloat priceFlagLabelY = self.height - StoreGoodsDetailSectionOneViewPadding - priceFlagLabelWH;
    self.priceFlagLabel.frame = CGRectMake(priceFlagLabelX, priceFlagLabelY, priceFlagLabelWH, priceFlagLabelWH);
    
    CGSize priceLabelSize = [self.priceLabel.text sizeWithFont:StoreGoodsDetailSectionOneViewPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat priceLabelX = CGRectGetMaxX(self.priceFlagLabel.frame);
    CGFloat priceLabelY = self.height - StoreGoodsDetailSectionOneViewPadding - priceLabelSize.height + 4;
    self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};
    
    CGSize oldPriceLabelSize = [self.oldPriceLabel.text sizeWithFont:StoreGoodsDetailSectionOneViewOldPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat oldPriceLabelX = CGRectGetMaxX(self.priceLabel.frame) + StoreGoodsDetailSectionOneViewPadding * 0.5;
    CGFloat oldPriceLabelY = self.height - StoreGoodsDetailSectionOneViewPadding - oldPriceLabelSize.height;
    self.oldPriceLabel.frame = (CGRect){{oldPriceLabelX, oldPriceLabelY}, oldPriceLabelSize};

    CGFloat quickBuyBtnW = StoreGoodsDetailSectionOneViewQuickBuyBtnH * 2.5;
    CGFloat quickBuyBtnH = StoreGoodsDetailSectionOneViewQuickBuyBtnH;
    CGFloat quickBuyBtnX = self.width - StoreGoodsDetailSectionOneViewPadding - quickBuyBtnW;
    CGFloat quickBuyBtnY = self.height - StoreGoodsDetailSectionOneViewPadding - quickBuyBtnH;
    self.quickBuyBtn.frame = CGRectMake(quickBuyBtnX, quickBuyBtnY, quickBuyBtnW, quickBuyBtnH);
    
    [self.quickBuyBtn setBackgroundImage: [[UIImage imageNamed:@"store_quickbuy.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(self.quickBuyBtn.height * 0.5, self.quickBuyBtn.width * 0.5, self.quickBuyBtn.height * 0.5, self.quickBuyBtn.width * 0.5) ] forState:UIControlStateNormal];
    
    self.lineView.frame = CGRectMake(0, self.oldPriceLabel.height * 0.5, self.oldPriceLabel.width, 0.6);
}

- (void)setStoreGoodsDetail:(StoreGoodsDetail *)storeGoodsDetail
{
    _storeGoodsDetail = storeGoodsDetail;
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:storeGoodsDetail.imglink] placeholderImage:[UIImage imageNamed:@""]];
    self.storeNameLabel.text = storeGoodsDetail.storename;
    self.nameLabel.text = storeGoodsDetail.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", storeGoodsDetail.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@", storeGoodsDetail.oprice];
    
    [self setNeedsLayout];
}

- (void)quickBuyBtnDidOnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(storeGoodsDetailSectionOneView:quickBuyBtnDidOnClick:)]) {
        [self.delegate storeGoodsDetailSectionOneView:self quickBuyBtnDidOnClick:button];
    }
}
@end
