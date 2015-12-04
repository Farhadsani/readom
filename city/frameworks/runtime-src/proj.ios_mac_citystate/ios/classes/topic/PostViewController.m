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

#define MaxPhotosCount 9

@implementation PostViewController
@synthesize note;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发表";
    [self setupLeftBackButtonItem:nil img:nil action:@selector(clickLeftBackButtonItem)];
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0f)];
    
    urls = [[NSMutableArray alloc] init];
    thumbs = [[NSMutableArray alloc] init];
    numInSection = 4;
    postImgLimit = 9;
    postTextLimit = 200;
    
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    mainFrame.origin = CGPointMake(0, 0);
    mainFrame.size = CGSizeMake(mainFrame.size.width,mainFrame.size.height);
    
    
    uiPostBg = [[UIImageView alloc] init];
    uiPostBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    uiPostBg.layer.cornerRadius = 5;
    uiPostBg.layer.masksToBounds = YES;
    uiPostBg.layer.borderColor = [UIColor color:green_color].CGColor;
    uiPostBg.layer.borderWidth = 0.5;
    
    uiPostView = [[UITextView alloc] init];
//    uiPostView.backgroundColor = [UIColor redColor];
    uiPostView.backgroundColor = [UIColor clearColor];
    uiPostView.returnKeyType = UIReturnKeyDone;
    [uiPostView setFont:[UIFont fontWithName:k_fontName_FZXY size:15]];
