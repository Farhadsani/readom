//
//  StoreSimpleCell.m
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import "StoreSimpleCell.h"
#import "NSString+Extension.h"

@interface StoreSimpleCell ()
@property (nonatomic, assign) int index;
@property (nonatomic, retain) RatingView * starView;
@property (nonatomic, retain) UIButton *commentButton;
@end

@implementation StoreSimpleCell
+ (instancetype)cellForTableView:(UITableView *)tableView{
    StoreSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreSimpleCell"];
    if (cell == nil) {
        cell = [[StoreSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StoreSimpleCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    [self sutpcell];
//}

- (void)setupCell{
    [self.contentView removeAllSubviews];
    
    if (!_storeSimpleIntro) {
        return;
    }
    
    self.frame = CGRectMake(0, 0, kScreenWidth, k_store__simple_cell_height);
    UIControl * back = [UIView control:@{V_Parent_View:self,
                                         V_Margin_Top:@10,
                                         V_BGColor:white_color,
                                         V_Border_Color:k_defaultLineColor,
                                         V_Border_Width:@0.5,
                                         V_Delegate:self,
                                         V_SEL:selStr(@selector(clickCell:)),
                                         }];
    [self.contentView addSubview:back];
    
    CGFloat padding = 6;
    CGFloat lineHeight = back.height-2*padding;
    
    UIImageView * logo = [UIView imageView:@{V_Parent_View:back,
                                             V_Frame:rectStr(padding*2, padding, lineHeight, lineHeight),
                                             V_Border_Color:k_defaultLineColor,
                                             V_Border_Width:@0.5,
                                             V_Border_Radius:@2,
                                             V_ContentMode:num(ModeAspectFill),
                                             }];
    [back addSubview:logo];
    NSString * imglink = _storeSimpleIntro.imglink;
    if (imglink) {
        if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
            [logo setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
        }
        else{
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
            if (img) {
                [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
                [logo setImage:img];
            }
        }
    }
    
    UIControl * rightBack = [UIView control:@{V_Parent_View:back,
                                              V_Left_View:logo,
                                              V_Margin_Left:strFloat(padding*2),
                                              V_Margin_Top:strFloat(padding),
                                              V_Height:strFloat(lineHeight),
                                              V_Delegate:self,
                                              V_SEL:selStr(@selector(clickCell:)),
                                              }];
    [back addSubview:rightBack];
    
    lineHeight = lineHeight/3.0;
    
    UIView * lab1 = [UIView label:@{V_Parent_View:rightBack,
                                    V_Height:strFloat(lineHeight),
                                    V_Text:_storeSimpleIntro.name,
                                    V_Font_Size:@18,
                                    V_Font_Family:k_fontName_FZZY,
                                    V_Color:k_defaultTextColor,
                                    V_Delegate:self,
                                    V_SEL:selStr(@selector(clickCell:)),
                                    }];
    if (_storeSimpleIntro.name.length > 0) {
        CGRect frame = lab1.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(logo.frame) - 60 - padding * 2;
        lab1.frame = frame;
    }
    lab1.userInteractionEnabled = YES;
    [rightBack addSubview:lab1];
    [self createLab1:rightBack];
    
    UILabel* lab2 = [UIView label:@{V_Parent_View:rightBack,
                                    V_Last_View:lab1,
                                    V_Height:strFloat(lineHeight),
                                    }];
    [rightBack addSubview:lab2];
    [self createLab2:lab2];
    
    lab2 = [UIView label:@{V_Parent_View:rightBack,
                           V_Last_View:lab2,
                           V_Height:strFloat(lineHeight),
                           V_Text:_storeSimpleIntro.intro,
                           V_Font_Size:@14,
                           V_Font_Family:k_fontName_FZZY,
                           V_Color:k_defaultLightTextColor,
                           }];
    [rightBack addSubview:lab2];
}

- (void)createLab1:(UIView *)view{
    UIButton * commentButton = [UIView button:@{V_Parent_View:view,
                                                V_Height:@30,
                                                V_Width:@70,
                                                V_Over_Flow_X:num(OverFlowRight),
                                                V_Img:(_storeSimpleIntro.liked)?@"like_selected":@"like_unselected",
                                                V_Delegate:self,
                                                V_SEL:selStr(@selector(doLike:))
                                                }];
    [view addSubview:commentButton];
    self.commentButton = commentButton;
}

- (void)clickCell:(id)sender{
    InfoLog(@"");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCell:)]) {
        [self.delegate didClickCell:self];
    }
}

- (void)doLike:(UIButton *)sender{
    NSString *uri = nil;
    if (_storeSimpleIntro.liked) { // 已收藏，切换到不收藏
        uri = k_api_store_like_del;
    } else {
        uri = k_api_store_like_post;
    }
    
    NSDictionary * params = @{@"userid":@(_storeSimpleIntro.userid),
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:uri,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)createLab2:(UIView *)view{
    self.starView = [[[RatingView alloc] initWithFrame:CGRectMake(0, 0, 100, view.height)] autorelease];
    _starView.userInteractionEnabled = NO;
    _starView.space_width = 5;
    _starView.star_height = 20;
    _starView.starMode = UIViewContentModeLeft;
    [_starView setImagesDeselected:@"store_star_gray" partlySelected:@"store_star_grayyellow" fullSelected:@"store_star_yellow" andDelegate:nil];
    [view addSubview:_starView];
    if (_storeSimpleIntro.rate) {
        [_starView displayRating:[_storeSimpleIntro.rate floatValue]];
        UILabel * lab = [UIView label:@{V_Parent_View:view,
                                        V_Height:strFloat(view.height),
                                        V_Left_View:_starView,
                                        V_Text:[NSString stringWithFormat:@"%.1f分", [_storeSimpleIntro.rate floatValue]],
                                        V_Font_Size:@17,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Color:k_defaultTextColor,
                                        }];
        [view addSubview:lab];
    }
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result
{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_post]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _storeSimpleIntro.liked = YES;
            [self.commentButton setImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateNormal];
        });
    } else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_del]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _storeSimpleIntro.liked = NO;
            [self.commentButton setImage:[UIImage imageNamed:@"like_unselected"] forState:UIControlStateNormal];
        });
    }
}

- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error
{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_post] || [[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_store_like_del]) {
        InfoLog(@"error:%@", error);
    }
}

@end
