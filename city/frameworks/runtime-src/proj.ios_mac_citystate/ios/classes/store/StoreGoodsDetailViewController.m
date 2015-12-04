//
//  StoreGoodsDetailViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import "StoreGoodsDetailViewController.h"
#import "MJExtension.h"
#import "StoreGoodsDetail.h"
#import "StoreGoodsDetailSectionOneView.h"
#import "StoreGoodsDetailSectionTwoView.h"
#import "StoreGoodsDetailSectionThreeView.h"
#import "StoreSubmitOrderViewController.h"

@interface StoreGoodsDetailViewController () <StoreGoodsDetailSectionOneViewDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, strong) StoreGoodsDetail *storeGoodsDetail;
@property (nonatomic, weak) StoreGoodsDetailSectionOneView *oneView;
@property (nonatomic, weak) StoreGoodsDetailSectionTwoView *twoView;
@property (nonatomic, weak) StoreGoodsDetailSectionThreeView *threeView;
@end

@implementation StoreGoodsDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"特卖详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeGoodsDetailSectionThreeCellLayoutSubviews:) name:StoreGoodsDetailSectionThreeViewLayoutSubviewsNotification object:nil];
    StoreGoodsDetailSectionOneView *oneView = [StoreGoodsDetailSectionOneView storeGoodsDetailSectionOneView];
    [self.contentView addSubview:oneView];
    self.oneView = oneView;
    oneView.frame = CGRectMake(0, 0, self.contentView.width, StoreGoodsDetailSectionOneViewHight);
    oneView.delegate = self;
    StoreGoodsDetailSectionTwoView *twoView = [StoreGoodsDetailSectionTwoView storeGoodsDetailSectionTwoView];
    [self.contentView addSubview:twoView];
    self.twoView = twoView;
    twoView.frame = CGRectMake(0, CGRectGetMaxY(oneView.frame) + 10, self.contentView.width, StoreGoodsDetailSectionTwoViewHight);
    StoreGoodsDetailSectionThreeView *threeView = [StoreGoodsDetailSectionThreeView storeGoodsDetailSectionThreeView];
    [self.contentView addSubview:threeView];
    self.threeView = threeView;
    threeView.frame = CGRectMake(0, CGRectGetMaxY(twoView.frame) + 10, self.contentView.width, self.threeView.height);
    

    NSDictionary * params = @{@"userid": @(self.userid),
                              @"goodsid": @(self.goodsid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_store_goods,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_goods]) {
        self.storeGoodsDetail = [StoreGoodsDetail objectWithKeyValues:[result objectOutForKey:@"res"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.oneView.storeGoodsDetail = self.storeGoodsDetail;
            self.twoView.storeGoodsDetail = self.storeGoodsDetail;
            self.threeView.storeGoodsDetail = self.storeGoodsDetail;
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_goods]) {
        InfoLog(@"error:%@", error);
    }
}

- (void)storeGoodsDetailSectionThreeCellLayoutSubviews:(NSNotification *)notification
{
    UIScrollView *view = self.contentView;
    CGFloat maxHeight = 0.0;
    for (UIView * v in view.subviews) {
        maxHeight = (v.y + v.height > maxHeight) ? v.y + v.height : maxHeight;
    }
    if (maxHeight > 0) {
        view.frame = self.view.bounds;
        view.contentSize = CGSizeMake(view.width, maxHeight+10 - 49);
    }
}

- (void)storeGoodsDetailSectionOneView:(StoreGoodsDetailSectionOneView *)view quickBuyBtnDidOnClick:(UIButton *)button
{
    if (![[UserManager sharedInstance] hasLogin]) {
        [[ExceptionEngine shared] alertTitle:nil message:@"使用此功能需要登录！" delegate:self tag:-13 cancelBtn:@"取消" btn1:@"登录" btn2:nil];
        return;
    }
    
    if (self.storeGoodsDetail) {
        StoreSubmitOrderViewController *storeSubmitOrderViewController = [[StoreSubmitOrderViewController alloc] init];
        // 设置订单数据
        GoodsOrder *goodsOrder = [[GoodsOrder alloc] init];
        goodsOrder.storeid = self.storeGoodsDetail.userid;
        goodsOrder.goodsid = self.storeGoodsDetail.goodsid;
        goodsOrder.name = self.storeGoodsDetail.name;
        goodsOrder.price = self.storeGoodsDetail.price;
        goodsOrder.phone = [UserManager sharedInstance].base.phone;
        goodsOrder.count = 1;
        storeSubmitOrderViewController.goodsOrder = goodsOrder;
        [self.navigationController pushViewController:storeSubmitOrderViewController animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
