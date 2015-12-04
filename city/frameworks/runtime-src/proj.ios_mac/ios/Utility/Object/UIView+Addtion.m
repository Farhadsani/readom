//
//  UIView+Addtion.m
//  
//
//  Created by hf on 14-1-17.
//  Copyright (c) 2014年 hf. All rights reserved.
//

#import "UIView+Addtion.h"
#import "BTLabel.h"

@implementation ImgControl
@synthesize customView = _customView;

@end

@implementation UIView (Addtion)

- (void)addAlphaView:(UIColor *)backgroundColor alpha:(CGFloat)alphaNmu{
    if(!self) return;
    UIView * vi = [self viewWithTag:kAlphaViewTag];
    if (vi) {
        [vi removeFromSuperview];
    }
    
    UIView * alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if ([self isKindOfClass:[UIScrollView class]]) {
        alphaView.frame = CGRectMake(0, 0, ((UIScrollView *)self).frame.size.width, ((UIScrollView *)self).contentSize.height);
    }
    alphaView.tag = kAlphaViewTag;
    alphaView.backgroundColor = [UIColor whiteColor];
    if (backgroundColor) {
        alphaView.backgroundColor = backgroundColor;
    }
    alphaView.alpha = 0.5;
    if (alphaNmu > 0) {
        alphaView.alpha = alphaNmu;
    }
    alphaView.userInteractionEnabled = NO;
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [((UITableViewCell *)self).contentView addSubview:alphaView];
    }
    else{
        [self addSubview:alphaView];
    }
    [self sendSubviewToBack:alphaView];
    [alphaView release];
}

+ (CGFloat)translate:(id)percentvalue parentView:(id)parentView{
    if (!percentvalue) return 0;
    
    NSString * str = percentvalue;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"px" withString:@""];
    CGFloat value = 0;
    if ([str rangeOfString:@"%"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"%" withString:@""];
        if ([UIView isViewClass:parentView]) {
            value = toView(parentView).height * [str floatValue] / 100.0;
        }
        else{
            value = [str floatValue];
            InfoLog(@"【Error】:宽度（高度）为百分比，但是没有设置父视图的宽度（高度）(V_Over_Flow_X需要与V_Width结合使用；V_Over_Flow_Y需要与V_Height结合使用) %d", __LINE__);
        }
    }
    else{
        value = [str floatValue];
    }
    return value;
}

