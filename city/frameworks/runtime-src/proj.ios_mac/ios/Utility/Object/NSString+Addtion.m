//
//  NSString+Addtion.m
//  
//
//  Created by hf on 13-4-22.
//
//

#import "NSString+Addtion.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h> 
#import "JSONKit.h"

@implementation NSAttributedString (Addtion)

- (CGFloat)heightForWidth:(CGFloat)width{
    return ceilf(CGRectGetHeight([self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                    context:nil])) + 0;
}

+ (NSAttributedString *)attrContent:(NSString *)text fontName:(NSString *)fontName fontsize:(CGFloat)fontsize color:(UIColor *)color{
    NSString * content = text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    NSAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName : [UIColor color:color],NSFontAttributeName:[UIFont fontWithName:fontName size:fontsize],NSKernAttributeName : @(0.2f), NSParagraphStyleAttributeName:paragraphStyle}] autorelease];
    return attributedString;
}

+ (NSAttributedString *)attrContent:(NSString *)text fontsize:(CGFloat)fontsize color:(UIColor *)color{
    NSString * content = text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    NSAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName : [UIColor color:color],NSFontAttributeName:[UIFont systemFontOfSize:fontsize],NSKernAttributeName : @(0.2f), NSParagraphStyleAttributeName:paragraphStyle}] autorelease];
    return attributedString;
}

@end

@implementation NSString (Addtion)

- (NSString*) HMACWithSecret:(NSString*) secret
{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [self UTF8String];
    unsigned char    mac[CC_MD5_DIGEST_LENGTH];
    char             hexmac[2 * CC_MD5_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgMD5, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}

//urlEncode编码
- (NSString *)urlEncodeValue
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self,NULL, CFSTR(";/?:@&=+$,-!~*\'()")/*NULL*/, kCFStringEncodingUTF8));
    return result;
}

