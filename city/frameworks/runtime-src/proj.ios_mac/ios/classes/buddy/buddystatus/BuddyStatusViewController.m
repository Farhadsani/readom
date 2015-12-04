//
//  BuddyStatusViewController.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

/*
 *【好友动态】界面
 *功能：查看好友的发表的动态消息
 *
 */


#import "BuddyStatusViewController.h"
#import "BuddyStatusCell.h"
#import "BuddyStatusesManager.h"
#import "AFNetworking.h"
#import "TagItem.h"
#import "BuddyStatusNoteItemFrame.h"
#import "MJRefresh.h"

@interface BuddyStatusViewController () <UITableViewDataSource, UITableViewDelegate, BuddyStatusCellDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, assign) long userid;
@property (nonatomic, weak) UITableView  *tableView;
@end

@implementation BuddyStatusViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"好友动态";
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.frame = self.contentView.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf1f1f1, 1.0f);
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - action
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if ([BuddyStatusesManager allNoteItemFrames].count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:[BuddyStatusesManager allNoteItemFrames].count+1 limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"userid":@(self.userid),
                              @"begin": @(begin),
                              @"limit": @(limit)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_buddy,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_buddy]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [[BuddyStatusesManager allNoteItemFrames] removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        [self handle:dict];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_buddy]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        InfoLog(@"error:%@", error);
    }
}

- (void)handle:(NSDictionary *)dict
{
    NSArray *res = [dict objectForKey:@"res"];
    for (NSDictionary *itemDict in res){
        BuddyStatusNoteItem *item = [[BuddyStatusNoteItem alloc] init];
        item.topicid = [[itemDict objectForKey:@"topicid"] longValue];
        item.noteid = [[itemDict objectForKey:@"noteid"] longValue];
        item.like_count = [[itemDict objectForKey:@"like_count"] intValue];
        item.note = [itemDict objectForKey:@"note"];
        item.topic = [itemDict objectForKey:@"topic"];
        item.ctime = [itemDict objectForKey:@"ctime"];
        
        NSArray *imgArr = [itemDict objectForKey:@"imgs"];
        NSMutableArray *imgs = [NSMutableArray array];
        for (NSString *img in imgArr) {
            [imgs addObject:img];
        }
        item.imgs = [imgs copy];
        
        NSArray *thumbArr = [itemDict objectForKey:@"thumbs"];
        NSMutableArray *thumbs = [NSMutableArray array];
        for (NSString *thumb in thumbArr) {
            [thumbs addObject:thumb];
        }
        item.thumbs = thumbs;
        
        NSDictionary *userDic = [itemDict objectForKey:@"user"];
        BuddyStatusUser *user = [[BuddyStatusUser alloc] init];
        user.userid = [[userDic objectForKey:@"userid"] longValue];
        user.name = [userDic objectForKey:@"name"];
        user.intro = [userDic objectForKey:@"intro"];
        user.zone = [userDic objectForKey:@"zone"];
        user.imglink = [userDic objectForKey:@"imglink"];
        user.thumblink = [userDic objectForKey:@"thumblink"];
        item.user = user;
        NSArray *tagArr = [itemDict objectForKey:@"tags"];
        NSMutableArray *tags = [NSMutableArray array];
        for (NSString *tagOne in tagArr) {
            TagItem *tagItem = [[TagItem alloc] init];
            tagItem.text = tagOne;
            [tags addObject:tagItem];
        }
        item.tags = tags;
        
        NSArray *placeArr = [itemDict objectForKey:@"place"];
        NSMutableArray *places = [NSMutableArray array];
        for (NSString *placeOne in placeArr) {
            TagItem *placeItem = [[TagItem alloc] init];
            placeItem.text = placeOne;
            [places addObject:placeItem];
        }
        item.place = places;
        
        item.liked = [[itemDict objectForKey:@"liked"] boolValue];
        BuddyStatusNoteItemFrame *noteItemFrame = [[BuddyStatusNoteItemFrame alloc] init];
        noteItemFrame.noteItem = item;
        [BuddyStatusesManager addNoteItemFrame:noteItemFrame];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([BuddyStatusesManager allNoteItemFrames].count > 0) {
            [self.tableView reloadData];
        } else {
        }
    });
    
    [self showTipView:@{k_ToView:self.tableView,
                        k_ShowMsg:@"没有好友真可怕~\n您可以在主页“出访”中关注您喜欢的",
                        k_ListCount:num([[BuddyStatusesManager allNoteItemFrames] count]),
                        }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BuddyStatusesManager allNoteItemFrames].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    BuddyStatusCell *cell = [BuddyStatusCell cellForTableView:tableView];
    BuddyStatusNoteItemFrame *noteItemFrame = [BuddyStatusesManager allNoteItemFrames][indexPath.row];
    cell.noteItemFrame = noteItemFrame;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusNoteItemFrame *noteItemFrame = [BuddyStatusesManager allNoteItemFrames][indexPath.row];
    return noteItemFrame.cellHeight;
}

#pragma mark - BuddyStatusCellDelegate
- (void)buddyStatusCell:(BuddyStatusCell *)cell userIconBtnDidOnClick:(UIButton *)button
{
    BuddyStatusUser *user = cell.noteItemFrame.noteItem.user;
    [self baseDeckBack];
    [self toCocos:user.userid :user.name :user.intro :user.zone :user.thumblink :user.imglink ];
}

#pragma mark - other method
- (void)setUserData:(long)userID
{
    self.userid = userID;
    
    [BuddyStatusesManager removeAllNoteItemFrames];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if(callback){
//        callback( 1 );
//    }
}
@end
