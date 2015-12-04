//
//  OrderCommentViewController.m
//  citystate
//
//  Created by hf on 15/10/15.
//
//

#import "OrderCommentViewController.h"
#import "BRPlaceholderTextView.h"

#define MaxPhotosCount 9    //图片限制
#define NumInSection 4      //一排有几个图片
#define Space 10
#define PictureItemWidth ((kScreenWidth - (NumInSection+1)*Space) / NumInSection) //一张图片所占位置的大小
#define PictureItemHeight PictureItemWidth

@interface OrderCommentViewController (){
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
@property (nonatomic, retain) RatingView * starView;

@end

@implementation OrderCommentViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要点评";
    [self setupRightBackButtonItem:@"发表" img:nil del:self sel:@selector(postOrderComment)];
    [self setupMainView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [uiThumbColl reloadData];
    [self refresh];
}

#pragma mark - delegate (CallBack)
#pragma mark RatingViewDelegate
- (void)RatingView:(RatingView *)view ratingChanged:(float)newRating{
    
}

#pragma mark request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_comment]) {
        [[LoadingView shared] hideLoading];
        if (self.delegate && [self.delegate respondsToSelector:@selector(OrderCommentViewController:data:)]) {
            self.orderIntro.commented = YES;
            self.orderIntro.rated = YES;
            [self.delegate OrderCommentViewController:self data:self.orderIntro];
        }
        [self showMessageView:@"评论成功" delayTime:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_comment]) {
        [[LoadingView shared] hideLoading];
    }
}

#pragma mark - action such as: click touch tap slip ...

- (void)postOrderComment{
    InfoLog(@"");
    if ([NSString isEmptyString:uiPostView.text]) {
        [self showMessageView:@"请填写评论内容!"  delayTime:3.0];
        return;
    }
    
    [[LoadingView shared] setIsFullScreen:YES];
    [[LoadingView shared] showLoading:nil message:@"努力发布中..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 设置参数数据
        NSDictionary * params = @{@"orderid":@(self.orderIntro.orderid),
                                  @"storeid":@(self.orderIntro.storeid),
                                  @"rate":strFloat(_starView.rating),
                                  @"comment":uiPostView.text,
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
            
            d = @{k_r_url:k_api_order_comment,
                  k_r_reqApiType:num(AFReqApi),
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_attchData:images,
                  k_r_loading:num(0),
                  };
        }
        else{
            d = @{k_r_url:k_api_order_comment,
                  k_r_delegate:self,
                  k_r_postData:dict,
                  k_r_loading:num(0),
                  };
        }
        
        [[ReqEngine shared] tryRequest:d];
    });
}

