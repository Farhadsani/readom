#import "TopicManager.h"
#import "TopicItem.h"
#import "TagItem.h"
#import "UserManager.h"
#import "LoggerClient.h"

@implementation TopicManager

@synthesize listShow, started, gettingNext, responsing, index;

-(id)init {
    self = [super init];
    if (self) {
        backIndex = 0;
        listShow = [[NSMutableArray alloc] init];
        setShow = [[NSMutableSet alloc] init];
        listNext = [[NSMutableArray alloc] init];
        started = NO;
        gettingNext = NO;
        responsing = NO;
        index = 0;
    }
    return self;
}

#pragma mark –
#pragma mark ------getNew------

NSString *testTopicStart = @" \
{\"idx\":0,\"ret\":0,\"msg\":\"ok\",\"res\":[ \
{ \
\"topicid\":100000, \
\"title\":\"像人生赢家那样度过下午四点钟\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":10086, \
\"provid\":0, \
\"cityid\":0, \
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
\"cityid\":1, \
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
\"cityid\":0, \
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
\"cityid\":2, \
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
\"cityid\":0, \
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
\"cityid\":0, \
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
\"cityid\":3, \
\"channel\":\"韩国频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日21:21\", \
\"liked\":0, \
}, \
]} \
";

NSString *testTopicNext = @" \
{\"idx\":0,\"ret\":0,\"msg\":\"ok\",\"res\":[ \
{ \
\"topicid\":100007, \
\"title\":\"逛完这些奇葩博物馆吹牛素材够三年\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":2398, \
\"provid\":2, \
\"cityid\":3, \
\"channel\":\"北京频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日22:22\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100008, \
\"title\":\"拯救家具品味从忘掉宜家开始\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":107, \
\"provid\":0, \
\"cityid\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日23:23\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100009, \
\"title\":\"当葱油饼遇上美图秀秀\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":10000, \
\"provid\":0, \
\"cityid\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日09:09\", \
\"liked\":0, \
}, \
{ \
\"topicid\":100010, \
\"title\":\"如何把一个死宅骗出来跑步\", \
\"summary\":\"在英国，当时钟敲响四下，世界为茶而停。品尝一份下午茶，享受一下午的悠闲时光，快来分享你的下午茶瞬间。\", \
\"hot\":20, \
\"provid\":0, \
\"cityid\":0, \
\"channel\":\"公共频道\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"ctime\":\"2015年7月15日10:10\", \
\"liked\":0, \
}, \
]} \
";


-(void)getStart:(int)limit
{
    if( started ){
        Log(@"already started");
        SendNotify(@"SHITOUREN_TOPIC_LIST_ERR",nil);
        return;
    }
    started = YES;
    @synchronized(self){
        self.gettingNext = YES;
    }
    
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"begin\":\"%d\",\"limit\":\"%d\",\"userid\":\"%ld\",\"provid\":\"%d\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],0,limit,[UserManager sharedInstance].userid,0];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_TOPIC_LIST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置cookie
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
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
                  if (error == nil) {
                      NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//         if ( YES ){
//             NSData *testData = [testTopicStart dataUsingEncoding:NSUTF8StringEncoding];
//             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSArray *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
//                 if ( YES ) {
                                      if ( resIdx == index ) {
                     for (NSDictionary * itemDict in resRes){
                         TopicItem *item = [[TopicItem alloc] init];
                         item.topicid = [[itemDict objectForKey:@"topicid"] longValue];
                         item.title = [itemDict objectForKey:@"title"];
                         item.summary = [itemDict objectForKey:@"summary"];
                         item.hot = [[itemDict objectForKey:@"hot"] intValue];
                         item.provid = [[itemDict objectForKey:@"provid"] intValue];
                         item.cityid = [[itemDict objectForKey:@"cityid"] intValue];
                         item.channel = [itemDict objectForKey:@"channel"];
                         item.imglink = [itemDict objectForKey:@"imglink"];
                         item.ctime = [itemDict objectForKey:@"ctime"];
                         item.liked = [[itemDict objectForKey:@"liked"] boolValue];
                         NoteManager *noteManager = [[NoteManager alloc] init:item.topicid];
                         item.noteManager = noteManager;
                         [listShow addObject:item];
                         [setShow addObject:[NSString stringWithFormat:@"%ld",item.topicid]];
                         backIndex++;
                     }
                     Log(@"topic loaded. next is %d",backIndex);
                     SendNotify(@"SHITOUREN_TOPIC_LIST_START",nil);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_TOPIC_LIST_FAIL",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
                 SendNotify(@"SHITOUREN_TOPIC_LIST_TIMEOUT",nil);
                 
             } else {
                 Log(@"request err");
                 SendNotify(@"SHITOUREN_TOPIC_LIST_ERR",nil);
             }
         }
         @synchronized(self){
             self.gettingNext = NO;
         }
         [self httpNext:limit];
     }];
}

