//
//  SysMsgCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/14.
//
//

#import "SysMsgCell.h"

#define k_section_1_height 55
#define k_section_2_margin_top 5
#define k_section_3_height 10

#define k_cell_margin_left 10

@implementation SysMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data_dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        //        self.backgroundColor = RandomColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if (!_data_dict) {
            self.data_dict = [[[NSMutableDictionary alloc] init] autorelease];
        }
        [_data_dict removeAllObjects];
        [_data_dict setNonEmptyValuesForKeysWithDictionary:data_dict];
        
        [self setupCell];
    
    return self;
    
}

- (CGFloat)calHeightOfCell{
    return k_section_1_height + [self heightOfSection2];
}

- (CGFloat)heightOfSection2{
    CGFloat height = k_section_2_margin_top;
    CGFloat tmp = [[self attrContent:[_data_dict objectOutForKey:@"content"]] heightForWidth:kScreenWidth-2*k_cell_margin_left-10] + 8;
    
    height += tmp;
    return height;
}

- (NSAttributedString *)attrContent:(NSString *)text{
    return [NSAttributedString attrContent:text fontName:k_fontName_FZXY fontsize:14 color:k_defaultLightTextColor lineHeight:25.0 align:NSTextAlignmentLeft];
}

- (void)setupCell{
    self.frame = CGRectMake(0, 0, kScreenWidth, [self calHeightOfCell]);
    self.contentView.frame = self.frame;
    
    [self.contentView removeAllSubviews];
    
    CGFloat y = k_cell_margin_left;
    UIView * line = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Margin_Top:strFloat(y),
                                       V_Width:strFloat(self.contentView.width),
                                       V_Height:@0.5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [self.contentView addSubview:line];
    UIView * section_1 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Frame:rectStr(0, y+0.5, self.contentView.width, k_section_1_height-y),
                                            V_BGColor:white_color,
                                            }];
    [self.contentView addSubview:section_1];
    
    userLogo = [UIView imageView:@{V_Parent_View:section_1,
                                   V_Width:strFloat(section_1.height-7),
                                   V_Margin_Left:@10,
                                   V_Margin_Top:@7,
                                   V_Border_Radius:strFloat(section_1.height-7/2.0),
                                   V_Img:@"res/user/0.png",
                                   V_ContentMode:num(ModeAspectFill),
                                   }];
    [section_1 addSubview:userLogo];
    userLogo.clipsToBounds = YES;
    
    CGFloat lineHeight = 20;
    UILabel * lab1 = [UIView label:@{V_Parent_View:section_1,
                                     V_Left_View:userLogo,
                                     V_Margin_Left:@5,
                                     V_Margin_Top:@9,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Size:@14,
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Color:k_defaultTextColor,
                                     V_Text:[NSString stringWithFormat:@"%@通知", [Device appDisplayName]],
                                     V_Alpha:@0.8,
                                     }];
    [section_1 addSubview:lab1];
    UILabel * lab2 = [UIView label:@{V_Parent_View:section_1,
                                     V_Left_View:userLogo,
                                     V_Last_View:lab1,
                                     V_Margin_Top:@3,
                                     V_Margin_Left:@5,
                                     V_Height:@15,
                                     V_Font_Size:@11,
                                     V_Font_Family:k_fontName_FZXY,
                                     V_Color:k_defaultLightTextColor,
                                     }];
    lab2.text = [[_data_dict objectOutForKey:@"ctime"] timeString2DateString];
    [section_1 addSubview:lab2];
    

    UIView * section_2 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Last_View:section_1,
                                            V_Height:strFloat([self heightOfSection2]),
                                            V_BGColor:white_color,
                                            V_Height:@50,
                                            }];
    [self.contentView addSubview:section_2];
    
    
    UILabel * contentLabel = [UIView label:@{V_Parent_View:section_2,
                                             V_Left_View:userLogo,
                                             V_Margin_Left:@5,
                                             V_Margin_Right:@5,
                                             V_BGColor:white_color,
                                             V_Font_Family:k_fontName_FZXY,
                                             V_Color:k_defaultTextColor,
                                             V_Font_Size:@14,
                                             V_NumberLines:num(99999),
                                             }];
    [contentLabel setAttributedText:[self attrContent:[_data_dict objectOutForKey:@"content"]]];
    [section_2 addSubview:contentLabel];
    
    UIView * line1 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Last_View:section_2,
                                       V_Width:strFloat(self.contentView.width),
                                       V_Height:@0.5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [self.contentView addSubview:line1];
    
}

@end
