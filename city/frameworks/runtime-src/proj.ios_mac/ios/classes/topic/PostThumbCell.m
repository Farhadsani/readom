/*
 *[发表]中添加图片的控件
 *
 */
#import "PostThumbCell.h"

@implementation PostThumbCell

@synthesize uiImgView,uiDeleteBtn,uiAddPhotoBtn;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setBackgroundColor:[UIColor yellowColor]];
        self.uiImgView = [[UIImageView alloc]init];
        self.uiImgView.backgroundColor = [UIColor clearColor];
        self.uiImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.uiImgView.layer.cornerRadius = 4;
        self.uiImgView.layer.masksToBounds = YES;
        self.uiImgView.layer.borderWidth = 2.0;
        self.uiImgView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.uiImgView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDelete:)];
        [self.uiImgView addGestureRecognizer:deleteTap];
        
        uiAddPhotoBtn = [[UIButton alloc] init];
        [uiAddPhotoBtn setUserInteractionEnabled:YES];
        [uiAddPhotoBtn addTarget:self action:@selector(doAdd:) forControlEvents:UIControlEventTouchUpInside];
        [uiAddPhotoBtn setBackgroundColor:[UIColor clearColor]];
        [uiAddPhotoBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:24]];
        [uiAddPhotoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [uiAddPhotoBtn setTitle:@"+" forState:UIControlStateNormal];
        uiAddPhotoBtn.layer.cornerRadius = 4;
        uiAddPhotoBtn.layer.masksToBounds = YES;
        uiAddPhotoBtn.layer.borderWidth = 1.0;
        uiAddPhotoBtn.layer.borderColor = [UIColor grayColor].CGColor;
        
        [self addSubview:self.uiAddPhotoBtn];
        [self addSubview:self.uiImgView];
//        [self addSubview:self.uiDeleteBtn];
    }
    return self;
}

-(void)startImg:(UIImage*)pImg :(NSIndexPath*)pIndexPath {
    self.indexPath = pIndexPath;
    CGRect mainFrame = self.frame;
    self.uiImgView.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    //    self.uiDeleteBtn.frame = CGRectMake(mainFrame.size.width-15, 5, 10, 10);
    self.uiAddPhotoBtn.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    
    self.uiImgView.hidden = NO;
    self.uiDeleteBtn.hidden = NO;
    self.uiAddPhotoBtn.hidden = YES;
    [self.uiImgView setImage:pImg];
}

-(void)startBtn:(id<PostThumbCellDelegate>)pDelegate :(NSIndexPath*)pIndexPath {
    self.delegate = pDelegate;
    self.indexPath = pIndexPath;
    CGRect mainFrame = self.frame;
    self.uiImgView.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    self.uiAddPhotoBtn.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    
    self.uiImgView.hidden = YES;
    self.uiDeleteBtn.hidden = YES;
    self.uiAddPhotoBtn.hidden = NO;
}

-(void)doAdd:(id)sender {
    if( self.delegate != nil ){
        [delegate PTHCDadd];
    }
}

-(void)doDelete:(id)sender {
    if( self.delegate != nil ){
        [delegate PTHCDdelete:_indexPath];
    }
}
@end