+ (CGRect)getFrameFrom:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return CGRectZero;
    
    CGRect frame = CGRectZero;
    if ([inf objectOutForKey:V_Frame]) {
        //优先级最高
        frame = rect([inf objectOutForKey:V_Frame]);
    }
    else{
        id v_root_VC = [inf objectOutForKey:V_Root_VC];
        id v_parent_View = [inf objectOutForKey:V_Parent_View];
        id v_width = [inf objectOutForKey:V_Width];
        id v_height = [inf objectOutForKey:V_Height];
        
        id v_left_view = [inf objectOutForKey:V_Left_View];
        id v_right_view = [inf objectOutForKey:V_Right_View];
        id v_last_view = [inf objectOutForKey:V_Last_View];
        id v_next_view = [inf objectOutForKey:V_Next_View];
        
        id V_margin_top = [inf objectOutForKey:V_Margin_Top];
        id V_margin_right = [inf objectOutForKey:V_Margin_Right];
        id V_margin_bottom = [inf objectOutForKey:V_Margin_Bottom];
        id V_margin_left = [inf objectOutForKey:V_Margin_Left];
        
        id V_margin = [inf objectOutForKey:V_Margin];
        if (V_margin) {
            UIEdgeInsets margin = edge(V_margin);
            V_margin_top = (V_margin_top) ? V_margin_top : [NSNumber numberWithFloat:margin.top];
            V_margin_right = (V_margin_right) ? V_margin_right : [NSNumber numberWithFloat:margin.right];
            V_margin_bottom = (V_margin_bottom) ? V_margin_bottom : [NSNumber numberWithFloat:margin.bottom];
            V_margin_left = (V_margin_left) ? V_margin_left : [NSNumber numberWithFloat:margin.left];
        }
        
        id v_over_flow_x = [inf objectOutForKey:V_Over_Flow_X];
        id v_over_flow_y = [inf objectOutForKey:V_Over_Flow_Y];
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        
        CGFloat parentViewWidth = kScreenWidth;
        if ([UIView isViewClass:v_parent_View]) {
            parentViewWidth = toView(v_parent_View).width;
        }
        else if ([UIView isViewControllerClass:v_root_VC]) {
            parentViewWidth = toViewController(v_parent_View).view.width;
        }
        
        CGFloat parentViewHeight = kScreenHeight;
        if ([UIView isViewClass:v_parent_View]) {
            parentViewHeight = toView(v_parent_View).height;
        }
        else if ([UIView isViewControllerClass:v_root_VC]) {
            parentViewHeight = toViewController(v_parent_View).view.height;
        }
        
        
        //计算宽度
        if (v_width) {
            width = [UIView translate:v_width parentView:v_parent_View];
        }
        else{
            width = parentViewWidth;
            if ([UIView isViewClass:v_left_view]) {
                width = width - (toView(v_left_view).x + toView(v_left_view).width);
            }
            if ([UIView isViewClass:v_right_view]) {
                width = width - (toView(v_right_view).x + toView(v_right_view).width);
            }
            
            if (V_margin_left && V_margin_right) {
                width = width - [V_margin_left floatValue] - [V_margin_right floatValue];
            }
            else{
                if (V_margin_left) {
                    width = width - [V_margin_left floatValue];
                }
                if (V_margin_right) {
                    width = width - [V_margin_right floatValue];
                }
            }
        }
        
        //计算高度
        if (v_height) {
            height = [UIView translate:v_height parentView:v_parent_View];
        }
        else{
            height = parentViewHeight;
            if ([UIView isViewClass:v_last_view]) {
                height = height - (toView(v_last_view).y + toView(v_last_view).height);
            }
            if ([UIView isViewClass:v_next_view]) {
                height = height - (toView(v_next_view).y + toView(v_next_view).height);
            }
            
            if (V_margin_top && V_margin_bottom) {
                height = height - [V_margin_top floatValue] - [V_margin_bottom floatValue];
            }
            else{
                if (V_margin_top) {
                    height = height - [V_margin_top floatValue];
                }
                if (V_margin_bottom) {
                    height = height - [V_margin_bottom floatValue];
                }
            }
        }
        
        //计算x坐标
        if (v_width && v_over_flow_x) {
            //优先级较高
            CGFloat value = [UIView translate:v_width parentView:v_parent_View];
            
            switch ([v_over_flow_x integerValue]) {
                case OverFlowXCenter:
                    x = (parentViewWidth - value)/2.0;
                    break;
                case OverFlowRight:{
                    x = parentViewWidth - value;
                    if (V_margin_right) {
                        x -= [V_margin_right floatValue];
                    }
                    if ([UIView isViewClass:v_right_view]) {
                        x -= (toView(v_right_view).superview.width - toView(v_right_view).x);
                    }
                }
                    break;
                    
                default:{
                    if (V_margin_left) {
                        x += [V_margin_left floatValue];
                    }
                    if ([UIView isViewClass:v_left_view]) {
                        x += (toView(v_left_view).x + toView(v_left_view).width);
                    }
                }
                    break;
            }
        }
        else{
            if ([UIView isViewClass:v_left_view]) {
                x += (toView(v_left_view).x + toView(v_left_view).width);
                if (V_margin_left) {
                    x += [V_margin_left floatValue];
                }
            }
            else if ([UIView isViewClass:v_right_view]) {
//                x = parentViewWidth - x - (toView(v_right_view).x + toView(v_right_view).width);
                x = parentViewWidth - x - (toView(v_right_view).superview.width - toView(v_right_view).x);
                if (V_margin_right) {
                    x -= [V_margin_right floatValue];
                }
                x -= width;
            }
            else if (V_margin_left) {
                x += [V_margin_left floatValue];
            }
            else if (V_margin_right) {
                x = parentViewWidth - x - [V_margin_right floatValue];
                if (v_width) {
                    x -= [v_width floatValue];
                }
                else{
                    x = 0;
                }
            }
        }
        
        //计算y坐标
        if (v_height && v_over_flow_y) {
            //优先级较高
            CGFloat value = [UIView translate:v_height parentView:v_parent_View];
            
            switch ([v_over_flow_y integerValue]) {
                case OverFlowYCenter:
                    y = (parentViewHeight - value)/2.0;
                    break;
                case OverFlowBottom:{
                    y = parentViewHeight - value;
                    if (V_margin_bottom) {
                        y -= [V_margin_bottom floatValue];
                    }
                    if ([UIView isViewClass:v_next_view]) {
                        y -= (toView(v_next_view).superview.height - toView(v_next_view).y);
                    }
                }
                    break;
                    
                default:{
                    if (V_margin_top) {
                        y += [V_margin_top floatValue];
                    }
                    if ([UIView isViewClass:v_left_view]) {
                        y += (toView(v_left_view).y + toView(v_left_view).height);
                    }
                }
                    break;
            }
        }
        else{
            if ([UIView isViewClass:v_last_view]) {
                y += (toView(v_last_view).y + toView(v_last_view).height);
                if (V_margin_top) {
                    y += [V_margin_top floatValue];
                }
            }
            else if ([UIView isViewClass:v_next_view]) {
//                y = parentViewHeight - y - (toView(v_next_view).y + toView(v_next_view).height);
                y = parentViewHeight - y - (toView(v_right_view).superview.height - toView(v_right_view).y);
                if (V_margin_bottom) {
                    y -= [V_margin_bottom floatValue];
                }
                y -= height;
            }
            else if (V_margin_top) {
                y += [V_margin_top floatValue];
            }
            else if (V_margin_bottom) {
                y = parentViewHeight - y - [V_margin_bottom floatValue];
                if (v_height) {
                    y -= [v_height floatValue];
                }
                else{
                    y = 0;
                }
            }
        }
        
        
        frame = CGRectMake(x, y, width, height);
    }
    return frame;
}

