//
//  NSString+Addtion.h
//  
//
//  Created by hf on 13-4-22.
//
//
#import <CoreLocation/CoreLocation.h>

@interface NSAttributedString (Height)

- (CGFloat)heightForWidth:(CGFloat)width;

+ (NSAttributedString *)attrContent:(NSString *)text fontsize:(CGFloat)fontsize color:(UIColor *)color;
+ (NSAttributedString *)attrContent:(NSString *)text fontName:(NSString *)fontName fontsize:(CGFloat)fontsize color:(UIColor *)color;
@end

@interface NSString (Addtion)

+ (BOOL)isEmptyString:(NSString *)string;
+ (BOOL)isLocationInChina:(CLLocationCoordinate2D)pt;
//根据定位经纬度，反编码用户实际位置：街道地址、城市名称、国家
+ (NSDictionary *)getAddressWithLatitude:(long long)lat longitude:(long long)lon;

//breakChar:换行符
+ (NSInteger)numberOfLineWithText:(NSString *)text font:(UIFont *)font superView:(UIView *)view breakLineChar:(NSString *)breakChar;
+ (NSInteger)numberOfLineWithText:(NSString *)text font:(UIFont *)font superWidth:(CGFloat)viewWidth breakLineChar:(NSString *)breakChar;

//baseURL:http://www.esoftmobile.com/mobile/download/iphone.html URLString:../introduce.html
//return:http://esoftmobile.com/mobile/introduce.html
+ (NSString *)URLWithString:(NSString *)URLString relativeToURL:(NSString *)baseURL;

//basePath:mobile/download/iphone.html PathString:../introduce.html
//return:mobile/introduce.html
+ (NSString *)PathWithString:(NSString *)PathString relativeToPath:(NSString *)basePath;

//URL:http://www.esoftmobile.com/mobile/download/iphone.html
//return:/mobile/download/iphone.html
+ (NSString *)pathWithURL:(NSString *)URL;
+ (NSString *)trimFileNameOfPath:(NSString *)path;
+ (NSString *)trimUrlOfHost:(NSString *)url;
- (NSString *)urlEncodeValue;

+ (NSString *)postStringWithDictionary:(NSDictionary *)postDict;
+ (NSString *)GETpostStringWithDictionary:(NSDictionary *)postDict;
+ (NSDictionary *)postDictionaryWithString:(NSString *)postString;
+ (NSString *)organizeToJsonStyleWithParams:(NSDictionary *)params method:(NSString *)method;

//URL:http://www.esoftmobile.com/mobile/download/iphone.html
//return:iphone.html
-(NSString *)fileName;


- (NSString *)trimWithStrings:(NSString *)string1, ...;

- (NSString *)trimStringBetween:(NSString *)startTag end:(NSString *)endTag;

//根据定长，将string分割成几段string
+ (NSArray *)trimString:(NSString *)string WithFont:(UIFont *)font AndLength:(CGFloat)length;

//HMAC MD5
- (NSString *)HMACWithSecret:(NSString*)secret;

//计算某年的天数
+ (NSInteger)calcuteDayOfYear:(NSString *)year;

//计算某年某月的天数
+ (NSInteger)calcuteDayWithYear:(NSString *)year mouth:(NSString *)mouth;

//计算一段时间内的月份数或者天数 如：2009/02-2012/11、2009/02/20-2012/11/08
+ (NSInteger)calculateDateRangeFrom:(NSString *)begin to:(NSString *)end dateType:(NSString *)dateType;

//计算当前日期（self）在间隔一段时间（step）后的日期，并返回
//- (NSString *)nextDateWithStep:(NSInteger)step dateType:(NSString *)dateType;

@end

@interface NSString (URLEncoding)

- (NSString *)urlEncodingString;

- (NSString *)urlDecodingString;

@end

@interface NSString (EndpointJson)<UIAlertViewDelegate>

+ (BOOL)hasErrorMessage:(NSDictionary *)jsonDict;

+ (NSDictionary *)getNormalResult:(NSDictionary *)jsonDict;

+ (NSDictionary *)getErrorResult:(NSDictionary *)jsonDict;

+ (BOOL)checkNumeric:(NSString *)string;

+ (BOOL)handelLoginAtOtherPlaceWithMessage:(NSDictionary *)jsonDict;

@end
