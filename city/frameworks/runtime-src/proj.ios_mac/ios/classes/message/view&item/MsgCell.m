//
//  MsgCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import "MsgCell.h"

#define k_section_1_height 55
#define k_section_2_margin_top 13
#define k_section_3_height 20

#define k_cell_margin_left 15

@implementation MsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data_dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
//        self.backgroundColor = RandomColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_data_dict) {
            self.data_dict = [[[NSMutableDictionary alloc] init] autorelease];
        }
        [_data_dict removeAllObjects];
        [_data_dict setNonEmptyValuesForKeysWithDictionary:data_dict];
        
        [self setupCell];
    }
    return self;
}

- (CGFloat)calHeightOfCell{
    return k_section_1_height + [self heightOfSection2] + k_section_3_height;
}

- (CGFloat)heightOfSection2{
    CGFloat height = k_section_2_margin_top;
    CGFloat tmp = [[self attrContent:[_data_dict objectOutForKey:@"content"]] heightForWidth:kScreenWidth-2*k_cell_margin_left-10] + 8;
//    InfoLog(@"content:%@ height:%f", [NSAttributedString attrContent:[_data_dict objectOutForKey:@"content"]], tmp);
    height += tmp;
    return height;
}

- (NSAttributedString *)attrContent:(NSString *)text{
    return [NSAttributedString attrContent:text fontName:k_fontName_FZXY fontsize:13 color:UIColorFromRGB(0xb29474, 1.0f)];
}

- (void)setupCell{
    self.frame = CGRectMake(0, 0, kScreenWidth, [self calHeightOfCell]);
    self.contentView.frame = self.frame;
    
    [self.contentView removeAllSubviews];
    
    CGFloat x = k_cell_margin_left;
    CGFloat y = k_cell_margin_left;
    UIView * section_1 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Frame:rectStr(x, y, self.contentView.width-2*x, k_section_1_height-y),
                                            }];
    [self.contentView addSubview:section_1];
    
    NSDictionary * userDict = [_data_dict objectOutForKey:@"user"];
    userLogo = [UIView imageView:@{V_Parent_View:section_1,
                                   V_Width:strFloat(section_1.height),
                                   V_Border_Radius:strFloat(section_1.height/2.0),
                                   V_Img:@"res/user/0.png",
                                   V_ContentMode:num(ModeAspectFit),
                                   }];
    [section_1 addSubview:userLogo];
    
    NSString * imglink = [userDict objectOutForKey:@"imglink"];
    if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
        [userLogo setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
    }
    else{
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
        if (img) {
            [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
            [userLogo setImage:img];
        }
    }
    
    CGFloat lineHeight = 18;
    UILabel * lab1 = [UIView label:@{V_Parent_View:section_1,
                                     V_Left_View:userLogo,
                                     V_Margin_Left:@5,
                                     V_Margin_Top:strFloat(userLogo.height/2.0-lineHeight),
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Size:@14,
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Color:UIColorFromRGB(0x666666, 1.0f),
                                     V_Text:[userDict objectOutForKey:@"name"],
                                     }];
    [section_1 addSubview:lab1];
    if (![NSString isEmptyString:[userDict objectOutForKey:@"intro"]]) {
        UILabel * lab2 = [UIView label:@{V_Parent_View:section_1,
                                         V_Left_View:userLogo,
                                         V_Last_View:lab1,
                                         V_Margin_Left:@5,
                                         V_Height:strFloat(lineHeight),
                                         V_Font_Size:@13,
                                         V_Font_Family:k_fontName_FZXY,
                                         V_Color:UIColorFromRGB(0x666666, 1.0f),
                                         V_Text:[userDict objectOutForKey:@"intro"],
                                         }];
        [section_1 addSubview:lab2];
    }
    else{
        lab1.frame = CGRectMake(lab1.x, 0, lab1.width, section_1.height);
    }
    
    UIView * section_2 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Last_View:section_1,
                                            V_Margin_Left:strFloat(x),
                                            V_Margin_Right:strFloat(x),
                                            V_Height:strFloat([self heightOfSection2]),
                                            }];
    [self.contentView addSubview:section_2];
    
    UIImageView * jiantouV = [UIView imageView:@{V_Parent_View:section_2,
                                                 V_BGColor:clear_color,
                                                 V_Img:@"jiantou_white",
                                                 V_Margin_Left:strFloat(userLogo.width),
                                                 V_Height:strFloat(k_section_2_margin_top),
                                                 V_Width:strFloat(20),
                                                 V_ContentMode:num(ModeBottom),
                                                 }];
    [section_2 addSubview:jiantouV];
    
    UIView * innerSectionIn2 = [UIView view_sub:@{V_Parent_View:section_2,
                                                  V_Last_View:jiantouV,
                                                  V_BGColor:white_color,
                                                  V_Border_Radius:@3,
                                                  }];
    [section_2 addSubview:innerSectionIn2];
    
    UILabel * contentLabel = [UIView label:@{V_Parent_View:innerSectionIn2,
                                         V_Margin_Left:@5,
                                         V_Margin_Right:@5,
                                         V_BGColor:clear_color,
                                         V_NumberLines:num(99999),
                                         V_Font_Family:k_fontName_FZXY,
                                         V_Color:UIColorFromRGB(0xb29474, 1.0f),
                                         V_Font_Size:@13,
                                         }];
    [contentLabel setAttributedText:[self attrContent:[_data_dict objectOutForKey:@"content"]]];
    [innerSectionIn2 addSubview:contentLabel];
    
    UILabel * section_3 = [UIView label:@{V_Parent_View:self.contentView,
                                          V_Last_View:section_2,
                                          V_Height:strFloat(k_section_3_height),
                                          V_Margin_Right:strFloat(x+3),
                                          V_BGColor:clear_color,
                                          V_Text:[_data_dict objectOutForKey:@"ctime"],
                                          V_TextAlign:num(TextAlignRight),
                                          V_Font_Family:k_fontName_FZXY,
                                          V_Color:UIColorFromRGB(0xb29474, 1.0f),
                                          V_Font_Size:@11,
                                          }];
    [self.contentView addSubview:section_3];
}

@end