+ (BOOL)isEmptyString:(NSString *)string{
    if (string && [string isKindOfClass:[NSNumber class]]) {
        if ([NSString stringWithFormat:@"%@", string].length == 0) {
            return YES;
        }
    }
    
    if (string && [string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (!string || ![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([string isEqual:[NSNull null]] ||
        ([string length] == 0) ||
        string == nil ||
        [string isEqualToString:@"null"] ||
        [string isEqualToString:@"(null)"] ||
        [string isEqualToString:@"<null>"]){
       
        return YES;
    }
    return NO;
}

+ (BOOL)isLocationInChina:(CLLocationCoordinate2D)pt{
    if (pt.latitude > _Map_Min_latitude_of_china &&
        pt.latitude < _Map_Max_latitude_of_china &&
        pt.longitude > _Map_Min_longitude_of_china &&
        pt.longitude < _Map_Max_longitude_of_china) {
        return YES;
    }
    return NO;
}

//根据定位经纬度，反编码用户实际位置：街道地址、城市名称、国家
+ (NSDictionary *)getAddressWithLatitude:(long long)lat longitude:(long long)lon{
    if ([NSString isLocationInChina:CLLocationCoordinate2DMake(lat, lon)]) {
        NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
        CLLocation * location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark * placemark = [placemarks firstObject];
//            InfoLog(@"%@",placemark.addressDictionary); //根据经纬度会输出该经纬度下的详细地址 国家 地区 街道 之类的
                if (placemark.addressDictionary) {
                    [d setNonEmptyValuesForKeysWithDictionary:placemark.addressDictionary];
                }
            }
        }];
        [geocoder release];
        [location release];
        
        return [d autorelease];
    }
    return nil;
}

+ (NSInteger)numberOfLineWithText:(NSString *)text font:(UIFont *)font superView:(UIView *)view breakLineChar:(NSString *)breakChar{
    NSInteger numer = 0;
    if (!text || text.length == 0) {
        return 0;
    }
    
    NSArray * arr = [text componentsSeparatedByString:(![NSString isEmptyString:breakChar]) ? breakChar : @"\n"];
    float viewWidth = view.frame.size.width;
    CGSize size = CGSizeZero;
    for (NSString * str in arr) {
        size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
        float i = size.width / viewWidth;
        int j = (int)i;
        int n = j + ((i>j)? 1 : 0);
        
        numer += n;
    }
    
    return numer;
}

+ (NSInteger)numberOfLineWithText:(NSString *)text font:(UIFont *)font superWidth:(CGFloat)viewWidth breakLineChar:(NSString *)breakChar{
    NSInteger numer = 0;
    if (!text || text.length == 0) {
        return 0;
    }
    
    NSArray * arr = [text componentsSeparatedByString:(![NSString isEmptyString:breakChar]) ? breakChar : @"\n"];
    CGSize size = CGSizeZero;
    for (NSString * str in arr) {
        if ([NSString isEmptyString:str]) {
            numer++;
        }
        else{
            size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
            float i = size.width / viewWidth;
            int j = (int)i;
            int n = j + ((i>j)? 1 : 0);
            
            numer += n;
        }
    }
    
    return numer;
}

-(NSString *)fileName
{
    NSString *name = self;
    NSUInteger start = [name rangeOfString:@"/"].location;
    while (start != NSNotFound) {
        name = [name substringFromIndex:start + 1];
        start = [name rangeOfString:@"/"].location;
    }
    return name;
}


+ (NSString *)URLWithString:(NSString *)URLString relativeToURL:(NSString *)baseURL{
    if (URLString == nil) {
        return nil;
    }
    return [[NSURL URLWithString:URLString relativeToURL:[NSURL URLWithString:baseURL]] absoluteString];
}

+ (NSString *)PathWithString:(NSString *)PathString relativeToPath:(NSString *)basePath{
    if (PathString == nil) {
        return nil;
    }
    NSString * absStr = [[NSURL URLWithString:PathString relativeToURL:[NSURL URLWithString:basePath]] absoluteString];
    if (absStr) {
        if ([absStr hasPrefix:@"///"]) {
            absStr = [absStr substringFromIndex:3];
        }
        else if ([absStr hasPrefix:@"//"]) {
            absStr = [absStr substringFromIndex:2];
        }
    }
    return absStr;
}

+ (NSString *)pathWithURL:(NSString *)URL{
    NSURL *url = [NSURL URLWithString:URL];
    return [url path];
}

+ (NSString *)turnToPostString:(NSArray *)list{
    if (list == nil || [list count] == 0) return @"";
    
    
    
    return @"";
}

+ (NSString *)postStringWithDictionary:(NSDictionary *)postDict{
    if (postDict == nil || [postDict count] == 0) return @"";
    NSArray *keys = [postDict allKeys];
    if ([keys count] > 0) {
        NSMutableString *postString = [[[NSMutableString alloc] init] autorelease];
        for (NSString *postKey in keys){
            id obj = [postDict objectOutForKey:postKey];
            if ([obj isKindOfClass:[NSString class]]) {
                [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,obj]];
            }
            else{
                [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,[NSString stringWithObjectAsJSON:obj]]];
            }
        }
        NSRange andRange = [postString rangeOfString:@"&"];
        if (andRange.location != NSNotFound) {
            [postString deleteCharactersInRange:NSMakeRange((postString.length - 1), 1)];
        }
        return postString;
    }
    return @"";
}

