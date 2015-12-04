//
//  MessageController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/28.
//
//


/*
 *【消息】界面
 *功能：查看[我的消息]、[宠物消息]、[收到的赞]、[系统消息]
 *
 */

#import "MessageController.h"


#define milky_color rgb(253,255,243)//乳白 色
#define CellH 80

@interface MessageController ()

@end

@implementation MessageController

- (void)variableInit{
    [super variableInit];
    self.hasLeftNavBackButton = YES;
    self.hidTabbarBar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    TitleBar *titleBar = [TitleBar titleBarWithTitles:self.tName andShowCount:self.tName.count];
    self.titleBar = titleBar;
    titleBar.frame = CGRectMake(0, 0, self.contentView.width, 40);
    titleBar.delegate = self;
    [self.contentView addSubview:titleBar];
    
    MyMsgViewController *myVC = [[[MyMsgViewController alloc] init] autorelease];
    myVC.hidTabbarBar = self.hidTabbarBar;
    PetMsgViewController * pmVC = [[[PetMsgViewController alloc]init] autorelease];
    pmVC.hidTabbarBar = self.hidTabbarBar;
    ReceivedPraiseViewController * rpVC = [[[ReceivedPraiseViewController alloc] init] autorelease];
    rpVC.hidTabbarBar = self.hidTabbarBar;
    SysMsgViewController * syVC = [[[SysMsgViewController alloc] init] autorelease];
    syVC.hidTabbarBar = self.hidTabbarBar;
    [self addChildViewController:myVC];
    [self addChildViewController:pmVC];
    [self addChildViewController:rpVC];
    [self addChildViewController:syVC];
    
    
    [self.contentView addSubview:myVC.view];
    self.selectedView = myVC.view;
    [self calFrame:myVC.view];
}

- (void)calFrame:(UIView *)vi{
    vi.frame = CGRectMake(0, self.titleBar.y+self.titleBar.height, self.view.width, self.view.height);
}

- (NSArray *)tName{
    if (!_tName) {
        _tName = @[@"我的消息",@"宠物消息",@"收到的赞",@"系统信息"];
    }
    return _tName;
}

- (void)titleBar:(TitleBar *)titleBar titleBtnDidOnClick:(NSInteger)index{
    self.navigationItem.title = self.tName[index];
    [self.selectedView removeFromSuperview];
    UIViewController *vc = self.childViewControllers[index];
    
    [self.contentView addSubview:vc.view];
    self.selectedView = vc.view;
    [self calFrame:vc.view];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabBar:YES animation:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
