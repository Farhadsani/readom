//
//  ReceivedPraisegCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/18.
//
//

#import "ReceivedPraiseCell.h"
#import "NSString+Addtion.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"

#define k_section_margin_top 10

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

- (void)userLogoAction:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mpCellUserZone" object:nil userInfo:@{@"cell": self}];
}

- (void)setupCell{
    self.frame = CGRectMake(0, 0, kScreenWidth, [self calHeightOfCell]);
    self.contentView.frame = self.frame;
    
    [self.contentView removeAllSubviews];
    
    CGFloat x = k_cell_margin_left;
    CGFloat y = k_section_margin_top;
    
    UIView * section = [UIView view_sub:@{V_Parent_View:self.contentView,
                                          V_Frame:rectStr(0, y, self.contentView.width-2, self.contentView.height-y),
                                          V_BGColor:white_color,
                                          V_Border_Color:k_defaultLineColor,
                                          V_Border_Width:@0.5,
                                          }];
    [self.contentView addSubview:section];
    
    x = 8;
    y = 8;
    UIView * section_1 = [UIView view_sub:@{V_Parent_View:section,
                                            V_Frame:rectStr(x, y, section.width-2*x, k_section_1_height-2*y),
                                            }];
    [section addSubview:section_1];
    
    NSDictionary * userDict = [_data_dict objectOutForKey:@"user"];
    userLogo = [UIView imageView:@{V_Parent_View:section_1,
                                   V_Width:strFloat(section_1.height),
                                   V_Height:strFloat(section_1.height),
                                   V_Border_Radius:strFloat(section_1.height/2.0),
                                   V_Img:@"res/user/0.png",
                                   V_Delegate:self,
                                   V_SEL:selStr(@selector(userLogoAction:)),
                                   V_ContentMode:num(ModeAspectFill),
                                   }];
    [section_1 addSubview:userLogo];
    userLogo.clipsToBounds = YES;
    
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
    
    CGFloat lineHeight = 20;
    UILabel * lab1 = [UIView label:@{V_Parent_View:section_1,
                                     V_Left_View:userLogo,
                                     V_Margin_Left:@5,
                                     V_Margin_Top:strFloat(userLogo.height/2.0-lineHeight),
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Size:@14,
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Color:k_defaultTextColor,
                                     V_Text:[userDict objectOutForKey:@"name"],
                                     V_Alpha:@0.8,
                                     }];
    [section_1 addSubview:lab1];
    UILabel * time = [UIView label:@{V_Parent_View:section_1,
                                     V_Left_View:userLogo,
                                     V_Last_View:lab1,
                                     V_Margin_Top:@5,
                                     V_Margin_Left:@5,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Size:@11,
                                     V_Font_Family:k_fontName_FZXY,
                                     V_Color:k_defaultLightTextColor,
                                     }];
    time.text = [[_data_dict objectOutForKey:@"ctime"] timeString2DateString];
    [section_1 addSubview:time];
    //    }
    //    else{
    //        lab1.frame = CGRectMake(lab1.x, 0, lab1.width, section_1.height);
    //    }
    UILabel * section_2 = [[[UILabel alloc]init]autorelease];
    UIFont * sectionFont = [UIFont fontWithName:k_fontName_FZZY size:16];
    NSString * text1 = @"赞了你";
    CGSize size = [text1 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:section_2.font,NSFontAttributeName, nil]];
    CGFloat with = size.width;
    
    section_2 = [UIView label:@{V_Parent_View:section,
                                V_Last_View:section_1,
                                V_Margin_Top:strFloat(y),
                                V_Margin_Left:strFloat(x),
                                V_Margin_Right:strFloat(x),
                                V_Width:strFloat(with),
                                V_Height:strFloat(k_section_2_height),
                                V_BGColor:clear_color,
                                V_Font:sectionFont,
                                //                                          V_Font_Size:@16,
                                //                                          V_Font_Family:k_fontName_FZZY,
                                V_Color:yello_color,
                                V_Text:text1,
                                }];
    [section addSubview:section_2];
    
    
    UIView * smile = [UIView view_sub:@{V_Parent_View:section,
                                        V_BGImg:@"smile.png",
                                        V_Last_View:section_1,
                                        V_Margin_Top:strFloat(y + 1),
                                        V_Margin_Right:strFloat(x),
                                        V_Width:@18,
                                        V_Height:@18,
                                        V_Height:strFloat(k_section_2_height),
                                        V_Margin_Left:strFloat(section_2.width + 8),
                                        }];
    [section addSubview:smile];
    
    NSString * topicImage = [_data_dict objectForKey:@"imglink"];
//    if (topicImage.length == 0) {
//        _section_3.frame = CGRectMake(0, CGRectGetMaxY(section_2.frame), self.contentView.width, 0);
//    }else{
        _section_3 = [UIView view_sub:@{V_Parent_View:section,
                                        V_Last_View:section_2,
                                        V_Margin_Top:strFloat(y),
                                        V_Margin_Left:strFloat(x),
                                        V_Margin_Right:strFloat(x),
                                        V_Height:strFloat(k_section_3_height-y+2),
                                        }];
        [section addSubview:_section_3];
        
        UIImageView * picv = [UIView imageView:@{V_Parent_View:_section_3,
                                                 V_Width:strFloat(_section_3.height),
                                                 V_Img:@"res/user/0.png",
                                                 V_Margin_Bottom:@5,
                                                 V_ContentMode:num(ModeAspectFill),
                                                 }];
    picv.clipsToBounds = YES;
        [picv sd_setImageWithURL:[NSURL URLWithString:topicImage] placeholderImage:[UIImage imageNamed:@"res/user/0.png"]];
        [_section_3 addSubview:picv];
    
    
    NSString * text = [_data_dict objectOutForKey:@"content"];
    UILabel * title = [UIView label:@{V_Parent_View:_section_3,
                                      V_Left_View:picv,
                                      V_Margin_Top:@3,
                                      V_Margin_Left:@3,
                                      V_Margin_Right:@3,
                                      V_Height:@20,
                                      V_Text:text,
                                      V_TextAlign:num(TextAlignLeft),
                                      V_Font_Size:@15,
                                      V_Font_Weight:num(FontWeightBold),
                                      V_Font_Family:k_fontName_FZZY,
                                      V_NumberLines:num(99999),
                                      V_Color:k_defaultTextColor,
                                      }];
//    title.backgroundColor = RandomColor;
    [title setAttributedText:[self attrContent:[_data_dict objectOutForKey:@"content"]]];

    [_section_3 addSubview:title];
    
}
- (NSAttributedString *)attrContent:(NSString *)text{
    return [NSAttributedString attrContent:text fontName:k_fontName_FZXY fontsize:13 color:k_defaultTextColor lineHeight:20.0 align:NSTextAlignmentCenter];
}


@end
