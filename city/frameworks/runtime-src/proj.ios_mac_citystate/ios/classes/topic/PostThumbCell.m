/*
 *[发表]中添加图片的控件
 *
 */
#import "PostThumbCell.h"

@interface PostThumbCell ()
@property (nonatomic, weak) UIImageView *deleteIv;
@end

@implementation PostThumbCell

@synthesize uiImgView,uiAddPhotoBtn;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.uiImgView = [[UIImageView alloc]init];
        self.uiImgView.backgroundColor = [UIColor clearColor];
        self.uiImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.uiImgView.layer.cornerRadius = 12;
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
        [uiAddPhotoBtn.titleLabel setFont:[UIFont fontWithName:k_fontName_FZZY size:28]];
        [uiAddPhotoBtn setTitleColor:[UIColor color:k_defaultLightTextColor] forState:UIControlStateNormal];
        [uiAddPhotoBtn setBackgroundImage:[UIImage imageNamed:@"addPicture"] forState:UIControlStateNormal];

        
        [self addSubview:self.uiAddPhotoBtn];
        [self addSubview:self.uiImgView];
        UIImageView *deleteIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shanchu"]];
        self.deleteIv = deleteIv;
        [self addSubview:deleteIv];
    }
    return self;
}

-(void)startImg:(UIImage*)pImg :(NSIndexPath*)pIndexPath {
    self.indexPath = pIndexPath;
    CGRect mainFrame = self.frame;
    self.uiImgView.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    self.deleteIv.frame = CGRectMake(mainFrame.size.width - self.deleteIv.width, 0, self.deleteIv.width, self.deleteIv.height);
    self.uiAddPhotoBtn.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    
    self.uiImgView.hidden = NO;
    self.deleteIv.hidden = NO;
    self.uiAddPhotoBtn.hidden = YES;
    [self.uiImgView setImage:pImg];
}

-(void)startBtn:(id<PostThumbCellDelegate>)pDelegate :(NSIndexPath*)pIndexPath {
    self.delegate = pDelegate;
    self.indexPath = pIndexPath;
    CGRect mainFrame = self.frame;
    self.uiImgView.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    self.deleteIv.frame = CGRectMake(mainFrame.size.width - self.deleteIv.width, 0, self.deleteIv.width, self.deleteIv.height);
    self.uiAddPhotoBtn.frame = CGRectMake(5, 5, mainFrame.size.width-10, mainFrame.size.height-10);
    
    self.uiImgView.hidden = YES;
    self.deleteIv.hidden = YES;
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
