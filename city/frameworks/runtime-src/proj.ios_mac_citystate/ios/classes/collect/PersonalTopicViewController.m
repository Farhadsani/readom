//
//  PersonalTopicViewController.m
//  qmap
//
//  Created by hf on 15/8/21.
//
//

/*
 *【话题】界面
 *功能：查看所有话题列表
 *
 */
#import "PersonalTopicViewController.h"
#import "PostViewController.h"
#import "TagItem.h"

@interface PersonalTopicViewController (){
    
}

@property (nonatomic, retain) UITableView * listTableView;
@property (nonatomic, retain) NSMutableArray * noteList;
@property (nonatomic, retain) TopicCellInCollect * topicCell;
@property (nonatomic) BOOL showMoreNoteButton;//显示“点击展开全部话题”按钮

@end


@implementation PersonalTopicViewController

- (void)variableInit{
    [super variableInit];
    self.showMoreNoteButton = NO;
}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话题";
    [self setupRightBackButtonItem:@"发表" img:nil del:self sel:@selector(didPublishNewNote)];
    
    if ([[self.data_dict objectOutForKey:@"from"] isEqualToString:@"note_like"]) {
        self.showMoreNoteButton = YES;
    }
    
    [[Cache shared] isNeedRefreshData:2 removeFlag:YES];
    
    [self setupMainView];
    
    [self requestDetail];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([[Cache shared] isNeedRefreshData:2 removeFlag:YES]) {
        [self requestAfterGetTopicDetail];
    }
}

#pragma mark - delegate (CallBack)

