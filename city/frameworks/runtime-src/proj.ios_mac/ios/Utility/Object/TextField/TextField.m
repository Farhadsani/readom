//
//  TextField.m
//  MHTextField
//
//  Created by hf on 6/13/15.
//  Copyright (c) 2015 yjmenu.com. All rights reserved.
//

#import "TextField.h"

@implementation TextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)inf{
    self = [super initWithFrame:frame info:inf];
//    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
//    NSLog(@"%s  %@",__FUNCTION__,self.inf);
    
    [self setStyle];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    NSLog(@"%s  %@",__FUNCTION__,self.inf);
    
    [self setStyle];
}

- (void)setStyle{
    [self setBorderStyle:UITextBorderStyleNone];
    
//    [self setFont: [UIFont systemFontOfSize:10]];
//    [self setTintColor:[UIColor orangeColor]];
//    [self setBackgroundColor:[UIColor blueColor]];
}
//

- (CGFloat)textRectMarginLeft{
    if ([self.inf objectOutForKey:V_LeftText]) {
        NSString * text = [self.inf objectOutForKey:V_LeftText];
        UIFont * f = [UIFont systemFontOfSize:k_default_fontSize];
        if ([self.inf objectOutForKey:V_Font_Size]) {
            f = [UIFont systemFontOfSize:[[self.inf objectOutForKey:V_Font_Size] floatValue]];
        }
        CGFloat w = [text sizeWithAttributes:@{NSFontAttributeName:f}].width+10;
        //        Info(@"%f", w);
        return w;
    }
    else{
        return 30;
    }
}

- (CGFloat)leftViewRectWidth{
    if ([self.inf objectOutForKey:V_LeftText]) {
        NSString * text = [self.inf objectOutForKey:V_LeftText];
        UIFont * f = [UIFont systemFontOfSize:k_default_fontSize];
        if ([self.inf objectOutForKey:V_Font_Size]) {
            f = [UIFont systemFontOfSize:[[self.inf objectOutForKey:V_Font_Size] floatValue]];
        }
        CGFloat w = [text sizeWithAttributes:@{NSFontAttributeName:f}].width+5;
        return w;
    }
    else{
        return 12;
    }
}
- (CGFloat)leftViewMargingLeft{
    if ([self.inf objectOutForKey:V_LeftImage] && [self.inf objectOutForKey:V_LeftImageMarginLeft]) {
        return [[self.inf objectOutForKey:V_LeftImageMarginLeft] floatValue];
    }
    else{
        return 0;
    }
}
- (CGFloat)leftTextMargingLeft{
    if ([self.inf objectOutForKey:V_LeftTextMarginLeft]) {
        return [[self.inf objectOutForKey:V_LeftTextMarginLeft] floatValue];
    }
    else{
        return 0;
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    //没有获得焦点时
    if (self.inf && ([self.inf objectOutForKey:V_LeftImage] || [self.inf objectOutForKey:V_Left_View] || [self.inf objectOutForKey:V_LeftText])) {
        return CGRectInset(bounds, [self textRectMarginLeft]+[self leftTextMargingLeft], 5);
    }
    else{
        return CGRectInset(bounds, 10+[self leftTextMargingLeft], 5);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    //获得焦点时
    if (self.inf && ([self.inf objectOutForKey:V_LeftImage] || [self.inf objectOutForKey:V_Left_View] || [self.inf objectOutForKey:V_LeftText])) {
        return CGRectInset(bounds, [self textRectMarginLeft]+[self leftTextMargingLeft], 5);
    }
    else{
        return CGRectInset(bounds, 10+[self leftTextMargingLeft], 5);
    }
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    if (self.inf && ([self.inf objectOutForKey:V_LeftImage] || [self.inf objectOutForKey:V_Left_View] || [self.inf objectOutForKey:V_LeftText])) {
        return CGRectMake(10+[self leftViewMargingLeft], 0, [self leftViewRectWidth], bounds.size.height);
    }
    else{
        return CGRectMake(0+[self leftViewMargingLeft], 0, 0, 0);
    }
}

//- (CGRect)rightViewRectForBounds:(CGRect)bounds{
//    return CGRectInset(bounds, 5, 5);
//}
//
//- (void)layoutSublayersOfLayer:(CALayer *)layer{
//    NSLog(@"%s  %@",__FUNCTION__,self.inf);
//    [super layoutSublayersOfLayer:layer];
//    
//    [layer setBorderWidth: 0.8];
//    [layer setBorderColor: [UIColor colorWithWhite:0.1 alpha:0.2].CGColor];
//    
//    [layer setCornerRadius:3.0];
//    [layer setShadowOpacity:1.0];
//    [layer setShadowColor:[UIColor redColor].CGColor];
//    [layer setShadowOffset:CGSizeMake(1.0, 1.0)];
//}
//
//- (void) drawPlaceholderInRect:(CGRect)rect {
////    //显示placeholder值时
////    NSLog(@"%s  %@",__FUNCTION__,self.inf);
////    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
////    [self.placeholder drawInRect:CGRectInset(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width-20, rect.size.height), 5, 5) withAttributes:attributes];
//}

@end
