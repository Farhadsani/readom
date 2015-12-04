//
//  MySeanViewController.m
//  citystate
//
//  Created by 小生 on 15/10/15.
//
//

#import "MySeanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZYQAssetPickerController.h"
#import "CocosViewController.h"
#import "BuddyItem.h"
#import "BusinessSeanViewController.h"
#import "OrderScanResultViewController.h"

@interface MySeanViewController ()<AVCaptureMetadataOutputObjectsDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>{
    int numInSection;
    NSInteger _seanNum;
    UIView * _bgView;

}
@property(nonatomic, retain) UIView * mySeanView;
@property(nonatomic ,retain) UIImageView * cameraImage;
@property (nonatomic, strong) UserBriefItem *   userBriefItem;

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MySeanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的二维码";
    [self stupMainView];
    [self qrFoundation];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Start
    [_session startRunning];
}

#pragma qr
- (void)qrFoundation{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    //相框size
    CGFloat camerSize = _mySeanView.height * 11/25;
    //左右的with
    CGFloat leftSize = (_mySeanView.width - camerSize) /2;

  [ _output setRectOfInterest : CGRectMake (( leftSize )/ SCREEN_HEIGHT ,(( SCREEN_WIDTH - camerSize )/ 2 )/ SCREEN_WIDTH , camerSize / SCREEN_HEIGHT , camerSize / SCREEN_WIDTH )];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        if (![stringValue containsString:@"?"]) {
            return;
        }
         NSString * params = [[stringValue componentsSeparatedByString:@"?"] objectAtExistIndex:1];
        NSArray * arr = [params componentsSeparatedByString:@"="];
        if ([arr count] == 2) {
            NSString * key = [arr objectAtExistIndex:0];
            NSString * value = [arr objectAtExistIndex:1];
            if ([key isEqualToString:@"promocode"]) {
                //停止扫描
                [_session stopRunning];
                //商家
                _seanNum = [value integerValue];
                [self requestCheckOrderProimidStatus];
//                [self pushOrderView];
            }
            else if ([key isEqualToString:@"userid"]) {
                //停止扫描
                [_session stopRunning];
                //用户
                _seanNum = [value integerValue];
                [self requestUserGetuser];
            }
            else if (![key isEqualToString:@"promocode"] || ![key isEqualToString:@"userid"]){
                [_session stopRunning];
                [self seanBgView];
                // 删除扫描线
                self.lineView.hidden = YES;
            }
        }
    }
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        NSDictionary * res = result[@"res"];
        BuddyItem * buddyItem = [[BuddyItem alloc]init];
        buddyItem.name = res[@"name"];
        buddyItem.zone = res[@"zone"];
        buddyItem.thumblink = res[@"thumblink"];
        buddyItem.imglink = res[@"imglink"];
        buddyItem.intro = res[@"intro"];
        
        [self toCocos:_seanNum :buddyItem.name:buddyItem.intro :buddyItem.zone :buddyItem.thumblink :buddyItem.imglink ];
        
        CocosViewController *vc = [CocosViewController cocosViewControllerWithBackType:CocosViewControllerBackTypeIOS mapIndexType:0];
        vc.userid = _seanNum;
        vc.buddyItem = buddyItem;
        [[CocosManager shared] addCocosMapView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_proimid_check]) {
        [self pushProimidScanResult:[result objectOutForKey:@"res"]];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_getuser]) {
        NSLog(@"error......");
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_proimid_check]) {
        NSLog(@"error......");
    }
}
#pragma action
- (void)pushOrderView{
    BusinessSeanViewController * vc = [[BusinessSeanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushProimidScanResult:(NSDictionary *)info{
    [_session startRunning];
    OrderScanResultViewController * vc = [[OrderScanResultViewController alloc]init];
    vc.title = @"特卖劵";
    vc.totalPrice = info[@"price"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)seanBgView{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8;
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [bgView addGestureRecognizer:tapGesture];
    
    CGFloat top = bgView.height / 3;
    UILabel * label = [UILabel label:@{V_Parent_View:bgView,
                                       V_Margin_Top:strFloat(top),
                                       V_Text:@"扫不到，换个二维码试试",
                                       V_TextAlign:num(TextAlignCenter),
                                       V_Color:white_color,
                                       V_Height:@20,
                                       V_Font_Family:k_defaultFontName,
                                       V_Font_Size:@14,
                                       }];
    [bgView addSubview:label];
    
    UILabel * twoLable = [UILabel label:@{V_Parent_View:bgView,
                                          V_Last_View:label,
                                          V_TextAlign:num(TextAlignCenter),
                                          V_Text:@"轻触屏幕继续扫描",
                                          V_Font_Family:k_defaultFontName,
                                          V_Font_Size:@12,
                                          V_Height:@20,
                                          V_Color:white_color,
                                          V_Alpha:@0.5,
                                          }];
    [bgView addSubview:twoLable];
}
- (void)tapAction:(UITapGestureRecognizer *)tapg{
    self.lineView.hidden = NO;
    [_bgView removeFromSuperview];
    [_session startRunning];
}
- (void)pthotoButAction:(UIButton *)sender{
    [self selectPhotosFromLib];
}

- (void)sacnButAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//调用相册
- (void)selectPhotosFromLib
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        //获取图片裁剪的图
//        int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
        //相框size
        int canerSize = self.mySeanView.height * 11/25;
        UIImage *thumb = [self scaleAndRotateImage:tempImg andMinImageWidth:canerSize];
//        _cameraImage.image = thumb;
//        _cameraImage.contentMode = UIViewContentModeScaleToFill;
#pragma 获取到当前的二维码图片，扫描识别
//        [thumbs addObject:thumb];

    }
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image andMinImageWidth:(int)scaleWidth{
    int kMaxResolution = scaleWidth; // 自定义宽度，根据比例裁剪图片
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    if( width<height ){
        bounds.size.width = kMaxResolution;
        bounds.size.height = kMaxResolution;
    }else{
        bounds.size.width = kMaxResolution                                                                                                                                                                                                                                                                                                                                     ;
        bounds.size.height = kMaxResolution;
    }
    return image;

}

#pragma mark - request
- (void)requestUserGetuser{
    NSDictionary * params = @{@"userid":@(_seanNum)
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_getuser,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)requestCheckOrderProimidStatus{
    NSDictionary * params = @{@"promocode":@(_seanNum)
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_proimid_check,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mainView
- (void)stupMainView{
    self.mySeanView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                         }];
    [self.contentView addSubview:_mySeanView];
    
    //顶部top
    CGFloat martop = _mySeanView.height * 1/10;
    //相框size
    CGFloat camerSize = _mySeanView.height * 11/25;
    //左右的with
    CGFloat leftSize = (_mySeanView.width - camerSize) /2;
    //底部的View
    CGFloat downSize = _mySeanView.height - martop - camerSize;
    //最上部的View
    UIView * upView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                         V_Height:strFloat(martop + 3),
                                         V_BGColor:black_color,
                                         V_Alpha:@0.6,
                                         }];
    [_mySeanView addSubview:upView];
    
    //左侧的View
    UIView * leftView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                           V_Last_View:upView,
                                         V_Height:strFloat(camerSize-4),
                                           V_Width:strFloat(leftSize + 3),
                                         V_BGColor:black_color,
                                         V_Alpha:@0.6,
                                         }];
    [_mySeanView addSubview:leftView];
    
    //右侧的View
    UIView * rightView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Last_View:upView,
                                           V_Height:strFloat(camerSize -4),
                                            V_Width:strFloat(leftSize +3),
                                           V_BGColor:black_color,
                                            V_Margin_Left:strFloat(camerSize + leftSize -3),
                                           V_Alpha:@0.6,
                                           }];
    [_mySeanView addSubview:rightView];
    
    //底部的View
    UIView * downView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                           V_Last_View:rightView,
                                            V_Height:strFloat(downSize+4),
                                            V_BGColor:black_color,
                                            V_Alpha:@0.6,
                                            }];
    [_mySeanView addSubview:downView];


    CGFloat scanHeight = _mySeanView.height * 18/25;
