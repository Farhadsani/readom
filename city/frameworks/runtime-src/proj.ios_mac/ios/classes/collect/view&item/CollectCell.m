//
//  CollectCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

/*
 *【个人动态】界面 cell展示
 *功能：个人动态 （关注、收藏）判断
 *
 */

#import "CollectCell.h"

@implementation CollectCell
@synthesize uiBtnSelect = uiBtnSelect;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _canEdit = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (OpType)getOpType:(CollectItem *)item{
    if ([item.optype isEqualToString:@"topic_like"]) {
        return topic_like;
    }else if ([item.optype isEqualToString:@"note_post"]){
        return note_post;
    }else if ([item.optype isEqualToString:@"note_like"]){
        return note_like;
    }
    else{
        return topic_like;
    }
}

- (void)refreshUI:(CollectItem *)item frmae:(CGRect)rect{
    self.dataItem = item;
    switch ([self getOpType:item]) {
        case topic_like:{
            [uiTypeImage setImage:[UIImage imageNamed:@"collect_2"]];
        }
            break;
        case note_post:{
            [uiTypeImage setImage:[UIImage imageNamed:@"collect_1"]];
        }
            break;
        case note_like:{
            [uiTypeImage setImage:[UIImage imageNamed:@"collect_3"]];
        }
            break;
            
        default:
            break;
    }
}

- (void)setupUI:(CollectItem *)item frmae:(CGRect)rect{
    self.frame = rect;
    self.dataItem = item;
    
    if (uiTypeBackground && uiTypeBackground.superview) {
        return;
    }
    
//    [self removeAllSubviews];
    
    uiTypeBackground = [UIView imageView:@{V_Parent_View:self,
                                           V_Width:@25,
                                           V_Height:@25,
                                           V_Img:@"collect_bg",
                                           }];
    [self addSubview:uiTypeBackground];
    
    uiTypeImage = [UIView imageView:@{V_Parent_View:uiTypeBackground,
                                      V_Frame:rectStr(5, 5, uiTypeBackground.width-10, uiTypeBackground.height-14),
                                      V_Img:@"collect_bg",
                                      V_ContentMode:num(ModeAspectFit),
                                      }];
    [self addSubview:uiTypeImage];
    
    CGFloat wid = 40;
    if (_canEdit) {
        wid = 60;
    }
    uiBtnSelect = [UIView button:@{V_Parent_View:self,
                                   V_Frame:rectStr(0, (self.height-wid)/2.0, wid, wid),
                                   V_Img:@"collect_4",
                                   V_Img_S:@"collect_5",
                                   V_Delegate:self,
                                   V_SEL:selStr(@selector(onSelect:))
                                   }];
    [self addSubview:uiBtnSelect];
    
    uiBtnHide = [UIView button:@{V_Parent_View:self,
                                 V_Frame:rectStr(self.width-40, self.height-45, 40, 40),
                                 V_Img:@"collect_hide1",
                                 V_HorizontalAlign:num(HorizontalCenter),
                                 V_VerticalAlign:num(VerticalBottom),
                                 V_Delegate:self,
                                 V_SEL:selStr(@selector(rquestHide:))
                                 }];
    [self addSubview:uiBtnHide];
    if (self.userid == [UserManager sharedInstance].brief.userid) {
        uiBtnHide.enabled = YES;
    } else {
        uiBtnHide.enabled = NO;
    }
    
    if (!_canEdit) {
        uiBtnSelect.hidden = YES;
    }
    else{
        uiBtnHide.hidden = YES;
    }
    
    CGFloat x = uiBtnSelect.x + uiBtnSelect.width;
//    CGFloat fontsize = 14;
    if ([self getOpType:item] == topic_like) {//纯文字
        UILabel * title = [UIView label:@{V_Parent_View:self,
                                          V_Margin_Left:strFloat(x),
                                          V_Margin_Right: @20,
                                          V_Text:([NSString isEmptyString:item.title])?@"":[NSString stringWithFormat:@"#%@#", item.title],
                                          V_Font_Size:@16,
                                          V_Font_Family:k_fontName_FZZY,
                                          V_Color:darkZongSeColor,
                                          V_NumberLines:@2,
                                          }];
        [self addSubview:title];
    }
    else{
        UILabel * note = [UIView label:@{V_Parent_View:self,
                                         V_Margin_Left:str(x),
                                         V_Height:@30,
                                         V_Text:([NSString isEmptyString:item.note])?@"":item.note,
                                         V_Font_Size:str(15),
                                         V_Font_Family:k_fontName_FZXY,
                                         V_Color:darkZongSeColor,
                                         }];
        //UIColorFromRGB(0xb29474, 1.0f)
        [self addSubview:note];
        
        if (item.title) {
            NSString * topic = [NSString stringWithFormat:@"#%@#", item.title];
            UILabel * title = [UIView label:@{V_Parent_View:self,
                                              V_Margin_Bottom:@1,
                                              V_Margin_Right:(uiBtnHide.hidden)?@10:strFloat(uiBtnHide.width-5),
                                              V_Height:@16,
                                              V_Over_Flow_Y:num(OverFlowBottom),
                                              V_TextAlign:num(TextAlignRight),
                                              V_Text:topic,
                                              V_Font_Size:str(12),
                                              V_Color:UIColorFromRGB(0xb29474, 1.0f),
                                              V_Font_Family:k_fontName_FZXY,
                                              }];
            [self addSubview:title];
        }
        
        NSArray * imgs = item.note_thumbs;
        if (![NSArray isNotEmpty:imgs]) {
            note.frame = CGRectMake(note.x, note.y, self.width, note.height);
        }
        else{
            CGFloat space = 0;
            CGFloat y = 20;
            CGFloat margingBottom = 15;
            if (![NSString isEmptyString:note.text]) {
                y = note.y+note.height;
                margingBottom = 8;
            }
            UIScrollView * sv = [UIView scrollView:@{V_Parent_View:self,
                                                     V_Frame:rectStr(x, y+5, note.width-uiBtnHide.width+10, self.height-y-5-10),
                                                     }];
            [self addSubview:sv];
            
            NSInteger index = 0;
            for (NSString * url in imgs) {
                if ([NSString isEmptyString:url]) {
                    continue;
                }
                
                
                UIImageView * imgv = [UIView imageView:@{V_Parent_View:sv,
                                                         V_Margin_Left:strFloat(index*(space+sv.height-margingBottom)),
                                                         V_Width:strFloat(sv.height-margingBottom),
                                                         V_Margin_Bottom:@(margingBottom),
                                                         V_Border_Radius:@5,
                                                         V_Border_Color:rgb(222, 177, 99),
                                                         V_Border_Width:@0.5,
                                                         V_ContentMode:num(ModeAspectFill),
                                                         }];
                [sv addSubview:imgv];
                
                space = 5;
                ++index;
                
                UIImage * im = [[Cache shared].pics_dict objectOutForKey:url];
                if (im) {
                    imgv.image = im;
                }
                else{
                    [self requestImage:url imgV:imgv];
                }
            }
            
            if ((sv.height+space)*index < sv.width) {
//                sv.frame = CGRectMake(sv.x, sv.y, (sv.height+space)*index, sv.height);
                sv.userInteractionEnabled = NO;
            }
            else{
                CGFloat maxWidth = 0.0;
                for (UIView * v in sv.subviews) {
                    maxWidth = (v.x + v.width > maxWidth) ? v.x + v.width : maxWidth;
                }
                sv.contentSize = CGSizeMake(maxWidth, sv.height);
            }
        }
    }
    
    [self refreshUI:item frmae:rect];
    
    UIView *line = [UIView view_sub:@{V_Parent_View:self,
                                      V_Frame:rectStr(0, self.height-0.5, self.width, 0.5),
                                      V_BGColor:UIColorFromRGB(0xdec2b2, 1.0f),
                                      }];
    [self addSubview:line];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_fromObj] isKindOfClass:[UIImageView class]]) {
        [(UIImageView *)[req.data_dict objectOutForKey:k_r_fromObj] setImage:(UIImage *)result];
        [[Cache shared].pics_dict setObject:(UIImage *)result forKey:[req.data_dict objectForKey:k_r_url]];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_user_feed_hide_set]) {
//        [self doHide:uiBtnHide];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didHiddenCollectCell:)]) {
            [_delegate didHiddenCollectCell:self];
        }
    }
}