//    uiPostView.font = [UIFont systemFontOfSize:20];
    uiPostView.delegate = self;
    uiPostView.textColor = UIColorFromRGB(0xb29474, 1.0f);
    uiPostView.alpha = 50;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    uiThumbColl = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, mainFrame.size.width-20, 100) collectionViewLayout:flowLayout];
    [uiThumbColl setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [uiThumbColl setBackgroundColor:[UIColor clearColor]];
    uiThumbColl.dataSource = self;
    uiThumbColl.delegate = self;
    [uiThumbColl registerClass:[PostThumbCell class] forCellWithReuseIdentifier:@"PostThumbCell"];
    
    
    uiTagView = [[PostTagView alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.width/4)];
    [uiTagView start:self :@"标签" :UIColorFromRGB(0xb29474, 1.0f)];

    
    uiPlaceView = [[PostTagView alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.width/4)];
    [uiPlaceView start:self :@"位置标签" :UIColorFromRGB(0xb29474, 1.0f)];
    
    uiProgress = [[ASProgressPopUpView alloc] init];
    uiProgress.font = [UIFont fontWithName:k_fontName_FZXY size:14];
    uiProgress.popUpViewAnimatedColors = @[[UIColor orangeColor], [UIColor color:green_color]];
    uiProgress.popUpViewCornerRadius = 3.0;
    
    uiComplete  = [[UILabel alloc] init];
    [uiComplete setTextColor:UIColorFromRGB(0x93cd56, 1.0f)];
    [uiComplete setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [uiComplete setBackgroundColor:[UIColor clearColor]];
    [uiComplete setFont:[UIFont fontWithName:k_fontName_FZXY size:14]];
    [uiComplete setNumberOfLines:1];
    [uiComplete setTextAlignment:NSTextAlignmentLeft];
    uiComplete.text = @"完成度";
    
    uiPostBtn = [[UIButton alloc] init];
    [uiPostBtn setBackgroundColor:[UIColor color:green_color]];
    [uiPostBtn.titleLabel setFont:[UIFont fontWithName:k_fontName_FZZY size:16]];
    [uiPostBtn setTitle:@"发表" forState:UIControlStateNormal];
    uiPostBtn.contentMode = UIViewContentModeScaleAspectFill;
    uiPostBtn.clipsToBounds = YES;
    uiPostBtn.layer.cornerRadius = 2;
    uiPostBtn.layer.masksToBounds = YES;
    [uiPostBtn addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:uiPostBg];
    [self.contentView addSubview:uiPostView];
    [self.contentView addSubview:uiThumbColl];
    [self.contentView addSubview:uiTagView];
    [self.contentView addSubview:uiPlaceView];
    [self.contentView addSubview:uiProgress];
    [self.contentView addSubview:uiComplete];
    [self.contentView addSubview:uiPostBtn];
}

- (void)clickLeftBackButtonItem
{
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh
{
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGRect postBgFrame = CGRectMake(10, 10, mainFrame.size.width-20, mainFrame.size.width/3);
    uiPostBg.frame = postBgFrame;
    
    CGRect postViewFrame = CGRectMake(postBgFrame.origin.x+5, postBgFrame.origin.y+5, postBgFrame.size.width-10, postBgFrame.size.height-10);
    uiPostView.frame = postViewFrame;
    uiPostView.placeholder = [NSString stringWithFormat:@"#%@#",note.title];
    
    int cellWidth = ([[UIScreen mainScreen] applicationFrame].size.width-10*2-numInSection*10)/numInSection;
    CGRect thumbCollFrame = CGRectMake(10, postBgFrame.origin.y+postBgFrame.size.height+10, mainFrame.size.width-20, (thumbs.count/numInSection+1)*(cellWidth+10));
    
    uiThumbColl.frame = thumbCollFrame;
    
    CGRect tagViewFrame = CGRectMake(0, thumbCollFrame.origin.y+thumbCollFrame.size.height, uiTagView.frame.size.width, uiTagView.frame.size.height);
    uiTagView.frame = tagViewFrame;
    
    CGRect placeViewFrame = CGRectMake(0, tagViewFrame.origin.y+tagViewFrame.size.height, uiPlaceView.frame.size.width, uiPlaceView.frame.size.height);
    uiPlaceView.frame = placeViewFrame;
    
    float complete = 0;
    if(thumbs.count>0){
        complete+=0.5;
    }
    if(thumbs.count>1){
        complete+=0.2;
    }
    if(uiPostView.text.length>0){
        complete+=0.1;
    }
    if(uiTagView.tags.count>0){
        complete+=0.1;
    }
    if(uiPlaceView.tags.count>0){
        complete+=0.1;
    }
    
    CGRect completeFrame = CGRectMake(15, placeViewFrame.origin.y+placeViewFrame.size.height+20, 50, 30);
    uiComplete.frame = completeFrame;
    //    uiComplete.text = [NSString stringWithFormat:@"完整度:%d%%",(int)(complete*100)];
    
    CGRect progressFrame = CGRectMake(15+50, placeViewFrame.origin.y+placeViewFrame.size.height+40, mainFrame.size.width-80, 30);
    uiProgress.frame = progressFrame;
    uiProgress.progress = complete;
    [uiProgress showPopUpViewAnimated:YES];
    
    CGRect postBtnFrame = CGRectMake(30, progressFrame.origin.y+progressFrame.size.height+10, mainFrame.size.width-60, 35);
    uiPostBtn.frame = postBtnFrame;
    
    CGSize uiContainerSize = uiContainer.contentSize;
    CGFloat selfHeight = postBtnFrame.origin.y + postBtnFrame.size.height + 100;
    uiContainerSize.height = selfHeight>mainFrame.size.height?selfHeight:uiContainerSize.height;
    uiContainer.contentSize = uiContainerSize;
    [super viewDidAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [uiThumbColl reloadData];
    [self refresh];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark ---UICollectionViewDataSource delegate---

//定义展示的Section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long left = thumbs.count-section*numInSection+1;
    return left>numInSection?numInSection:left;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return thumbs.count/numInSection+1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PostThumbCell";
    PostThumbCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    if( indexPath.section*numInSection+indexPath.row == thumbs.count ){
        [cell startBtn:self :indexPath];
    }else{
        [cell startImg:[thumbs objectAtExistIndex:(indexPath.section*numInSection+indexPath.row)] :indexPath];
    }
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
    return CGSizeMake(cellWidth, cellWidth);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 10, 10);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark -
#pragma mark ---UICollectionViewDelegate delegate---

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}
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
        Log(@"支持拍照和相片库");
        [self showLoginSheet];
    } else if( cameraAvailable ) {
        Log(@"仅支持拍照");
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor clearColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    } else if( photoAvailable ) {
        Log(@"仅支持相片库");
        [self selectPhotosFromLib];
    } else {
        Log(@"都不支持");
    }
}

