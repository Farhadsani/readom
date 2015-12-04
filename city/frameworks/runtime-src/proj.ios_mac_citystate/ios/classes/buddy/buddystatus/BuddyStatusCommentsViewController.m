//
//  BuddyStatusCommentsViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import "BuddyStatusCommentsViewController.h"
#import "BuddyStatusCommentCell.h"
#import "BuddyStatusCommentFrame.h"
#import "MJRefresh.h"
#import "BuddyItem.h"
#import "CocosViewController.h"
#import "BuddyStatusCommentInputView.h"
#import "IQKeyboardManager.h"
#import "BuddyItem.h"

@interface BuddyStatusCommentsViewController ()<UITableViewDataSource, UITableViewDelegate, BuddyStatusCommentInputViewDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *buddyStatusCommentFrames;
@property (nonatomic, weak) BuddyStatusCommentInputView *buddyStatusCommentInputView;
@property (nonatomic, weak) UIControl *coverView;
@end

@implementation BuddyStatusCommentsViewController
- (NSMutableArray *)buddyStatusCommentFrames
{
    if (!_buddyStatusCommentFrames) {
        _buddyStatusCommentFrames =[NSMutableArray array];
    }
    return _buddyStatusCommentFrames;
}

#pragma mark - life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMainView];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_comment_list]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
            [self.buddyStatusCommentFrames removeAllObjects];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        NSArray *buddyStatusComments = [BuddyStatusComment objectArrayWithKeyValuesArray:[dict objectForKey:@"res"]];
        for (BuddyStatusComment *buddyStatusComment in buddyStatusComments) {
            BuddyStatusCommentFrame *buddyStatusCommentFrame = [[BuddyStatusCommentFrame alloc] init];
            buddyStatusCommentFrame.buddyStatusComment = buddyStatusComment;
            [self.buddyStatusCommentFrames addObject:buddyStatusCommentFrame];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"没有评论",
                                k_ListCount:num(self.buddyStatusCommentFrames.count),
                                }];
        });

    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_comment_list]) {
        NSNumber *begin = [req.data_dict objectOutForKey:k_r_postData][@"params"][@"begin"];
        if (begin.intValue == 0) { // 下拉刷新
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self showTipView:@{k_ToView:self.tableView,
                                k_ShowMsg:@"没有评论",
                                k_ListCount:num(self.buddyStatusCommentFrames.count),
                                }];
        });
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buddyStatusCommentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusCommentCell *cell = [BuddyStatusCommentCell cellForTableView:tableView];
    BuddyStatusCommentFrame *buddyStatusCommentFrame = self.buddyStatusCommentFrames[indexPath.row];
    cell.buddyStatusCommentFrame = buddyStatusCommentFrame;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转到有Cocos个人中心页面，需要先调用该函数刷新数据
    
    BuddyStatusCommentFrame *commentFrame =  [_buddyStatusCommentFrames objectAtExistIndex:indexPath.row];
    BuddyStatusUser *statusUser = commentFrame.buddyStatusComment.user;
    BuddyItem *item = [[BuddyItem alloc] init];
    item.userid =statusUser.userid;
    if (![[UserManager sharedInstance] isCurrentUser:item.userid]) {
        item.name = statusUser.name;
        item.intro = statusUser.intro;
        item.imglink = statusUser.imglink;
        item.thumblink = statusUser.imglink;
        
        [self toCocos:item.userid :item.name :item.intro :item.zone :item.thumblink :item.imglink ];
        //再push到viewController
        CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
        vc.userid = item.userid;
        vc.buddyItem = item;
        [[CocosManager shared] addCocosMapView:vc];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyStatusCommentFrame *buddyStatusCommentFrame = self.buddyStatusCommentFrames[indexPath.row];
    return buddyStatusCommentFrame.cellHeight;
}

#pragma mark - init & dealloc
- (void)setupMainView
{
    self.title = @"评论";
    
    CGFloat inputHeight = 60;
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height - inputHeight);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor color:clear_color]];
    self.tableView.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    self.tableView.layer.borderWidth = 0.5;
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableViewFooterView;
    
    UIView *keyView = [UIApplication sharedApplication].keyWindow;
    UIControl *coverView  = [[UIControl alloc] init];
    [keyView addSubview:coverView];
    self.coverView = coverView;
    coverView.backgroundColor = [UIColor clearColor];
    coverView.frame = [UIScreen mainScreen].bounds;
    [coverView addTarget:self action:@selector(coverViewDidOnClick) forControlEvents:UIControlEventTouchUpInside];
    coverView.hidden = YES;
    
    BuddyStatusCommentInputView *buddyStatusCommentInputView = [[BuddyStatusCommentInputView alloc] init];
    [keyView addSubview:buddyStatusCommentInputView];
    self.buddyStatusCommentInputView =buddyStatusCommentInputView;
    buddyStatusCommentInputView.feedid = self.feedid;
    buddyStatusCommentInputView.frame = CGRectMake(0, keyView.height - inputHeight, keyView.width, inputHeight);
    buddyStatusCommentInputView.delegate = self;
    
    // 增加下拉刷新、上拉加载更多
    [self.tableView addHeaderWithTarget:self action:@selector(loadNew)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentTextViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentTextViewtDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentTextViewtDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.buddyStatusCommentInputView removeFromSuperview];
    [self.coverView removeFromSuperview];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commentTextViewDidChange:(NSNotification *)notification
{
    CGFloat height = self.buddyStatusCommentInputView.addedHeight;
    
    if (height != 0) {
        CGRect frame = self.buddyStatusCommentInputView.frame;
        frame.size.height += height;
        frame.origin.y -= height;
        self.buddyStatusCommentInputView.frame = frame;
    }
}

- (void)commentTextViewtDidBeginEditing:(NSNotification *)notification
{
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
}

- (void)commentTextViewtDidEndEditing:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat y = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    [UIView animateWithDuration:0.7 animations:^{
        CGRect frame = self.buddyStatusCommentInputView.frame;
        frame.origin.y = y - self.buddyStatusCommentInputView.height;
        self.buddyStatusCommentInputView.frame = frame;
    }];
}

- (void)coverViewDidOnClick
{
    [self.buddyStatusCommentInputView quit];
}

#pragma mark - other method
- (void)loadNew
{
    [self setDataWithBegin:0 limit:LIMIT];
}

- (void)loadMore
{
    if (self.buddyStatusCommentFrames.count == 0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [self setDataWithBegin:self.buddyStatusCommentFrames.count+1 limit:LIMIT];
}

// 获取网络数据
- (void)setDataWithBegin:(long)begin limit:(long)limit
{
    NSDictionary * params = @{@"begin": @(begin),
                              @"limit": @(limit),
                              @"feedid": @(self.feedid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_feed_comment_list,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_loading:num(0),
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)buddyStatusCommentInputView:(BuddyStatusCommentInputView *)view sendBtnDidOnClick:(UIButton *)btn
{
    if (self.backBlk) {
        self.backBlk(self.feedid);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