+ (void)setCommonStyle:(NSDictionary *)inf toView:(UIView *)view{
    //背景颜色 背景图片 边框 圆角 透明度 Tag 事件响应开关
    view.backgroundColor = [UIColor clearColor];//默认透明
    
    if ([inf objectOutForKey:V_BGColor]) {
        view.backgroundColor = [UIColor color:[inf objectOutForKey:V_BGColor]];
    }
    
    if ([inf objectOutForKey:V_tintColor]) {
        view.tintColor = [UIColor color:[inf objectOutForKey:V_tintColor]];
    }
    
    if ([inf objectOutForKey:V_BGImg]) {
        UIImage * img = [UIView getImg:[inf objectOutForKey:V_BGImg]];
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setBackgroundImage:img forState:UIControlStateNormal];
        }
        if ([view isKindOfClass:[UITextField class]]) {
            ((UITextField *)view).background = img;
        }
        if ([view isKindOfClass:[UILabel class]]) {
            view.backgroundColor = [UIColor colorWithPatternImage:img];
        }
        else{
            view.layer.contents = (id)[img CGImage];
        }
    }
    if ([view isKindOfClass:[UIButton class]] && [inf objectOutForKey:V_BGColor_C]) {
        [(UIButton *)view setBackgroundImage:[UIImage imageWithColor:[inf objectOutForKey:V_BGColor_C] baseView:view] forState:UIControlStateHighlighted];
    }
    if ([view isKindOfClass:[UIButton class]] && [inf objectOutForKey:V_BGColor_S]) {
        [(UIButton *)view setBackgroundImage:[UIImage imageWithColor:[inf objectOutForKey:V_BGColor_S] baseView:view] forState:UIControlStateSelected];
    }
    if ([view isKindOfClass:[UIButton class]] && [inf objectOutForKey:V_BGImg_C]) {
        [(UIButton *)view setBackgroundImage:[UIView getImg:[inf objectOutForKey:V_BGImg_C]] forState:UIControlStateHighlighted];
    }
    if ([view isKindOfClass:[UIButton class]] && [inf objectOutForKey:V_BGImg_S]) {
        [(UIButton *)view setBackgroundImage:[UIView getImg:[inf objectOutForKey:V_BGImg_S]] forState:UIControlStateSelected];
    }
    if ([view isKindOfClass:[UIButton class]] && [inf objectOutForKey:V_BGImg_Unabled]) {
        [(UIButton *)view setBackgroundImage:[UIView getImg:[inf objectOutForKey:V_BGImg_Unabled]] forState:UIControlStateDisabled];
    }
//    //textField默认有灰色边框
//    if ([view isKindOfClass:[UITextField class]]) {
//        view.layer.borderWidth = 0.5;
//        view.layer.borderColor = [UIColor grayColor].CGColor;
//        view.layer.cornerRadius = 2.0;
//        view.layer.masksToBounds = YES;
//    }
    
    if ([inf objectOutForKey:V_Border_Width] && [[inf objectOutForKey:V_Border_Width] floatValue] > 0) {
        view.layer.borderWidth = [[inf objectOutForKey:V_Border_Width] floatValue];
        if ([inf objectOutForKey:V_Border_Color]) {
            view.layer.borderColor = [UIColor color:[inf objectOutForKey:V_Border_Color]].CGColor;
        }
        view.layer.masksToBounds = YES;
    }
    if ([inf objectOutForKey:V_Border_Radius]) {
        view.layer.cornerRadius = [[inf objectOutForKey:V_Border_Radius] floatValue];
        view.layer.masksToBounds = YES;
    }
    if ([inf objectOutForKey:V_Alpha]) {
        view.alpha = [[inf objectOutForKey:V_Alpha] floatValue];
    }
    if ([inf objectOutForKey:V_Tag]) {
        view.tag = [[inf objectOutForKey:V_Tag] integerValue];
    }
    if ([inf objectOutForKey:V_Click_Enable]) {
        switch ([[inf objectOutForKey:V_Click_Enable] integerValue]) {
            case Click_No:
                view.userInteractionEnabled = NO;
                break;
            default:
                view.userInteractionEnabled = YES;
                break;
        }
    }
    if ([inf objectOutForKey:V_Hidden] && [[inf objectOutForKey:V_Hidden] integerValue] == HiddenYES) {
        view.hidden = YES;
    }
}

+ (UITextView *)textView:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    UITextView * view = [[[UITextView alloc] init] autorelease];
    view.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:view];
    
    return view;
}

+ (UIView *)view_sub:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    UIView * view = [[[UIView alloc] init] autorelease];
    view.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:view];
    
    return view;
}

+ (UIScrollView *)scrollView:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    UIScrollView * view = [[[UIScrollView alloc] init] autorelease];
    view.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:view];
    
    return view;
}