//    UIButton * photoBut = [UIView button:@{V_Parent_View:self.mySeanView,
//                                          V_Margin_Top:strFloat(scanHeight),
//                                           V_Width:strFloat(_mySeanView.width/2),
//                                           V_VerticalAlign:num(VerticalCenter),
//                                          V_Img:@"scanPhtoto",
//                                          V_Img_C:@"scanPhtoto",
//                                           V_Title:@"相册",
//                                          V_SEL:selStr(@selector(pthotoButAction:)),
//                                          V_Delegate:self,
//                                          }];
//    [photoBut setTitle:@"相册" forState:UIControlStateNormal];
//    [photoBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [photoBut setImageEdgeInsets:UIEdgeInsetsMake(-40.0, 28.0, 0.0, 0.0)];
//    [photoBut setTitleEdgeInsets:UIEdgeInsetsMake(19.0, -28.0, 0.0, 0.0)];
//    [_mySeanView addSubview:photoBut];
    
    
    UIButton * seanBut = [UIView button:@{V_Parent_View:self.mySeanView,
//                                          V_Left_View:photoBut,
                                          V_Margin_Top:strFloat(scanHeight),
                                          V_Width:strFloat(_mySeanView.width/3),
                                          V_Height:@45,
                                          V_Over_Flow_X:num(OverFlowXCenter),
                                          V_Img:@"scanBut",
                                          V_Img_C:@"scanBut",
                                          V_Color:[UIColor whiteColor],
                                          V_SEL:selStr(@selector(sacnButAction:)),
                                          V_Delegate:self,
                                          }];
    UIButton * seanBut2 = [UIView button:@{V_Parent_View:self.mySeanView,
                                           V_Last_View:seanBut,
                                           V_Width:strFloat(_mySeanView.width/3),
                                           V_Height:@20,
                                           V_Over_Flow_X:num(OverFlowXCenter),
                                           V_Title:@"我的二维码",
                                           V_Color:[UIColor whiteColor],
                                           V_SEL:selStr(@selector(sacnButAction:)),
                                           V_Delegate:self,
                                           }];
