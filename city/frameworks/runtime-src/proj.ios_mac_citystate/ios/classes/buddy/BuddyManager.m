//
//  BuddyManager.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/22.
//
//

#import "BuddyManager.h"
#import "LoggerClient.h"
#import "UserManager.h"

@implementation BuddyManager

@synthesize frendList, fansList, ortherList, mainUser;

-(id)init {
    self = [super init];
    if (self) {
        frendList = [[NSMutableArray alloc] init];
        fansList = [[NSMutableArray alloc] init];
        ortherList = [[NSMutableArray alloc] init];
        mainUser = [[BuddyItem alloc]init];
        showLoadingFlag = YES;
    }
    return self;
}
//根据不同的BuddyShowType(登录状态)获取不同的好友信息
- (BuddyShowType)getBuddyShowType{
    BuddyShowType type = OnlySquare;
    if ([UserManager sharedInstance].userLoginStatus == Lstatus_loginSuccess) {
        if (self.mainUser.userid && self.mainUser.userid > 0) {
            if ([[UserManager sharedInstance] isCurrentUser:self.mainUser.userid]) {
                type = FanAndFollowAndSquare;
            }
            else{
                type = FanAndFollow;
            }
        }
        else{
            type = FanAndFollowAndSquare;
        }
    }
    else{
        if ([UserManager sharedInstance].userid && [UserManager sharedInstance].userid > 0) {
            if (self.mainUser.userid && self.mainUser.userid > 0) {
                if ([[UserManager sharedInstance] isCurrentUser:self.mainUser.userid]) {
                    type = OnlySquare;
                }
                else{
                    type = FanAndFollow;
                }
            }
            else{
                type = OnlySquare;
            }
        }
        else{
            if (self.mainUser.userid && self.mainUser.userid > 0) {
                type = FanAndFollow;
            }
            else{
                type = OnlySquare;
            }
        }
    }
    
    return type;
}

#pragma mark request

//正常处理判断
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_square]) {
        [self handelPriviteLoading];
        
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [ortherList removeAllObjects];
        }
        
        NSArray * res = [result objectOutForKey:@"res"];
        if (res) {
            for (NSDictionary* itemDict in res) {
                [ortherList addNonEmptyObject:[self getItem:itemDict]];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetResult:error:reqData:)]) {
            [self.delegate didGetResult:@"square" error:nil reqData:req.data_dict];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfollow] ||
             [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfans]) {
        [self handelPriviteLoading];
        
        NSString * type = [req.data_dict objectOutForKey:@"type"];
        
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            if ([type isEqualToString:@"follow"]) {
                [frendList removeAllObjects];
            }
            else if ([type isEqualToString:@"fans"]){
                [fansList removeAllObjects];
            }
        }
        
        NSArray * res = [result objectOutForKey:@"res"];
        if (res) {
            for (NSDictionary* itemDict in res) {
                if ([type isEqualToString:@"follow"]) {
                    [frendList addNonEmptyObject:[self getItem:itemDict]];
                }
                else if ([type isEqualToString:@"fans"]){
                    [fansList addNonEmptyObject:[self getItem:itemDict]];
                }
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetResult:error:reqData:)]) {
            [self.delegate didGetResult:type error:nil reqData:req.data_dict];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        NSString * userId = [req getParamValue:@"userid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAddFollow:result:error:from:)]) {
            [self.delegate didAddFollow:userId result:result error:nil from:[req.data_dict objectOutForKey:@"Cell"]];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        NSString * userId = [req getParamValue:@"userid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRemoveFollow:result:error:from:)]) {
            [self.delegate didRemoveFollow:userId result:result error:nil from:[req.data_dict objectOutForKey:@"Cell"]];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getbuddycount]) {
        [self handelPriviteLoading];
        NSString * userId = [req getParamValue:@"userid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetbuddycount:result:error:)]) {
            [self.delegate didGetbuddycount:userId result:result error:nil];
        }
    }
}

- (void)handelPriviteLoading{
    if (showLoadingFlag) {
        if (![NSArray isNotEmpty:[ReqEngine shared].reqestCollects]) {
            [[LoadingView shared] hideLoading];
            showLoadingFlag = NO;
            if ([self.delegate isKindOfClass:[BaseViewController class]]) {
                [(BaseViewController *)self.delegate contentView].userInteractionEnabled = YES;
            }
        }
    }
}

