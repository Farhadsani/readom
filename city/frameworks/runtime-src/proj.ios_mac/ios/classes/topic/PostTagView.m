#import "PostTagView.h"
#import "LoggerClient.h"
#import "CWDLeftAlignedCollectionViewFlowLayout.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation PostTagView

@synthesize tags,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect mainFrame = self.frame;
        mainFrame.origin = CGPointMake(0, 0);
        mainFrame.size = CGSizeMake(mainFrame.size.width,mainFrame.size.height);
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        uiTagLabels = [[NSMutableArray alloc] init];
        tags = [[NSMutableArray alloc] init];
        postTagLimit = 5;
        
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        
        CGRect tagBgFrame = CGRectMake(10, 10, mainFrame.size.width-20, mainFrame.size.height-20);
        uiTagBg = [[UIImageView alloc] initWithFrame:tagBgFrame];
        uiTagBg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        uiTagBg.layer.cornerRadius = 5;
        uiTagBg.layer.masksToBounds = YES;
        [uiTagBg setUserInteractionEnabled:YES];
        [uiTagBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        uiTagBg.layer.borderColor = [UIColor color:green_color].CGColor;
        uiTagBg.layer.borderWidth = 0.5;
        
        CGRect tagFieldFrame = CGRectMake(0, 0, (mainFrame.size.width-40)/4, 30);
        uiTagField = [[UITextField alloc] initWithFrame:tagFieldFrame];
        uiTagField.backgroundColor = [UIColor redColor];
        uiTagField.backgroundColor = [UIColor clearColor];
        [uiTagField setFont:[UIFont fontWithName:k_fontName_FZXY size:14]];
        uiTagField.returnKeyType = UIReturnKeyDefault;
        uiTagField.delegate = self;
        
        CWDLeftAlignedCollectionViewFlowLayout *flowLayout=[[CWDLeftAlignedCollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        uiTagColl = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 20, mainFrame.size.width-40, 100) collectionViewLayout:flowLayout];
        [uiTagColl setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [uiTagColl setBackgroundColor:[UIColor blueColor]];
        [uiTagColl setBackgroundColor:[UIColor clearColor]];
        uiTagColl.dataSource = self;
        uiTagColl.delegate = self;
        [uiTagColl registerClass:[PostTagCell class] forCellWithReuseIdentifier:@"PostTagCell"];
//        [uiTagColl setUserInteractionEnabled:YES];
//        [uiTagColl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        
        [self addSubview:uiTagBg];
        [self addSubview:uiTagColl];
        [self registerForKeyboardNotifications];
    }
    return self;
}

-(void)start:(id<PostTagViewDelegate>)pDelegate :(NSString *)placeholder :(UIColor*)pColor
{
    self.delegate = pDelegate;
    uiTagField.placeholder = placeholder;
    uiTagColor = pColor;
}

-(void)click:(id)sender
{
    [uiTagField becomeFirstResponder];
}

