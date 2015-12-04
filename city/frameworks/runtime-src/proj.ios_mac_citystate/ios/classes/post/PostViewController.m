/*
 *[发表]页面
 *功能：发表说说、标签、位置标签、添加图片、显示完成度
 *调用相册库、拍照。
 */
#import "PostViewController.h"
#import "UserManager.h"
#import "LoggerClient.h"
#import "NetWorkManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"
#import "BRPlaceholderTextView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import "AppController.h"

#define MaxPhotosCount 9    //图片限制
#define NumInSection 4      //一排有几个图片
#define Space 10
#define PictureItemWidth ((kScreenWidth - (NumInSection+1)*Space) / NumInSection) //一张图片所占位置的大小
#define PictureItemHeight PictureItemWidth

@interface PostViewController (){
    PostTagView             *uiTagView;
    PostTagView             *uiPlaceView;
    
    UIView * mainSection;
    UIView * section_tags;
    UIControl * placeTagBackView;
    UILabel * placeTagLabel;
    
    UIScrollView * pictureBoardView;
    UIButton * addTitleButton;
    BRPlaceholderTextView * uiPostView;
    UICollectionView * uiThumbColl;
    
    NSMutableArray          *urls;
    NSMutableArray          *thumbs;
    
    int                     numInSection;//一排有几个图片
    int                     postImgLimit;//图片限制
    int                     postTextLimit;
}

@property (nonatomic, assign) int index;
@property (nonatomic, assign) BMKPoiInfo * currentPoi;
@end

@implementation PostViewController
@synthesize note;

#pragma mark - life Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"发表";
    [self setupLeftBackButtonItem:nil img:nil action:@selector(clickLeftBackButtonItem)];
    [self setupRightBackButtonItem:@"发表" img:nil del:self sel:@selector(post)];
    
    [self setupMainView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [uiThumbColl reloadData];
    [self refresh];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - delegate (CallBack)

#pragma mark PlaceTagVCDelegate
- (void)VC:(PlaceTagViewController *)cell didSelectedPlaceTag:(BMKPoiInfo *)poiInfo{
    if (placeTagLabel) {
        placeTagLabel.text = poiInfo.name;
        self.currentPoi = poiInfo;
        
        CGFloat wid = [placeTagLabel.text stringSize:placeTagLabel.font].width;
        if (wid > placeTagLabel.width) {
            placeTagLabel.textAlignment = NSTextAlignmentLeft;
        }
        else{
            placeTagLabel.textAlignment = NSTextAlignmentRight;
        }
    }
}

#pragma mark - action such as: click touch tap slip ...

- (void)clickLeftBackButtonItem{
    UIViewController * vc2 = [((AppController *)APPLICATION) getVisibleViewController];
    [vc2 dismissViewControllerAnimated:YES completion:nil];
//    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpToPlaceTagViewController:(id)sender{
    PlaceTagViewController * vc = [[PlaceTagViewController alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)refresh{
    [self updateAddTitleButtonStatus];
    
    int cellWidth = (self.contentView.width-10*2-numInSection*10)/numInSection;
    cellWidth = PictureItemHeight+Space;
    uiThumbColl.frame = CGRectMake(uiThumbColl.x, uiThumbColl.y, uiThumbColl.width, (thumbs.count/numInSection+1)*(cellWidth));
    
    pictureBoardView.frame = CGRectMake(pictureBoardView.x, pictureBoardView.y, pictureBoardView.width, uiThumbColl.height+Space/2);
    
    placeTagBackView.frame = CGRectMake(placeTagBackView.x, uiTagView.y+uiTagView.height, placeTagBackView.width, placeTagBackView.height);
    
    section_tags.frame = CGRectMake(section_tags.x, pictureBoardView.y+pictureBoardView.height+5, section_tags.width, placeTagBackView.y+placeTagBackView.height);
    
    mainSection.frame = CGRectMake(mainSection.x, mainSection.y, mainSection.width, section_tags.y+section_tags.height);
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width, uiThumbColl.y+uiThumbColl.height+20);
}

#pragma mark - init & dealloc

- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    if (!urls) {
        urls = [[NSMutableArray alloc] init];
    }
    [urls removeAllObjects];
    if (!thumbs) {
        thumbs = [[NSMutableArray alloc] init];
    }
    [thumbs removeAllObjects];
    
    numInSection = NumInSection;
    postImgLimit = MaxPhotosCount;
    postTextLimit = 1200;
    
    CGFloat top = 0;
    mainSection = [UIView view_sub:@{V_Parent_View:self.contentView,
                                     V_Margin_Top:strFloat(top),
                                     V_Height:strFloat(300),
                                     V_Border_Color:k_defaultLineColor,
                                     V_Border_Width:@0.5,
                                     V_BGColor:white_color,
                                     }];
    [self.contentView addSubview:mainSection];
    
    top = Space;
    uiPostView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(top, top/2, mainSection.width-2*top, 100)];
    uiPostView.backgroundColor = [UIColor clearColor];
    [uiPostView setFont:[UIFont fontWithName:k_fontName_FZXY size:17]];
    uiPostView.delegate = self;
    uiPostView.textColor = k_defaultTextColor;
    uiPostView.placeholder = @"发表内容";
    [mainSection addSubview:uiPostView];
    [uiPostView release];
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"1200字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:12];
    maxLabel.textColor = k_defaultTextColor;
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(uiPostView.frame) - maxLabelSize.width, CGRectGetHeight(uiPostView.frame) - maxLabelSize.height, maxLabelSize.width, maxLabelSize.height);
    [mainSection addSubview:maxLabel];
    [maxLabel release];
    
    pictureBoardView = [UIView scrollView:@{V_Parent_View:mainSection,
                                            V_Last_View:uiPostView,
                                            V_Margin_Top:strFloat(top),
                                            V_Height:strFloat(PictureItemHeight+2*Space),
                                            }];
    [mainSection addSubview:pictureBoardView];
    
    UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    uiThumbColl = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, pictureBoardView.width, PictureItemHeight+2*Space) collectionViewLayout:flowLayout];
    [uiThumbColl setBackgroundColor:[UIColor color:clear_color]];
    uiThumbColl.dataSource = self;
    uiThumbColl.delegate = self;
    [uiThumbColl registerClass:[PostThumbCell class] forCellWithReuseIdentifier:@"PostThumbCell"];
    [pictureBoardView addSubview:uiThumbColl];
    [uiThumbColl release];
    
    
    section_tags = [UIView view_sub:@{V_Parent_View:mainSection,
                                      V_Last_View:pictureBoardView,
                                      V_Margin_Top:strFloat(top),
                                      V_Height:strFloat(100),
                                      }];
    [mainSection addSubview:section_tags];
    [self loadStarViewTo:section_tags];
    
    mainSection.frame = CGRectMake(mainSection.x, mainSection.y, mainSection.width, section_tags.y+section_tags.height);
}

