//
//  MsgCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import "MsgCell.h"
#import "NSString+Extension.h"

#define k_section_1_height 65
#define k_section_2_margin_top 10
#define k_section_2_height 25

#define k_cell_margin_left 10
#define k_cell_margin_top 10

@implementation MsgCell
{
    UIView * _section_1;
    UILabel * _section_2;
    UILabel * _section_3;
    NSMutableArray * _array;
}
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
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupCell];
}

- (NSAttributedString *)attrContent:(NSString *)text{
    return [NSAttributedString attrContent:text fontName:k_fontName_FZXY fontsize:13 color:k_defaultTextColor lineHeight:20.0 align:NSTextAlignmentCenter];
}

- (void)hiddenSelectedView{
    UIView * view = [APPLICATION.window viewWithTag:23623];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [view removeFromSuperview];
            }
        }];
    }
    
    view = [APPLICATION.window viewWithTag:23623+1];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
            view.frame = CGRectMake(view.x, APPLICATION.window.height, view.width, view.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [view removeFromSuperview];
            }
        }];
    }
}

- (void)userLogoAction:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgCellUserZone" object:nil userInfo:@{@"cell": self}];
}

- (void)requestDelete:(UIButton *)sender{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"messageid":[_data_dict objectOutForKey:@"messageid"],
                              };
    NSDictionary * dict = @{@"idx":str(0),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_message_user_del,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_message_user_del]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgCellDelete" object:nil userInfo:@{@"cell": self}];
    }
}

- (void)setupCell{    
    [self.contentView removeAllSubviews];
    
    CGFloat y = k_cell_margin_top;
    
    UIView * back = [UIView view_sub:@{V_Parent_View:self.contentView,
                                       V_Margin_Top:strFloat(y),
                                       V_BGColor:white_color,
                                       V_Border_Color:k_defaultLineColor,
                                       V_Border_Width:@0.5,
                                       }];
    [self.contentView addSubview:back];
    
    
    _section_1 = [UIView view_sub:@{V_Parent_View:back,
                                    V_Frame:rectStr(0, 0, back.width, k_section_1_height),
                                    }];
    [back addSubview:_section_1];
    
    [self setupSection_1];
    
    _section_2 = [UIView label:@{V_Parent_View:back,
                                 V_Last_View:_section_1,
                                 V_Margin_Left:strFloat(k_cell_margin_left),
                                 V_Margin_Right:strFloat(k_cell_margin_left),
                                 V_Height:strFloat(k_section_2_height),
                                 V_Text:[[_data_dict objectOutForKey:@"user"] objectOutForKey:@"name"],
                                 V_Font_Size:@14,
                                 V_Font_Family:k_fontName_FZZY,
                                 V_TextAlign:num(TextAlignCenter),
                                 V_Color:k_defaultTextColor,
                                 V_Alpha:@0.8,
                                 }];
    [back addSubview:_section_2];
    
    _section_3 = [UIView label:@{V_Parent_View:back,
                                 V_Last_View:_section_2,
                                 V_Margin_Left:strFloat(k_cell_margin_left),
                                 V_Margin_Right:strFloat(k_cell_margin_left),
                                 V_Height:strFloat([self heightOfSection3]),
                                 V_Font_Size:@14,
                                 V_Font_Family:k_fontName_FZZY,
                                 V_TextAlign:num(TextAlignCenter),
                                 V_Color:k_defaultTextColor,
                                 V_NumberLines:num(99999),
                                 }];
    [_section_3 setAttributedText:[self attrContent:[_data_dict objectOutForKey:@"content"]]];
    [back addSubview:_section_3];
}

- (void)setupSection_1{
    UILabel * ctime = [UIView label:@{V_Parent_View:_section_1,
                                      V_Margin_Left:@15,
                                       V_TextAlign:num(TextAlignLeft),
                                      V_Font_Family:k_fontName_FZXY,
                                      V_Color:k_defaultLightTextColor,
                                      V_Font_Size:@11,
                                      }];
    ctime.text = [[_data_dict objectForKey:@"ctime"] timeString2DateString];
    [_section_1 addSubview:ctime];
    
    CGFloat top = 10;
    userLogo = [UIButton button:@{V_Parent_View:_section_1,
                                   V_Margin_Top:strFloat(top),
                                   V_Margin_Bottom:strFloat(top),
                                   V_Width:strFloat(_section_1.height-2*top),
                                   V_Over_Flow_X:num(OverFlowXCenter),
                                   V_BGColor:white_color,
                                   V_Border_Radius:strFloat((_section_1.height-2*top)/2.0),
                                   V_Img:@"res/user/0.png",
                                  V_Delegate:self,
                                  V_SEL:selStr(@selector(userLogoAction:)),
                                   V_ContentMode:num(ModeAspectFill),
                                   }];
    [_section_1 addSubview:userLogo];
    
    NSString * imglink = [[_data_dict objectOutForKey:@"user"] objectOutForKey:@"imglink"];
    if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
//        [userLogo setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
        [userLogo setImage:[[Cache shared].pics_dict objectForKey:imglink] forState:UIControlStateNormal];
    }
    else{
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
        if (img) {
            [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
             [userLogo setImage:img forState:UIControlStateNormal];
        }
    }
    
    UIButton * del = [UIView button:@{V_Parent_View:_section_1,
                                      V_Margin_Right:@10,
                                      V_Over_Flow_X:num(OverFlowRight),
                                      V_Width:@40,
                                      V_Img:@"del_bg.png",
                                      V_BGImg_S:@"del_s_bg.png",
                                      V_ContentMode:num(ModeCenter),
                                      V_SEL:selStr(@selector(requestDelete:)),
                                      V_Delegate:self,
                                      }];
    [_section_1 addSubview:del];
}

- (CGFloat)calHeightOfCell{
    return k_cell_margin_top + k_section_1_height + [self heightOfSection3] + k_section_2_height;
}

- (CGFloat)heightOfSection3{
    return [[self attrContent:[_data_dict objectOutForKey:@"content"]] heightForWidth:self.width-2*k_cell_margin_left] + 20;
}

@end
