//
//  SightDetailViewController.m
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import "SightDetailViewController.h"
#import "AppController.h"
#import "SightDetailIntroItem.h"
#import "SightDetailIntroViewController.h"
#import "TitleBar.h"
#import "SightDetailVisitorViewController.h"
#import "BuddyItem.h"
#import "CocosViewController.h"
#import "BuddyStatusCell.h"
#import "SightDetailGoodsViewController.h"
#import "SightDetailGoodsCell.h"
#import "StoreSubmitOrderViewController.h"
#import "BuddyStatusCommentsViewController.h"


@interface SightDetailViewController () <TitleBarDelegate, BuddyStatusCellDelegate, SightDetailGoodsCellDelegate>
{
    UIControl * controlBack;
    UIControl * navBarBack;
    UIView * popContentView;
}
@property (nonatomic, strong) NSMutableArray *introItems;
@property (nonatomic, weak) UIView *showingView;
@property (nonatomic, assign) NSInteger showingIndex;
@property (nonatomic, strong) SightDetailGoods * selectedSightDetailGoods;
@property (nonatomic, weak) SightDetailVisitorViewController *sightDetailVisitorViewController;
@end

@implementation SightDetailViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setupMainView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (popContentView.y == controlBack.height) {
        [UIView animateWithDuration:0.3 animations:^{
            controlBack.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
            popContentView.frame = CGRectMake(popContentView.x, controlBack.height-popContentView.height, popContentView.width, popContentView.height);
        } completion:^(BOOL finished) {
        }];
    }
    else{
        controlBack.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    }
    [self setNavBarShadow:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNavBarShadow:NO];
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate

#pragma mark other delegate

#pragma mark - action such as: click touch tap slip ...

- (void)back:(id)sender{
    [self hideTabBar:NO animation:YES];
    InfoLog(@"");
    [UIView animateWithDuration:0.3 animations:^{
        controlBack.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        navBarBack.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        popContentView.frame = CGRectMake(popContentView.x, controlBack.height, popContentView.width, popContentView.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [navBarBack removeFromSuperview];
            [self.view removeFromSuperview];
        }
    }];
    
    [self backToMapIndex:0];
}

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{
    [self setNavBarShadow:YES];
    
    controlBack = [UIView control:@{V_Parent_View:self.view,
                                    V_Delegate:self,
                                    V_SEL:selStr(@selector(back:)),
                                    }];
    [self.view addSubview:controlBack];
    
    popContentView = [UIView view_sub:@{V_Parent_View:controlBack,
                                     V_BGColor:white_color,
                                     V_Margin_Top:strFloat(controlBack.height/5),
                                     V_Height:strFloat(controlBack.height*4/5),
                                     }];
    [controlBack addSubview:popContentView];
    popContentView.frame = CGRectMake(popContentView.x, controlBack.height, popContentView.width, popContentView.height);
    
    UILabel * title = [UIView label:@{V_Parent_View:popContentView,
                                      V_Height:strFloat(k_DEFAULT_NAVIGATION_BAR_HEIGHT),
                                      V_BGColor:k_defaultNavBGColor,
                                      V_Text:[self.data_dict objectOutForKey:k_sightName],
                                      V_TextAlign:num(TextAlignCenter),
                                      V_Font_Size:strFloat(k_defaultNavTitleFontSize),
                                      V_Font_Family:k_defaultFontName,
                                      }];
    [popContentView addSubview:title];
    
    TitleBar *titleBar = [TitleBar titleBarWithTitles:@[@"简介", @"游客", @"特卖"] andShowCount:3];
    [popContentView addSubview:titleBar];
    titleBar.frame = CGRectMake(0, title.height, popContentView.width, 40);
    titleBar.delegate = self;

    CGRect frame = CGRectMake(0, CGRectGetMaxY(titleBar.frame), popContentView.width, popContentView.height - CGRectGetMaxY(titleBar.frame));
    SightDetailIntroViewController *sightDetailIntroViewController = [[SightDetailIntroViewController alloc] init];
    sightDetailIntroViewController.introItems = self.introItems;
    [self addChildViewController:sightDetailIntroViewController];
    [popContentView addSubview:sightDetailIntroViewController.view];
    sightDetailIntroViewController.view.frame = frame;
    self.showingView = sightDetailIntroViewController.view;
    self.showingIndex = 0;
    
    SightDetailVisitorViewController *sightDetailVisitorViewController = [[SightDetailVisitorViewController alloc] init];
    sightDetailVisitorViewController.sightid = [self.data_dict[k_sightID] longValue];
    [self addChildViewController:sightDetailVisitorViewController];
    sightDetailVisitorViewController.view.frame = frame;
    self.sightDetailVisitorViewController = sightDetailVisitorViewController;
    
    SightDetailGoodsViewController *sightDetailGoodsViewController = [[SightDetailGoodsViewController alloc] init];
    sightDetailGoodsViewController.areaid = [self.data_dict[k_sightID] longValue];
    [self addChildViewController:sightDetailGoodsViewController];
    sightDetailGoodsViewController.view.frame = frame;
}

