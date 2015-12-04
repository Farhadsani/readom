//
//  StoreGoodsDetailSectionThreeView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import "StoreGoodsDetailSectionThreeView.h"
#import "NSString+Extension.h"

@interface StoreGoodsDetailSectionThreeView () <UIWebViewDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (nonatomic, weak) UILabel *noteLabel;
@property (nonatomic, weak) UIView *lineView;
@property (weak, nonatomic) UILabel *dateTitleLabel;
@property (weak, nonatomic) UILabel *timeTitleLabel;
@property (weak, nonatomic) UILabel *ruleTitleLabel;
@property (weak, nonatomic) UILabel *dateLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *ruleLabel;
@end

@implementation StoreGoodsDetailSectionThreeView
+ (instancetype)storeGoodsDetailSectionThreeView
{
//    return [[[NSBundle mainBundle] loadNibNamed:@"StoreGoodsDetailSectionThreeView" owner:nil options:nil] lastObject];
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = lightgray_color.CGColor;
    self.layer.borderWidth = 0.6;

    UILabel *noteLabel = [[UILabel alloc] init];
    self.noteLabel = noteLabel;
    [self addSubview:noteLabel];
    noteLabel.textColor = gray_color;
    [noteLabel setFont:StoreGoodsDetailSectionThreeViewLabelFont];
    noteLabel.text = @"购买须知";
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = k_defaultLineColor;
    
    UILabel *dateTitleLabel = [[UILabel alloc] init];
    self.dateTitleLabel = dateTitleLabel;
    [self addSubview:dateTitleLabel];
    dateTitleLabel.textColor = k_defaultTextColor;
    [dateTitleLabel setFont:StoreGoodsDetailSectionThreeViewTitleLabelFont];
    dateTitleLabel.text = @"有效期:";
    
    UILabel *dateLabel = [[UILabel alloc] init];
    self.dateLabel = dateLabel;
    [self addSubview:dateLabel];
    dateLabel.textColor = gray_color;
    [dateLabel setFont:StoreGoodsDetailSectionThreeViewContentLabelFont];
    
    UILabel *timeTitleLabel = [[UILabel alloc] init];
    self.timeTitleLabel = timeTitleLabel;
    [self addSubview:timeTitleLabel];
    timeTitleLabel.textColor = k_defaultTextColor;
    [timeTitleLabel setFont:StoreGoodsDetailSectionThreeViewTitleLabelFont];
    timeTitleLabel.text = @"使用时间:";
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    timeLabel.textColor = gray_color;
    [timeLabel setFont:StoreGoodsDetailSectionThreeViewContentLabelFont];
    
    UILabel *ruleTitleLabel = [[UILabel alloc] init];
    self.ruleTitleLabel = ruleTitleLabel;
    [self addSubview:ruleTitleLabel];
    ruleTitleLabel.textColor = k_defaultTextColor;
    [ruleTitleLabel setFont:StoreGoodsDetailSectionThreeViewTitleLabelFont];
    ruleTitleLabel.text = @"使用规则:";
    
    UILabel *ruleLabel = [[UILabel alloc] init];
    self.ruleLabel = ruleLabel;
    [self addSubview:ruleLabel];
    ruleLabel.textColor = gray_color;
    [ruleLabel setFont:StoreGoodsDetailSectionThreeViewContentLabelFont];
    ruleLabel.numberOfLines = 0;
}

- (void)setStoreGoodsDetail:(StoreGoodsDetail *)storeGoodsDetail
{
    _storeGoodsDetail = storeGoodsDetail;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@至%@", storeGoodsDetail.startdate, storeGoodsDetail.enddate];
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@", storeGoodsDetail.starttime, storeGoodsDetail.endtime];
    self.ruleLabel.text = storeGoodsDetail.rule;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat margin = StoreGoodsDetailSectionThreeViewSubViewMargin * 2;
    CGFloat noteLabelX = margin;
    CGFloat noteLabelY = StoreGoodsDetailSectionThreeViewSubViewMargin;
    CGSize noteLabelSize = [self.noteLabel.text sizeWithFont:StoreGoodsDetailSectionThreeViewLabelFont andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.noteLabel.frame = (CGRect){{noteLabelX, noteLabelY}, noteLabelSize.width, noteLabelSize.height+10};
    
    self.lineView.frame = CGRectMake(margin, CGRectGetMaxY(self.noteLabel.frame) + 4, self.width - margin * 2, 0.6);
    
    [self.dateTitleLabel sizeToFit];
    self.dateTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.lineView.frame) + 6, self.dateTitleLabel.width, self.dateTitleLabel.height);
    
    [self.dateLabel sizeToFit];
    self.dateLabel.frame = CGRectMake(40, CGRectGetMaxY(self.dateTitleLabel.frame) + 2, self.dateLabel.width, self.dateLabel.height);
    
    [self.timeTitleLabel sizeToFit];
    self.timeTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.dateLabel.frame) + 2, self.timeTitleLabel.width, self.timeTitleLabel.height);
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(40, CGRectGetMaxY(self.timeTitleLabel.frame) + 2, self.timeLabel.width, self.timeLabel.height);
    
    [self.ruleTitleLabel sizeToFit];
    self.ruleTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.timeLabel.frame) + 2, self.ruleTitleLabel.width, self.ruleTitleLabel.height);
    
    CGSize size = [self.storeGoodsDetail.rule sizeWithFont:StoreGoodsDetailSectionThreeViewContentLabelFont andMaxSize:CGSizeMake(width - 60, MAXFLOAT)];
    self.ruleLabel.frame = CGRectMake(40, CGRectGetMaxY(self.ruleTitleLabel.frame) + 2, size.width, size.height);
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.ruleLabel.frame) + StoreGoodsDetailSectionThreeViewSubViewMargin;
    self.frame = frame;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:StoreGoodsDetailSectionThreeViewLayoutSubviewsNotification object:nil];
}
@end