//处理异常判断
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_square]) {
        [self handelPriviteLoading];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetResult:error:reqData:)]) {
            [self.delegate didGetResult:@"square" error:error reqData:req.data_dict];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfollow] ||
             [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getfans]) {
        [self handelPriviteLoading];
        NSString * type = [req.data_dict objectOutForKey:@"type"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetResult:error:reqData:)]) {
            [self.delegate didGetResult:type error:error reqData:req.data_dict];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_follow]) {
        NSString * userId = [req getParamValue:@"userid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAddFollow:result:error:from:)]) {
            [self.delegate didAddFollow:userId result:nil error:error from:[req.data_dict objectOutForKey:@"Cell"]];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_unfollow]) {
        NSString * userId = [req getParamValue:@"userid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRemoveFollow:result:error:from:)]) {
            [self.delegate didRemoveFollow:userId result:nil error:error from:[req.data_dict objectOutForKey:@"Cell"]];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getbuddycount]) {
        [self handelPriviteLoading];
        NSString * userId = [req getParamValue:@"userid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetbuddycount:result:error:)]) {
            [self.delegate didGetbuddycount:userId result:nil error:error];
        }
    }
}
//获取好友、粉丝列表
- (void)requestfrendDataBegin:(long)begin limit:(long)limit{
    [[LoadingView shared] showLoading:nil message:nil];
    if ([self.delegate isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)self.delegate contentView].userInteractionEnabled = NO;
    }
    
    switch ([self getBuddyShowType]) {
        case OnlySquare:{
            [self requestSquareDataBegin:begin limit:limit];
        }
            break;
        case FanAndFollow:{
            long userID = mainUser.userid;
            InfoLog(@"获取%ld的好友列表。。。。", userID);
            [self requestData:userID :k_api_user_getfollow :@"follow" begin:begin limit:limit];
            [self requestData:userID :k_api_user_getfans :@"fans" begin:begin limit:limit];
            
            [self requestGetbuddycount:userID];
        }
            break;
        case FanAndFollowAndSquare:{
            long userID = mainUser.userid;
            InfoLog(@"获取%ld的好友列表。。。。", userID);
            [self requestData:userID :k_api_user_getfollow :@"follow" begin:begin limit:limit];
            [self requestData:userID :k_api_user_getfans :@"fans" begin:begin limit:limit];
            [self requestSquareDataBegin:begin limit:limit];
            
            [self requestGetbuddycount:userID];
        }
            break;
            
        default:
            break;
    }
}

- (void)requestData:(NSInteger)index userid:(long)userID begin:(long)begin limit:(long)limit{
    switch (index) {
        case 1:
            [self requestData:userID :k_api_user_getfans :@"fans" begin:begin limit:limit];
            break;
        case 2:
            [self requestData:userID :k_api_user_getfollow :@"follow" begin:begin limit:limit];
            break;
        case 3:
            [self requestSquareDataBegin:begin limit:limit];
            break;
            
        default:
            break;
    }
}
- (void)requestData:(long)userid :(NSString*)url :(NSString*)type begin:(long)begin limit:(long)limit{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",userid],
                              @"begin": @(begin),
                              @"limit": @(limit),
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:url,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         @"type":type,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}
//请求用户广场数据
- (void)requestSquareDataBegin:(long)begin limit:(long)limit{
    NSDictionary * params = @{@"begin": @(begin),
                              @"limit": @(limit),
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_square,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

//关注用户
- (void)requestFollow:(long)userID from:(BuddyCell *)cell{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",userID]};
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_follow,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         @"Cell":cell,
                         };
    [[ReqEngine shared] tryRequest:d];
}

//取消关注用户
- (void)requestUnFollow:(long)userID from:(BuddyCell *)cell{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",userID]};
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_unfollow,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         @"Cell":cell,
                         };
    [[ReqEngine shared] tryRequest:d];
}
//用户、粉丝列表统计信息
- (void)requestGetbuddycount:(long)userID{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",userID]};
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_getbuddycount,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (NSMutableArray*)getTableData:(int)index{
    if (index == 1){
        curList = fansList;
    }
    else if (index == 2){
        curList = frendList;
    }
    else {//if (index == 3)
        curList = ortherList;
    }
    return curList;
}

- (BuddyItem*)getBoddyItem:(NSInteger)index{
    BuddyItem *item = [curList objectAtExistIndex:index];
    return item;
}

- (BuddyItem *)getItem:(NSDictionary *)itemDict{
    BuddyItem *item = [[[BuddyItem alloc] init] autorelease];
    item.userid = [[itemDict objectForKey:@"userid"] longValue];
    item.name = [itemDict objectForKey:@"name"];
    item.intro = [itemDict objectForKey:@"intro"];
    item.zone = [itemDict objectForKey:@"zone"];
    item.imglink = [itemDict objectForKey:@"imglink"];
    item.thumblink = [itemDict objectForKey:@"thumblink"];
    item.relationship = [[itemDict objectForKey:@"type"] integerValue];
    return item;
}

@end