//设置导航栏的遮罩的显示/隐藏
- (void)setNavBarShadow:(BOOL)isShow{
    if (isShow) {
        if (navBarBack && navBarBack.superview) {
        }
        else{
            navBarBack = [UIView control:@{V_Parent_View:self.navigationController.navigationBar,
                                           V_Height:@64,
                                           V_Delegate:self,
                                           V_SEL:selStr(@selector(back:)),
                                           }];
            [self.navigationController.navigationBar addSubview:navBarBack];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            navBarBack.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        if (navBarBack && navBarBack.superview) {
            [UIView animateWithDuration:0.3 animations:^{
                navBarBack.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
            } completion:^(BOOL finished) {
                if (finished && navBarBack) {
                    [navBarBack removeFromSuperview];
                }
            }];
        }
    }
}

#pragma mark - other method
#pragma mark
- (NSMutableArray *)introItems
{
    if (!_introItems) {
        _introItems = [NSMutableArray array];
        NSArray *descName = @[@"最美季节", @"开放时间", @"游览时间", @"主要看点", @"大家印象", @"推荐理由", @"门票价格", @"游览Tips", @"交通线路"];
        NSArray *dicts = [NSJSONSerialization JSONObjectWithData:[self.data_dict[k_sightDescs] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([NSArray isNotEmpty:dicts]) {
            for (NSDictionary *dict in dicts) {
                SightDetailIntroItem *item = [[SightDetailIntroItem alloc] init];
                item.descid = [dict[@"descid"] intValue];
                item.content = dict[@"content"];
                item.desc = descName[item.descid - 1];
                item.icon = [NSString stringWithFormat:@"sightdetailintro_%d", item.descid];
                [_introItems addObject:item];
            }
        }
        else if ([NSDictionary isNotEmpty:dicts]){
            //TODO:这里在只有一个值时，源数据有问题
        }
    }
    return _introItems;
}

#pragma mark - TitleBarDelegate
- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index
{
    [self.showingView removeFromSuperview];
    [popContentView addSubview:((UIViewController *)self.childViewControllers[index]).view];
}

#pragma mark - BuddyStatusCellDelegate
- (void)buddyStatusCell:(BuddyStatusCell *)cell userIconBtnDidOnClick:(UIButton *)button
{
    BuddyStatusUser *user = cell.noteItemFrame.noteItem.user;
    BuddyItem *buddyItem = [BuddyItem buddyItemWithBuddyStatusUser:user];
    
    //跳转到有Cocos个人中心页面，需要先调用该函数刷新数据
    [self toCocos:buddyItem.userid :buddyItem.name :buddyItem.intro :buddyItem.zone :buddyItem.thumblink :buddyItem.imglink];
    //再push到viewController
    CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeCoCos mapIndexType:MapIndexType_sight];
    vc.userid = user.userid;
    vc.buddyItem = buddyItem;
    [[CocosManager shared] addCocosMapView:vc];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buddyStatusCellrequestComment:(NSInteger)feedid
{
    BuddyStatusCommentsViewController *buddyStatusCommentsViewController = [[BuddyStatusCommentsViewController alloc] init];
    buddyStatusCommentsViewController.feedid = feedid;
    buddyStatusCommentsViewController.backBlk = ^(long fid) {
        NSMutableArray *buddyStatusNoteItemFrame = self.sightDetailVisitorViewController.buddyStatusNoteItemFrame;
        for (int i = 0; i < buddyStatusNoteItemFrame.count; i++) {
            BuddyStatusNoteItem *item = ((BuddyStatusNoteItemFrame *)buddyStatusNoteItemFrame[i]).noteItem;
            if (item.feedid == fid) {
                item.commented = YES;
                item.comments_count++;
                [self.sightDetailVisitorViewController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    };
    [self.navigationController pushViewController:buddyStatusCommentsViewController animated:YES];
}

#pragma mark - SightDetailGoodsCellDelegate
- (void)sightDetailGoodsCell:(SightDetailGoodsCell *)cell quickBuyBtnDidOnClickWithSightDetailGoods:(SightDetailGoods *)sightDetailGoods
{
    if (sightDetailGoods) {
        if ([[UserManager sharedInstance] hasLogin]) {
            [self goNext_JumpToSubmitOrderVC:sightDetailGoods];
        }
        else{
            self.selectedSightDetailGoods = sightDetailGoods;
            [[ExceptionEngine shared] alertTitle:nil message:@"使用此功能需要登录！" delegate:self tag:-13 cancelBtn:@"取消" btn1:@"登录" btn2:nil];
        }
    }
}

- (void)checkLoginStatus{
    if ([[UserManager sharedInstance] hasLogin]) {
        [self goNext_JumpToSubmitOrderVC:self.selectedSightDetailGoods];
    }
    else{
        [[ExceptionEngine shared] alertTitle:nil message:@"使用此功能需要登录！" delegate:self tag:-13 cancelBtn:@"取消" btn1:@"登录" btn2:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ExceptionEngine resetAlertMessage];
    if (alertView.tag == -13 && buttonIndex == k_buttonIndex_btn1) {
        [[UserManager sharedInstance] tryCheckLogin:self delegate:nil info:nil CallBack:^(int ret) {
//            [self goNext_JumpToSubmitOrderVC:self.selectedSightDetailGoods];
        }];
    }
}

- (void)goNext_JumpToSubmitOrderVC:(SightDetailGoods *)sightDetailGoods{
    StoreSubmitOrderViewController *storeSubmitOrderViewController = [[StoreSubmitOrderViewController alloc] init];
    // 设置订单数据
    GoodsOrder *goodsOrder = [[GoodsOrder alloc] init];
    goodsOrder.storeid = sightDetailGoods.store.userid;
    goodsOrder.goodsid = sightDetailGoods.goodsid;
    goodsOrder.name = sightDetailGoods.name;
    goodsOrder.price = sightDetailGoods.price;
    goodsOrder.phone = [UserManager sharedInstance].base.phone;
    goodsOrder.count = 1;
    storeSubmitOrderViewController.goodsOrder = goodsOrder;
    
    [self.navigationController pushViewController:storeSubmitOrderViewController animated:YES];
}

- (void)didLoginSuccessInLoginVC:(NSDictionary *)result{
    InfoLog(@"");
    [self goNext_JumpToSubmitOrderVC:self.selectedSightDetailGoods];
}

@end