- (void)loadStarViewTo:(UIView *)view{
    CGFloat lineHeight = 50;
    CGFloat x = Space;
    
    UIView * lab1 = [UIView view_sub:@{V_Parent_View:view,
                                       V_Margin_Left:strFloat(x),
                                       V_Height:@0.5,
                                       V_BGColor:k_defaultLineColor,
                                       }];
    [view addSubview:lab1];
    
    uiTagView = [[PostTagView alloc] initWithFrame:CGRectMake(0, 0, view.width, lineHeight)];
    uiTagView.tagHeight = 30;
    [uiTagView start:self :@"标签描述" :[UIColor color:k_defaultLineColor]];
    [view addSubview:uiTagView];
    
    placeTagBackView = [UIView control:@{V_Parent_View:view,
                                     V_Last_View:lab1,
                                     V_Height:strFloat(lineHeight),
                                     V_Delegate:self,
                                     V_SEL:selStr(@selector(jumpToPlaceTagViewController:))
                                     }];
    [view addSubview:placeTagBackView];
    
    lab1 = [UIView view_sub:@{V_Parent_View:placeTagBackView,
                              V_Margin_Left:strFloat(x),
                              V_Height:@0.5,
                              V_BGColor:k_defaultLineColor,
                              }];
    [placeTagBackView addSubview:lab1];
    
    UIImageView * imgv = [UIView imageView:@{V_Parent_View:placeTagBackView,
                                             V_Margin_Right:strFloat(x),
                                             V_Width:@10,
                                             V_Over_Flow_X:num(OverFlowRight),
                                             V_Img:@"buddystatus_arrow",
                                             V_ContentMode:num(ModeAspectFit),
                                             }];
    [placeTagBackView addSubview:imgv];
    
    NSString * text = @"位置：";
    CGFloat wid = [text stringSize:[UIFont fontWithName:k_defaultFontName size:14]].width+5;
    UILabel * placeTag = [UIView label:@{V_Parent_View:placeTagBackView,
                                         V_Margin_Left:strFloat(x+5),
                                         V_Text:text,
                                         V_Width:strFloat(wid),
                                         V_Color:k_defaultLightTextColor,
                                         V_Font_Family:k_defaultFontName,
                                         V_Font_Size:@14,
                                         }];
    [placeTagBackView addSubview:placeTag];
    
    placeTagLabel = [UIView label:@{V_Parent_View:placeTagBackView,
                                    V_Left_View:placeTag,
                                    V_Right_View:imgv,
                                    V_Margin_Right:@5,
                                    V_Color:k_defaultTextColor,
                                    V_Font_Family:k_defaultFontName,
                                    V_Font_Size:@14,
                                    V_TextAlign:num(TextAlignRight),
                                    V_NumberLines:@2,
                                    }];
    [placeTagBackView addSubview:placeTagLabel];
    
    placeTagBackView.frame = CGRectMake(placeTagBackView.x, placeTagBackView.y, placeTagBackView.width, placeTag.y+placeTag.height);
    view.frame = CGRectMake(view.x, view.y, view.width, placeTagBackView.y+placeTagBackView.height);
}