- (void)didPublishNewNote{
    PostViewController * vc = [[[PostViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.note = self.topicCell.topicItem;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark request

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_one]) {
        NSArray * res = [result objectOutForKey:@"res"];
        if (res) {
            [self.data_dict setNonEmptyObject:res forKey:@"topic"];
//            [self setupTopicView];
            
            [self setupNoteListView];
            
            [self requestAfterGetTopicDetail];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_one]) {
        [self.noteList removeAllObjects];
        [self doAfterGetNote:[result objectOutForKey:@"res"]];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_list]) {
        if (self.showMoreNoteButton) {
            self.showMoreNoteButton = NO;
            if ([[result objectOutForKey:@"res"] isKindOfClass:[NSArray class]]) {
                NSMutableArray * ma = [[NSMutableArray alloc] initWithArray:[result objectOutForKey:@"res"]];
                if ([self.noteList count] > 0 && [ma containsObject:[self.noteList objectAtExistIndex:0]]) {
                    [ma removeObject:[self.noteList objectAtExistIndex:0]];
                }
                [self doAfterGetNote:ma];
                [ma release];
            }
            else{
                [self doAfterGetNote:[result objectOutForKey:@"res"]];
            }
        }
        else{
            [self.noteList removeAllObjects];
            [self doAfterGetNote:[result objectOutForKey:@"res"]];
        }
    }
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_user_list]) {
        InfoLog(@"error:%@", error);
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_one] ||
             [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_list]){
        [self showTipView:@{k_ToView:self.listTableView,
                            k_OffsetY:strFloat(_topicCell.y+_topicCell.height+80),
                            k_ShowMsg:@"暂时还没有人发表内容，快来发表吧！",
                            k_ListCount:num([_noteList count]),
                            }];
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if (_noteList) {
        if (self.showMoreNoteButton) {
            return [_noteList count]+2;
        }
        else{
            return [_noteList count]+1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self setupTopicView];
        return _topicCell.height;
    }
    else if (self.showMoreNoteButton && indexPath.row == [_noteList count]+1){
        return 50;
    }
    else{
        BuddyStatusNoteItemFrame *noteItemFrame = [self dict2NoteItemFrame:[_noteList objectAtExistIndex:indexPath.row-1]];
        return noteItemFrame.cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self setupTopicView];
        
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TopCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TopCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView removeAllSubviews];
        [cell.contentView addSubview:_topicCell];
        
        return cell;
    }
    else if (self.showMoreNoteButton && indexPath.row == [_noteList count]+1){
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MoreCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView removeAllSubviews];
        
        UIView * back = [UIView view_sub:@{V_Parent_View:cell.contentView,
                                           V_Height:strFloat([self tableView:tableView heightForRowAtIndexPath:indexPath]),
                                           V_BGColor:clear_color,
                                           }];
        [cell.contentView addSubview:back];
        
        UILabel * lab = [UIView label:@{V_Parent_View:back,
                                        V_Margin_Top:@15,
                                        V_Height:@17,
                                        V_Text:@"点击展开全部话题",
                                        V_Color:gray_color,
                                        V_Font_Size:@14,
                                        V_Font_Family:k_fontName_FZXY,
                                        V_TextAlign:num(TextAlignCenter),
                                        }];
        [back addSubview:lab];
        
        UIImageView * imgv = [UIView imageView:@{V_Parent_View:back,
                                                 V_Last_View:lab,
                                                 V_Img:@"jiantou_down_gray",
                                                 V_ContentMode:num(ModeCenter),
                                                 }];
        [back addSubview:imgv];
        
        return cell;
    }
    else{
        BuddyStatusCell *cell = (BuddyStatusCell*)[tableView dequeueReusableCellWithIdentifier:@"BuddyStatusCell"];
        if (cell == nil) {
            cell = [[[BuddyStatusCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BuddyStatusCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor color:clear_color];
        BuddyStatusNoteItemFrame *noteItemFrame = [self dict2NoteItemFrame:[_noteList objectAtExistIndex:indexPath.row-1]];
        [cell setNoteItemFrame:noteItemFrame];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    if (self.showMoreNoteButton && indexPath.row == [_noteList count]+1){
        [self clickShowMoreNote];
    }
}

#pragma mark - action such as: click touch tap slip ...

- (void)clickShowMoreNote{
    CollectCell * cell = [self.data_dict objectOutForKey:@"CollectCell"];
    if (cell && [cell isKindOfClass:[CollectCell class]]) {
        [self requestNotesList:cell.dataItem.topicID];
    }
    else{
        self.showMoreNoteButton = NO;
        [_listTableView reloadData];
    }
}

- (void)requestDetail{
    CollectCell * cell = [self.data_dict objectOutForKey:@"CollectCell"];
    if (cell && [cell isKindOfClass:[CollectCell class]]) {
        [self requestTopicDetail:cell.dataItem.topicID];
    }
}

- (void)requestAfterGetTopicDetail{
    CollectCell * cell = [self.data_dict objectOutForKey:@"CollectCell"];
    if (cell && [cell isKindOfClass:[CollectCell class]]) {
        OpType opType =[cell getOpType:cell.dataItem];
        if (opType == topic_like) {
            //获取话题、获取话题下发表的所有内容
            [self requestNotesList:cell.dataItem.topicID];
        }
        else{
            //获取话题，获取当前的一条内容
            [self requestNoteDetail:cell.dataItem.topicID];
        }
    }
}

- (void)requestTopicDetail:(NSString *)topicId{
    if ([NSString isEmptyString:topicId]) {
        return;
    }
    
    NSDictionary * params = @{@"topicid":topicId};
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_topic_one,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)requestNoteDetail:(NSString *)noteId{
    if ([NSString isEmptyString:noteId]) {
        return;
    }
    NSDictionary * params = @{@"noteid":noteId};
    NSDictionary * dict = @{@"idx":@1,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_note_one,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)requestNotesList:(NSString *)topicId{
    if ([NSString isEmptyString:topicId]) {
        return;
    }
    
    NSDictionary * params = @{@"topicid":topicId,
                              @"begin":@0,
                              @"limit":@50,
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_note_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)doAfterGetNote:(id)res{
    if (!res) {
        return;
    }
    if ([NSDictionary isNotEmpty:res]) {
        [self.noteList addNonEmptyObject:res];
    }
    else if ([NSArray isNotEmpty:res]) {
        [self.noteList addObjectsFromArray:res];
    }
    [self setupNoteListView];
    [self showTipView:@{k_ToView:self.listTableView,
                        k_OffsetY:strFloat(_topicCell.y+_topicCell.height+80),
                        k_ShowMsg:@"暂时还没有人发表内容，快来发表吧！",
                        k_ListCount:num([_noteList count]),
                        }];
}

- (void)jumpToPictureListVC{
    
}

- (void)jumpToPublishVC{
    
}

#pragma mark - init & dealloc

- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    [self setupNoteListView];
}

- (void)setupTopicView{
    if (!_topicCell) {
        self.topicCell = [[[TopicCellInCollect alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0)] autorelease];
        [self.contentView addSubview:_topicCell];
        _topicCell.delegate = self;
    }
    
    if (![NSDictionary isNotEmpty:[self.data_dict objectOutForKey:@"topic"]]) {
        return;
    }
    
    [_topicCell updateCell:[self.data_dict objectOutForKey:@"topic"]];
}

- (void)setupNoteListView{
    if (!_noteList) {
        self.noteList = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (!_listTableView) {
        self.listTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)] autorelease];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.backgroundColor = [UIColor color:clear_color];
        _listTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [_listTableView setSectionIndexColor:[UIColor clearColor]];
        [_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_listTableView setSeparatorColor:[UIColor color:lightgray_color]];
        _listTableView.scrollEnabled = YES;
        [self.contentView addSubview:_listTableView];
    }
//    [_listTableView setContentInset:UIEdgeInsetsMake(_topicCell.y+_topicCell.height, 0, 0, 0)];
    [_listTableView reloadData];
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark

- (BuddyStatusNoteItemFrame *)dict2NoteItemFrame:(NSDictionary *)itemDict{
    
    if (![NSDictionary isNotEmpty:itemDict]) {
        return nil;
    }
    
    BuddyStatusNoteItem *noteItem = [[BuddyStatusNoteItem alloc] init];
    
    BuddyStatusNoteItem *item = [[BuddyStatusNoteItem alloc] init];
    item.feedid = [[itemDict objectForKey:@"feedid"] longValue];
    item.ctime = [itemDict objectForKey:@"ctime"];
    item.liked = [[itemDict objectForKey:@"liked"] boolValue];
    item.like_count = [[itemDict objectForKey:@"like_count"] intValue];
    item.commented = [[itemDict objectForKey:@"commented"] boolValue];
    item.comments_count = [[itemDict objectForKey:@"comments_count"] intValue];
    item.content = [itemDict objectForKey:@"content"];
    
    
    NSArray *imgArr = [itemDict objectForKey:@"imgs"];
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *img in imgArr) {
        [imgs addObject:img];
    }
    item.imgs = [imgs copy];
    
    NSDictionary *userDic = [itemDict objectForKey:@"user"];
    BuddyStatusUser *user = [[BuddyStatusUser alloc] init];
    user.userid = [[userDic objectForKey:@"userid"] longValue];
    user.name = [userDic objectForKey:@"name"];
    user.intro = [userDic objectForKey:@"intro"];
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
    
    BuddyStatusNoteItemFrame *noteItemFrame = [[BuddyStatusNoteItemFrame alloc] init];
    noteItemFrame.noteItem = noteItem;
    
    return noteItemFrame;
}

#pragma mark - BuddyStatusCellDelegate
- (void)buddyStatusCell:(BuddyStatusCell *)cell userIconBtnDidOnClick:(UIButton *)button
{
    BuddyStatusUser *user = cell.noteItemFrame.noteItem.user;
    [self baseDeckBack];
    [self toCocos:user.userid :user.name :user.intro :nil :user.thumblink :user.imglink ];
}
@end
