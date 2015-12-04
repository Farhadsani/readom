//
//  GlobalFunction.h
//  
//
//  Created by hf on 13-7-3.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//
#import "GlobalConstants.h"

inline static void doShakeAnimation (UIView *view){
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.1];
    shake.toValue = [NSNumber numberWithFloat:+0.1];
    shake.duration = 0.1;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 2;
    [view.layer addAnimation:shake forKey:@"imageView"];
    view.alpha = 1.0;
    [UIView animateWithDuration:1.5 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}
inline static NSString  *tanslateLocalCode (NSString *key, NSString* tbl, NSString* comment){
    NSString *alphabet = @"\\d+";
    NSPredicate *alphabetP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphabet];
    BOOL containAlphabet = [alphabetP evaluateWithObject:key];
    NSString *errorString;
    if (containAlphabet) {
#ifdef __SHOW_ERROR_CODE__
        errorString = [NSString stringWithFormat:@"%@(错误码:%@)",[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)], key];
#else
        errorString = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)]];
#endif
    } else {
        errorString = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)]];
    }
    return errorString;
}
inline static BOOL  validateEmail (NSString * email){
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest  evaluateWithObject:email];
}
inline static BOOL  checkIsNormalCharacter (NSString * string){
    NSString *emailRegex = @"[A-Z0-9a-z]{8}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:string];
}
inline static NSString * deleteWhiteSpace(NSString* string){
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string;
}
inline static UIColor* getColorFromHex(NSString *hexColor){
    if (hexColor == nil) {
        return nil;
    } else if ([hexColor isEqualToString: @"transparent"] || [hexColor isEqualToString: @"clear"]){
        return [UIColor clearColor];
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}
inline static UIImage* getImageFromString(NSString *string) {
    NSArray *array = [string componentsSeparatedByString:@"."];
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
    return [UIImage imageWithContentsOfFile:imagePath];
}
inline static NSString * str(NSInteger i){
    NSString * string = [NSString stringWithFormat:@"%d", (int)i];
    return string;
}
inline static NSString * strFloat(CGFloat f){
    NSString * string = [NSString stringWithFormat:@"%f", f];
    return string;
}
inline static NSString * strLong(long l){
    NSString * string = [NSString stringWithFormat:@"%ld", l];
    return string;
}
inline static NSString * strDouble(double f){
    NSString * string = [NSString stringWithFormat:@"%lf", f];
    return string;
}
inline static NSString * strObj(id obj){
    NSString * string = [NSString stringWithFormat:@"%@", obj];
    return string;
}
inline static NSString * strBOOL(BOOL bol){
    return (bol)?@"YES":@"NO";
}
inline static NSNumber * num(NSInteger i){
    NSNumber * number = [NSNumber numberWithInteger:i];
    return number;
}
inline static NSNumber * numFloat(CGFloat f){
    NSNumber * number = [NSNumber numberWithFloat:f];
    return number;
}
//适配屏幕，计算宽度
inline static CGFloat fit_W(CGFloat width){
    return width  * kScreenWidth / 384.0;
}
//适配屏幕，计算高度
inline static CGFloat fit_H(CGFloat height){
    return height * (kScreenHeight-20) / (648.0-24.0);
}
//视图大小
inline static NSString * rectStr(CGFloat x, CGFloat y, CGFloat w, CGFloat h){
    return NSStringFromCGRect(CGRectMake(x, y, w, h));
}
inline static CGRect rect(NSString * frameStr){
    return CGRectFromString(frameStr);
}
//内部偏移，类似于css的padding margin值
inline static NSString * edgeStr(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left){
    return NSStringFromUIEdgeInsets(UIEdgeInsetsMake(top, left, bottom, right));
}
inline static UIEdgeInsets edge(NSString * edgeStr){
    return UIEdgeInsetsFromString(edgeStr);
}
inline static NSString * selStr(SEL sel){
    return NSStringFromSelector(sel);
}
inline static SEL sel(NSString * selStr){
    return NSSelectorFromString(selStr);
}
inline static UIView * toView(id obj){
    if (obj && ([obj isKindOfClass:[UIView class]] || [obj isMemberOfClass:[UIView class]])) {
        return (UIView *)obj;
    }
    else if (obj){
        return obj;
    }
    else{
        return nil;
    }
}
inline static UIViewController * toViewController(id obj){
    if (obj && ([obj isKindOfClass:[UIViewController class]] || [obj isMemberOfClass:[UIViewController class]])) {
        return (UIViewController *)obj;
    }
    else if (obj){
        return obj;
    }
    else{
        return nil;
    }
}