- (void)updateAddTitleButtonStatus{
    if (!addTitleButton) {
        addTitleButton = [UIView button:@{V_Parent_View:uiThumbColl,
                                          V_Frame:rectStr(PictureItemWidth+Space, 0, 80, uiThumbColl.height),
                                          V_Title:@"添加图片",
                                          V_Color:k_defaultLightTextColor,
                                          V_Font_Size:@16,
                                          V_Font_Family:k_fontName_FZZY,
                                          V_Tag:@90,
                                          V_Delegate:self,
                                          V_SEL:selStr(@selector(PTHCDadd)),
                                          }];
        [uiThumbColl addSubview:addTitleButton];
    }
    
    if (thumbs.count <= 0) {
        addTitleButton.hidden = NO;
    }
    else{
        addTitleButton.hidden = YES;
    }
}

#pragma mark -
#pragma mark ---UICollectionViewDataSource delegate---

//定义展示的Section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long left = thumbs.count-section*numInSection +1;
    return left>numInSection?numInSection:left;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return thumbs.count/numInSection + 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PostThumbCell";
    PostThumbCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSInteger c = indexPath.section*numInSection+indexPath.row;
    if( c == thumbs.count ){
        [cell startBtn:self :indexPath];
    }else{
        [cell startImg:[thumbs objectAtExistIndex:(c)] :indexPath];
    }
    
    if (c == MaxPhotosCount) {
        cell.hidden = YES;
    }
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(PictureItemWidth+Space/2, PictureItemHeight+Space/2);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(Space/2, Space/2, 0, Space/2);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark -
#pragma mark ---UICollectionViewDelegate delegate---
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -
#pragma mark ---PostThumbCellDelegate delegate---

- (void)PTHCDadd {
    if( thumbs.count>=postImgLimit ){
        return;
    }
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if( cameraAvailable && photoAvailable ) {
        InfoLog(@"支持拍照和相片库");
        [self showLoginSheet];
    } else if( cameraAvailable ) {
        InfoLog(@"仅支持拍照");
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor clearColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    } else if( photoAvailable ) {
        InfoLog(@"仅支持相片库");
        [self selectPhotosFromLib];
    } else {
        InfoLog(@"都不支持");
    }
}

- (void)showLoginSheet {
    [uiPostView resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)PTHCDdelete:(NSIndexPath*)indexPath {
    [thumbs removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [urls removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [uiThumbColl reloadData];
    [self refresh];
}

#pragma mark -
#pragma mark ---PostTagViewDelegate delegate---

- (void)PTVDreload {
    [self refresh];
}


#pragma mark -
#pragma mark ---UIActionSheetDelegate delegate---

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: {
            InfoLog(@"从相册选取");
            [self selectPhotosFromLib];
            break;
        }
        case 1: {
            InfoLog(@"拍照");
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.view.backgroundColor = [UIColor clearColor];
            UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
            picker.sourceType = sourcheType;
            picker.delegate = self;
            picker.allowsEditing = NO;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
    }
}

- (void)selectPhotosFromLib
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = postImgLimit - urls.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
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
        int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
        int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
        UIImage *thumb = [UIImage scaleAndRotateImage:tempImg andMinImageWidth:cellWidth];
        [thumbs addObject:thumb];
        [urls addObject:asset.defaultRepresentation.url];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [uiThumbColl reloadData];
    });
}