+ (NSString *)GETpostStringWithDictionary:(NSDictionary *)postDict{
    if (postDict == nil || [postDict count] == 0) return @"";
    NSArray *keys = [postDict allKeys];
    if ([keys count] > 0) {
        NSMutableString *postString = [[[NSMutableString alloc] init] autorelease];
        for (NSString *postKey in keys){
            id obj = [postDict objectOutForKey:postKey];
            if ([obj isKindOfClass:[NSString class]]) {
//                if ([[postKey uppercaseString] rangeOfString:@"LOCATION"].location != NSNotFound ||
//                    [[postKey uppercaseString] rangeOfString:@"ADDRESS"].location != NSNotFound) {
//                    obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//中文转码
//                }
//                obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//中文转码
                [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,obj]];
            }
            else if ([obj isKindOfClass:[UIImage class]]) {
                NSData * data = nil;
                if (UIImagePNGRepresentation((UIImage *)obj)) {
                    data = UIImagePNGRepresentation((UIImage *)obj);
                }
                else{
                    data = UIImageJPEGRepresentation((UIImage *)obj, 1.0);
                }
                if (data) {
                    [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,data]];
                }
            }
            else if ([obj isKindOfClass:[NSArray class]]){
                [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,[NSString stringWithObjectAsJSON:obj]]];
//                for (id ys in obj) {
//                    if ([ys isKindOfClass:[NSString class]]) {
//                        [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,ys]];
//                    }
//                    else{
//                        [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,[NSString stringWithObjectAsJSON:obj]]];
//                    }
//                }
            }
            else{
                [postString appendString:[NSString stringWithFormat:@"%@=%@&",postKey,[NSString stringWithObjectAsJSON:obj]]];
            }
        }
        NSRange andRange = [postString rangeOfString:@"&"];
        if (andRange.location != NSNotFound) {
            [postString deleteCharactersInRange:NSMakeRange((postString.length - 1), 1)];
        }
        return postString;
    }
    return @"";
}


+ (NSDictionary *)turnToDictionaryWithString:(NSString *)postString{
    NSRange range = [postString rangeOfString:@"="];
    if (range.location != NSNotFound) {
        NSArray * a = [postString componentsSeparatedByString:@"="];
        if (a && [a count]==2) {
            return [NSDictionary dictionaryWithObject:[a objectAtExistIndex:1] forKey:[a objectAtExistIndex:0]];
        }
        else if (a && [a count] > 2){
            NSString * key = [postString substringToIndex:range.location];
            NSString * value = [postString substringFromIndex:range.location+range.length];
            if (![NSString isEmptyString:key] && ![NSString isEmptyString:value]) {
                return [NSDictionary dictionaryWithObject:value forKey:key];
            }
        }
    }
    return nil;
}

+ (NSDictionary *)postDictionaryWithString:(NSString *)postString{
    if (postString == nil || postString.length == 0) return nil;
    
    if ([postString rangeOfString:@"&"].location != NSNotFound) {
        NSMutableDictionary * mDict = [[[NSMutableDictionary alloc] init] autorelease];
        NSArray * a = [postString componentsSeparatedByString:@"&"];
        for (NSString * str in a) {
            NSDictionary * md = [NSString turnToDictionaryWithString:str];
            if (md && [md count]==1) {
                NSString * key = [[md allKeys] objectAtExistIndex:0];
                if (key && key.length>0) {
                    [mDict setObject:[md objectOutForKey:key] forKey:key];
                }
            }
        }
        return mDict;
    }
    else{
        return [NSString turnToDictionaryWithString:postString];
    }
}

+ (NSString *)organizeToJsonStyleWithParams:(NSDictionary *)params method:(NSString *)method{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableDictionary * tmp = [[NSMutableDictionary alloc] init];
    [tmp setObject:@"ZH_cn" forKey:@"Locale"];
    [dict setObject:tmp forKey:@"header"];
    
    if (method && method.length>0) {
        [dict setObject:method forKey:@"method"];
    }
    else{
        [dict setObject:@"" forKey:@"method"];
    }
//    [dict setObject:@"null" forKey:k_id];
    
    [dict setObject:@"POST" forKey:@"method"];
    
    if (params && [params count]>0) {
        [dict setObject:params forKey:@"params"];
    }
    else{
        [dict setObject:@"" forKey:@"params"];
    }
    
    [tmp release];
    return [[NSString stringWithObjectAsJSON:dict] stringByReplacingOccurrencesOfString:@"\"null\"" withString:@"null"];
}

//从路径取出最后的文件名，如：参数：/logn/login.html  返回：login.html
+ (NSString *)trimFileNameOfPath:(NSString *)path{
    if ([NSString isEmptyString:path]) {
        return path;
    }
    
    NSString *name = path;
    NSUInteger start = [name rangeOfString:@"/" options:NSBackwardsSearch].location;
    if (start != NSNotFound) {
        name = [name substringFromIndex:start + 1];
    }
    return name;
}

