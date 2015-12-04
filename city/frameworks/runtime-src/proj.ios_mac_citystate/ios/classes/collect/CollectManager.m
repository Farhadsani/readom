//
//  CollectManager.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import "CollectManager.h"
#import "UserManager.h"

@implementation CollectManager
@synthesize collectData;

-(id)init {
    self = [super init];
    if (self) {
        collectData = [[NSMutableArray alloc] init];
    }
    return self;
}


NSString *testCollectData = @" \
{\"idx\":0,\"ret\":0,\"msg\":\"ok\",\"res\":[ \
{ \
\"topicid\":100000, \
\"title\":\"像人生赢家那样度过下午四点钟\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":10086, \
\"provid\":0, \
\"type\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日15:15\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100001, \
\"title\":\"错过最后两天就要再等一年才能见到的夏雨荷\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":63, \
\"provid\":1, \
\"type\":1, \
\"channel\":\"江苏频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日16:16\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100002, \
\"title\":\"在香汗淋漓的季节遇到里焦外嫩的你\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":3, \
\"provid\":0, \
\"type\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日17:17\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100003, \
\"title\":\"不想当厨子的店老板不是好明星\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":155, \
\"provid\":2, \
\"type\":2, \
\"channel\":\"北京频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日18:18\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100004, \
\"title\":\"欢度周末的十种姿势\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":278, \
\"provid\":0, \
\"type\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日19:19\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100005, \
\"title\":\"死肥俱乐部\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":9, \
\"provid\":0, \
\"type\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日20:20\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100006, \
\"title\":\"漫游太贵电话先关机几天有事请微信我\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":16, \
\"provid\":3, \
\"type\":2, \
\"channel\":\"韩国频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日21:21\", \
\"liked\":0, \
}, \
]} \
";

- (void)requestData:(long)userID :(long)begin :(long)limit :(int)hide
{
//    if( started ){
//        Log(@"already started");
//        SendNotify(@"SHITOUREN_TOPIC_LIST_ERR",nil);
//        return;
//    }
//    started = YES;
//    @synchronized(self){
//        self.gettingNext = YES;
//    }
    int index = 0;
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"userid\":\"%ld\",\"begin\":\"%ld\",\"limit\":\"%ld\",\"hide\":\"%d\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],userID,begin,limit,hide];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_USER_FEED_LIST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"shitouren_qmap_ios" forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"shitouren_ssid", NSHTTPCookieName,
                                    [UserManager sharedInstance].ss.ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid, nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
        if (error == nil) {
//            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//         if ( YES ){
//             NSData *testData = [testCollectData dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSArray *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
                 if ( YES ) {
                     //                                      if ( resIdx == index ) {
                     for (NSDictionary * itemDict in resRes){
                         CollectItem *item = [[CollectItem alloc] init];
                         item.feedID = [[itemDict objectForKey:@"feedid"] longValue];
                         item.optype = [itemDict objectForKey:@"optype"];
                         NSDictionary *data = [itemDict objectForKey:@"data"];
                         item.topicID = [[data objectForKey:@"topicid"] longValue];
                         item.title = [data objectForKey:@"title"];
                         item.noteID = [[data objectForKey:@"noteid"] longValue];
                         item.note = [data objectForKey:@"note"];
                         NSArray *imgs = [data objectForKey:@"note_thumbs"];
                         for (NSString *img in imgs) {
                             [item.note_thumbs addObject:img];
                         }
                         
                         [collectData addObject:item];
//                         [setShow addObject:[NSString stringWithFormat:@"%ld",item.topicid]];
//                         backIndex++;
                         
                     }
//                     Log(@"topic loaded. next is %d",backIndex);
                     SendNotify(@"SHITOUREN_COLLECT_LIST_START",nil);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
//                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_COLLECT_LIST_FAIL",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
//                 Log(@"request timeout");
//                 SendNotify(@"SHITOUREN_TOPIC_LIST_TIMEOUT",nil);
                 
             } else {
//                 Log(@"request err");
//                 SendNotify(@"SHITOUREN_TOPIC_LIST_ERR",nil);
             }
         }
//         @synchronized(self){
//             self.gettingNext = NO;
//         }
//         [self httpNext:limit];
     }];
}


@end