-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
}

#pragma mark -
#pragma mark ---UIImagePickerController delegate---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage] ) {
        if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            //获取照片的原图
            UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
            //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:original.CGImage orientation:(ALAssetOrientation)[original imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
                [urls addObject:assetURL];
            }];
            
            int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
            int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
            UIImage *thumb = [UIImage scaleAndRotateImage:original andMinImageWidth:cellWidth];
            [thumbs addObject:thumb];
            [uiThumbColl reloadData];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark ---UITextFieldDelegate delegate---

//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

//将要结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    return;
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self refresh];
    return;
}

//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    InfoLog(@"test --------- %lu , %lu , %@, %lu",(unsigned long)range.length,(unsigned long)range.location,string,string.length);
    if( text.length < 1 ){//删除
        return YES;
    }
    if( text.length > 1 ){//粘贴多字
        if( textView.text.length>postTextLimit ){//之前已有文字
            return NO;
        }else{//之前没有文字
            return YES;
        }
    }
    //string.length == 1
    if( textView.text.length>postTextLimit ){//超限
        return NO;
    }else{//之前没有文字
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        return YES;
    }
}

- (void)post{
    if ([NSString isEmptyString:uiPostView.text] && urls.count <= 0) {
        [self showMessageView:@"请填写内容或者至少添加一张图片!"  delayTime:3.0];
        return;
    }
    if (placeTagLabel.text.length == 0) {
        [self showMessageView:@"请选择位置信息!"  delayTime:3.0];
        return;
    }
    
    [[LoadingView shared] setIsFullScreen:YES];
    [[LoadingView shared] showLoading:nil message:@"努力发布中..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userid = [UserManager sharedInstance].brief.userid;
        // 设置参数数据
        NSArray *tagsArr = uiTagView.tags;
        NSString *tagsStr = [tagsArr componentsJoinedByString:@","];
        
        NSDictionary * params = @{@"content":uiPostView.text,
                                  @"tags":tagsStr,
                                  @"place":self.currentPoi.address,
                                  @"lat": [NSString stringWithFormat:@"%f", self.currentPoi.pt.latitude],
                                  @"lng": [NSString stringWithFormat:@"%f", self.currentPoi.pt.longitude]
                                  };
        NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                                @"ver":[Device appBundleShortVersion],
                                @"params":params,
                                };
        
        NSDictionary * d = nil;
        
        if (urls.count > 0) {
            // 获取出来图片
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:urls.count];
            // NSMutableArray *imagesName = [NSMutableArray arrayWithCapacity:urls.count];
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                for (NSURL *url in urls) {
                    [library assetForURL:url resultBlock:^(ALAsset *asset) {
                        // 使用asset来获取本地图片
                        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                        CGImageRef imgRef = [assetRep fullResolutionImage];
                        UIImage *image = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
                        image = [UIImage scaleAndRotateImage:image andMaxImageHeight:800];
                        [images addObject:image];
                        // [imagesName addObject:url.absoluteString]; // assets-library://asset/asset.JPG?id=D1AFC86A-59D3-4BA0-8C43-06064A57DFF0&ext=JPG
                        if (images.count == urls.count) {
                            dispatch_semaphore_signal(sema);
                        }
                    } failureBlock:^(NSError *error) {
                        InfoLog(@"获取图片失败");
                        dispatch_semaphore_signal(sema);
                    }];
                }
            });
            
            // 使用信号量控制,获取所有的图片
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            d = @{k_r_url:k_api_feed_post,
                  k_r_reqApiType:num(AFReqApi),
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_attchData:images,
                  k_r_loading:num(0),
                  };
        } else {
            d = @{k_r_url:k_api_feed_post,
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_loading:num(0),
                  };
        }
        
        [[ReqEngine shared] tryRequest:d];
    });
}

#pragma mark - 网络请求处理
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_post]) {
        [MessageView showMessageView:@"发表成功" delayTime:2.0];
        [[Cache shared] setNeedRefreshData:2 value:1];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        [[LoadingView shared] hideLoading];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_feed_post]) {
        [[LoadingView shared] hideLoading];
    }
}

- (void)baseNavBack
{
    [self hideTabBar:NO animation:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    if (urls) {
        [urls release];
        urls = nil;
    }
    if (thumbs) {
        [thumbs release];
        thumbs = nil;
    }
    [super dealloc];
}
@end
