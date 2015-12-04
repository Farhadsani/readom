//
//  MsgManager.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import "MsgManager.h"
#import "MsgItem.h"
#import "LoggerClient.h"
#import "UserManager.h"

@implementation MsgManager

@synthesize msgList, myMsgList, petMsgList, systemMsgList, supportMsgList;

NSString *testMSGData = @" \
{\"idx\":0,\"ret\":0,\"msg\":\"ok\",\"res\":[ \
{ \
\"userid\":100000, \
\"username\":\"大嘴鸟\", \
\"intro\":\"我的长项是低空飞行\", \
\"zone\":\"Home\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100001, \
\"username\":\"乱画师\", \
\"intro\":\"听说仰望天空能看到未来\", \
\"zone\":\"仰望之地\", \
\"msg\":\"现在把类的声明放在main函数之前，它的作用域是全局的。这样做可以使main函数更简\\n练一些。在main函数中定义了两个对象并且给出了初值，然后输出两个学生的数据。当主函数结束时调用析构函数，输出stud has been destructe!。值得注意的是，真正实用的析构函数一般是不含有输出信息的\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100002, \
\"username\":\"摄手\", \
\"intro\":\"在很久以前其实叫处男座\", \
\"zone\":\"灵感的空间\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100003, \
\"username\":\"叶湘\", \
\"intro\":\"单核大萝卜\", \
\"zone\":\"大萝卜帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100004, \
\"username\":\"高翔\", \
\"intro\":\"群居为主单约为辅\", \
\"zone\":\"这个岛还缺一个女岛主\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100005, \
\"username\":\"岚妹子\", \
\"intro\":\"总是在累觉不爱的时候来桃花\", \
\"zone\":\"暮光之城\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100006, \
\"username\":\"无名\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100007, \
\"username\":\"张三\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100007, \
\"username\":\"李四\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100007, \
\"username\":\"王五\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100010, \
\"username\":\"赵六\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100011, \
\"username\":\"马大\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
{ \
\"userid\":100012, \
\"username\":\"牛二\", \
\"intro\":\"有时候想一句话很费劲\", \
\"zone\":\"桃花帝国\", \
\"msg\":\"泡着茶，看着书，泡着茶，看着书\", \
\"time\":\"2015.3.6\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
}, \
]} \
";



-(id)init {
    self = [super init];
    if (self) {
        msgList = [[NSMutableArray alloc] init];
        myMsgList = [[NSMutableArray alloc] init];
        petMsgList = [[NSMutableArray alloc] init];
        systemMsgList = [[NSMutableArray alloc] init];
        supportMsgList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)requestDate
{
    NSError *error;
    NSData *testData = [testMSGData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableContainers error:&error ];
    //    int resIdx = [[resDict objectForKey:@"idx"] intValue];
    int resRet = [[resDict objectForKey:@"ret"] intValue];
    NSString *msg = [resDict objectForKey:@"msg"];
    NSArray *resRes = [resDict objectForKey:@"res"];
    if (resRet == 0){
        if (YES) {
            //      if ( resIdx == index ) {
            for (NSDictionary* itemDict in resRes) {
                MsgItem *item = [[MsgItem alloc] init];
                
                item.userItem.userid = [[itemDict objectForKey:@"userid"] longValue];
                item.userItem.name = [itemDict objectForKey:@"username"];
                item.userItem.intro = [itemDict objectForKey:@"intro"];
                item.userItem.zone = [itemDict objectForKey:@"zone"];
                item.userItem.imglink = [itemDict objectForKey:@"imglink"];
                item.strMsg = [itemDict objectForKey:@"msg"];
                item.strTime = [itemDict objectForKey:@"time"];
                [msgList addObject:item];
            }
        }
    }else {
        Log(@"request false : %@",msg);
        //        SendNotify(@"SHITOUREN_TOPIC_LIST_FAIL",resDict);
    }

}

//获取我的消息
-(void)requestMyMsgDate :(long)begin :(long)limit
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"begin\":\"%ld\", \"limit\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], begin, limit];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_USER] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     for (NSDictionary* itemDict in resRes) {
            
                         MsgItem *item = [[MsgItem alloc]init];
                         item.strMsg = [itemDict objectForKey:@"content"];
                         item.strTime = [itemDict objectForKey:@"ctime"];
                         NSMutableDictionary *sendUserInfo = [itemDict objectForKey:@"user"];
                         item.userItem.userid = [[sendUserInfo objectForKey:@"userid"] longValue];
                         item.userItem.name = [sendUserInfo objectForKey:@"name"];
                         item.userItem.intro = [sendUserInfo objectForKey:@"intro"];
                         item.userItem.zone = [sendUserInfo objectForKey:@"zone"];
                         item.userItem.imglink = [sendUserInfo objectForKey:@"imglink"];
                         item.userItem.thumblink = [sendUserInfo objectForKey:@"imglink"];
                         
                         [myMsgList addObject:item];
                     }
                     
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"user");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];
}

-(void)delMyMsgData
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_USER_DEL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
//             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     [myMsgList removeAllObjects];
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"user");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];

}

-(void)sendMsg :(long)userID :(NSString*)strContent
{
    InfoLog(@"发送的目的ID和内容：%ld, %@", userID, strContent);
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"peerid\":\"%ld\", \"content\":\"%@\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], userID, strContent];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_USER_ADD] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
//             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {                
                     SendNotify(@"SHITOUREN_MSG_SEND_SUCC", @"user");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];
}


- (MsgItem*)getMyMsgItem:(long)index
{
    MsgItem *item = [myMsgList objectAtExistIndex:index];
    return  item;
}

