//
//  MyStoreGoodsEditCell.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/30.
//
//

#import "MyStoreGoodsEditCell.h"

#define MyStoreGoodsEditCell_ID @"MyStoreGoodsEditCell"

#define MyStoreGoodsEditCellFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface MyStoreGoodsEditCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation MyStoreGoodsEditCell
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    MyStoreGoodsEditCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStoreGoodsEditCell_ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyStoreGoodsEditCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    self.titleLabel.font = MyStoreGoodsEditCellFont;
    self.titleLabel.textColor = darkGary_color;
    
    self.descLabel.font = MyStoreGoodsEditCellFont;
    self.descLabel.textColor = gray_color;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    self.descLabel.text = desc;
}
@end
