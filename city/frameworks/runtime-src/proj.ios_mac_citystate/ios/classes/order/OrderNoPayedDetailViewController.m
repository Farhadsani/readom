//
//  OrderNoPayedDetailViewController.m
//  citystate
//
//  Created by hf on 15/10/15.
//
//

#import "OrderNoPayedDetailViewController.h"
#import "OrderHasCommentViewController.h"
#import "StoreViewController.h"
#import "OrderIntro.h"
#import "StoreSimpleIntro.h"
#import "OrdersViewController.h"
#import "QRCodeViewController.h"
#import "StorePayMoneyViewController.h"

#define Space 10

@interface OrderNoPayedDetailViewController ()

@property (nonatomic, assign) int index;
@property (nonatomic, retain) RatingView * starView;

@property (nonatomic, retain) StoreSimpleIntro * storeSimpleIntro;

@end

@implementation OrderNoPayedDetailViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setupMainView];
    [self requestOrderDetail];
}

#pragma mark - delegate (CallBack)

#pragma mark OrderCommentVCDelegate
- (void)OrderCommentViewController:(OrderCommentViewController *)vc data:(OrderIntro*)orderIntro{
    [self requestOrderDetail];
    
    OrdersViewController * lvc = [self.navigationController.viewControllers objectAtExistIndex:[self.navigationController.viewControllers indexOfObject:self]-1];
    if (lvc && [lvc isKindOfClass:[OrdersViewController class]]) {
        [lvc OrderCommentViewController:vc data:orderIntro];
    }
}

#pragma mark StoreSimpleCellDelegate

- (void)didClickCell:(StoreSimpleCell *)cell{
    StoreViewController * vc = [[StoreViewController alloc] init];
    vc.userid = self.orderIntro.storeid;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark request delegate
- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_detail]) {
//        if ([NSDictionary isNotEmpty:[result objectForKey:@"res"]]) {
//            if ([[result objectForKey:@"res"] objectForKey:@"order"]) {
//                self.orderIntro = [OrderIntro objectWithKeyValues:[[result objectForKey:@"res"] objectForKey:@"order"]];
//                StoreSimpleIntro *intro = [[StoreSimpleIntro alloc] init];
//                intro.name = [[result objectForKey:@"res"] objectForKey:@"order"][@"storename"];
//                intro.intro = [[result objectForKey:@"res"] objectForKey:@"order"][@"intro"];
//                intro.rate = [[result objectForKey:@"res"] objectForKey:@"order"][@"storerate"];
//                intro.imglink = [[result objectForKey:@"res"] objectForKey:@"order"][@"imglink"];
//                intro.userid = [[[result objectForKey:@"res"] objectForKey:@"order"][@"storeid"] longValue];
//                intro.liked = [[[result objectForKey:@"res"] objectForKey:@"order"][@"storeid"] boolValue];
//                self.storeSimpleIntro = intro;
//            }
//            [self setupMainView];
//        }
        
        NSDictionary * res = [result objectForKey:@"res"];
        if ([NSDictionary isNotEmpty:res]) {
            NSDictionary * order = [res objectForKey:@"order"];
            if (order) {
                self.orderIntro = [OrderIntro objectWithKeyValues:order];
                StoreSimpleIntro *intro = [[StoreSimpleIntro alloc] init];
                intro.name = order[@"storename"];
                intro.intro = order[@"intro"];
                intro.rate = order[@"storerate"];
                intro.imglink = order[@"imglink"];
                intro.userid = [order[@"storeid"] longValue];
                intro.liked = [order[@"liked"] boolValue];
                self.storeSimpleIntro = intro;
            }
            [self setupMainView];
        }
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_order_detail]) {
        
    }
}

#pragma mark - action such as: click touch tap slip ...

