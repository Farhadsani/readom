//
//  BuddyCell.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

#import "BuddyCell.h"

@implementation BuddyCell

@synthesize userImage, userName, userIntro, buddyBtn, delegate, modelItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup{
    CGFloat cellHeight = 50;
    userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,  5, cellHeight-2*5, cellHeight-2*5)];
    [userImage setImage:[UIImage imageNamed:@"register-done-2-1.png"]];
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.layer.cornerRadius = userImage.width/2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderColor = [UIColor color:k_defaultLineColor].CGColor;
    userImage.layer.borderWidth = 0.5;
    
    [self.contentView addSubview:userImage];
    
    userName = [UIView label:@{V_Parent_View:self.contentView,
                               V_Left_View:userImage,
                               V_Margin_Left:@5,
                               V_Margin_Right:@5,
                               V_Margin_Top:@8,
                               V_Font_Family:k_fontName_FZZY,
                               V_Font_Size:num(15),
                               V_Height:strFloat(cellHeight/2.0-5),
                               V_Color:k_defaultTextColor,
                               }];
    [self.contentView addSubview:userName];
    
    userIntro = [UIView label:@{V_Parent_View:self.contentView,
                                V_Last_View:userName,
                                V_Left_View:userImage,
                                V_Margin_Left:@5,
                                V_Color:k_defaultTextColor,
                                V_Font_Size:num(12),
                                V_Height:strFloat(cellHeight/2.0-5),
                                V_Font_Family:k_fontName_FZZY,
                                V_Color:k_defaultLightTextColor,
                                V_Alpha:@0.5,
                                }];
    [self.contentView addSubview:userIntro];
    
    buddyBtn = [UIView button:@{V_Parent_View:self.contentView,
                                V_Margin_Top:@5,
                                V_Width:strFloat(cellHeight-10),
                                V_Height:strFloat(cellHeight-10),
                                V_Over_Flow_X:num(OverFlowRight),
                                V_Margin_Right:@3,
                                V_HorizontalAlign:num(HorizontalRight),
                                V_Delegate:self,
                                V_SEL:selStr(@selector(onRelationShip:)),
                                }];
    [self.contentView addSubview:buddyBtn];
    
    UIView * line =  [UIView view_sub:@{V_Parent_View:self.contentView,
                                        V_Last_View:userImage,
                                        V_Margin_Top:@5,
                                        V_Height:@0.5,
                                        V_Margin_Left:@10,
                                        V_Margin_Right:@10,
                                        V_BGColor:k_defaultLineColor,
                                        }];
    [self.contentView addSubview:line];

}
- (void)onRelationShip:(UIButton *)sender
{
    UIButton *button = (UIButton*)sender;
    InfoLog(@"选中的按钮是：%ld",(long)button.tag);
    if (modelItem.type == 1 || modelItem.type == 3) {
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
            [userImage setImage:[[Cache shared].pics_dict objectOutForKey:imglink]];
        }
        else{
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imglink]]];
            if (img) {
                [[Cache shared].pics_dict setNonEmptyObject:img forKey:imglink];
                [userImage setImage:img];
            }
        }
    }
    
    if ([[UserManager sharedInstance] isCurrentUser:item.userid]) {
        buddyBtn.hidden = YES;
    }
    
    //    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    
    //    userName.frame = CGRectMake(userImage.x+userImage.width+10, 10, self.width-userImage.x-userImage.width-10-20, 20);
    [userName setNumberOfLines:1];
    userName.text = item.name;
    userName.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (item.type == 0) {   //没有任何关系
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_6"] forState:UIControlStateNormal];
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_5"] forState:UIControlStateSelected];
    }
    else if (item.type == 1)  //关注非粉丝
    {
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_1"] forState:UIControlStateNormal];
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_2"] forState:UIControlStateSelected];
    }
    else if (item.type == 2)  //粉丝
    {
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_6"] forState:UIControlStateNormal];
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_5"] forState:UIControlStateSelected];
    }
    else if (item.type == 3)  // 互相关注
    {
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_4"] forState:UIControlStateNormal];
        [buddyBtn setImage:[UIImage imageNamed:@"buddy_3"] forState:UIControlStateNormal];
    }
    buddyBtn.tag = index;
    userIntro.text = item.intro;

    buddyBtn.frame = CGRectMake(self.width-70, 0, 60, 50);
    
    if ([NSString isEmptyString:item.intro]) {
        userIntro.hidden = YES;
        userName.frame = CGRectMake(userName.x, 0, userName.width, 50);
    }
}
@end
