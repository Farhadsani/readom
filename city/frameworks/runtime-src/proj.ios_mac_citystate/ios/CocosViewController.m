//
//  CocosViewController.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/9.
//
//

#import "CocosViewController.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface CocosViewController (){
    UIImageView * thunbImgView;
}
@property (nonatomic, assign) CocosViewControllerBackType backType;
@property (nonatomic, assign) MapIndexType mapIndexType;
@end

@implementation CocosViewController
+ (instancetype)cocosViewControllerWithBackType:(CocosViewControllerBackType)backType mapIndexType:(MapIndexType)mapIndexType
{
    CocosViewController *cocosViewController = [[self alloc] init];
    cocosViewController.backType = backType;
    cocosViewController.mapIndexType = mapIndexType;
    return cocosViewController;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupLeftBackButtonItem:nil img:nil action:@selector(clickLeftBackButtonItem)];
    
    [self setupPrivateNavbar];
}

- (void)clickRightButtonItem:(id)sender{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideTabBar:YES animation:NO];
    
    if (![self.view.subviews containsObject:[CocosManager shared].cocosView]) {
        [[CocosManager shared] addCocosUserCenterView:self];
    }
    
    [self refreshUserHome:self.userid];
}

- (void)viewDidAppear:(BOOL)animated{
    [self hideTabBar:YES animation:NO];
    
    
}


- (void)setupPrivateNavbar{
    if (self.buddyItem) {
        self.title = self.buddyItem.name;
        
        CGFloat wid = 30;
        thunbImgView = [UIView imageView:@{V_Frame:rectStr(0, 0, wid, wid),
                                           V_ContentMode:num(ModeAspectFill),
                                           V_Border_Radius:strFloat(wid/2.0),
                                           V_Delegate:self,
                                           V_SEL:selStr(@selector(tapImage)),
                                           V_BGColor:white_color,
                                           }];
        thunbImgView.clipsToBounds = YES;
        thunbImgView.image = [UIImage imageNamed:@"register-done-2-1.png"];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:thunbImgView] autorelease];
//        [thunbImgView  sd_setImageWithURL:[NSURL URLWithString:self.buddyItem.imglink] placeholderImage:[UIImage imageNamed:@"register-done-2-1.png"]];
        NSString * imglink = nil;
        if (![NSString isEmptyString:self.buddyItem.thumblink]) {
            imglink = self.buddyItem.thumblink;
        }
        else if (![NSString isEmptyString:self.buddyItem.imglink]) {
            imglink = self.buddyItem.imglink;
        }
        
        if (imglink) {
            if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
                thunbImgView.image = [[Cache shared].pics_dict objectOutForKey:imglink];
            }
            else{
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
                if (img) {
                    [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
                    thunbImgView.image = img;
                }
            }
        }
    }
}

- (void)tapImage
{
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:self.buddyItem.imglink]; // 图片路径
    photo.srcImageView = thunbImgView;
    
    MJPhotoBrowser * browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = 0;
    browser.photos = @[photo];
    [browser show];
}

- (void)clickLeftBackButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.backType == CocosViewControllerBackTypeIOS) {
        [self backUserHome:self.userid];
    } else {
        [self toMap:self.mapIndexType indexId:nil];
        [self backToMapIndex:self.userid];
    }
}
@end
