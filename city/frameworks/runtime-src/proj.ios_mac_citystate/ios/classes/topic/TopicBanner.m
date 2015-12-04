/*
 *[话题]topic界面图片轮播
 *功能设置：分页滚动、定时器
 */
#import "TopicBanner.h"
#import "UIImageView+WebCache.h"

@interface TopicBanner ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger totalNum;
@property (nonatomic, assign) int currentIndex;
@end

@implementation TopicBanner
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect mainFrame = self.frame;
        mainFrame.origin = CGPointMake(0, 0);
        mainFrame.size = CGSizeMake(mainFrame.size.width,mainFrame.size.height);
        //topic界面的图片轮播
        UIImageView *border = [[UIImageView alloc] init];
        CGRect borderFrame = CGRectMake(10, 10, mainFrame.size.width-20,mainFrame.size.height-20);
        border.frame = borderFrame;
        border.layer.cornerRadius = 8;
        border.layer.masksToBounds = YES;
        border.layer.borderWidth = 1;
        border.layer.borderColor = UIColorFromRGB(0x8fce4a,1.0f).CGColor;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 15, CGRectGetWidth(self.frame)-30, CGRectGetHeight(self.frame)-30)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;//是否显示竖向滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;//是否显示横向滚动条
        _scrollView.pagingEnabled = YES;//是否设置分页
        _scrollView.layer.cornerRadius = 5;
        _scrollView.layer.masksToBounds = YES;
        
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _pageControl.currentPage = 0;
        _pageControl.backgroundColor  = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor color:green_color];
        _pageControl.alpha = 0.7;
        
        [self addSubview:border];
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        

        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

-(void)timerAction:(NSTimer *)timer{
    if (_totalNum>1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        if (newOffset.x > (CGRectGetWidth(_scrollView.frame) * (_totalNum-1))) {
            newOffset.x = 0 ;
        }
        int index = newOffset.x / CGRectGetWidth(_scrollView.frame);
        newOffset.x = index * CGRectGetWidth(_scrollView.frame);
        self.currentIndex = index;
        [_scrollView setContentOffset:newOffset animated:YES];
    }else{
        [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;   //当前是第几个视图
    _pageControl.currentPage = index;
}

- (void)setDicts:(NSArray *)dicts
{
    _dicts = dicts;
    
    if( dicts.count == 0 ){
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [img setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:img];
        return;
    }
    _totalNum = dicts.count > 5 ? 5 : dicts.count;
    for (int i = 0; i<_totalNum; i++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        img.contentMode = UIViewContentModeScaleAspectFill;
        [img sd_setImageWithURL:[NSURL URLWithString:dicts[i][@"imglink"]]];
        [img setTag:i];
        [_scrollView addSubview:img];
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidOnClick)];
        [img addGestureRecognizer:recognizer];
    }
    
    _pageControl.numberOfPages = _totalNum; //设置页数 //滚动范围 600=300*2，分2页
    CGRect frame;
    frame = _pageControl.frame;
    frame.size.width = 15*_totalNum;
    _pageControl.frame = frame;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_totalNum,CGRectGetHeight(_scrollView.frame));//滚动范围 600=300*2，分2页
}
- (void)openTimer{
    [_timer setFireDate:[NSDate distantPast]];//开启定时器
}
- (void)closeTimer{
    [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _pageControl.center = self.center;
    CGRect pageContorolFrame = _pageControl.frame;
    pageContorolFrame.origin.y = self.frame.size.height -24;
    _pageControl.frame = pageContorolFrame;
}

- (void)imageViewDidOnClick
{
    if ([self.delegate respondsToSelector:@selector(topicBanner:didOnClick:)]) {
        NSString *topicID = [NSString stringWithFormat:@"%@", self.dicts[self.currentIndex][@"topicid"]];
        [self.delegate topicBanner:self didOnClick:topicID];
    }
}
@end