- (void)refresh{
    [self updateAddTitleButtonStatus];
//    uiPostView.placeholder = @"请发表点评，您的评价将成为其他用户的重要参考";
    
    int cellWidth = (self.contentView.width-10*2-numInSection*10)/numInSection;
    cellWidth = PictureItemHeight+Space;
    uiThumbColl.frame = CGRectMake(uiThumbColl.x, uiThumbColl.y, uiThumbColl.width, (thumbs.count/numInSection+1)*(cellWidth));
    
    pictureBoardView.frame = CGRectMake(pictureBoardView.x, pictureBoardView.y, pictureBoardView.width, uiThumbColl.height+Space/2);
    
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
    postTextLimit = 200;
    
    CGFloat top = Space;
    
    UIView * section_1 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Margin_Top:strFloat(top),
                                            V_Height:strFloat(90),
                                            V_Border_Color:k_defaultLineColor,
                                            V_Border_Width:@0.5,
                                            V_BGColor:white_color,
                                            }];
    [self.contentView addSubview:section_1];
    [self loadStarViewTo:section_1];
    
    UIView * section_2 = [UIView view_sub:@{V_Parent_View:self.contentView,
                                            V_Last_View:section_1,
                                            V_Margin_Top:strFloat(top),
                                            V_Height:strFloat(100),
                                            V_Border_Color:k_defaultLineColor,
                                            V_Border_Width:@0.5,
                                            V_BGColor:white_color,
                                            }];
    [self.contentView addSubview:section_2];
    uiPostView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(top, top/2, section_2.width-2*top, section_2.height-top)];
    uiPostView.backgroundColor = [UIColor clearColor];
    uiPostView.returnKeyType = UIReturnKeyDone;
    [uiPostView setFont:[UIFont fontWithName:k_fontName_FZXY size:17]];
    uiPostView.delegate = self;
    uiPostView.textColor = k_defaultTextColor;
    uiPostView.placeholder = @"请发表点评，您的评价将成为其他用户的重要参考";
    [section_2 addSubview:uiPostView];
    [uiPostView release];
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = @"120字以内";
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:12];
    maxLabel.textColor = k_defaultTextColor;
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabel.frame = CGRectMake(CGRectGetWidth(uiPostView.frame) - maxLabelSize.width, CGRectGetHeight(uiPostView.frame) - maxLabelSize.height, maxLabelSize.width, maxLabelSize.height);
    [section_2 addSubview:maxLabel];
    [maxLabel release];
    
    pictureBoardView = [UIView scrollView:@{V_Parent_View:self.contentView,
                                            V_Last_View:section_2,
                                            V_Margin_Top:strFloat(top),
                                            V_Height:strFloat(PictureItemHeight+2*Space),
                                            V_Border_Color:k_defaultLineColor,
                                            V_Border_Width:@0.5,
                                            V_BGColor:white_color,
                                            }];
    [self.contentView addSubview:pictureBoardView];
    
    UICollectionViewFlowLayout *flowLayout=[[[UICollectionViewFlowLayout alloc] init] autorelease];
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    uiThumbColl = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, pictureBoardView.width, PictureItemHeight+2*Space) collectionViewLayout:flowLayout];
//    [uiThumbColl setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [uiThumbColl setBackgroundColor:[UIColor color:clear_color]];
    uiThumbColl.dataSource = self;
    uiThumbColl.delegate = self;
    [uiThumbColl registerClass:[PostThumbCell class] forCellWithReuseIdentifier:@"PostThumbCell"];
    [pictureBoardView addSubview:uiThumbColl];
    [uiThumbColl release];
}

- (void)loadStarViewTo:(UIView *)view{
    CGFloat AStarWidth = 26;
    CGFloat space = (view.width - AStarWidth*5)/6;
    CGFloat starHeight = 30;
    CGFloat textHeight = 30;
    CGFloat top = (view.height - starHeight - textHeight)/2.0;
    
    self.starView = [[[RatingView alloc] initWithFrame:CGRectMake(space, top, AStarWidth*5+space*4, starHeight)] autorelease];
    _starView.userInteractionEnabled = YES;
    _starView.space_width = space;
    _starView.star_height = 26;
    _starView.star_width = AStarWidth;
    _starView.starMode = UIViewContentModeLeft;
    [_starView setImagesDeselected:@"star_comment_unselected" partlySelected:@"star_comment_halfSelected" fullSelected:@"star_comment_selected" andDelegate:self];
    [_starView displayRating:0];
    [view addSubview:_starView];
    
    NSArray * texts = @[@"差评",@"一般",@"满意",@"推荐",@"大赞",];
    CGFloat textWidth = 40;
    for (int i = 0; i < 5; ++i) {
        UIImageView * star = [_starView.subviews objectAtExistIndex:i];
        if (star && [star isKindOfClass:[UIImageView class]]) {
            [view addSubview:[UIView label:@{V_Parent_View:view,
                                             V_Last_View:_starView,
                                             V_Margin_Left:strFloat(space+star.x-3),
                                             V_Width:strFloat(textWidth),
                                             V_Height:strFloat(textHeight),
                                             V_Text:[texts objectAtIndex:i],
                                             V_Color:k_defaultLightTextColor,
                                             V_Font_Size:@15,
                                             V_Font_Family:k_defaultFontName,
                                             V_TextAlign:num(TextAlignLeft),
                                             }]];
        }
    }
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

#pragma mark - other method
#pragma mark
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
        [self showMessageView:@"您选择的图片已达上限" delayTime:3.0];
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark ---PostTagViewDelegate delegate---

- (void)PTHCDdelete:(NSIndexPath*)indexPath {
    [thumbs removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [urls removeObjectAtIndex:(indexPath.section*numInSection+indexPath.row)];
    [uiThumbColl reloadData];
    [self refresh];
}

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

- (void)selectPhotosFromLib{
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
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
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

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    InfoLog(@"到达上限");
    [self showMessageView:@"您选择的图片已达上限" delayTime:3.0];
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

@end
