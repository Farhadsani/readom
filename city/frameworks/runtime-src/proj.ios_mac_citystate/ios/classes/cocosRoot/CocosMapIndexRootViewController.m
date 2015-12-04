//
//  CocosMapIndexRootViewController.m
//  citystate
//
//  Created by hf on 15/10/8.
//
//

#import "CocosMapIndexRootViewController.h"
#import "StateNearbyViewController.h"
#import "ExponentViewController.h"

@interface CocosMapIndexRootViewController ()

@end

@implementation CocosMapIndexRootViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.forceHiddenNavAndTabbar = YES;
    }
    return self;
}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftBackButtonItem:nil img:@"nearbystatus.png" action:@selector(clickLeftItem:)];
    [self setupRightBackButtonItem:nil img:@"exponenttype.png" del:self sel:@selector(clickRightItem:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![self.view.subviews containsObject:[CocosManager shared].cocosView]) {
        [[CocosManager shared] addCocosMapView:self];
    }
    
    if ([CocosManager shared].isUserCenterStatus) {
        if (!self.currentIndexId) {
            self.currentMapIndexType = MapIndexType_sight;
            self.currentIndexId = [[[NSString alloc] init] autorelease];
        }
        [self toMap:_currentMapIndexType indexId:nil];
    } else {
        if (!self.currentIndexId) {
            self.currentMapIndexType = MapIndexType_sight;
            self.currentIndexId = [[[NSString alloc] init] autorelease];
        }
        [self toMap:_currentMapIndexType indexId:nil];
    }
    
    if (self.sightDetailViewController && self.sightDetailViewController.view.superview) {
        [self.view bringSubviewToFront:self.sightDetailViewController.view];
        [self hideTabBar:YES animation:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.sightDetailViewController && self.sightDetailViewController.view.superview) {
        [self.view bringSubviewToFront:self.sightDetailViewController.view];
        [self hideTabBar:YES animation:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.forceHiddenNavAndTabbar = NO;
}


//显示景点详情界面
- (void)showSightDetailView:(UIViewController *)vc{
    if (vc) {
        [self hideTabBar:YES animation:YES];
        self.sightDetailViewController = vc;
        [self addChildViewController:self.sightDetailViewController];
        [self.view addSubview:self.sightDetailViewController.view];
    }
}

//刷新地图数据
- (void)updateCocosMap:(MapIndexType)indexType indexId:(NSString *)indexId{
    if (![self.view.subviews containsObject:[CocosManager shared].cocosView]) {
        [[CocosManager shared] addCocosMapView:self];
    }
    
    if (_currentMapIndexType == indexType) {
        if (_currentMapIndexType == MapIndexType_sight) {
            [self toMap:_currentMapIndexType indexId:nil];
        }
        else if (![_currentIndexId isEqualToString:indexId]){
            self.currentIndexId = indexId;
            [self toMap:_currentMapIndexType indexId:_currentIndexId];
        }
    }
    else{
        self.currentMapIndexType = indexType;
        if (_currentMapIndexType == MapIndexType_sight) {
            self.currentIndexId = @"";
            [self toMap:_currentMapIndexType indexId:nil];
        }
        else{
            self.currentIndexId = indexId;
            [self toMap:_currentMapIndexType indexId:_currentIndexId];
        }
    }
}

#pragma mark - delegate (CallBack)

#pragma mark ExponentVCDelegate delegate
- (void)ViewController:(ExponentViewController *)vc didSelectedIndexType:(MapIndexType)indexType indexID:(NSString *)indexId{
    [self updateCocosMap:indexType indexId:indexId];
}

#pragma mark other delegate

#pragma mark - action such as: click touch tap slip ...

- (void)clickLeftItem:(id)sender{
    StateNearbyViewController *nearby = [[[StateNearbyViewController alloc] init] autorelease];
    [self.navigationController pushViewController:nearby animated:YES];
}

- (void)clickRightItem:(id)sender{
    ExponentViewController *vc = [[[ExponentViewController alloc] init] autorelease];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{
    
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark


@end
