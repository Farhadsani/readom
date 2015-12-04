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

-(void)startLabel:(id<PostTagCellDelegate>)pDelegate :(NSIndexPath*)pIndexPath :(NSString*)pTag :(UIColor*)pColor {
    self.delegate = pDelegate;
    self.indexPath = pIndexPath;
    NSString *tTag = [NSString stringWithFormat:@"%@ x ",pTag];
    for( UIView* one in self.subviews ){
        [one removeFromSuperview];
    }
    uiTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    [uiTagLabel setUserInteractionEnabled:YES];
    [uiTagLabel setTextColor:UIColorFromRGB(0xa4866c, 1.0f)];
    [uiTagLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [uiTagLabel setBackgroundColor:[UIColor clearColor]];
    [uiTagLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [uiTagLabel setNumberOfLines:1];
    [uiTagLabel setTextAlignment:NSTextAlignmentCenter];
    [uiTagLabel setLineBreakMode:NSLineBreakByWordWrapping];
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDelete:)];
    [uiTagLabel addGestureRecognizer:deleteTap];
    uiTagLabel.layer.masksToBounds = YES;
    uiTagLabel.layer.cornerRadius = 5;
    uiTagLabel.layer.borderWidth = 1;
    uiTagLabel.layer.borderColor = pColor.CGColor;
    
    uiTagLabel.text = tTag;
    //设置一个行高上限
    CGSize textMaxSize = CGSizeMake(300,30);
    NSDictionary *textAttribute = @{NSFontAttributeName: uiTagLabel.font};
    CGSize textLabelsize = [uiTagLabel.text boundingRectWithSize:textMaxSize options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttribute context:nil].size;
    uiTagLabel.frame = CGRectMake(0,0,textLabelsize.width+5,textLabelsize.height+5);
    
    [self addSubview:uiTagLabel];
}

-(void)startField:(UITextField*)pTagField {
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