-(void)addTag:(NSString*)pTag
{
    [uiTagField setText:@""];
    if( tags.count >= postTagLimit ){
        return;
    }
    NSString *tTag = [NSString stringWithFormat:@"%@ x ",pTag];
    Log(@" refresh add %@",pTag);
    
    UILabel *uiText  = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,30)];
    [uiText setTextColor:UIColorFromRGB(0xa4866c, 1.0f)];
    [uiText setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [uiText setBackgroundColor:[UIColor clearColor]];
    [uiText setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [uiText setNumberOfLines:1];
    [uiText setTextAlignment:NSTextAlignmentCenter];
    [uiText setLineBreakMode:NSLineBreakByWordWrapping];
    uiText.layer.masksToBounds = YES;
    uiText.layer.cornerRadius = 3;
    uiText.layer.borderWidth = 0.5;
    uiText.layer.borderColor = [UIColor color:green_color].CGColor;
    
    uiText.text = tTag;
    //设置一个行高上限
    CGSize textMaxSize = CGSizeMake(300,30);
    NSDictionary *textAttribute = @{NSFontAttributeName: uiText.font};
    CGSize textLabelsize = [uiText.text boundingRectWithSize:textMaxSize options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttribute context:nil].size;
    uiText.frame = CGRectMake(0,0,textLabelsize.width+5,textLabelsize.height+5);
    
    [tags addObject:pTag];
    [uiTagLabels addObject:uiText];
    [self refresh];
    [uiTagField becomeFirstResponder];
}

-(void)refresh {
    [uiTagColl reloadData];
    
    CGRect mainFrame = self.frame;
    
    CGRect tagCollFrame = CGRectMake(20, 20, mainFrame.size.width-40, uiTagColl.collectionViewLayout.collectionViewContentSize.height);
    uiTagColl.frame = tagCollFrame;
    
    CGRect tagBgFrame = CGRectMake(10, 10, mainFrame.size.width-20, tagCollFrame.origin.y+tagCollFrame.size.height+10);
    uiTagBg.frame = tagBgFrame;
    
    mainFrame.size.height = tagBgFrame.origin.y+tagBgFrame.size.height;
    self.frame = mainFrame;
    
    if( delegate != nil ){
        [delegate PTVDreload];
    }
}

#pragma mark -
#pragma mark ---UITextFieldDelegate delegate---

//控制当前输入框是否能被编辑
- ( BOOL )textFieldShouldBeginEditing:( UITextField *)textField {
    return YES;
}

//当输入框开始时触发 ( 获得焦点触发 )
- ( void )textFieldDidBeginEditing:(UITextField*)textField {
    return;
}

//询问输入框是否可以结束编辑 ( 键盘是否可以收回)
- ( BOOL )textFieldShouldEndEditing:(UITextField*)textField {
    return YES;
}

//当前输入框结束编辑时触发 ( 键盘收回之后触发 )
- ( void )textFieldDidEndEditing:( UITextField *)textField {
    if( textField.text.length > 0 ){
        [self addTag:textField.text];
    }
    return;
}

//当输入框文字发生变化时触发 ( 只有通过键盘输入时 , 文字改变 , 触发 )
- ( BOOL )textField:( UITextField  *)textField shouldChangeCharactersInRange:( NSRange )range replacementString:( NSString  *)string {
//    Log(@"test --------- %lu , %lu , %@, %lu",(unsigned long)range.length,(unsigned long)range.location,string,string.length);
    if( string.length < 1 ){//删除
        return YES;
    }
//    if( string.length > 1 ){//粘贴多字
//        return NO;
//    }
    //string.length == 1
    if( [string isEqualToString:@" "]  || [string isEqualToString:@","]){//分隔符
        if( textField.text.length>0 ){//之前已有文字
            [self addTag:textField.text];
            return NO;
        }else{//之前没有文字
            return NO;
        }
    }else {//非分隔符
        if( textField.text.length>10 ){//超限
            return NO;
        }else{//之前没有文字
            return YES;
        }
    }
}

//控制输入框清除按钮是否有效 (yes, 有 ;no, 没有)
- ( BOOL )textFieldShouldClear:(UITextField*)textField {
    return YES;
}

//控制键盘是否回收
- ( BOOL )textFieldShouldReturn:(UITextField*)textField {
    if( textField.text.length > 0 ){
        [self addTag:textField.text];
    }
    return YES;
}

- (void) registerForKeyboardNotifications{
    AddObserver(keyboardWillShow:, UIKeyboardDidShowNotification);
    AddObserver(keyboardWillHide:, UIKeyboardDidHideNotification);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    return;
}

- (void) keyboardWillHide:(NSNotification *)notification {
    return;
}

#pragma mark -
#pragma mark ---UICollectionViewDataSource delegate---

//定义展示的Section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if( tags.count==0 || section == 1 ){
//        return 1;
//    }else{
//        return tags.count;
//    }
    return tags.count+1;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return tags.count>0?2:1;
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PostTagCell";
    PostTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //    if( tags.count==0 || indexPath.section == 1 ){
    //        [cell startField:uiTagField];
    //    }else{
    //        [cell startLabel:[tags objectAtExistIndex:indexPath.row]];
    //    }
    if( indexPath.row == tags.count ){
        [cell startField:uiTagField];
    }else{
        [cell startLabel:self :indexPath :[tags objectAtExistIndex:indexPath.row] :uiTagColor];
    }
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if( tags.count==0 || indexPath.section == 1 ){
//        return CGSizeMake(uiTagField.frame.size.width, uiTagField.frame.size.height);
//    }
    if( indexPath.row == tags.count ){
        return CGSizeMake(uiTagField.frame.size.width, uiTagField.frame.size.height);
    }
    UILabel *one = [uiTagLabels objectAtExistIndex:indexPath.row];
    return CGSizeMake(one.frame.size.width, one.frame.size.height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
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
#pragma mark ---PostTagCellDelegate delegate---

- (void)PTGCDdelete:(NSIndexPath*)indexPath {
    [uiTagLabels removeObjectAtIndex:indexPath.row];
    [tags removeObjectAtIndex:indexPath.row];
    [self refresh];
}

@end
