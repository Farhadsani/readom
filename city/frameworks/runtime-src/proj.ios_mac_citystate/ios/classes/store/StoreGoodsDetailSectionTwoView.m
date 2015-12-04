//
//  StoreGoodsDetailSectionTwoView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/15.
//
//

#import "StoreGoodsDetailSectionTwoView.h"
#import "RatingView.h"

@interface StoreGoodsDetailSectionTwoView ()
@property (nonatomic, weak) RatingView *startReate;
@property (nonatomic, weak) UILabel *startReateLabel;
@property (nonatomic, weak) UIButton *addressIconView;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UIButton *phoneBtn;
@property (nonatomic, weak) UIView *lineView1;
@property (nonatomic, weak) UIView *lineView2;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation StoreGoodsDetailSectionTwoView
+ (instancetype)storeGoodsDetailSectionTwoView
{
    return [[StoreGoodsDetailSectionTwoView alloc] init];
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

    RatingView *startReate = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 100, StoreGoodsDetailSectionTwoViewStartReateH)];
    startReate.star_height = StoreGoodsDetailSectionTwoViewStartReateH;
    startReate.userInteractionEnabled = NO;
    startReate.space_width = 5.0;
    [startReate setImagesDeselected:@"store_star_gray" partlySelected:@"store_star_grayyellow" fullSelected:@"store_star_yellow" andDelegate:nil];
    self.startReate = startReate;
    [self addSubview:startReate];
    
    UILabel *startReateLabel = [[UILabel alloc] init];
    self.startReateLabel = startReateLabel;
    [self addSubview:startReateLabel];
    startReateLabel.textColor = k_defaultTextColor;
    [startReateLabel setFont:StoreGoodsDetailSectionTwoViewStartReateLabelFont];
    
    UIButton *addressIconView = [[UIButton alloc] init];
    self.addressIconView = addressIconView;
    [self addSubview:addressIconView];
    [addressIconView setImage:[UIImage imageNamed:@"store_location.png"] forState:UIControlStateNormal];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    self.addressLabel = addressLabel;
    [self addSubview:addressLabel];
    addressLabel.textColor = gray_color;
    [addressLabel setFont:StoreGoodsDetailSectionTwoViewAddressLabelFont];
    
    UIButton *phoneBtn = [[UIButton alloc]init];
    self.phoneBtn = phoneBtn;
    [self addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(phoneBtnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setImage:[UIImage imageNamed:@"store_phone.png"] forState:UIControlStateNormal];
    
    UIView *lineView1 = [[UIView alloc] init];
    [self addSubview:lineView1];
    self.lineView1 = lineView1;
    lineView1.backgroundColor = k_defaultLineColor;
    
    UIView *lineView2 = [[UIView alloc] init];
    [self addSubview:lineView2];
    self.lineView2 = lineView2;
    lineView2.backgroundColor = k_defaultLineColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = StoreGoodsDetailSectionTwoViewSubViewMargin * 2;
    
    CGFloat startReateX = margin;
    CGFloat startReateY = StoreGoodsDetailSectionTwoViewSubViewMargin;
    self.startReate.frame = (CGRect){{startReateX, startReateY}, self.startReate.frame.size};
    
    CGFloat startReateLabelX = CGRectGetMaxX(self.startReate.frame) + StoreGoodsDetailSectionTwoViewSubViewMargin;
    CGFloat startReateLabelY = startReateY + 4;
    CGFloat startReateLabelH = self.startReate.height - 4;
    CGFloat startReateLabelW = 40;
    self.startReateLabel.frame = CGRectMake(startReateLabelX, startReateLabelY, startReateLabelW, startReateLabelH);
    
    CGFloat addressIconViewX = StoreGoodsDetailSectionTwoViewSubViewMargin;
    CGFloat addressIconViewY = CGRectGetMaxY(self.startReate.frame) + StoreGoodsDetailSectionTwoViewSubViewMargin;
    CGFloat addressIconViewWH = StoreGoodsDetailSectionTwoViewAddressIconViewH;
    self.addressIconView.frame = CGRectMake(addressIconViewX, addressIconViewY, addressIconViewWH, addressIconViewWH);
    
    CGFloat phoneBtnW = StoreGoodsDetailSectionTwoViewAddressIconViewH * 1.5;
    CGFloat phoneBtnH = StoreGoodsDetailSectionTwoViewAddressIconViewH;
    CGFloat phoneBtnX = self.width - margin - phoneBtnW;
    CGFloat phoneBtnY = CGRectGetMaxY(self.startReate.frame) + StoreGoodsDetailSectionTwoViewSubViewMargin;
    self.phoneBtn.frame = CGRectMake(phoneBtnX, phoneBtnY, phoneBtnW, phoneBtnH);
    
    CGFloat addressLabelX = CGRectGetMaxX(self.addressIconView.frame);
    CGFloat addressLabelY = CGRectGetMaxY(self.startReate.frame) + StoreGoodsDetailSectionTwoViewSubViewMargin;
    CGFloat addressLabelH = StoreGoodsDetailSectionTwoViewAddressIconViewH;
    CGFloat addressLabelW = CGRectGetMinX(self.phoneBtn.frame) - CGRectGetMaxX(self.addressIconView.frame) - StoreGoodsDetailSectionTwoViewSubViewMargin * 2;
    self.addressLabel.frame = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
    
    self.lineView1.frame = CGRectMake(margin, CGRectGetMaxY(self.startReate.frame) + StoreGoodsDetailSectionTwoViewSubViewMargin * 0.5, self.width - margin * 2, 0.6);
    self.lineView2.frame = CGRectMake(CGRectGetMinX(self.phoneBtn.frame) - StoreGoodsDetailSectionTwoViewSubViewMargin, CGRectGetMaxY(self.lineView1.frame), 0.6, StoreGoodsDetailSectionTwoViewAddressIconViewH + StoreGoodsDetailSectionTwoViewSubViewMargin);
}

- (void)setStoreGoodsDetail:(StoreGoodsDetail *)storeGoodsDetail
{
    _storeGoodsDetail = storeGoodsDetail;
    
    [self.startReate displayRating:[storeGoodsDetail.rate floatValue]];
    self.startReateLabel.text = [NSString stringWithFormat:@"%@分", storeGoodsDetail.rate];
    self.addressLabel.text = storeGoodsDetail.address;
}

- (void)phoneBtnDidOnClick:(UIButton *)button
{
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@", self.storeGoodsDetail.phone];
    NSURL *url = [NSURL URLWithString:phoneStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}
@end
