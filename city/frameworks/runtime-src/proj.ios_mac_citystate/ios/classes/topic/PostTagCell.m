#import "PostTagCell.h"

@implementation PostTagCell

@synthesize uiTagLabel,uiTagField,delegate,indexPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor yellowColor]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)startLabel:(id<PostTagCellDelegate>)pDelegate :(NSIndexPath*)pIndexPath :(NSString*)pTag :(UIColor*)pColor :(CGFloat)height{
    self.delegate = pDelegate;
    self.indexPath = pIndexPath;
    NSString *tTag = [NSString stringWithFormat:@"  %@",pTag];
    for( UIView* one in self.subviews ){
        [one removeFromSuperview];
    }
    uiTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, height)];
    [uiTagLabel setUserInteractionEnabled:YES];
    [uiTagLabel setTextColor:UIColorFromRGB(0xa4866c, 1.0f)];
    [uiTagLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [uiTagLabel setBackgroundColor:[UIColor clearColor]];
    [uiTagLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [uiTagLabel setNumberOfLines:1];
    [uiTagLabel setTextAlignment:NSTextAlignmentLeft];
    [uiTagLabel setLineBreakMode:NSLineBreakByWordWrapping];
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDelete:)];
    [uiTagLabel addGestureRecognizer:deleteTap];
    uiTagLabel.layer.masksToBounds = YES;
    uiTagLabel.layer.cornerRadius = uiTagLabel.height/2.0;
    uiTagLabel.layer.borderWidth = 0.5;
    uiTagLabel.layer.borderColor = pColor.CGColor;
    
    uiTagLabel.text = tTag;
    //设置一个行高上限
    CGSize textMaxSize = CGSizeMake(300, height);
    NSDictionary *textAttribute = @{NSFontAttributeName: uiTagLabel.font};
    CGSize textLabelsize = [uiTagLabel.text boundingRectWithSize:textMaxSize options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttribute context:nil].size;
    uiTagLabel.frame = CGRectMake(0, 0, textLabelsize.width+20, height);
    
    [self addSubview:uiTagLabel];
    
    CGFloat wid = 16;
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(uiTagLabel.width-wid-2, (height-wid)/2.0, wid, wid)];
    lab.text = @"+";
    lab.textColor = [UIColor color:pColor];
//    lab.backgroundColor = [UIColor greenColor];
    lab.font = [UIFont systemFontOfSize:23.0];
    [uiTagLabel addSubview:lab];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = lab.height/2.0;
    lab.transform = CGAffineTransformMakeRotation(DegreesToRadians(45));
}

- (void)startField:(UITextField*)pTagField {
    for( UIView* one in self.subviews ){
        [one removeFromSuperview];
    }
    self.uiTagField = pTagField;
    [self addSubview:self.uiTagField];
}

-(void)doDelete:(id)sender {
    if( self.delegate != nil ){
        [delegate PTGCDdelete:indexPath];
    }
}

@end