//参数：“http://22.11.18.32/src/logn/login.html 或者 http://22.11.18.32:8089/resourse.action”
//返回：“/src/logn/login.html 或者空”
+ (NSString *)trimUrlOfHost:(NSString *)url{
    NSString * localUrl = url;    
    if ([localUrl rangeOfString:@"http://"].location != NSNotFound) {
        localUrl = [localUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        
        NSRange ran = [localUrl rangeOfString:@".action"];
        if (ran.location != NSNotFound) {
            localUrl = [localUrl substringFromIndex:ran.location+7];
        }
        else{
            NSRange range = [localUrl rangeOfString:@"/"];
            if (range.location != NSNotFound) {
                localUrl = [localUrl substringFromIndex:range.location];
            }
        }
    }
    else if ([localUrl rangeOfString:@"https://"].location != NSNotFound) {
        localUrl = [localUrl stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        
        NSRange ran = [localUrl rangeOfString:@".action"];
        if (ran.location != NSNotFound) {
            localUrl = [localUrl substringFromIndex:ran.location+7];
        }
        else{
            NSRange range = [localUrl rangeOfString:@"/"];
            if (range.location != NSNotFound) {
                localUrl = [localUrl substringFromIndex:range.location];
            }
        }
    }
    
    return localUrl;
}

- (NSString *)trimWithStrings:(NSString *)string1, ...{
    NSString *result = self;
    va_list args;
    va_start(args,string1);

    for (NSString *arg = string1; arg; arg = va_arg(args,NSString *)){
        result = [result stringByReplacingOccurrencesOfString:arg withString:@""];  
    }
    va_end(args);
    return result;
}

- (NSString *)trimStringBetween:(NSString *)startTag end:(NSString *)endTag{
    NSString *string = self;
    NSString *deleteString = nil;
    NSScanner *theScanner = [NSScanner scannerWithString:string];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:startTag intoString:NULL];
        [theScanner scanUpToString:endTag intoString:&deleteString];
        if (deleteString) {
            string = [string stringByReplacingOccurrencesOfString:
                      [NSString stringWithFormat:@"%@%@",deleteString,endTag] withString:@""];
        }
    }
    return string;
}

//根据定长，将string分割成几段string
+ (NSArray *)trimString:(NSString *)string WithFont:(UIFont *)font AndLength:(CGFloat)sLength{
    if (!string) return nil;
    if ([string sizeWithAttributes:@{NSFontAttributeName:font}].width <= sLength || sLength <= 0 || string.length == 0) return [NSArray arrayWithObject:string];
    
    NSMutableArray * resultArr = [[[NSMutableArray alloc] init] autorelease];
    
    NSUInteger strLength = string.length;
    NSInteger index = 0;
    NSInteger startIndex = 0;
    CGFloat lineWidth = 0;
    while (index < strLength) {
        NSString *c = [string substringWithRange:NSMakeRange(index, 1)];
        CGSize letterSize = [c sizeWithAttributes:@{NSFontAttributeName:font}];
        if (lineWidth + letterSize.width > sLength) {
            NSRange lineRange = NSMakeRange(startIndex, index - startIndex);
            if (lineRange.length) {
                NSString *line = [string substringWithRange:lineRange];
                [resultArr addObject:line];
            }
            if (lineWidth) {
                lineWidth = 0;
            }
            startIndex = lineRange.location + lineRange.length;
        }
        lineWidth += letterSize.width;
        ++ index;
    }
    NSRange lineRange = NSMakeRange(startIndex, index - startIndex);
    if (lineRange.length) {
        NSString *line = [string substringWithRange:lineRange];
        [resultArr addObject:line];
    }
    
    return resultArr;
}

//计算当年的天数
+ (NSInteger)calcuteDayOfYear:(NSString *)year{
    NSInteger yearDay = [year integerValue];
    NSInteger dayOfYear = 365;
    if (yearDay%400 == 0 || (yearDay%4 == 0 && yearDay%100 != 0)) { //判断是否为闰年，条件为真则为闰年
        dayOfYear = 366;
    }
    return dayOfYear;
}