- (void)requestImage:(NSString *)url imgV:(UIImageView *)view{
    if ([NSString isEmptyString:url]) {
        return;
    }
    
    NSDictionary * d = @{k_r_url:url,
                         k_r_reqApiType:num(SysConnectionReqApi),
                         k_r_delegate:self,
                         k_r_fromObj:view,
                         k_r_loading:num(0),
                         k_r_showError:num(0),
                         k_r_methodType:@"GET",
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)onSelect:(id)sender
{
    BOOL s = uiBtnSelect.selected;
    uiBtnSelect.selected = !s;
    
    if (_delegate && [_delegate respondsToSelector:@selector(beginSelectedCollectCell:)]) {
        [_delegate beginSelectedCollectCell:self];
    }
}

- (void)requestCancelCollect:(id)sender{
    InfoLog(@"");
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"feedid":@[self.dataItem.feedID],
                              @"hide":@0,
                              };
    NSDictionary * dict = @{@"idx":str(1),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_hide_set,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_clickView:sender,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)rquestHide:(id)sender{
//    BOOL s = uiBtnHide.selected;
//    uiBtnHide.selected = !s;
    InfoLog(@"");
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"feedid":@[self.dataItem.feedID],
                              @"hide":(uiBtnHide.selected)?@0:@1,
                              };
    NSDictionary * dict = @{@"idx":str(1),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_user_feed_hide_set,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         k_r_clickView:sender,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)doHide:(id)sender{
    BOOL s = uiBtnHide.selected;
    uiBtnHide.selected = !s;
}

@end