- (void)clickCommentCell:(id)sender{
    if (_orderIntro && _orderIntro.rated) {
        OrderHasCommentViewController * vc = [[OrderHasCommentViewController alloc] init];
        vc.orderIntro = self.orderIntro;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else{
        OrderCommentViewController * vc = [[OrderCommentViewController alloc] init];
        vc.orderIntro = self.orderIntro;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)clickToQRCode:(id)sender{
    UIControl *ctrl = (UIControl *)sender;
    int t = (int)ctrl.tag;
    NSDictionary * info = self.orderIntro.code[t];
    NSString *  passwd = [info objectOutForKey:@"passwd"];
    id used = [info objectOutForKey:@"used"];
    NSString * qrcode = [info objectOutForKey:@"qrcode"];
    NSLog(@"%@..%@ ..  %@", passwd, used, qrcode);
    
    QRCodeViewController *vc = [[QRCodeViewController alloc]init];
    vc.orderIntro = self.orderIntro;
    vc.QRcodeURL = qrcode;
    vc.passwd = passwd;
    vc.used = ([strObj(used) integerValue] == 0) ? NO : YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)jumoToPay:(UIButton *)sender{
    StorePayMoneyViewController * vc = [[StorePayMoneyViewController alloc] init];
    GoodsOrder *goodsOrder = [[GoodsOrder alloc] init];
    CGFloat totalPrice = [self.orderIntro.price floatValue] * self.orderIntro.goodscount;
    NSString *totalPriceStr = [NSString stringWithFormat:@"￥%.2f", totalPrice];
    goodsOrder.totalPrice = totalPriceStr;
    vc.goodsOrder = goodsOrder;
    vc.orderid = self.orderIntro.orderid;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark  request method
- (void)requestOrderDetail{
    NSDictionary * params = @{@"orderid": @(self.orderIntro.orderid)
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_order_detail,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - init & dealloc
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    if (!_storeSimpleIntro || !_orderIntro) {
        return;
    }
    
    CGFloat top = 0;
    UIView * section = [UIView control:@{V_Parent_View:self.contentView,
                                            V_Margin_Top:strFloat(top),
                                            V_Height:strFloat(k_store__simple_cell_height),
                                            V_Border_Color:k_defaultLineColor,
                                            V_Border_Width:@0.5,
                                            V_BGColor:white_color,
                                            }];
    [self.contentView addSubview:section];
    [self createSection_1:section];
    
    top = Space;
    section = [UIView control:@{V_Parent_View:self.contentView,
                                  V_Last_View:section,
                                  V_Margin_Top:strFloat(top),
                                  V_Height:strFloat(50),
                                  V_Border_Color:k_defaultLineColor,
                                  V_Border_Width:@0.5,
                                  V_BGColor:white_color,
                                  V_Delegate:self,
                                  V_SEL:selStr(@selector(clickCommentCell:)),
                                  }];
    [self.contentView addSubview:section];
    [self createSection_2:section];
    section.userInteractionEnabled = self.orderIntro.payed;
    
    section = [UIView view_sub:@{V_Parent_View:self.contentView,
                                   V_Last_View:section,
                                   V_Margin_Top:strFloat(top),
                                   V_Height:strFloat(100),
                                   V_Border_Color:k_defaultLineColor,
                                   V_Border_Width:@0.5,
                                   V_BGColor:white_color,
                                   }];
    [self.contentView addSubview:section];
    [self createSection_4:section];
    
    self.contentView.frame = CGRectMake(self.contentView.x, self.contentView.y, self.contentView.width, self.contentView.height-60);
    self.contentView.contentSize = CGSizeMake(self.contentView.contentSize.width, section.y+section.height);
    
    if (!self.orderIntro.expired) {
        UIButton * payButton = [UIView button:@{V_Parent_View:self.view,
                                                V_Height:@40,
                                                V_Width:@160,
                                                V_Over_Flow_X:num(OverFlowXCenter),
                                                V_Over_Flow_Y:num(OverFlowBottom),
                                                V_Margin_Bottom:@20,
                                                V_Title:@"去付款",
                                                V_Font_Size:@16,
                                                V_Font_Family:k_fontName_FZZY,
                                                V_Color:white_color,
                                                V_BGImg:@"store_buypay",
                                                V_BGImg_C:@"store_buypay_sel",
                                                V_Delegate:self,
                                                V_SEL:selStr(@selector(jumoToPay:))
                                                }];
        [self.view addSubview:payButton];
    }
}

- (void)createSection_1:(UIView *)section{
    StoreSimpleCell * storeSimpleCell = [[StoreSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeSimpleCell"];
    storeSimpleCell.storeSimpleIntro = self.storeSimpleIntro;
    storeSimpleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    storeSimpleCell.delegate = self;
    [storeSimpleCell setupCell];
    [section addSubview:storeSimpleCell];
    [storeSimpleCell release];
}

- (void)createSection_2:(UIView *)section{
    UITableViewCell * commentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    commentCell.frame = CGRectMake(0, 0, section.width, section.height);
    commentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    commentCell.accessoryView = [UIView imageView:@{V_Frame:rectStr(0, 0, 15, 30),
                                                    V_Img:@"buddystatus_arrow",
                                                    V_ContentMode:num(ModeCenter),
                                                    }];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.userInteractionEnabled = NO;
    
    self.starView = [[[RatingView alloc] initWithFrame:CGRectMake(Space, 0, 150, section.height)] autorelease];
    _starView.userInteractionEnabled = NO;
    _starView.space_width = Space-5;
    _starView.star_height = 23;
    _starView.starMode = UIViewContentModeScaleAspectFit;
    [_starView setImagesDeselected:@"star_comment_unselected" partlySelected:@"star_comment_halfSelected" fullSelected:@"star_comment_selected" andDelegate:nil];
    [commentCell.contentView addSubview:_starView];
    
    UILabel * lab = [UIView label:@{V_Parent_View:commentCell,
                                    V_Height:strFloat(section.height),
                                    V_Margin_Right:@25,
                                    V_Width:@80,
                                    V_Over_Flow_X:num(OverFlowRight),
                                    V_Font_Size:@16,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultLightTextColor,
                                    V_TextAlign:num(TextAlignRight),
                                    }];
    [commentCell addSubview:lab];
    
    if (_orderIntro && _orderIntro.rated) {
        [_starView displayRating:[_orderIntro.rate floatValue]];
        lab.text = [NSString stringWithFormat:@"%.1f分", [_orderIntro.rate floatValue]];
    }
    else{
        [_starView displayRating:0];
        lab.text = @"评分";
    }
    
    [section addSubview:commentCell];
    [commentCell release];
}

- (void)createSection_4:(UIView *)section{
    CGFloat lineHeight = 35;
    CGFloat x = Space;
    UIView * lab1 = [UIView label:@{V_Parent_View:section,
                                    V_Height:strFloat(lineHeight),
                                    V_Margin_Left:strFloat(x),
                                    V_Margin_Top:@5,
                                    V_Text:@"订单信息",
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultLightTextColor,
                                    }];
    [section addSubview:lab1];
    
    lab1 = [UIView view_sub:@{V_Parent_View:section,
                              V_Last_View:lab1,
                              V_Margin_Left:strFloat(x),
                              V_Margin_Right:strFloat(x),
                              V_Height:@0.5,
                              V_BGColor:k_defaultLineColor,
                              }];
    [section addSubview:lab1];
    
    lineHeight = 28;
    
    CGFloat y = lab1.y+lab1.height+5;
    CGFloat w = section.width - 2*x;
    int index = 0;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"特卖名称：" :_orderIntro.goodsname :nil :nil :nil];
    
    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"特卖详情：" :_orderIntro.intro :nil :nil :nil];
    
    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"手机号码：" :_orderIntro.phone :nil :nil :nil];
    
    index++;
    y = lab1.y+lab1.height;
    lab1 = [self View:section frame:CGRectMake(x, y, w, lineHeight) with:@"订单数量：" :[NSString stringWithFormat:@"%d",_orderIntro.goodscount] :@"          总价：" :[NSString stringWithFormat:@"¥%.2f",_orderIntro.goodscount*[_orderIntro.price floatValue]] :nil];
    
    [self resetFrameHeightOfView:section];
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark

- (UIView *)View:(UIView *)section frame:(CGRect)frame with:(NSString *)text1 :(NSString *)text2 :(NSString *)text3 :(NSString *)text4 :(NSString *)textRight{
    UIView * base = [UIView view_sub:@{V_Parent_View:section,
                                       V_BGColor:white_color,
                                       }];
    base.frame = frame;
    [section addSubview:base];
    
    CGFloat lineHeight = 25;
    CGFloat left = Space;
    
    CGFloat textWidth = [text1 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
    UIView * lab1 = [UIView label:@{V_Parent_View:base,
                                    V_Height:strFloat(lineHeight),
                                    V_Width:strFloat(textWidth),
                                    V_Text:text1,
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultLightTextColor,
                                    }];
    [base addSubview:lab1];
    
    if (text2) {
        textWidth = [text2 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:strFloat(textWidth),
                               V_Left_View:lab1,
                               V_Text:text2,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultTextColor,
                               }];
        [base addSubview:lab1];
    }
    
    if (text3) {
        textWidth = [text3 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:strFloat(textWidth),
                               V_Left_View:lab1,
                               V_Text:text3,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultLightTextColor,
                               }];
        [base addSubview:lab1];
    }
    
    if (text4) {
        if ([text4 containsString:@"¥"]) {
            NSString * unit = @"¥ ";
            textWidth = [unit stringSize:[UIFont systemFontOfSize:14.0]].width;
            lab1 = [UIView label:@{V_Parent_View:base,
                                   V_Height:strFloat(lineHeight),
                                   V_Width:strFloat(textWidth),
                                   V_Left_View:lab1,
                                   V_Text:unit,
                                   V_Font_Size:@14,
                                   V_Color:k_defaultTextColor,
                                   }];
            [base addSubview:lab1];
            text4 = [text4 stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        }
        
        textWidth = [text4 stringSize:[UIFont fontWithName:k_fontName_FZZY size:15]].width;
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:strFloat(textWidth),
                               V_Left_View:lab1,
                               V_Text:text4,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultTextColor,
                               }];
        [base addSubview:lab1];
    }
    
    if (textRight) {
        lab1 = [UIView label:@{V_Parent_View:base,
                               V_Height:strFloat(lineHeight),
                               V_Width:@100,
                               V_Over_Flow_X:num(OverFlowRight),
                               V_Margin_Right:strFloat(left),
                               V_Text:textRight,
                               V_Font_Size:@15,
                               V_Font_Family:k_fontName_FZZY,
                               V_Color:k_defaultLightTextColor,
                               V_TextAlign:num(TextAlignRight),
                               }];
        [base addSubview:lab1];
    }
    
    return base;
}

@end