- (void)requestPetData :(long)begin :(long)limit
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"begin\":\"%ld\", \"limit\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], begin, limit];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_PET] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    InfoLog(@"SSID：%@，CHECK: %@，VERIFY: %@", ssid, ssid_check, ssid_verify);
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     for (NSDictionary* itemDict in resRes) {
                         
                         MsgItem *item = [[MsgItem alloc]init];
                         item.strMsg = [itemDict objectForKey:@"content"];
                         item.strTime = [itemDict objectForKey:@"ctime"];
                         NSMutableDictionary *sendUserInfo = [itemDict objectForKey:@"user"];
                         item.userItem.userid = [[sendUserInfo objectForKey:@"userid"] longValue];
                         item.userItem.name = [sendUserInfo objectForKey:@"name"];
                         item.userItem.intro = [sendUserInfo objectForKey:@"intro"];
                         item.userItem.zone = [sendUserInfo objectForKey:@"zone"];
                         item.userItem.imglink = [sendUserInfo objectForKey:@"imglink"];
                         item.userItem.thumblink = [sendUserInfo objectForKey:@"imglink"];
                         
                         [petMsgList addObject:item];
                     }
                     
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"pet");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];

}

- (void)sendPetMsg :(long)userID :(NSString*)strContent
{
    InfoLog(@"该函数的功能由lua实现");
}

- (void)delPetMsgData
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_PET_DEL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             //             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     [petMsgList removeAllObjects];
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"pet");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];

}

- (MsgItem*)getPetMsgItem:(long)index
{
    MsgItem *item = [petMsgList objectAtExistIndex:index];
    return  item;
}

- (void)requestSystemData :(long)begin :(long)limit
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"begin\":\"%ld\", \"limit\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], begin, limit];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_SYSTEM] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    InfoLog(@"SSID：%@，CHECK: %@，VERIFY: %@", ssid, ssid_check, ssid_verify);
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
//                     if(resRes.count > 0){
                     for (NSDictionary* itemDict in resRes) {
                         
//                         MsgItem *item = [[MsgItem alloc]init];
//                         item.strMsg = [itemDict objectForKey:@"content"];
//                         item.strTime = [itemDict objectForKey:@"ctime"];
//                         NSMutableDictionary *sendUserInfo = [itemDict objectForKey:@"user"];
//                         item.userItem.userid = [[sendUserInfo objectForKey:@"userid"] longValue];
//                         item.userItem.name = [sendUserInfo objectForKey:@"name"];
//                         item.userItem.intro = [sendUserInfo objectForKey:@"intro"];
//                         item.userItem.zone = [sendUserInfo objectForKey:@"zone"];
//                         item.userItem.imglink = [sendUserInfo objectForKey:@"imglink"];
//                         item.userItem.thumblink = [sendUserInfo objectForKey:@"imglink"];
                         
//                         [systemMsgList addObject:item];
                     }
//                     }
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"system");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];
    

}

- (void)delSystemMsgData
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_SYSTEM_DEL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             //             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     [systemMsgList removeAllObjects];
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"system");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];
}

//- (MsgItem*)getSystemMsgItem :(long)index
//{
//    MsgItem *item = [systemMsgList objectAtExistIndex:index];
//    return  item;
//}

- (void)requestSupportData
{
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_MESSAGE_LIKE] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    InfoLog(@"SSID：%@，CHECK: %@，VERIFY: %@", ssid, ssid_check, ssid_verify);
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shitouren_check", NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"shitouren_verify", NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSMutableDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet == 0 ) {
                 if ( resIdx == index ) {
                     //                     if(resRes.count > 0){
                     for (NSDictionary* itemDict in resRes) {
                         SupportMsgItem *item = [[SupportMsgItem alloc]init];
                         item.imgCount = [[itemDict objectForKey:@"imgcount"] longValue];
                         item.imgLink = [itemDict objectForKey:@"imglink"];
                         item.noteID = [[itemDict objectForKey:@"noteid"]longValue];
                         item.ctime = [itemDict objectForKey:@"ctime"];
                         NSDictionary *topic = [itemDict objectForKey:@"topic"];
                         item.cityID = [[topic objectForKey:@"cityid"]longValue];
                         item.topic_ctime = [topic objectForKey:@"ctime"];
                         item.provid = [[topic objectForKey:@"provid"]longValue];
                         item.content = [topic objectForKey:@"summary"];
                         item.title = [topic objectForKey:@"title"];
                         item.topicID = [[topic objectForKey:@"topicid"]longValue];
                         NSDictionary *user = [itemDict objectForKey:@"user"];
                         item.userItem.userid = [[user objectForKey:@"userid"] longValue];
                         item.userItem.name = [user objectForKey:@"name"];
                         item.userItem.intro = [user objectForKey:@"intro"];
                         item.userItem.zone = [user objectForKey:@"zone"];
                         item.userItem.imglink = [user objectForKey:@"imglink"];
                         item.userItem.thumblink = item.userItem.imglink; //[user objectForKey:@"imglink"];
                         
                         [supportMsgList addObject:item];
                     }
                     //                     }
                     SendNotify(@"SHITOUREN_MSG_LIST_SUCC", @"support");
                     return;
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 InfoLog(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 //                 Log(@"request timeout");
             } else {
                 //                 Log(@"request err");
             }
         }
         //         loginCallback(0);
     }];
    

}

- (SupportMsgItem*)getSupportMsgItem :(long)index
{
    SupportMsgItem *item = [supportMsgList objectAtExistIndex:index];
    return  item;
}


@end