- (void)showLoginSheet {
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
            Log(@"从相册选取");
            [self selectPhotosFromLib];
            break;
        }
        case 1: {
            Log(@"拍照");
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
    picker.maximumNumberOfSelection = MaxPhotosCount - urls.count;
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
        int maxWidth = [[UIScreen mainScreen] applicationFrame].size.width;
        int cellWidth = (maxWidth-10*2-numInSection*10)/numInSection;
        UIImage *thumb = [self scaleAndRotateImage:tempImg andMinImageWidth:cellWidth];
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
            UIImage *thumb = [self scaleAndRotateImage:original andMinImageWidth:cellWidth];
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
    [self refresh];
    return;
}

//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    Log(@"test --------- %lu , %lu , %@, %lu",(unsigned long)range.length,(unsigned long)range.location,string,string.length);
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

-(void)post:(UIButton *)postBtn {
    if ([NSString isEmptyString:uiPostView.text] && urls.count <= 0) {
        [self showMessageView:@"请填写内容或者添加一张图片!"  delayTime:3.0];
        return;
    }
    
//    if (urls.count <= 0) {
//        [self showMessageView:@"请至少添加一张图片!"  delayTime:2.0];
//        return ;
//    }
    [[LoadingView shared] showLoading:nil message:@"正在上传数据..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 设置参数数据
        NSArray *tagsArr = uiTagView.tags;
        NSString *tagsStr = [tagsArr componentsJoinedByString:@","];
        
        NSArray *placesArr = uiPlaceView.tags;
        NSString *placesStr = [placesArr componentsJoinedByString:@","];
        NSDictionary * params = @{@"topicid":strLong(self.note.topicid),
                                  @"note":uiPostView.text,
                                  @"tags":tagsStr,
                                  @"place":placesStr,
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
                        image = [self scaleAndRotateImage:image andMaxImageHeight:800];
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
            
            d = @{k_r_url:k_api_note_post,
                  k_r_reqApiType:num(AFReqApi),
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_attchData:images,
                  k_r_loading:num(0),
                  k_r_clickView:postBtn,
                  };
        }
        else{
            d = @{k_r_url:k_api_note_post,
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_loading:num(0),
                  k_r_clickView:postBtn,
                  };
        }
        
        [[ReqEngine shared] tryRequest:d];
    });
}

#pragma mark - 网络请求处理
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_post]) {
        [MessageView showMessageView:@"发表成功" delayTime:2.0];
        [[Cache shared] setNeedRefreshData:2 value:1];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self baseNavBack];
//        });
        [[LoadingView shared] hideLoading];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_note_post]) {
        [[LoadingView shared] hideLoading];
    }
}

#pragma mark -
#pragma mark ---一些图形处理函数---

- (UIImage *)scaleAndRotateImage:(UIImage *)image andMinImageWidth:(int)scaleWidth{
    int kMaxResolution = scaleWidth; // 自定义宽度，根据比例裁剪图片
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    if( width<height ){
        bounds.size.width = kMaxResolution;
        bounds.size.height = kMaxResolution*height/width;
    }else{
        bounds.size.width = kMaxResolution*width/height;
        bounds.size.height = kMaxResolution;
    }
    return [self scaleToBounds:image :bounds];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image andMaxImageHeight:(int)scaleHeight{
    int kMaxResolution = scaleHeight; // 自定义高度，根据比例裁剪图片
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    return [self scaleToBounds:image :bounds];
}

- (UIImage *)scaleToBounds:(UIImage *)image :(CGRect)bounds {
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)baseNavBack
{
    [self hideTabBar:NO animation:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