//计算当月的天数
+ (NSInteger)calcuteDayWithYear:(NSString *)year mouth:(NSString *)mouth{
    NSInteger yearDay = [year integerValue];
    NSInteger dayOfMonthAtFeb = 28;  //2月份的天数
    if (yearDay%400 == 0 || (yearDay%4 == 0 && yearDay%100 != 0)) { //判断是否为闰年，条件为真则为闰年
        dayOfMonthAtFeb = 29;
    }
    NSInteger dayOfMouth = 30;
    NSInteger n = [mouth integerValue];
    if (2 == n) {
        dayOfMouth = dayOfMonthAtFeb;
    }
    else if (4==n || 6==n || 9==n || 11==n) {
        dayOfMouth = 30;
    }
    else{
        dayOfMouth = 31;
    }
    
    return dayOfMouth;
}

//计算一段时间内的月份数或者天数或者周数 如：2009/02-2012/11、2009/02/20-2012/11/08
//dateType: (字符串)用来区分是按月统计还是按周统计,值为"week"表示按周统计,值为"mouth"或者为空时表示按月统计,默认表示按月统计
+ (NSInteger)calculateDateRangeFrom:(NSString *)begin to:(NSString *)end dateType:(NSString *)dateType{
    if ([begin isEqualToString:end]) {
        return 0;
    }
    else{
        begin = [begin stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        end = [end stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        NSArray * arrBegin = [begin componentsSeparatedByString:@"/"];
        NSArray * arrEnd = [end componentsSeparatedByString:@"/"];
        if ([begin length] == 7) {       // xxxx/xx
            //返回月份数或者周数
            if ([[arrBegin objectAtExistIndex:0] isEqualToString:[arrEnd objectAtExistIndex:0]]) {
                return [[arrEnd objectAtExistIndex:1] integerValue] - [[arrBegin objectAtExistIndex:1] integerValue];
            }
            else{
                NSInteger yearBegin = [[arrBegin objectAtExistIndex:0] integerValue];
                NSInteger mouthBegin = [[arrBegin objectAtExistIndex:1] integerValue];
                NSInteger yearEnd = [[arrEnd objectAtExistIndex:0] integerValue];
                NSInteger mouthEnd = [[arrEnd objectAtExistIndex:1] integerValue];
                if (dateType && [dateType isEqualToString:@"week"]) {
                    //返回周数
                    if (yearEnd - yearBegin == 1) {
                        return (52 - mouthBegin) + mouthEnd;
                    }
                    else{
                        return (52 - mouthBegin) + mouthEnd + (yearEnd - yearBegin - 1)*52;
                    }
                }
                else{
                    //返回月份数
                    if (yearEnd - yearBegin == 1) {
                        return (12 - mouthBegin) + mouthEnd;
                    }
                    else{
                        return (12 - mouthBegin) + mouthEnd + (yearEnd - yearBegin - 1)*12;
                    }
                }
            }
        }
        else if ([begin length] == 10) {  // xxxx/xx/xx
            //返回天数
            if ([[arrBegin objectAtExistIndex:0] isEqualToString:[arrEnd objectAtExistIndex:0]] &&
                [[arrBegin objectAtExistIndex:1] isEqualToString:[arrEnd objectAtExistIndex:1]]) {
                return [[arrEnd objectAtExistIndex:2] intValue] - [[arrBegin objectAtExistIndex:2] integerValue];
            }
            else if([[arrBegin objectAtExistIndex:0] isEqualToString:[arrEnd objectAtExistIndex:0]]){
                NSInteger mouthBegin = [[arrBegin objectAtExistIndex:1] integerValue];
                NSInteger mouthEnd = [[arrEnd objectAtExistIndex:1] integerValue];
                NSInteger dayBegin = [[arrBegin objectAtExistIndex:2] integerValue];
                NSInteger dayEnd = [[arrEnd objectAtExistIndex:2] integerValue];
                
                NSInteger sum = (mouthEnd - mouthBegin - 1);
                NSInteger dayOfMouth = 0;
                for (int i = 0; i < sum; ++i) {
                    dayOfMouth += [NSString calcuteDayWithYear:[arrBegin objectAtExistIndex:0] mouth:[NSString stringWithFormat:@"%d", (int)mouthBegin+1]];
                }
                NSInteger dayOfCurrentMouth = [NSString calcuteDayWithYear:[arrBegin objectAtExistIndex:0] mouth:[arrBegin objectAtExistIndex:1]];  //计算当月的总天数
                
                return (dayOfCurrentMouth - dayBegin) + dayEnd + dayOfMouth;
            }
            else{
                NSInteger yearBegin = [[arrBegin objectAtExistIndex:0] integerValue];
                NSInteger yearEnd = [[arrEnd objectAtExistIndex:0] integerValue];
                NSInteger mouthBegin = [[arrBegin objectAtExistIndex:1] integerValue];
                NSInteger mouthEnd = [[arrEnd objectAtExistIndex:1] integerValue];
                NSInteger dayBegin = [[arrBegin objectAtExistIndex:2] integerValue];
                NSInteger dayEnd = [[arrEnd objectAtExistIndex:2] integerValue];
                return (30 - dayBegin) + (12 - mouthBegin)*30 + (yearEnd - yearBegin - 1)*365 + dayEnd + (mouthEnd - 1)*30;                    
            }
        }
        else if ([begin length] == 4){
            //返回年数
            return [end integerValue] - [begin integerValue];
        }
        else if ([begin length] == 1 || [begin length] == 2){
            //返回月数或者天数，月数：范围在1-12  天数：范围在1-31
            return [end integerValue] - [begin integerValue];
        }
    }
    
    return 0;
}

@end


@implementation NSString (URLEncoding)

- (NSString *)urlEncodingString{
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

- (NSString *)urlDecodingString{
    CFStringRef result = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                               (CFStringRef)self,
                                                                               CFSTR(""),
                                                                               kCFStringEncodingUTF8);
    NSString *resultString = [NSString stringWithString:(__bridge NSString *)result];
    CFRelease(result);
    return resultString;
}

@end

@implementation NSString(EndpointJson)

+ (BOOL)hasErrorMessage:(NSDictionary *)jsonDict{
    BOOL isError = NO;
    
    id errorMsg = [NSString getErrorResult:jsonDict];
    if (errorMsg && [errorMsg isKindOfClass:[NSDictionary class]]) {
        isError = YES;
    }
    
    return isError;
}

+ (BOOL)handelLoginAtOtherPlaceWithMessage:(NSDictionary *)jsonDict{
    BOOL isError = NO;
    
    id errorMsg = [NSString getErrorResult:jsonDict];
    if (errorMsg && [errorMsg isKindOfClass:[NSDictionary class]]) {
        isError = YES;
        if ([errorMsg objectOutForKey:@"errorcode"]) {
            id code = [errorMsg objectOutForKey:@"errorcode"];
            if (code && [code isKindOfClass:[NSString class]] && [code isEqualToString:@"USER_L01006"]) {
                isError = YES;
                [[ExceptionEngine shared] alertTitle:nil code:code delegate:nil tag:0 cancelBtn:@"确定" btn1:nil btn2:nil];
            }
        }
    }
    
    return isError;
}

+ (NSDictionary *)getErrorResult:(NSDictionary *)jsonDict{
    if (jsonDict) {
        id result = [jsonDict objectOutForKey:@"ret"];
        if (!result) {
            return @{@"error":@"没有错误码，ret没有值"};
        }
        if (result && [result integerValue] == 0) {
            return nil;
        }
        else{
            return jsonDict;
        }
    }
    
    return nil;
}

+ (NSDictionary *)getNormalResult:(NSDictionary *)jsonDict{
    if (!jsonDict) {
        return nil;
    }
    
    id result = [jsonDict objectOutForKey:@"ret"];
    if (!result) {
        return @{@"error":@"没有错误码，ret没有值"};
    }
    if (result && [result integerValue] == 0) {
        return jsonDict;
    }
    
    return nil;
}

+ (BOOL)checkNumeric:(NSString *)string{
    if (string == nil)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches     == string.length;
}

@end

