//
//  PetMsgCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/14.
//
//

#import "PetMsgCell.h"
#import "NSString+Extension.h"

#define k_section_1_height 55
#define k_section_margin_top 10

#define k_cell_margin_left 15

#define yelloText_color             rgb(253, 220, 67)       //小黄人黄色

@implementation PetMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data_dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
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
    return k_section_margin_top + k_section_1_height + [self heightOfSection2];
}

- (CGFloat)heightOfSection2{
    CGFloat height = 0;
    CGFloat tmp = [[self attrContent:[_data_dict objectOutForKey:@"content"]] heightForWidth:kScreenWidth-2*k_cell_margin_left-10-100] + 5;
    height += tmp;
    return height;
}
- (NSAttributedString *)attrContent:(NSString *)text{
    return [NSAttributedString attrContent:text fontName:k_fontName_FZZY fontsize:16 color:yello_color lineHeight:25.0 align:NSTextAlignmentCenter];
}

- (void)requestDelete:(UIButton *)sender{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"messageid":[_data_dict objectOutForKey:@"messageid"],
                              };
    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_message_pet_del,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_pet_del]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"petCellDelete" object:nil userInfo:@{@"cell": self}];
    }
}
- (void)userLogoAction:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"petCellUserZone" object:nil userInfo:@{@"cell": self}];
}

- (void)setupCell{
    self.frame = CGRectMake(0, 0, kScreenWidth, [self calHeightOfCell]);
    self.contentView.frame = self.frame;
    
    CGFloat x = k_cell_margin_left;
    CGFloat y = k_section_margin_top;
    
    [self.contentView removeAllSubviews];
    
    UIView * section = [UIView view_sub:@{V_Parent_View:self.contentView,
                                          V_Frame:rectStr(0, y, self.contentView.width, self.contentView.height-y),
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
    UILabel * name = [UIView label:@{V_Parent_View:section_1,
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
    [section_1 addSubview:name];
    
    UILabel * time = [UIView label:@{V_Parent_View:section_1,
                                     V_Left_View:userLogo,
                                     V_Last_View:name,
                                     V_Margin_Left:@5,
                                     V_Margin_Right:@90,
                                     V_Height:strFloat(lineHeight),
                                     V_Font_Size:@11,
                                     V_Font_Family:k_fontName_FZXY,
                                     V_Color:k_defaultLightTextColor,
                                     }];
    time.text = [[_data_dict objectOutForKey:@"ctime"] timeString2DateString];
    [section_1 addSubview:time];
    
    UIButton * del = [UIView button:@{V_Parent_View:section_1,
                                      V_Margin_Right:@1,
                                      V_Margin_Top:@5,
                                      V_Width:@40,
                                      V_Height:@40,
                                      V_Img:@"del_bg.png",
                                      V_BGImg_S:@"del_s_bg.png",
                                      V_SEL:selStr(@selector(requestDelete:)),
                                      V_Delegate:self,
                                      }];
    [section_1 addSubview:del];
    
    UIView * section_2 = [UIView view_sub:@{V_Parent_View:section,
                                            V_Last_View:section_1,
                                            V_Margin_Top:strFloat(y),
                                            V_Margin_Left:strFloat(x),
                                            V_Margin_Right:strFloat(x),
                                            V_Height:strFloat([self heightOfSection2]),
                                            }];
    [section addSubview:section_2];
    
    UILabel * contentLabel = [[[UILabel alloc]init]autorelease];
    UIFont * sectionFont = [UIFont fontWithName:k_fontName_FZZY size:16];
    NSString * text1 = [_data_dict objectOutForKey:@"content"];
    CGSize size = [text1 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:contentLabel.font,NSFontAttributeName, nil]];
    CGFloat with = size.width;
    
    contentLabel = [UIView label:@{V_Parent_View:section_2,
                                             V_Margin_Left:@5,
                                             V_Margin_Right:@105,
                                             V_Width:strFloat(with),
                                             V_BGColor:white_color,
                                             V_Font:sectionFont,
                                             V_Color:yello_color,
                                             V_NumberLines:num(99999),
                                             V_Text:text1,
                                             }];
    contentLabel.backgroundColor =[UIColor clearColor];
    [section_2 addSubview:contentLabel];
    
    UIView * cry = [UIView view_sub:@{V_Parent_View:section_2,
                                        V_BGImg:@"cry.png",
                                        V_Margin_Top:@6,
                                        V_Margin_Right:strFloat(x),
                                        V_Width:@18,
                                        V_Height:@18,
                                        V_Height:strFloat(contentLabel.height),
                                        V_Margin_Left:strFloat(contentLabel.width + 6),
                                        }];
    [section_2 addSubview:cry];
}
@end
