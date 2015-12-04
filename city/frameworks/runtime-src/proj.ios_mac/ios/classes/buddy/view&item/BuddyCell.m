//
//  BuddyCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

#import "BuddyCell.h"

@implementation BuddyCell

@synthesize uiUserImage, uiUserName, uiZone, uiBtn, delegate, modelItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        uiUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [uiUserImage setImage:[UIImage imageNamed:@"res/user/0.png"]];
        uiUserImage.contentMode = UIViewContentModeScaleAspectFit;
        uiUserImage.layer.cornerRadius = uiUserImage.frame.size.width/2;
        uiUserImage.layer.backgroundColor = UIColorFromRGB(0xe6be78, 1.0f).CGColor;
//        uiUserImage.layer.borderWidth = 3.0f;
//        uiUserImage.layer.borderColor = UIColorFromRGB(0xff0000, 1.0f).CGColor;
        uiUserImage.clipsToBounds = YES;
        
        
        uiUserName = [[UILabel alloc] init];
//        [uiUserName setTextColor:UIColorFromRGB(0xa4866c,1.0f)];
        [uiUserName setTextColor:rgb(102, 102, 102)];
        [uiUserName setBackgroundColor:[UIColor clearColor]];
        [uiUserName setFont:[UIFont fontWithName:k_fontName_FZZY size:15]];
        [uiUserName setTextAlignment:NSTextAlignmentLeft];
        
        uiZone = [[UILabel alloc] init];
        [uiZone setTextColor:[UIColor color:green_color]];
        [uiZone setBackgroundColor:[UIColor clearColor]];
        [uiZone setFont:[UIFont fontWithName:k_fontName_FZXY size:12]];
        [uiZone setTextAlignment:NSTextAlignmentLeft];
        
        uiBtn = [[UIButton alloc] init];
        uiBtn.frame = CGRectMake(self.width-40, (self.height-30)/2.0, 30, 30);
        [uiBtn addTarget:self action:@selector(onRelationShip:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:uiUserImage];
        [self.contentView addSubview:uiUserName];
        [self.contentView addSubview:uiZone];
        [self.contentView addSubview:uiBtn];
    }
    return self;
}

- (void)onRelationShip:(id)sender
{
    UIButton *button = (UIButton*)sender;
    InfoLog(@"选中的按钮是：%ld",(long)button.tag);
    if (self.modelItem.relationship == 1 || self.modelItem.relationship == 3) {
        //已经关注了(取消关注)
        if (delegate && [delegate respondsToSelector:@selector(BuddyCell:onUnRelationShip:)]){
            [delegate BuddyCell:self onUnRelationShip:button.tag];
        }
    }
    else{
        if (delegate && [delegate respondsToSelector:@selector(BuddyCell:onRelationShip:)]){
            [delegate BuddyCell:self onRelationShip:button.tag];
        }
    }
}

- (void)doAfterHandelFollow:(BOOL)isFollow result:(NSDictionary *)result{
    if (uiBtn) {
        if (isFollow) {
            if ([result objectOutForKey:@"res"] && [[result objectOutForKey:@"res"] objectOutForKey:@"type"] && [[[result objectOutForKey:@"res"] objectOutForKey:@"type"] integerValue] == 3) {
                self.modelItem.relationship = 3;
                [uiBtn setImage:[UIImage imageNamed:@"buddy_3"] forState:UIControlStateNormal];
            }
            else{
                self.modelItem.relationship = 1;
                [uiBtn setImage:[UIImage imageNamed:@"buddy_2"] forState:UIControlStateNormal];
            }
        }
        else{
            if ([result objectOutForKey:@"res"] && [[result objectOutForKey:@"res"] objectOutForKey:@"type"] && [[[result objectOutForKey:@"res"] objectOutForKey:@"type"] integerValue] == 2) {
                self.modelItem.relationship = 2;
                [uiBtn setImage:[UIImage imageNamed:@"buddy_1"] forState:UIControlStateNormal];
            }
            else{
                self.modelItem.relationship = 0;
                [uiBtn setImage:[UIImage imageNamed:@"buddy_1"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)start: (BuddyItem*) item :(long)index
{
    self.modelItem = item;
    
    NSString * imglink = item.imglink;
    if (imglink) {
        if ([[Cache shared].pics_dict objectOutForKey:imglink]) {
            [uiUserImage setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
        }
        else{
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
            if (img) {
                [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
                [uiUserImage setImage:img];
            }
        }
    }
    
    if ([[UserManager sharedInstance] isCurrentUser:item.userid]) {
        uiBtn.hidden = YES;
    }
    
//    if (self.modelItem.relationship == 1 || self.modelItem.relationship == 3) {
//        //已经关注了
//        uiBtn.userInteractionEnabled = NO;
//    }
    
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    
    uiUserName.frame = CGRectMake(uiUserImage.x+uiUserImage.width+10, 10, self.width-uiUserImage.x-uiUserImage.width-10-20, 25);
    [uiUserName setNumberOfLines:1];
    NSString *text = @"";
    if ([NSString isEmptyString:item.intro]) {
        text = [NSString stringWithFormat:@"%@",item.name];
    }
    else{
        text = [NSString stringWithFormat:@"%@, %@",item.name, item.intro];
    }
    uiUserName.text = text;
    uiUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    //设置一个行高上限
//    CGSize maxSize = CGSizeMake(mainFrame.size.width-50*2,64);
//    NSDictionary *attribute = @{NSFontAttributeName: uiUserName.font};
//    CGSize labelsize = [uiUserName.text boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    uiUserName.frame = CGRectMake(70, 24, labelsize.width, labelsize.height);
    
    if (item.relationship == 0) {   //没有任何关系
        [uiBtn setImage:[UIImage imageNamed:@"buddy_1"] forState:UIControlStateNormal];
    }
    else if (item.relationship == 1)  //关注非粉丝
    {
        [uiBtn setImage:[UIImage imageNamed:@"buddy_2"] forState:UIControlStateNormal];
    }
    else if (item.relationship == 2)  //粉丝
    {
        [uiBtn setImage:[UIImage imageNamed:@"buddy_1"] forState:UIControlStateNormal];
    }
    else if (item.relationship == 3)  // 互相关注
    {
        [uiBtn setImage:[UIImage imageNamed:@"buddy_3"] forState:UIControlStateNormal];
    }
    uiBtn.tag = index;
    
    uiZone.frame = CGRectMake(uiUserName.x, uiUserName.frame.origin.y+uiUserName.frame.size.height, uiUserName.width, 22);
    uiZone.text = item.zone;
    
    self.frame = CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.width, 70);
    uiBtn.frame = CGRectMake(self.width-40-20, (self.height-30)/2.0, 30, 30);
    
    if ([NSString isEmptyString:item.zone]) {
        uiZone.hidden = YES;
        uiUserName.frame = CGRectMake(uiUserName.x, uiUserName.y, uiUserName.width, self.height-2*uiUserName.y);
    }
}
@end
