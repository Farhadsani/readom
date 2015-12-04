
#import "TopicCell.h"

#define TopicCell_ID @"TopicCell"

@interface TopicCell ()
@property (strong, nonatomic) UILabel        *topicHot;
@property (strong, nonatomic) UILabel        *topicTitle;
@property (strong, nonatomic) UILabel        *topicChannel;
@end

@implementation TopicCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _topicHot = [[UILabel alloc] init];
        [_topicHot setTextColor:UIColorFromRGB(0x93cd56,1.0f)];
        [_topicHot setBackgroundColor:[UIColor clearColor]];
        [_topicHot setFont:[UIFont fontWithName:k_fontName_FZZY size:14]];
        [_topicHot setTextAlignment:NSTextAlignmentLeft];
        
        _topicTitle = [[UILabel alloc] init];
        [_topicTitle setTextColor:UIColorFromRGB(0xb29474,1.0f)];
        [_topicTitle setBackgroundColor:[UIColor clearColor]];
//        [_topicTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [_topicTitle setFont:[UIFont fontWithName:k_fontName_FZZY size:14]];
        [_topicTitle setTextAlignment:NSTextAlignmentLeft];
        
        _topicChannel = [[UILabel alloc] init];
        [_topicChannel setTextColor:UIColorFromRGB(0x666666, 1.0f)];
        [_topicChannel setBackgroundColor:[UIColor clearColor]];
        [_topicChannel setFont:[UIFont fontWithName:k_fontName_FZXY size:12]];
//        [_topicChannel setFont:[UIFont fontWithName:k_fontName_FZXY size:12]];
        
        [_topicTitle setTextAlignment:NSTextAlignmentLeft];
        
        [self.contentView addSubview:_topicHot];
        [self.contentView addSubview:_topicTitle];
        [self.contentView addSubview:_topicChannel];
    }
    return self;
}

-(void)setTopicItem:(TopicItem *)topicItem{
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    
    _topicHot.frame = CGRectMake(0, 10, 50, 20);
    _topicHot.text = [NSString stringWithFormat:@"%d",topicItem.hot];
    _topicHot.textAlignment = NSTextAlignmentCenter;
    
    CGFloat wid = mainFrame.size.width-_topicHot.x-_topicHot.width-10;
    _topicTitle.frame = CGRectMake(_topicHot.x+_topicHot.width, _topicHot.y, wid, 22);
    [_topicTitle setNumberOfLines:2];
    [_topicTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSString *text = [NSString stringWithFormat:@"#%@#",topicItem.title];
    _topicTitle.text = text;
    
    
    //设置一个行高上限
    CGSize maxSize = CGSizeMake(wid, _topicTitle.height*2);
    NSDictionary *attribute = @{NSFontAttributeName: _topicTitle.font};
    CGSize labelsize = [_topicTitle.text boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _topicTitle.frame = CGRectMake(_topicTitle.x, _topicTitle.y, _topicTitle.width, labelsize.height);
    
    _topicChannel.frame = CGRectMake(_topicTitle.x, _topicTitle.y+_topicTitle.height, _topicTitle.width, 18);
    _topicChannel.text = topicItem.channel;
    self.frame = CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.width, _topicChannel.frame.origin.y+_topicChannel.frame.size.height+_topicTitle.y);
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCell_ID];
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicCell_ID];
    }
    return cell;
}
@end
