//
//  ReceivedPraisegCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/18.
//
//

#import "ReceivedPraiseCell.h"

#define k_section_margin_top 15

#define k_section_1_height 55
#define k_section_2_height 20
#define k_section_3_height 90

#define k_cell_margin_left 15

@implementation ReceivedPraiseCell

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
    return k_section_margin_top + k_section_1_height + k_section_2_height + k_section_3_height;
}

- (void)setupCell{
    self.frame = CGRectMake(0, 0, kScreenWidth, [self calHeightOfCell]);
    self.contentView.frame = self.frame;
    
    [self.contentView removeAllSubviews];
    
    CGFloat x = k_cell_margin_left;
    CGFloat y = k_section_margin_top;
    
    UIView * section = [UIView view_sub:@{V_Parent_View:self.contentView,
                                          V_Frame:rectStr(x, y, self.contentView.width-2*x, self.contentView.height-y),
                                          V_Border_Radius:@5,
                                          V_BGColor:white_color,
                                          }];
    [self.contentView addSubview:section];
    
    x = 7;
    y = 7;
    UIView * section_1 = [UIView view_sub:@{V_Parent_View:section,
                                            V_Frame:rectStr(x, y, section.width-2*x, k_section_1_height-2*y),
                                            }];
    [section addSubview:section_1];
    
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
    
    CGFloat lineHeight = 16;
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
    
    UILabel * section_2 = [UIView label:@{V_Parent_View:section,
                                          V_Last_View:section_1,
                                          V_Margin_Top:strFloat(y),
                                          V_Margin_Left:strFloat(x),
                                          V_Margin_Right:strFloat(x),
                                          V_Height:strFloat(k_section_2_height),
                                          V_BGColor:clear_color,
                                          V_Font_Size:@16,
                                          V_Font_Family:k_fontName_FZZY,
                                          V_Color:midZongSeColor,
                                          V_Text:@"赞了你",
                                          }];
    [section addSubview:section_2];
    
    UIView * section_3 = [UIView view_sub:@{V_Parent_View:section,
                                            V_Last_View:section_2,
                                            V_Margin_Top:strFloat(y),
                                            V_Margin_Left:strFloat(x),
                                            V_Margin_Right:strFloat(x),
                                            V_Height:strFloat(k_section_3_height-y+2),
                                            }];
    [section addSubview:section_3];
    
    UIImageView * picv = [UIView imageView:@{V_Parent_View:section_3,
                                             V_Width:strFloat(section_3.height),
                                             V_Img:@"res/user/0.png",
                                             V_Margin_Bottom:@5,
                                             V_ContentMode:num(ModeFill),
                                             }];
    [section_3 addSubview:picv];
    
    imglink = [_data_dict objectOutForKey:@"imglink"];
    if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
        [picv setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
    }
    else{
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
        if (img) {
            [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
            [picv setImage:img];
        }
    }
    
    NSDictionary * topicDict = [_data_dict objectOutForKey:@"topic"];
    NSString * text = [NSString stringWithFormat:@"#%@#", [topicDict objectOutForKey:@"title"]];
    UILabel * title = [UIView label:@{V_Parent_View:section_3,
                                      V_Left_View:picv,
                                      V_Margin_Top:@3,
                                      V_Margin_Left:@3,
                                      V_Margin_Right:@3,
                                      V_Height:@20,
                                      V_Text:text,
                                      V_TextAlign:num(TextAlignCenter),
                                      V_Font_Size:@16,
                                      V_Font_Family:k_fontName_FZZY,
                                      V_Color:darkZongSeColor,
                                      }];
    [section_3 addSubview:title];
    
    UILabel * time = [UIView label:@{V_Parent_View:section_3,
                                     V_Margin_Right:strFloat(1),
                                     V_Margin_Bottom:@2,
                                     V_Height:@15,
                                     V_Over_Flow_Y:num(OverFlowBottom),
                                     V_BGColor:clear_color,
                                     V_Text:[_data_dict objectOutForKey:@"ctime"],
                                     V_Font_Size:@11,
                                     V_Font_Family:k_fontName_FZXY,
                                     V_Color:UIColorFromRGB(0xb29474, 1.0f),
                                     V_TextAlign:num(TextAlignRight),
                                     }];
    [section_3 addSubview:time];
    
    text = [topicDict objectOutForKey:@"summary"];
    NSInteger count = [NSString numberOfLineWithText:text font:[UIFont systemFontOfSize:12] superWidth:section_3.width-picv.x-picv.width-10 breakLineChar:nil];
    CGFloat hei = section_3.height-title.y-title.height-time.height-10;
    if (count * 18 < hei) {
        hei = count * 18;
    }
    UILabel * summary = [UIView label:@{V_Parent_View:section_3,
                                        V_Left_View:picv,
                                        V_Last_View:title,
                                        V_Margin_Left:@3,
                                        V_Margin_Right:@3,
                                        V_Height:strFloat(hei),
                                        V_Text:text,
                                        V_TextAlign:num(TextAlignCenter),
                                        V_Font_Size:@16,
                                        V_Font_Family:k_fontName_FZXY,
                                        V_Color:UIColorFromRGB(0xb29474, 1.0f),
                                        V_NumberLines:num(count),
                                        }];
    [section_3 addSubview:summary];
}

@end
