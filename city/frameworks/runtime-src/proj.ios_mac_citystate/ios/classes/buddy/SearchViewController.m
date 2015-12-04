//
//  SearchViewController.m
//  citystate
//
//  Created by 小生 on 15/10/25.
//
//

#import "SearchViewController.h"
#import "CTSearchBox.h"
#import "BuddyItem.h"
#import "UIImageView+WebCache.h"
#import "CocosViewController.h"

@interface SearchViewController ()<CTSearchBoxDelegate,UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic,retain)NSMutableArray * tableArray;
@property (nonatomic,retain) UITableView *searchResultTableView;
@property (nonatomic,weak)CTSearchBox *searchBar;
@end

@implementation SearchViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        CTSearchBox *searchBar = [[CTSearchBox alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
        searchBar.delegate = self;
        self.navigationItem.titleView = searchBar;
        _searchBar = searchBar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.5;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tapg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dataActions:)];
    [self.contentView addGestureRecognizer:tapg];
    tapg.delegate = self;
    self.tableArray = [NSMutableArray array];
}

- (void)requesUserWithString:(NSString *)str
{
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",self.userid]
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_square,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_square]) {
        NSArray *dicts = [result objectOutForKey:@"res"];
        [self.tableArray removeAllObjects];
        [self.tableArray addObjectsFromArray:[self dicts2Models:dicts]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.searchResultTableView reloadData];
    });
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_square]) {
        InfoLog(@"error:%@", error);
    }
}

- (NSArray *)dicts2Models:(NSArray *)dicts
{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in dicts){
        BuddyItem *buddyItem = [[BuddyItem alloc] init];
        buddyItem.userid = [dict[@"userid"] integerValue];
        buddyItem.imglink = dict[@"imglink"];
        buddyItem.name = dict[@"name"];
        [models addObject:buddyItem];
    }
    return models;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    [cell.contentView removeAllSubviews];
    cell.frame = CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BuddyItem * item = [_tableArray objectAtExistIndex:indexPath.row];
    UIImageView * userIcon = [UIImageView imageView:@{V_Parent_View:cell,
                                                V_Margin_Left:@10,
                                                V_Margin_Top:@5,
                                                V_Width:@40,
                                                V_Height:@40,
                                                V_Border_Radius:@20,
                                                V_Border_Color:k_defaultLineColor,
                                                }];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:item.imglink] placeholderImage:[UIImage imageNamed:@"res/user/0.png"]];
    [cell.contentView addSubview:userIcon];
    [cell.contentView addSubview:[UILabel label:@{V_Parent_View:cell,
                                                 V_Margin_Left:strFloat(userIcon.width + 20),
                                                 V_Over_Flow_Y:strFloat(OverFlowYCenter),
                                                 V_Text:item.name,
                                                 V_Width:strFloat(cell.width - userIcon.width - 20),
                                                 V_Color:darkGary_color,
                                                 V_Font_Family:k_fontName_FZXY,
                                                 V_Font:@14,
                                                  V_TextAlign:num(TextAlignLeft),
                                                 }]];
    [cell.contentView addSubview:[UIView view_sub:@{V_Parent_View:cell,
                                                    V_Height:@0.5,
                                                    V_BGColor:k_defaultLineColor,
                                                    }]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.contentView removeAllSubviews];
    BuddyItem *item =  [_tableArray objectAtExistIndex:indexPath.row];
    [self toCocos:item.userid :item.name :item.intro :item.zone :item.thumblink :item.imglink ];
        //再push到viewController
    CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
    vc.userid = item.userid;
    vc.buddyItem = item;
    [[CocosManager shared] addCocosMapView:vc];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchBar:(CTSearchBox *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.searchResultTableView.hidden = YES;
        self.view.alpha = 0.5;
    } else {
        [self requesUserWithString:searchText];
        self.searchResultTableView.hidden = NO;
        self.view.alpha = 1.0;
    }
}

- (UITableView *)searchResultTableView
{
    if (!_searchResultTableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.contentView addSubview:tableView];
        _searchResultTableView = tableView;
        self.searchResultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _searchResultTableView;
}

- (void)dataActions:(UITapGestureRecognizer *)tapg{
    if (self.cancel) {
        self.cancel();
    }
}
- (void)searchBarCancelButtonClicked:(CTSearchBox *)searchBar {
    NSLog(@"----");
    if (self.cancel) {
        self.cancel();
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
@end