+ (UIControl *)control:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    UIControl * view = [[[UIControl alloc] init] autorelease];
    view.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:view];
    
    if ([inf objectOutForKey:V_Delegate] && [inf objectOutForKey:V_SEL]) {
        [view addTarget:[inf objectOutForKey:V_Delegate] action:sel([inf objectOutForKey:V_SEL]) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return view;
}

+ (UILabel *)label:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    UILabel * lab = [[[UILabel alloc] init] autorelease];
    lab.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:lab];
    if ([inf objectOutForKey:V_Text]) {
        lab.text = [inf objectOutForKey:V_Text];
    }
    lab.textColor = [UIColor color:textColor_normal];
    if ([inf objectOutForKey:V_Color]) {
        lab.textColor = [UIColor color:[inf objectOutForKey:V_Color]];
    }
    if ([inf objectOutForKey:V_NumberLines]) {
        lab.numberOfLines = [V_NumberLines integerValue];
    }
    
    
//    if ([inf objectOutForKey:V_Text]) {
//        
////        id v_padding_top = [inf objectOutForKey:V_Padding_Top];
////        id v_padding_right = [inf objectOutForKey:V_Padding_Right];
////        id v_padding_bottom = [inf objectOutForKey:V_Padding_Bottom];
//        id v_padding_left = [inf objectOutForKey:V_Padding_Left];
//        
//        id v_padding = [inf objectOutForKey:V_Padding];
//        if (v_padding) {
//            UIEdgeInsets padding = edge(v_padding);
////            v_padding_top = (v_padding_top) ? v_padding_top : [NSNumber numberWithFloat:padding.top];
////            v_padding_right = (v_padding_right) ? v_padding_right : [NSNumber numberWithFloat:padding.right];
////            v_padding_bottom = (v_padding_bottom) ? v_padding_bottom : [NSNumber numberWithFloat:padding.bottom];
//            v_padding_left = (v_padding_left) ? v_padding_left : [NSNumber numberWithFloat:padding.left];
//        }
//        //    [lab setEdgeInsets:UIEdgeInsetsMake((v_padding_top)?[v_padding_top floatValue]:0, (v_padding_left)?[v_padding_left floatValue]:0, (v_padding_bottom)?[v_padding_bottom floatValue]:0, (v_padding_right)?[v_padding_right floatValue]:0)];
//        
//        
//        NSMutableParagraphStyle *
//        style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
////        style.lineSpacing = 10;//增加行高
////        style.headIndent = 0;//头部缩进，相当于左padding
////        style.tailIndent = 20;//相当于右padding
////        style.lineHeightMultiple = 1.5;//行间距是多少倍
////        style.alignment = NSTextAlignmentLeft;//对齐方式
//        style.firstLineHeadIndent = [v_padding_left floatValue];//首行头缩进
////        style.paragraphSpacing = 20;//段落后面的间距
////        style.paragraphSpacingBefore = 20;//段落之前的间距
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[inf objectOutForKey:V_Text]];
//        [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attrString.length)];
//        lab.attributedText = attrString;
//        [attrString release];
//        [style release];
//        
////        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:textField.text attributes:@{NSForegroundColorAttributeName : [UIColor color:darkblack_color],NSKernAttributeName : @(2.3f)}];
////        [textField setAttributedText:attributedString];
//    }
    
    CGFloat font_size = 14.0;
    if ([inf objectOutForKey:V_Font_Size]) {
        font_size = [[inf objectOutForKey:V_Font_Size] floatValue];
    }
    if ([[inf objectForKey:V_Font_Family] isEqualToString:@"FZY1JW—GB1-0"] || [[inf objectForKey:V_Font_Family] isEqualToString:@"FZY3JW—GB1-0"]) {
        font_size-=7;
    }
    if ([inf objectOutForKey:V_Font_Weight] && [[inf objectOutForKey:V_Font_Weight] integerValue] == FontWeightBold) {
        if ([inf objectOutForKey:V_Font_Family]) {
//            if ([UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",[inf objectOutForKey:V_Font_Family]] size:font_size]) {
                lab.font = [UIFont fontWithName:[inf objectOutForKey:V_Font_Family] size:font_size];
//            }
//            else{
//                lab.font = [UIFont boldSystemFontOfSize:font_size];
//            }
        }
        else{
            lab.font = [UIFont boldSystemFontOfSize:font_size];
        }
    }
    else{
        if ([inf objectOutForKey:V_Font_Family]) {
            lab.font = [UIFont fontWithName:[inf objectOutForKey:V_Font_Family] size:font_size];
        }
        else{
            lab.font = [UIFont systemFontOfSize:font_size];
        }
    }
    
    if ([inf objectOutForKey:V_Font] && [[inf objectOutForKey:V_Font] isKindOfClass:[UIFont class]]) {
        lab.font = (UIFont *)[inf objectOutForKey:V_Font];
    }
    
    if ([inf objectOutForKey:V_TextAlign]) {
        switch ([[inf objectOutForKey:V_TextAlign] integerValue]) {
            case TextAlignCenter:
                lab.textAlignment = NSTextAlignmentCenter;
                break;
            case TextAlignRight:
                lab.textAlignment = NSTextAlignmentRight;
                break;
            default:
                lab.textAlignment = NSTextAlignmentLeft;
                break;
        }
    }
    
    if ([inf objectOutForKey:V_Delegate] && [inf objectOutForKey:V_SEL]) {
        lab.userInteractionEnabled = YES;
        ImgControl * control = [[ImgControl alloc] initWithFrame:CGRectMake(0, 0, lab.width, lab.height)];
        control.customView = lab;
        control.tag = lab.tag;
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:[inf objectOutForKey:V_Delegate] action:sel([inf objectOutForKey:V_SEL]) forControlEvents:UIControlEventTouchUpInside];
        [lab addSubview:control];
        [control release];
    }
    
    return lab;
}
+ (UIButton *)button:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:button];
    if ([inf objectOutForKey:V_ContentEdge]) {
        [button setContentEdgeInsets:edge([inf objectOutForKey:V_ContentEdge])];
    }
    
    [button setTitleColor:[UIColor color:textColor_normal] forState:UIControlStateNormal];
    if ([inf objectOutForKey:V_Color]) {
        [button setTitleColor:[UIColor color:[inf objectOutForKey:V_Color]] forState:UIControlStateNormal];
    }
    if ([inf objectOutForKey:V_Color_C]) {
        [button setTitleColor:[UIColor color:[inf objectOutForKey:V_Color_C]] forState:UIControlStateHighlighted];
    }
    if ([inf objectOutForKey:V_Color_S]) {
        [button setTitleColor:[UIColor color:[inf objectOutForKey:V_Color_S]] forState:UIControlStateSelected];
    }
    if ([inf objectOutForKey:V_Color_Enable]) {
        [button setTitleColor:[UIColor color:[inf objectOutForKey:V_Color_Enable]] forState:UIControlStateDisabled];
    }
    
    if ([inf objectOutForKey:V_Img]) {
        [button setImage:[UIView getImg:[inf objectOutForKey:V_Img]] forState:UIControlStateNormal];
    }
    if ([inf objectOutForKey:V_Img_C]) {
        [button setImage:[UIView getImg:[inf objectOutForKey:V_Img_C]] forState:UIControlStateHighlighted];
    }
    if ([inf objectOutForKey:V_Img_S]) {
        [button setImage:[UIView getImg:[inf objectOutForKey:V_Img_S]] forState:UIControlStateSelected];
    }
    
    if ([inf objectOutForKey:V_ImageEdge]) {
        [button setImageEdgeInsets:edge([inf objectOutForKey:V_ImageEdge])];
    }
    
    if ([inf objectOutForKey:V_Title]) {
        [button setTitle:[inf objectOutForKey:V_Title] forState:UIControlStateNormal];
    }
    if ([inf objectOutForKey:V_Title_C]) {
        [button setTitle:[inf objectOutForKey:V_Title_C] forState:UIControlStateHighlighted];
    }
    if ([inf objectOutForKey:V_Title_S]) {
        [button setTitle:[inf objectOutForKey:V_Title_S] forState:UIControlStateSelected];
    }
    if ([inf objectOutForKey:V_TitleEdge]) {
        [button setTitleEdgeInsets:edge([inf objectOutForKey:V_TitleEdge])];
    }
    
    if ([inf objectOutForKey:V_Selected] && [[inf objectOutForKey:V_Selected] integerValue] == SelectedYES) {
        [button setSelected:YES];
    }
    if ([inf objectOutForKey:V_NumberLines]) {
        button.titleLabel.numberOfLines = [[inf objectOutForKey:V_Color] integerValue];
    }
    
    CGFloat font_size = 14.0;
    if ([inf objectOutForKey:V_Font_Size]) {
        font_size = [[inf objectOutForKey:V_Font_Size] floatValue];
    }
    if ([inf objectOutForKey:V_Font_Weight] && [[inf objectOutForKey:V_Font_Weight] integerValue] == FontWeightBold) {
        if ([inf objectOutForKey:V_Font_Family]) {
//            if ([UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",[inf objectOutForKey:V_Font_Family]] size:font_size]) {
                button.titleLabel.font = [UIFont fontWithName:[inf objectOutForKey:V_Font_Family] size:font_size];
//            }
//            else{
//                button.titleLabel.font = [UIFont boldSystemFontOfSize:font_size];
//            }
        }
        else{
            button.titleLabel.font = [UIFont boldSystemFontOfSize:font_size];
        }
    }
    else{
        if ([inf objectOutForKey:V_Font_Family]) {
            button.titleLabel.font = [UIFont fontWithName:[inf objectOutForKey:V_Font_Family] size:font_size];
        }
        else{
            button.titleLabel.font = [UIFont systemFontOfSize:font_size];
        }
    }
    
    if ([inf objectOutForKey:V_Font] && [[inf objectOutForKey:V_Font] isKindOfClass:[UIFont class]]) {
        button.titleLabel.font = (UIFont *)[inf objectOutForKey:V_Font];
    }
    
    if ([inf objectOutForKey:V_HorizontalAlign]) {
        switch ([[inf objectOutForKey:V_HorizontalAlign] integerValue]) {
            case TextAlignLeft:
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                break;
            case TextAlignRight:
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                break;
            default:
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                break;
        }
    }
    if ([inf objectOutForKey:V_VerticalAlign]) {
        switch ([[inf objectOutForKey:V_VerticalAlign] integerValue]) {
            case VerticalTop:
                [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                break;
            case VerticalBottom:
                [button setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
                break;
            default:
                [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                break;
        }
    }
    
    
    if ([inf objectOutForKey:V_Delegate] && [inf objectOutForKey:V_SEL]) {
        [button addTarget:[inf objectOutForKey:V_Delegate] action:sel([inf objectOutForKey:V_SEL]) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

+ (UIImageView *)imageView:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    UIImageView * imgView = [[[UIImageView alloc] init] autorelease];
    imgView.frame = [UIView getFrameFrom:inf];
    [UIView setCommonStyle:inf toView:imgView];
    
    
    id v_padding_top = [inf objectOutForKey:V_Padding_Top];
    id v_padding_right = [inf objectOutForKey:V_Padding_Right];
    id v_padding_bottom = [inf objectOutForKey:V_Padding_Bottom];
    id v_padding_left = [inf objectOutForKey:V_Padding_Left];
    
    id v_padding = [inf objectOutForKey:V_Padding];
    if (v_padding) {
        UIEdgeInsets padding = edge(v_padding);
        v_padding_top = (v_padding_top) ? v_padding_top : [NSNumber numberWithFloat:padding.top];
        v_padding_right = (v_padding_right) ? v_padding_right : [NSNumber numberWithFloat:padding.right];
        v_padding_bottom = (v_padding_bottom) ? v_padding_bottom : [NSNumber numberWithFloat:padding.bottom];
        v_padding_left = (v_padding_left) ? v_padding_left : [NSNumber numberWithFloat:padding.left];
    }
    UIImageView * tmp = nil;
    if (v_padding_top || v_padding_right || v_padding_bottom || v_padding_left) {
        UIImageView * imgView2 = [[[UIImageView alloc] init] autorelease];
        CGFloat x = (v_padding_left)?[v_padding_left floatValue]:0;
        CGFloat y = (v_padding_top)?[v_padding_top floatValue]:0;
        CGFloat w = imgView.frame.size.width - x - ((v_padding_right)?[v_padding_right floatValue]:0);
        if (!v_padding_right && [inf objectOutForKey:V_Img]) {
            CGFloat imageWidth = [UIView getImg:[inf objectOutForKey:V_Img]].size.width;
            if (imageWidth < w) {
                w = imageWidth;
            }
        }
        CGFloat h = imgView.frame.size.height - y - ((v_padding_bottom)?[v_padding_bottom floatValue]:0);
        if (!v_padding_bottom && [inf objectOutForKey:V_Img]) {
            CGFloat imageheight = [UIView getImg:[inf objectOutForKey:V_Img]].size.height;
            if (imageheight < h) {
                h = imageheight;
            }
        }
        imgView2.frame = CGRectMake(x, y,  w, h);
        imgView2.backgroundColor = [UIColor clearColor];
        imgView2.userInteractionEnabled = NO;
        [imgView addSubview:imgView2];
        
        tmp = imgView2;
    }
    else{
        tmp = imgView;
    }
    
    if ([inf objectOutForKey:V_Img]) {
        [tmp setImage:[UIView getImg:[inf objectOutForKey:V_Img]]];
    }
    if ([NSArray isNotEmpty:[inf objectOutForKey:V_AnimationImages]]) {
        if ([[[inf objectOutForKey:V_AnimationImages] objectAtExistIndex:0] isKindOfClass:[UIImage class]]) {
            [tmp setAnimationImages:[inf objectOutForKey:V_AnimationImages]];
        }
        else{
            NSMutableArray * imgArr = [[NSMutableArray alloc] init];
            for (NSString * imgName in [inf objectOutForKey:V_AnimationImages]) {
                [imgArr addNonEmptyObject:[UIImage imageNamed:imgName]];
            }
            [tmp setAnimationImages:imgArr];
            [imgArr release];
        }
    }
    
    [tmp setContentMode:UIViewContentModeScaleAspectFit];
    if ([inf objectOutForKey:V_ContentMode]) {
        switch ([[inf objectOutForKey:V_ContentMode] integerValue]) {
            case ModeFill:
                [tmp setContentMode:UIViewContentModeScaleToFill];
                break;
            case ModeAspectFit:
                [tmp setContentMode:UIViewContentModeScaleAspectFit];
                break;
            case ModeAspectFill:
                [tmp setContentMode:UIViewContentModeScaleAspectFill];
                break;
            case ModeLeft:
                [tmp setContentMode:UIViewContentModeLeft];
                break;
            case ModeCenter:
                [tmp setContentMode:UIViewContentModeCenter];
                break;
            case ModeRight:
                [tmp setContentMode:UIViewContentModeRight];
                break;
            case ModeTop:
                [tmp setContentMode:UIViewContentModeTop];
                break;
            case ModeBottom:
                [tmp setContentMode:UIViewContentModeBottom];
                break;
                
            default:
                [tmp setContentMode:UIViewContentModeScaleAspectFit];
                break;
        }
    }
    
    if ([inf objectOutForKey:V_Delegate] && [inf objectOutForKey:V_SEL]) {
        imgView.userInteractionEnabled = YES;
        ImgControl * control = [[ImgControl alloc] initWithFrame:CGRectMake(0, 0, imgView.width, imgView.height)];
        control.customView = imgView;
        control.tag = imgView.tag;
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:[inf objectOutForKey:V_Delegate] action:sel([inf objectOutForKey:V_SEL]) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:control];
        [control release];
    }
    
    return imgView;
}

+ (UITextField *)textFiled:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) return nil;
    
    TextField * textField = [[[TextField alloc] initWithFrame:[UIView getFrameFrom:inf] info:inf] autorelease];
//    UITextField * textField = [[[UITextField alloc] initWithFrame:[UIView getFrameFrom:inf]] autorelease];
    textField.borderStyle = UITextBorderStyleNone;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([inf objectOutForKey:V_TextAlign] && [[inf objectOutForKey:V_TextAlign] integerValue] == TextAlignRight) {
        textField.clearButtonMode = UITextFieldViewModeNever;
    }
    
    [UIView setCommonStyle:inf toView:textField];
    
//    if ([inf objectOutForKey:V_Delegate]) {
//        textField.delegate = [inf objectOutForKey:V_Delegate];
//    }
    
    if ([inf objectOutForKey:V_Placeholder]) {
        textField.placeholder = [inf objectOutForKey:V_Placeholder];
    }
    if ([inf objectOutForKey:V_Text]) {
        textField.text = [inf objectOutForKey:V_Text];
        if ([inf objectOutForKey:V_HasLetterSpace] && [[inf objectOutForKey:V_HasLetterSpace] integerValue] == HasLetterSpace_YES) {
            NSAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:[inf objectOutForKey:V_Text] attributes:@{NSForegroundColorAttributeName : [UIColor color:darkblack_color],NSKernAttributeName : @(2.3f)}] autorelease];
            [textField setAttributedText:attributedString];
        }
    }
    
    textField.textColor = [UIColor color:textColor_normal];
    if ([inf objectOutForKey:V_Color]) {
        textField.textColor = [UIColor color:[inf objectOutForKey:V_Color]];
    }
    
    CGFloat font_size = k_default_fontSize;
    if ([inf objectOutForKey:V_Font_Size]) {
        font_size = [[inf objectOutForKey:V_Font_Size] floatValue];
    }
    if ([inf objectOutForKey:V_Font_Weight] && [[inf objectOutForKey:V_Font_Weight] integerValue] == FontWeightBold) {
        if ([inf objectOutForKey:V_Font_Family]) {
//            if ([UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",[inf objectOutForKey:V_Font_Family]] size:font_size]) {
                textField.font = [UIFont fontWithName:[inf objectOutForKey:V_Font_Family] size:font_size];
//            }
//            else{
//                textField.font = [UIFont boldSystemFontOfSize:font_size];
//            }
        }
        else{
            textField.font = [UIFont boldSystemFontOfSize:font_size];
        }
    }
    else{
        if ([inf objectOutForKey:V_Font_Family]) {
            textField.font = [UIFont fontWithName:[inf objectOutForKey:V_Font_Family] size:font_size];
        }
        else{
            textField.font = [UIFont systemFontOfSize:font_size];
        }
    }
    
    if ([inf objectOutForKey:V_Font] && [[inf objectOutForKey:V_Font] isKindOfClass:[UIFont class]]) {
        textField.font = (UIFont *)[inf objectOutForKey:V_Font];
    }
    
    if ([inf objectOutForKey:V_IsSecurity] && [[inf objectOutForKey:V_IsSecurity] integerValue] == SecurityYES) {
        textField.secureTextEntry = YES;
        textField.clearsOnBeginEditing = YES;
    }
    if ([inf objectOutForKey:V_KeyboardType]) {
        switch ([[inf objectOutForKey:V_KeyboardType] integerValue]) {
            case Number:
                textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case Email:
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                break;
            case Url:
                textField.keyboardType = UIKeyboardTypeURL;
                break;
            default:
                textField.keyboardType = UIKeyboardTypeDefault;
                break;
        }
    }
    if ([inf objectOutForKey:V_ReturnKeyType]) {
        switch ([[inf objectOutForKey:V_ReturnKeyType] integerValue]) {
            case Go:
                textField.returnKeyType = UIReturnKeyGo;
                break;
            case Next:
                textField.returnKeyType = UIReturnKeyNext;
                break;
            case Search:
                textField.returnKeyType = UIReturnKeySearch;
                break;
            case Done:
                textField.returnKeyType = UIReturnKeyDone;
                break;
            case Send:
                textField.returnKeyType = UIReturnKeySend;
                break;
            default:
                textField.returnKeyType = UIReturnKeyDefault;
                break;
        }
    }
    
    if ([inf objectOutForKey:V_TextAlign]) {
        switch ([[inf objectOutForKey:V_TextAlign] integerValue]) {
            case TextAlignCenter:
                textField.textAlignment = NSTextAlignmentCenter;
                break;
            case TextAlignRight:
                textField.textAlignment = NSTextAlignmentRight;
                break;
            default:
                textField.textAlignment = NSTextAlignmentLeft;
                break;
        }
    }
    
    if ([inf objectOutForKey:V_Selected] && [[inf objectOutForKey:V_Selected] integerValue] == SelectedYES) {
        [textField becomeFirstResponder];
    }
    
    if ([inf objectOutForKey:V_LeftImage]) {
        UIImageView * im = [self imageView:@{V_Frame:rectStr(0, 0, 30, 30),V_Img:[inf objectOutForKey:V_LeftImage]}];
        im.contentMode = UIViewContentModeScaleAspectFit;
        textField.leftView = im;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    else if ([inf objectOutForKey:V_LeftText]) {
        UILabel * im = [self label:@{V_Text:[inf objectOutForKey:V_LeftText],
                                     V_Font_Size:([inf objectOutForKey:V_Font_Size])?[inf objectOutForKey:V_Font_Size]:num(k_default_fontSize),
                                     V_Color:([inf objectOutForKey:V_Color])?[inf objectOutForKey:V_Color]:[UIColor blackColor]
                                     }];
        im.backgroundColor = [UIColor clearColor];
        textField.leftView = im;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    else if ([inf objectOutForKey:V_Left_View] && [[inf objectOutForKey:V_Left_View] isKindOfClass:[UIView class]]) {
        textField.leftView = [inf objectOutForKey:V_Left_View];
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    if ([inf objectOutForKey:V_RightImage]) {
        UIImageView * im = [self imageView:@{V_Frame:rectStr(0, 0, 30, 30),V_Img:[inf objectOutForKey:V_RightImage]}];
        im.contentMode = UIViewContentModeScaleAspectFit;
        textField.rightView = im;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    else if ([inf objectOutForKey:V_Right_View] && [[inf objectOutForKey:V_Right_View] isKindOfClass:[UIView class]]) {
        textField.rightView = [inf objectOutForKey:V_Right_View];
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return textField;
}

#pragma mark - Util Method

- (CGFloat)x{
    if (self) {
        return self.frame.origin.x;
    }
    else{
        return 0;
    }
}
- (CGFloat)y{
    if (self) {
        return self.frame.origin.y;
    }
    else{
        return 0;
    }
}
- (CGFloat)width{
    if (self) {
        return self.frame.size.width;
    }
    else{
        return 0;
    }
}
- (CGFloat)height{
    if (self) {
        return self.frame.size.height;
    }
    else{
        return 0;
    }
}

+ (BOOL)isViewClass:(id)obj{
    if (obj && ([obj isKindOfClass:[UIView class]] || [obj isMemberOfClass:[UIView class]])) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isViewControllerClass:(id)obj{
    if (obj && ([obj isKindOfClass:[UIViewController class]] || [obj isMemberOfClass:[UIViewController class]])) {
        return YES;
    }
    else{
        return NO;
    }
}
+ (UIImage *)getImg:(id)obj{
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        return obj;
    }
    else if (obj && [obj isKindOfClass:[UIColor class]]){
        return [UIImage imageWithColor:obj];
    }
    else if (obj && [obj isKindOfClass:[NSString class]] && ([obj hasPrefix:@"0x"] || [obj hasPrefix:@"#"] || [[obj lowercaseString] hasPrefix:@"rgb"])){
        return [UIImage imageWithColor:[UIColor color:obj]];
    }
    else if (obj && ![NSString isEmptyString:obj]){
        return [UIImage imageNamed:obj];
    }
    return nil;
}

- (void)resetFrameHeightOfView:(UIView *)view{
    if (view) {
        CGFloat maxHeight = 0.0;
        for (UIView * v in view.subviews) {
            maxHeight = (v.y + v.height > maxHeight) ? v.y + v.height : maxHeight;
        }
        if (maxHeight > 0) {
            view.frame = CGRectMake(view.x, view.y, view.width, maxHeight+10);
        }
    }
}

- (void)resetFrameWidthOfView:(UIView *)view{
    if (view) {
        CGFloat maxWidth = 0.0;
        for (UIView * v in view.subviews) {
            maxWidth = (v.x + v.width > maxWidth) ? v.x + v.width : maxWidth;
        }
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            if (maxWidth < view.width) {
                if (maxWidth > 0) {
                    view.frame = CGRectMake(view.x, view.y, maxWidth, view.height);
                }
            }
        }
        else{
            if (maxWidth > 0) {
                view.frame = CGRectMake(view.x, view.y, maxWidth+10, view.height);
            }
        }
    }
}

@end

