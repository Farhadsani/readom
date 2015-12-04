

#import "TopicCellInCollect.h"
#import "TagItem.h"

@implementation TopicCellInCollect

- (void)updateCell:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) {
        return;
    }
    
    if (!_date_dict) {
        self.date_dict = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    [self setItemModel:inf];
    
    [self setCell];
}

#pragma mark - delegate (CallBack)

#pragma mark request

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_like_post]) {
        //收藏成功
        colectBtn.selected = YES;
        [colectBtn setTitle: [NSString stringWithFormat:@" %d", [colectBtn.titleLabel.text intValue]+1] forState:UIControlStateNormal];
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_like_del]) {
        //取消收藏成功
        colectBtn.selected = NO;
        [colectBtn setTitle: [NSString stringWithFormat:@" %d", [colectBtn.titleLabel.text intValue]-1] forState:UIControlStateNormal];
    }
}
- (void)didfailedLoad:(Reqest *)req withError:(NSError *)error{
    InfoLog(@"error:%@", error);
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_like_post]) {
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_topic_like_del]) {
    }
}

#pragma mark - action SEL

//- (void)publishToTopic:(UIButton *)sender{
//    if (_delegate && [_delegate respondsToSelector:@selector(didPublishNewNote:)]) {
//        [_delegate didPublishNewNote:self];
//    }
//}

- (void)collectTopic:(UIButton *)sender{
    NSString * url = nil;
    if (sender.selected) {
        //已收藏
        url = k_api_topic_like_del;//取消收藏
    }
    else{
        url = k_api_topic_like_post;
    }
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",[UserManager sharedInstance].userid],
                              @"topicid":[NSString stringWithFormat:@"%.0ld",self.topicItem.topicid],
                              };
    NSDictionary * dict = @{@"idx":@0,
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:url,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

#pragma mark - init view

- (void)setCell{
    if (!_topicItem) {
        return;
    }
    
    [self removeAllSubviews];
    
    CGFloat marginX = 8;
    
    UIView * backView = [UIView view_sub:@{V_Parent_View:self,
                                           V_Margin:edgeStr(marginX, marginX, 5, marginX),
                                           V_Height:@50,
                                           V_BGColor:[UIColor colorWithWhite:1 alpha:0.8],
                                           V_Border_Radius:@5,
                                           }];
    [self addSubview:backView];
    
    UILabel * channelLab = [UIView label:@{V_Parent_View:backView,
                                           V_Margin_Left:strFloat(marginX),
                                           V_Margin_Top:strFloat(marginX),
                                           V_Height:@20,
                                           V_Font_Size:@14,
                                           V_Color:gray_color,
                                           V_Text:self.topicItem.channel,
                                           V_Font_Family:k_fontName_FZXY,
                                           }];
    [backView addSubview:channelLab];
    
    NSString * text = [NSString stringWithFormat:@"#%@#", self.topicItem.title];
    UILabel * topicTitle = [UIView label:@{V_Parent_View:backView,
                                           V_Last_View:channelLab,
                                           V_Margin:edgeStr(marginX, marginX, 0, marginX),
                                           V_Height:@40,
                                           V_Font_Size:@16,
                                           V_Font_Family:k_fontName_FZZY,
                                           V_Color:darkZongSeColor,
                                           V_Text:text,
                                           V_TextAlign:num(TextAlignCenter),
                                           V_NumberLines:@2,
                                           }];
    [backView addSubview:topicTitle];
    
    if (![NSString isEmptyString:self.topicItem.summary]) {
        NSInteger line = [NSString numberOfLineWithText:self.topicItem.summary font:[UIFont systemFontOfSize:14.0] superWidth:backView.width-2*marginX breakLineChar:nil];
        topicTitle = [UIView label:@{V_Parent_View:backView,
                                     V_Last_View:topicTitle,
                                     V_Margin:edgeStr(5, marginX, 0, marginX),
                                     V_Height:strFloat(20*line),
                                     V_Font_Size:@15,
                                     V_Font_Family:k_fontName_FZXY,
                                     V_Color:UIColorFromRGB(0xb29474, 1.0f),
                                     V_Text:self.topicItem.summary,
                                     V_TextAlign:num(TextAlignLeft),
                                     V_NumberLines:num(line+1),
                                     }];
        [backView addSubview:topicTitle];
    }
    
    UIView * actionView = [UIView view_sub:@{V_Parent_View:backView,
                                             V_Last_View:topicTitle,
                                             V_Margin:edgeStr(marginX, marginX, 0, marginX),
                                             V_Height:@30,
                                             }];
    [backView addSubview:actionView];
    
    colectBtn = [UIView button:@{V_Parent_View:actionView,
                                 V_Over_Flow_X:num(OverFlowRight),
                                 V_Margin_Right:@5,
                                 V_Margin_Top:@5,
                                 V_Margin_Bottom:@5,
                                 V_Width:@80,
                                 V_HorizontalAlign:num(HorizontalRight),
                                 V_Font_Size:@14,
                                 V_Color:orange_color,
                                 V_Color_S:orange_color,
                                 V_Title:[NSString stringWithFormat:@" %d", self.topicItem.hot],
                                 V_Img:@"topic_delliked",
                                 V_Img_S:@"topic_liked",
                                 V_Delegate:self,
                                 V_SEL:selStr(@selector(collectTopic:)),
                                 V_Selected:num((self.topicItem.liked)?SelectedYES:SelectedNO),
                                 }];
    [actionView addSubview:colectBtn];
    
    [self resetFrameHeightOfView:backView];
    [self resetFrameHeightOfView:self];
}

- (void)setItemModel:(NSDictionary *)itemDict{
    if (![NSDictionary isNotEmpty:itemDict] || _topicItem) {
        return;
    }
    
    [_date_dict setValuesForKeysWithDictionary:itemDict];
    
    self.topicItem = [[[TopicItem alloc] init] autorelease];
    _topicItem.topicid = [[itemDict objectForKey:@"topicid"] longValue];
    _topicItem.title = [itemDict objectForKey:@"title"];
    _topicItem.summary = [itemDict objectForKey:@"summary"];
    _topicItem.hot = [[itemDict objectForKey:@"hot"] intValue];
    _topicItem.provid = [[itemDict objectForKey:@"provid"] intValue];
    _topicItem.cityid = [[itemDict objectForKey:@"cityid"] intValue];
    _topicItem.channel = [itemDict objectForKey:@"channel"];
    _topicItem.imglink = [itemDict objectForKey:@"imglink"];
    _topicItem.ctime = [itemDict objectForKey:@"ctime"];
    _topicItem.liked = [[itemDict objectForKey:@"liked"] boolValue];
    NoteManager *noteManager = [[NoteManager alloc] init:_topicItem.topicid];
    _topicItem.noteManager = noteManager;
}

@end
