//
//  GoodsShoppingCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/11/26.
//
//

#import "GoodsShoppingCell.h"
#import "UIImageView+WebCache.h"

#define GoodsShoppingCell_ID @"GoodsShoppingCell"

@interface GoodsShoppingCell ()
@property (weak, nonatomic) IBOutlet UIImageView *timeline;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation GoodsShoppingCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    GoodsShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsShoppingCell_ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsShoppingCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    self.timeLabel.font = [UIFont fontWithName:k_fontName_FZZY size:14];
    self.timeLabel.textColor = gray_color;
    self.timeLabel.alpha = 0.6;
    
    CALayer *layer = self.iconView.layer;
    layer.cornerRadius = 8;
    layer.masksToBounds = YES;
}

- (void)setTimelineStr:(NSString *)timelineStr
{
    self.timeline.image = [UIImage imageNamed:timelineStr];
}

- (void)setStoreGoodsDetail:(StoreGoodsDetail *)storeGoodsDetail
{
    _storeGoodsDetail = storeGoodsDetail;
    
    self.timeLabel.text = [storeGoodsDetail.ctime substringWithRange:NSMakeRange(0, 10)];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:storeGoodsDetail.imglink]];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@在%@购买%.2f元特买劵%d张", storeGoodsDetail.shoper, storeGoodsDetail.storename, [storeGoodsDetail.price floatValue] * storeGoodsDetail.goodscount, storeGoodsDetail.goodscount]];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineSpacing = 6.0;
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontName_FZZY size:16], NSForegroundColorAttributeName:darkGary_color, NSParagraphStyleAttributeName: mParaStyle} range:NSMakeRange(0, attrStr.length)];
    
    [attrStr addAttributes:@{NSForegroundColorAttributeName:darkblack_color} range:NSMakeRange(0, storeGoodsDetail.shoper.length)];
    
    self.contentLabel.attributedText = attrStr;
}
@end