-(void)getNext :(int)limit
{
    @synchronized(self){
        if(self.gettingNext){
            return;
        }
        self.gettingNext = YES;
    }
    //    Log(@"next : %lu",(unsigned long)listNext.count);
    if(listNext.count > 0){
        int nextCount = 0;
        for( TopicItem *one in listNext ){
            if( [setShow containsObject:[NSString stringWithFormat:@"%ld",one.topicid]] ){
                continue;
            }
            ++nextCount;
            [listShow addObject:one];
            [setShow addObject:[NSString stringWithFormat:@"%ld",one.topicid]];
        }
        [listNext removeAllObjects];
        @synchronized(self){
            self.gettingNext = NO;
        }
        SendNotify(@"SHITOUREN_TOPIC_LIST_SUCC",nil);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self httpNext:limit];
        });
    }
}

-(void)httpNext:(int)limit
{
    @synchronized(self){
        self.gettingNext = YES;
    }
    
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"begin\":\"%d\",\"limit\":\"%d\",\"userid\":\"%ld\",\"provid\":\"%d\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],backIndex,limit,[UserManager sharedInstance].userid,0];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_TOPIC_LIST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置cookie
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
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
                  if (error == nil) {
                      NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//         if ( YES ){
//             NSData *testData = [testTopicNext dataUsingEncoding:NSUTF8StringEncoding];
//             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSArray *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
//                 if ( YES ) {
                                      if ( resIdx == index ) {
                     for (NSDictionary * itemDict in resRes){
                         TopicItem *item = [[TopicItem alloc] init];
                         item.topicid = [[itemDict objectForKey:@"topicid"] longValue];
                         item.title = [itemDict objectForKey:@"title"];
                         item.summary = [itemDict objectForKey:@"summary"];
                         item.hot = [[itemDict objectForKey:@"hot"] intValue];
                         item.provid = [[itemDict objectForKey:@"provid"] intValue];
                         item.cityid = [[itemDict objectForKey:@"cityid"] intValue];
                         item.channel = [itemDict objectForKey:@"channel"];
                         item.imglink = [itemDict objectForKey:@"imglink"];
                         item.ctime = [itemDict objectForKey:@"ctime"];
                         item.liked = [[itemDict objectForKey:@"liked"] boolValue];
                         NoteManager *noteManager = [[NoteManager alloc] init:item.topicid];
                         item.noteManager = noteManager;
                         [listNext addObject:item];
                         backIndex++;
                     }
                     Log(@"topic loaded. next is %d",backIndex);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
             } else {
                 Log(@"request err");
             }
         }
         @synchronized(self){
             self.gettingNext = NO;
         }
     }];
}

-(BOOL)likePost:(long)topicid {
    @synchronized(self){
        if(self.responsing){
            Log(@"request handing");
            NSString *topic = [NSString stringWithFormat:@"%ld",topicid];
            SendNotify(@"SHITOUREN_API_TOPIC_LIKE_POST_TIMEOUT",topic);
            return NO;
        }
        self.responsing = YES;
    }
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"topicid\":\"%ld\",\"userid\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],topicid,[UserManager sharedInstance].userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_TOPIC_LIKE_POST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置cookie
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
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
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             if (resRet==0) {
                 if ( resIdx == index ) {
                     TopicItem *item = nil;
                     for (TopicItem * itemOne in listShow){
                         if( itemOne.topicid == topicid){
                             item = itemOne;
                         }
                     }
                     if( item != nil ){
                         item.liked = !item.liked;
                     }
                     Log(@"%ld liked by %ld",topicid,[UserManager sharedInstance].userid);
                     SendNotify(@"SHITOUREN_API_TOPIC_LIKE_POST_SUCC",item);
                     
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_API_TOPIC_LIKE_POST_FAIL",msg);
                 
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
                 SendNotify(@"SHITOUREN_API_TOPIC_LIKE_POST_TIMEOUT",nil);
                 
             } else {
                 Log(@"request err");
                 SendNotify(@"SHITOUREN_API_TOPIC_LIKE_POST_ERR",nil);
                 
             }
         }
         @synchronized(self){
             self.responsing = NO;
         }
     }];
    return YES;
}

-(BOOL)likeDel:(long)topicid {
    @synchronized(self){
        if(self.responsing){
            Log(@"request handing");
            NSString *topic = [NSString stringWithFormat:@"%ld",topicid];
            SendNotify(@"SHITOUREN_API_TOPIC_LIKE_DEL_TIMEOUT",topic);
            return NO;
        }
        self.responsing = YES;
    }
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"topicid\":\"%ld\",\"userid\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],topicid,[UserManager sharedInstance].userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_TOPIC_LIKE_DEL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置cookie
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
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
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             if (resRet==0) {
                 if ( resIdx == index ) {
                     TopicItem *item = nil;
                     for (TopicItem * itemOne in listShow){
                         if( itemOne.topicid == topicid){
                             item = itemOne;
                         }
                     }
                     if( item != nil ){
                         item.liked = !item.liked;
                     }
                     Log(@"%ld liked by %ld",topicid,[UserManager sharedInstance].userid);
                     SendNotify(@"SHITOUREN_API_TOPIC_LIKE_DEL_SUCC",item);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_API_TOPIC_LIKE_DEL_FAIL",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
                 SendNotify(@"SHITOUREN_API_TOPIC_LIKE_DEL_TIMEOUT",nil);
             } else {
                 Log(@"request err");
                 SendNotify(@"SHITOUREN_API_TOPIC_LIKE_DEL_ERR",nil);
             }
         }
         @synchronized(self){
             self.responsing = NO;
         }
     }];
    return YES;
}

@end
