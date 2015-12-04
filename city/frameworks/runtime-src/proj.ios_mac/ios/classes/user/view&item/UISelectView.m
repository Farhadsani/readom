//
//  UISelectView.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/31.
//
//

#import "UISelectView.h"
#import "UISelectCell.h"

@implementation UISelectView

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:UIColorFromRGB(0x000000, 0.4f)];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
//        [singleTap release];
        
        CGFloat viewW = self.frame.size.width;
        CGFloat viewH = 300;
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - viewH - 65, viewW, viewH)];
        [view setBackgroundColor:UIColorFromRGB(0xffffff, 1.0f)];
        [self addSubview:view];
        
//        uiLine=[[UIImageView alloc] initWithFrame:self.frame];
//        UIGraphicsBeginImageContext(frame.size);
//        [uiLine.image drawInRect:CGRectMake(0, 0, uiLine.frame.size.width, uiLine.frame.size.height)];
//        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
//        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
//        CGContextBeginPath(UIGraphicsGetCurrentContext());
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 50, viewH - 60);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width-50, viewH - 60);
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        uiLine.image=UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        uiOKBtn = [[UIButton alloc]initWithFrame:CGRectMake((viewW-100)/2, viewH - 60, 100, 50)];
        [uiOKBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [uiOKBtn setTitle:@"确定" forState:UIControlStateNormal];
        [uiOKBtn setTitleColor:UIColorFromRGB(0x00ff00, 1.0f) forState:UIControlStateNormal];
//        [uiOKBtn setBackgroundColor:UIColorFromRGB(0xff00ff, 1.0f)];
        [uiOKBtn addTarget:self action:@selector(onSelectOK:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [view addSubview:uiOKBtn];
        
    }
    return self;
}

-(void)setDefaultSelectItem:(long)s :(long)index
{
    style = s;
    if(arrayData.count < 5)
    {
        for (UIButton *btn in btnArray) {
            btn.selected = (index == btn.tag);
        }
    }else
    {
        NSIndexPath *ip=[NSIndexPath indexPathForRow:index inSection:0];
        [uiListView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];

    }
}

-(void)addSubItem:(NSArray *)arrItemNames
{
    btnArray = [[NSMutableArray alloc]init];
//    arrayData = arrItemNames;
    arrayData = [[NSMutableArray alloc]init];
    for (NSString *name in arrItemNames) {
        [arrayData addObject:name];
    }
    
    long index = 0;
    CGFloat width = 100;
    CGFloat height = 40;
    CGFloat left = (self.frame.size.width - width)/2;
    
    CGFloat maxShowCount = arrItemNames.count ;
    if (arrItemNames.count < 5)
    {
        for (NSString *strName in arrItemNames) {
//            NSLog(@"item %ld is %@", index, strName);
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(left, 10 + index * height, width, height)];
            btn.tag = index;
            [btn setTitle:strName forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x00ff00, 1.0f) forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btnBack1.png"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onSelectItem:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            [btnArray addObject:btn];
            index = index + 1;
        }
    }else
    {
        maxShowCount = 4;
        uiListView = [[UITableView alloc]initWithFrame:CGRectMake((self.frame.size.width-200)/2, 10, 200, height * 5)];
        [uiListView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [uiListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [uiListView setBackgroundColor:UIColorFromRGB(0x00ffff, 1.0f)];
        uiListView.dataSource = self;
        uiListView.delegate = self;
        [view addSubview:uiListView];
        [uiListView reloadData];
        uiListView.showsVerticalScrollIndicator = NO;
//        uiListView.
//        NSIndexPath *ip=[NSIndexPath indexPathForRow:4 inSection:0];
//        [uiListView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
//        NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:2];
//        [self tableView:tableView didSelectRowAtIndexPath:path];
    }
    
    CGFloat viewH = 10 + maxShowCount * height + 10 + 55;
    view.frame = CGRectMake(0, self.frame.size.height - viewH - 65, self.frame.size.width, viewH);
    uiOKBtn.frame = CGRectMake((self.frame.size.width-100)/2, viewH-55, 100, 45);
    
    [self DrawLine:viewH-55];
}



-(void)onSelectItem:(id)sender
{
    for (UIButton *btn in btnArray) {
        btn.selected = NO;
    }
    UIButton *s = (UIButton*)sender;
    s.selected = YES;
    selIndex = s.tag;
}

-(void)onSelectItemInListView:(long)index
{
    selIndex = index;
//    [uiListView reloadData];
}

-(void)onSelectOK:(id)sender
{
    NSLog(@"当前选择了。。。。。");
    [delegate selItemForSelectView:style :selIndex];
}

-(void)DrawLine:(CGFloat)height
{
    uiLine=[[UIImageView alloc] initWithFrame:self.frame];
    UIGraphicsBeginImageContext(self.frame.size);
    [uiLine.image drawInRect:CGRectMake(0, 0, uiLine.frame.size.width, uiLine.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 50, height);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width-50, height);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    uiLine.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [view addSubview:uiLine];

}

- (void)fadeIn
{
//    CGRect rect = [[UIScreen mainScreen] bounds];
    self.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 +200);
    [UIView animateWithDuration:0.5f animations:^{
        self.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    } completion:^(BOOL finished) {
        //   [imageView setImageURL:[NSURL URLWithString:imgUrl]];
    }];
}

- (void)fadeOut
{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    CGPoint point = [sender locationInView:self];
    
//    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    
    if(point.y < self.frame.size.height - 300 - 65)
    {
        self.alpha = 0.0;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma TableView的处理

-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    //    return topicManager.listShow.count+1;
    return arrayData.count;
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if( [indexPath row] == topicManager.listShow.count ) {
    UISelectCell *cell = [[UISelectCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setItemName:arrayData[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)pTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if([indexPath row] == topicManager.listShow.count) {
    //        return;
    //    }
    [self onSelectItemInListView:indexPath.row];
    return;
}


@end
