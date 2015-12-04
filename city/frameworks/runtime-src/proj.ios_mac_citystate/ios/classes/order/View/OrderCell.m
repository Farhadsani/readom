//
//  OrderCell.m
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import "OrderCell.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"

@interface OrderCell ()

@end

@implementation OrderCell
+ (instancetype)cellForTableView:(UITableView *)tableView{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    [self sutpcell];
//}

- (void)jumoToComment:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickComment:)]) {
        [self.delegate didClickComment:self];
    }
}

- (void)jumoToPay:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPay:)]) {
        [self.delegate didClickPay:self];
    }
}

- (void)setupCell{
    [self.contentView removeAllSubviews];
    
    if (!_orderIntro) {
        return;
    }
    
    self.frame = CGRectMake(0, 0, kScreenWidth, k_order_cell_height);
    UIView * back = [UIView view_sub:@{V_Parent_View:self,
                                       V_Margin_Top:@10,
                                       V_BGColor:white_color,
                                       V_Border_Color:k_defaultLineColor,
                                       V_Border_Width:@0.5,
                                       }];
    [self.contentView addSubview:back];
    
    CGFloat padding = 10;
    CGFloat lineHeight = back.height-2*padding;
    
    UIImageView * logo = [UIView imageView:@{V_Parent_View:back,
                                             V_Frame:rectStr(padding, padding, lineHeight, lineHeight),
                                             V_Border_Color:k_defaultLineColor,
                                             V_Border_Width:@0.5,
                                             V_Border_Radius:@2,
                                             V_ContentMode:num(ModeAspectFill),
                                             }];
    [back addSubview:logo];
    NSString * imglink = _orderIntro.imglink;
    if (imglink) {
        if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
            [logo setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
        }
        else{
            [logo sd_setImageWithURL:[NSURL URLWithString:imglink] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [[Cache shared].pics_dict setNonEmptyObject:image forKey:imglink];
                    [logo setImage:image];
                }
            }];
//            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
//            if (img) {
//                [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
//                [logo setImage:img];
//            }
        }
    }
    
    UIView * rightBack = [UIView view_sub:@{V_Parent_View:back,
                                            V_Left_View:logo,
                                            V_Margin_Left:strFloat(padding/2.0),
                                            V_Margin_Top:strFloat(padding),
                                            V_Height:strFloat(lineHeight),
                                            }];
    [back addSubview:rightBack];
    
    lineHeight = lineHeight/4.0;
    
    UIView * lab1 = [UIView label:@{V_Parent_View:rightBack,
                                    V_Height:strFloat(lineHeight),
                                    V_Text:_orderIntro.storename,
                                    V_Font_Size:@18,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultTextColor,
                                    }];
    [rightBack addSubview:lab1];
    
    lab1 = [UIView label:@{V_Parent_View:rightBack,
                           V_Last_View:lab1,
                           V_Height:strFloat(lineHeight),
                           V_Text:_orderIntro.goodsname,
                           V_Font_Size:@14,
                           V_Font_Family:k_fontName_FZZY,
                           V_Color:k_defaultLightTextColor,
                           }];
    [rightBack addSubview:lab1];
    
    lab1 = [UIView label:@{V_Parent_View:rightBack,
                           V_Last_View:lab1,
                           V_Height:strFloat(lineHeight),
                           V_Text:[NSString stringWithFormat:@"总价￥%.2f 数量%d", _orderIntro.goodscount*[_orderIntro.price floatValue],_orderIntro.goodscount],
                           V_Font_Size:@14,
                           V_Font_Family:k_fontName_FZZY,
                           V_Color:k_defaultLightTextColor,
                           }];
    [rightBack addSubview:lab1];
    
    NSString *status;
    if (_orderIntro.expired) {
        status = @"支付时间已过期";
    } else if (_orderIntro.commented) {
        status = @"已点评";
    } else {
        status = @"待点评";
    }
    lab1 = [UIView label:@{V_Parent_View:rightBack,
                           V_Last_View:lab1,
                           V_Height:strFloat(lineHeight),
                           V_Text:status,
                           V_Font_Size:@14,
                           V_Font_Family:k_fontName_FZZY,
                           V_Color:k_defaultLightTextColor,
                           }];
    [rightBack addSubview:lab1];

    if (!_orderIntro.expired) {
        if (!_orderIntro.payed){
            if ([lab1 isKindOfClass:[UILabel class]]) {
                ((UILabel *)lab1).text = @"未支付";
            }
            UIButton * payButton = [UIView button:@{V_Parent_View:rightBack,
                                                    V_Margin_Right:strFloat(padding+5),
                                                    V_Height:@28,
                                                    V_Width:@80,
                                                    V_Over_Flow_X:num(OverFlowRight),
                                                    V_Over_Flow_Y:num(OverFlowBottom),
                                                    V_Title:@"付款",
                                                    V_Font_Size:@16,
                                                    V_Font_Family:k_fontName_FZZY,
                                                    V_Color:white_color,
                                                    V_BGImg:@"red_pay_icon",
                                                    V_Delegate:self,
                                                    V_SEL:selStr(@selector(jumoToPay:))
                                                    }];
            [rightBack addSubview:payButton];
        } else if (!_orderIntro.commented) {
            UIButton * commentButton = [UIView button:@{V_Parent_View:rightBack,
                                                        V_Margin_Right:strFloat(padding+5),
                                                        V_Height:@28,
                                                        V_Width:@80,
                                                        V_Over_Flow_X:num(OverFlowRight),
                                                        V_Over_Flow_Y:num(OverFlowBottom),
                                                        V_Title:@"点评",
                                                        V_Font_Size:@16,
                                                        V_Font_Family:k_fontName_FZZY,
                                                        V_Color:white_color,
                                                        V_BGImg:@"commentBG",
                                                        V_Delegate:self,
                                                        V_SEL:selStr(@selector(jumoToComment:))
                                                        }];
            [rightBack addSubview:commentButton];
        }
    }
}
@end
