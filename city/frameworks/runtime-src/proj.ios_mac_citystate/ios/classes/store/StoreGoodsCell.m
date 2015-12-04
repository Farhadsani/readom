//
//  StoreGoodsCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import "StoreGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

@interface StoreGoodsCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *oldPriceLabel;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation StoreGoodsCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    StoreGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreGoodsCell_ID];
    if (cell == nil) {
        cell = [[StoreGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoreGoodsCell_ID];
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
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    CALayer *layer = iconView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;

    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    nameLabel.textColor = k_defaultTextColor;
    nameLabel.font = StoreGoodsCellNameLabelFont;
    nameLabel.numberOfLines = 0;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    priceLabel.textColor = yello_color;
    priceLabel.font = StoreGoodsCellPriceLabelFont;

    UILabel *oldPriceLabel = [[UILabel alloc] init];
    self.oldPriceLabel = oldPriceLabel;
    [self.contentView addSubview:oldPriceLabel];
    oldPriceLabel.textColor = gray_color;
    oldPriceLabel.font = StoreGoodsCellOldPriceLabelFont;

    UILabel *countLabel = [[UILabel alloc] init];
    self.countLabel = countLabel;
    [self.contentView addSubview:countLabel];
    countLabel.textColor = gray_color;
    countLabel.font = StoreGoodsCellCountLabelFont;
    
    UIView *lineView = [[UIView alloc] init];
    [self.oldPriceLabel addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = darkGary_color;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = StoreGoodsCellSubViewMargin;
    CGFloat iconViewWH = StoreGoodsCellIconViewHight;
    CGFloat iconViewX = margin * 2;
    CGFloat iconViewY = margin;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    CGFloat nameLabelX = CGRectGetMaxX(self.iconView.frame) + margin;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:StoreGoodsCellNameLabelFont andMaxSize:CGSizeMake(self.width - nameLabelX - margin * 2, MAXFLOAT)];
    self.nameLabel.frame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    CGSize priceLabelSize = [self.priceLabel.text sizeWithFont:StoreGoodsCellPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat priceLabelX = nameLabelX;
    CGFloat priceLabelY = self.height - margin - priceLabelSize.height;
    self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};
   
    CGSize oldPriceLabelSize = [self.oldPriceLabel.text sizeWithFont:StoreGoodsCellOldPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat oldPriceLabelX = CGRectGetMaxX(self.priceLabel.frame) + margin;
    CGFloat oldPriceLabelY = self.height - margin - oldPriceLabelSize.height;
    self.oldPriceLabel.frame = (CGRect){{oldPriceLabelX, oldPriceLabelY}, oldPriceLabelSize};
    
    CGSize countLabelSize = [self.countLabel.text sizeWithFont:StoreGoodsCellCountLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat countLabelX = self.width - margin * 2 - countLabelSize.width;
    CGFloat countLabelY = self.height - margin - countLabelSize.height;
    self.countLabel.frame = (CGRect){{countLabelX, countLabelY}, countLabelSize};
    
    self.lineView.frame = CGRectMake(0, self.oldPriceLabel.height * 0.5, self.oldPriceLabel.width, 0.6);
}

- (void)setStoreGoods:(StoreGoods *)storeGoods
{
    _storeGoods = storeGoods;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_storeGoods.imglink] placeholderImage:[UIImage imageNamed:nil]];
    self.nameLabel.text = _storeGoods.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", _storeGoods.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@", _storeGoods.oprice];
    self.countLabel.text = [NSString stringWithFormat:@"已售%d", _storeGoods.sold];
}
@end
