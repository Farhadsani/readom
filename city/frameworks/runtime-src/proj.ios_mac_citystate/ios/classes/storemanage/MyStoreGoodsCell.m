//
//  MyStoreGoodsCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/29.
//
//

#import "MyStoreGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

@interface MyStoreGoodsCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *oldPriceLabel;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MyStoreGoodsCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    MyStoreGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreGoodsCell_ID];
    if (cell == nil) {
        cell = [[MyStoreGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyStoreGoodsCell_ID];
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
    self.iconView = iconView;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    [self.contentView addSubview:iconView];
    CALayer *layer = iconView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    nameLabel.textColor = k_defaultTextColor;
    nameLabel.font = MyStoreGoodsCellNameLabelFont;
    nameLabel.numberOfLines = 0;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    priceLabel.textColor = yello_color;
    priceLabel.font = MyStoreGoodsCellPriceLabelFont;
    
    UILabel *oldPriceLabel = [[UILabel alloc] init];
    self.oldPriceLabel = oldPriceLabel;
    [self.contentView addSubview:oldPriceLabel];
    oldPriceLabel.textColor = gray_color;
    oldPriceLabel.font = MyStoreGoodsCellOldPriceLabelFont;
    
    UIView *lineView = [[UIView alloc] init];
    [self.oldPriceLabel addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = darkGary_color;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = MyStoreGoodsCellSubViewMargin;
    CGFloat iconViewWH = MyStoreGoodsCellIconViewHight;
    CGFloat iconViewX = margin * 2;
    CGFloat iconViewY = margin;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    CGFloat nameLabelX = CGRectGetMaxX(self.iconView.frame) + margin;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:MyStoreGoodsCellNameLabelFont andMaxSize:CGSizeMake(self.width - nameLabelX - margin * 2, MAXFLOAT)];
    self.nameLabel.frame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    CGSize priceLabelSize = [self.priceLabel.text sizeWithFont:MyStoreGoodsCellPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat priceLabelX = nameLabelX;
    CGFloat priceLabelY = self.height - margin - priceLabelSize.height;
    self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};
    
    CGSize oldPriceLabelSize = [self.oldPriceLabel.text sizeWithFont:MyStoreGoodsCellOldPriceLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat oldPriceLabelX = CGRectGetMaxX(self.priceLabel.frame) + margin;
    CGFloat oldPriceLabelY = self.height - margin - oldPriceLabelSize.height;
    self.oldPriceLabel.frame = (CGRect){{oldPriceLabelX, oldPriceLabelY}, oldPriceLabelSize};
    
    self.lineView.frame = CGRectMake(0, self.oldPriceLabel.height * 0.5, self.oldPriceLabel.width, 0.6);
}

- (void)setStoreGoodsDetail:(StoreGoodsDetail *)storeGoodsDetail
{
    _storeGoodsDetail = storeGoodsDetail;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:storeGoodsDetail.imglink] placeholderImage:[UIImage imageNamed:nil]];
    self.nameLabel.text = storeGoodsDetail.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", storeGoodsDetail.price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@", storeGoodsDetail.oprice];
}
@end
