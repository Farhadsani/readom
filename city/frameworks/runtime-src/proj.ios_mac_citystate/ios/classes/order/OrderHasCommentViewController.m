//
//  OrderHasCommentViewController.m
//  citystate
//
//  Created by hf on 15/10/17.
//
//

#import "OrderHasCommentViewController.h"
#import "BRPlaceholderTextView.h"

@interface OrderHasCommentViewController ()
@property (nonatomic, retain) RatingView * starView;

@end

@implementation OrderHasCommentViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点评";
    [self setupMainView];
}

#pragma mark - delegate (CallBack)

#pragma mark request delegate

#pragma mark other delegate

#pragma mark - action such as: click touch tap slip ...

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{
    [self.contentView removeAllSubviews];
    
    if (!_orderIntro) {
        return;
    }
    
    CGFloat top = 10;
    UIView * section = [UIView control:@{V_Parent_View:self.contentView,
                                         V_Margin_Top:strFloat(top),
                                         V_Height:strFloat(200),
                                         V_Border_Color:k_defaultLineColor,
                                         V_Border_Width:@0.5,
                                         V_BGColor:white_color,
                                         }];
    [self.contentView addSubview:section];
    
    CGFloat lineHeight = 50;
    UILabel * lab1 = [UIView label:@{V_Parent_View:section,
                                     V_Height:strFloat(lineHeight),
                                     }];
    [section addSubview:lab1];
    [self createLab2:lab1];
    
    CGFloat x = 10;
    
    UIView* line = [UIView view_sub:@{V_Parent_View:section,
                                      V_Last_View:lab1,
                                      V_Margin_Left:strFloat(x),
                                      V_Margin_Right:strFloat(x),
                                      V_Height:@0.5,
                                      V_BGColor:k_defaultLineColor,
                                      }];
    [section addSubview:line];
    
    NSString * text = _orderIntro.content;
    if (!text || text.length == 0) {
        text = @"没有评论内容";
    }
    UIFont * font = [UIFont fontWithName:k_fontName_FZXY size:14];
    CGFloat count = [NSString numberOfLineWithText:text font:font superWidth:section.width-2*x breakLineChar:nil];
    BRPlaceholderTextView * commentText = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(x, line.y+line.height+5, section.width-2*x, count*20+40)];
    commentText.backgroundColor = [UIColor clearColor];
    commentText.returnKeyType = UIReturnKeyDone;
    [commentText setFont:font];
    commentText.textColor = k_defaultLightTextColor;
    commentText.text = text;
    commentText.editable = NO;
    [section addSubview:commentText];
    [commentText release];
    
    if ([NSArray isNotEmpty:_orderIntro.pictures]) {
        line = [UIView view_sub:@{V_Parent_View:section,
                                  V_Last_View:commentText,
                                  V_Margin_Left:strFloat(x),
                                  V_Margin_Right:strFloat(x),
                                  V_Height:@0.5,
                                  V_BGColor:k_defaultLineColor,
                                  }];
        [section addSubview:line];
        
        x = 10;
        CGFloat num = 4;
        CGFloat imgWidth = (section.width - x*(num+1)) / num;
        CGFloat imgHeight = imgWidth;
        CGFloat y = line.y+line.height+x;
        int i = 0;
        for (NSString * imglink in _orderIntro.pictures) {
            if (![NSString isEmptyString:imglink]) {
                UIImageView * imgv = [UIView imageView:@{V_Parent_View:section,
                                                         V_Frame:rectStr(x, y, imgWidth, imgHeight),
                                                         V_Border_Color:k_defaultLineColor,
                                                         V_Border_Width:@0.5,
                                                         V_Border_Radius:@3,
                                                         }];
                imgv.contentMode = UIViewContentModeScaleAspectFill;
                [section addSubview:imgv];
                if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
                    [imgv setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
                }
                else{
                    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
                    if (img) {
                        [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
                        [imgv setImage:img];
                    }
                }
                
                ++i;
                
                x = imgv.x + imgv.width + 10;
                if (fmod(i, num) == 0) {
                    x = 10;
                    y = y + imgHeight + x;
                }
            }
        }
    }
    
    [self resetFrameHeightOfView:section];
}

- (void)createLab2:(UIView *)view{
    self.starView = [[[RatingView alloc] initWithFrame:CGRectMake(10, 0, 100, view.height)] autorelease];
    _starView.userInteractionEnabled = NO;
    _starView.space_width = 5;
    _starView.star_height = 16;
    _starView.starMode = UIViewContentModeLeft;
    [_starView setImagesDeselected:@"store_star_gray" partlySelected:@"store_star_grayyellow" fullSelected:@"store_star_yellow" andDelegate:nil];
    [view addSubview:_starView];
    if (_orderIntro.rate) {
        [_starView displayRating:[_orderIntro.rate floatValue]];
        UILabel * lab = [UIView label:@{V_Parent_View:view,
                                        V_Height:strFloat(view.height),
                                        V_Left_View:_starView,
                                        V_Text:[NSString stringWithFormat:@"%.1f分", [_orderIntro.rate floatValue]],
                                        V_Font_Size:@17,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Color:k_defaultTextColor,
                                        }];
        [view addSubview:lab];
    }
    
    if (_orderIntro.ctime) {
        NSString * ctime = _orderIntro.ctime;
        if ([ctime containsString:@" "]) {
            ctime = [[ctime componentsSeparatedByString:@" "] objectAtIndex:0];
        }
        UILabel * lab2 = [UIView label:@{V_Parent_View:view,
                                         V_Height:strFloat(view.height),
                                         V_Width:@200,
                                         V_Over_Flow_X:num(OverFlowRight),
                                         V_Margin_Right:strFloat(15),
                                         V_Text:ctime,
                                         V_Font_Size:@15,
                                         V_Font_Family:k_fontName_FZZY,
                                         V_Color:k_defaultLightTextColor,
                                         V_TextAlign:num(TextAlignRight),
                                         }];
        [view addSubview:lab2];
    }
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - other method
#pragma mark

@end
