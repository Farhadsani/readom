//
//  UISelectCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/3.
//
//

#import "UISelectCell.h"

@implementation UISelectCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        uiImageback = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 180, 40)];
        [uiImageback setImage:[UIImage imageNamed:@"btnBack1.png"]];
        uiImageback.alpha = 0.0f;
//        uiImageback.backgroundColor
        
        uiLabelItem = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//        uiLabelItem.text = @"22222";
        uiLabelItem.textColor = UIColorFromRGB(0x00ff00, 1.0f);
        uiLabelItem.backgroundColor = [UIColor clearColor];
        uiLabelItem.textAlignment = NSTextAlignmentCenter;
//        uiLabelItem.backgroundColor = UIColorFromRGB(0xe6be78, 1.0f);
        uiLabelItem.layer.cornerRadius = 10;
        uiLabelItem.clipsToBounds = YES;
        
        [self addSubview:uiImageback];
        [self addSubview:uiLabelItem];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    NSLog(@"select......%d", selected);
//    buttonItem.selected = selected;
    if (selected == 1)
    {
        uiImageback.alpha = 1.0f;
        uiLabelItem.backgroundColor = UIColorFromRGB(0xe6be78, 1.0f);
    }else
    {
        uiImageback.alpha = 0.0f;
        uiLabelItem.backgroundColor = UIColorFromRGB(0xffffff, 1.0f);
    }
}

-(void)setItemName:(NSString *)name
{
    uiLabelItem.text = name;
}

@end
