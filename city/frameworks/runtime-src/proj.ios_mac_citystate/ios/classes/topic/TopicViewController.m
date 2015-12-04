#import "TopicViewController.h"
#import "PostViewController.h"
#import "UserManager.h"
#import "NetworkManager.h"
#import "LoggerClient.h"
#import "AFNetworking.h"
#import "UIViewController+Addtion.h"

@implementation TopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"话题";
    
    [self getOn];
    
    topicView = [[TopicView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    topicView.delegate = self;
    [self.contentView addSubview:topicView];
    
    [topicView startList];
}
- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self baseBack:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [topicView.listView.banner openTimer];//开启定时器
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [topicView.listView.banner closeTimer];//关闭定时器
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)TVDback {
    [self setupLeftBackButtonItem:nil img:nil action:@selector(baseBack:)];
//    [self baseBack:nil];
}

- (void)TVDlist {
    self.title = @"话题";
    [self setupLeftBackButtonItem:nil img:nil action:@selector(baseBack:)];
}

- (void)TVDnote {
    self.title = @"话题";
    [self setupLeftBackButtonItem:nil img:nil action:@selector(back2list)];
}

- (void)TVDgallery {
    self.title = @"";
    [self setupLeftBackButtonItem:nil img:nil action:@selector(back2note)];
}

- (void)TVDpost:(TopicItem*)pNote {
    PostViewController *postVC = [[PostViewController alloc]  init];
    postVC.note = pNote;
    [self.navigationController pushViewController:postVC animated:YES];
}

- (void)TVDlike:(TopicItem*)pNote {
    if (pNote.liked) { // 已收藏，切换到取消收藏
        [topicView.topicManager likeDel:pNote.topicid];
    } else {
        [topicView.topicManager likePost:pNote.topicid];
    }
}

//- (void)TVDshare:(RongoShareItem*)pItem {
////    [self presentPopupViewController:RONGO_ARC_AUTORELEASE([[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil]) animationType:MJPopupViewAnimationFade];
////    [[ShareManager sharedInstance] shareRongo:pItem :self];
//}


- (void)baseBack:(id)sender
{
    [self getOff];
    [self baseDeckAndNavBack];
//    if( callback ){
//        callback( YES );
//    }
    long userID = [UserManager sharedInstance].brief.userid;
    NSString *name = [UserManager sharedInstance].brief.name;
    NSString *intro = [UserManager sharedInstance].brief.intro;
    NSString *zone = [UserManager sharedInstance].brief.zone;
    //    NSData *data = [UserManager sharedInstance].brief.thumbdata;
    NSString *thumblink = [UserManager sharedInstance].brief.thumblink;
    NSString *imglink = [UserManager sharedInstance].brief.imglink;

    if(name == nil) {name = @""; }
    if(intro == nil) {intro = @""; }
    if(zone == nil) {zone = @""; }
    if(thumblink == nil) {thumblink = @""; }
    if(imglink == nil) {imglink = @""; }
    
    if ([UserManager sharedInstance].userLoginStatus == Lstatus_loginSuccess) {
        [self toCocos:userID :name :intro :zone :thumblink :imglink];
    }else
    {
        [self toCocos:0 :@"" :@"" :@"" :@"" :@""];
    }
//    [self toMap];
}

- (void)getOn {
    AddObserver(nsFail:, @"SHITOUREN_TOPIC_LIST_FAIL");
    AddObserver(nsFail:, @"SHITOUREN_TOPIC_LIKE_POST_FAIL");
    AddObserver(nsFail:, @"SHITOUREN_TOPIC_LIKE_DEL_FAIL");
    AddObserver(topicLikedOrDelLikedSuccess:, @"SHITOUREN_API_TOPIC_LIKE_POST_SUCC");
    AddObserver(topicLikedOrDelLikedSuccess:, @"SHITOUREN_API_TOPIC_LIKE_DEL_SUCC");
    AddObserver(baseDeckAndNavBack, @"SHITOUREN_BACK_DECKANDNAV");
    
}

- (void)getOff {
    DelObserver(@"SHITOUREN_TOPIC_LIST_FAIL");
    DelObserver(@"SHITOUREN_TOPIC_LIKE_POST_FAIL");
    DelObserver(@"SHITOUREN_TOPIC_LIKE_DEL_FAIL");
    DelObserver(@"SHITOUREN_API_TOPIC_LIKE_POST_SUCC");
    DelObserver(@"SHITOUREN_API_TOPIC_LIKE_DEL_SUCC");
    DelObserver(@"SHITOUREN_BACK_DECKANDNAV");
}


-(void)nsFail:(NSNotification *)notification {
    NSString *msg = (NSString*)(notification.object);
    [self baseShowBotHud:NSLocalizedString(msg, @"")];
}

- (void)topicLikedOrDelLikedSuccess:(NSNotification *)notification
{
    TopicItem *item = (TopicItem*)(notification.object);
    topicView.noteView.banner.uiLikeBtn.selected = item.liked;
}

- (void)TVWgallery
{
//    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)TVWnote
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)baseNavBack {
}

@end