//    [seanBut setImageEdgeInsets:UIEdgeInsetsMake(-40.0, 28.0, 0.0, 0.0)];
//    [seanBut setTitleEdgeInsets:UIEdgeInsetsMake(19.0, -70.0, 0.0, 0.0)];

    [_mySeanView addSubview:seanBut];
    [_mySeanView addSubview:seanBut2];
    
    self.cameraImage = [UIView imageView:@{V_Parent_View:self.mySeanView,
                                                    V_Margin_Top:strFloat(martop),
                                                    V_Left_View:leftView,
                                                    V_Right_View:rightView,
                                                    V_BGColor:clear_color,
                                                    V_Over_Flow_X:num(OverFlowXCenter),
                                                    V_Img:@"qr_frame",
                                                    V_Height:strFloat(camerSize),
                                                    V_Width:strFloat(camerSize),
                                                    }];
    [_mySeanView addSubview:self.cameraImage];
    
    //扫描线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(leftView.width, martop, camerSize-10, 1)];
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_bg"]];
    [self.view addSubview:line];
    
    [UIView beginAnimations:@"animationID" context:NULL];
    [UIView setAnimationDuration:4];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:line cache:YES];  //这句话估计得注释掉才行，有一次就因为这句话出现个小问题
    [UIView setAnimationRepeatCount:100];
    
    [line setFrame:CGRectMake(leftView.width, martop+camerSize, camerSize, 1)];
    [UIView commitAnimations];
    self.lineView = line;
    
    [line release];
    
    UILabel * lab = [UIView label:@{V_Parent_View:self.mySeanView,
                                    V_Last_View:self.cameraImage,
                                    V_Margin_Top:strFloat(martop - 20),
                                    V_Over_Flow_X:num(OverFlowXCenter),
                                    V_Text:@"将取景框对准二维码",
                                    V_TextAlign:num(TextAlignCenter),
                                    V_Color:white_color,
                                    V_Alpha:@1,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Height:@20,
                                    }];
    [_mySeanView addSubview:lab];
    
}
#pragma back
- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    
}

- (void)dealloc{
    [super dealloc];
    [_mySeanView release];
    [_cameraImage release];
}

@end
