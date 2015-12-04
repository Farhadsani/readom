//
//  UserBaseInfoView.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

#import "UserBaseInfoView.h"

@implementation UserBaseInfoView

NSString *strZoneTitle = @"个人空间名称";
NSString *strIntroTitle = @"个人简介";

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
//        [self setBackgroundColor:UIColorFromRGB(0xff0000, 1.0f)];
        
        uiZoneTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
        uiZoneTitle.font = [UIFont boldSystemFontOfSize:14];
        uiZoneTitle.text = strZoneTitle;
        uiZoneTitle.textColor = UIColorFromRGB(0xe6be78, 1.0f);
        
        uiUserZoneTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 200, 30)];
        uiUserZoneTitle.font = [UIFont boldSystemFontOfSize:20];
//        uiUserZoneTitle.text = @"长老之岛";
        uiUserZoneTitle.textColor = UIColorFromRGB(0xe6be78, 1.0f);
        
        uiIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 200, 30)];
        uiIntroTitle.font = [UIFont boldSystemFontOfSize:14];
        uiIntroTitle.text = strIntroTitle;
        uiIntroTitle.textColor = UIColorFromRGB(0xe6be78, 1.0f);
        
        uiUserIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 60, 300, 30)];
        uiUserIntroTitle.font = [UIFont boldSystemFontOfSize:20];
//        uiUserIntroTitle.text = @"石头人工作室创始人";
        uiUserIntroTitle.textColor = UIColorFromRGB(0xe6be78, 1.0f);
        
        [self addSubview:uiZoneTitle];
        [self addSubview:uiUserZoneTitle];
        [self addSubview:uiIntroTitle];
        [self addSubview:uiUserIntroTitle];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setInfo:(NSString *)strZone :(NSString *)strIntro
{
    CGSize sizeZoneTitle = [strZoneTitle sizeWithFont:uiZoneTitle.font];
    CGSize sizeZone = [strZone sizeWithFont:uiUserZoneTitle.font];
    
    CGFloat zoneWidth = sizeZoneTitle.width + sizeZone.width + 20;
    
    uiZoneTitle.frame = CGRectMake((self.frame.size.width - zoneWidth)/2, 50 - sizeZoneTitle.height, sizeZoneTitle.width, sizeZoneTitle.height);
    uiUserZoneTitle.frame = CGRectMake((self.frame.size.width - zoneWidth)/2 + sizeZoneTitle.width + 20, 50 - sizeZone.height, sizeZone.width, sizeZone.height);
    
    uiUserZoneTitle.text = strZone;
    
    CGSize sizeIntroTitle = [strIntroTitle sizeWithFont:uiIntroTitle.font];
    CGSize sizeIntro = [strIntro sizeWithFont:uiUserIntroTitle.font];
    
    CGFloat introWidth = sizeIntroTitle.width + sizeIntro.width + 20;
    
    uiIntroTitle.frame = CGRectMake((self.frame.size.width - introWidth)/2, 100 - sizeIntroTitle.height, sizeIntroTitle.width, sizeIntroTitle.height);
    uiUserIntroTitle.frame = CGRectMake((self.frame.size.width - introWidth)/2 + sizeIntroTitle.width + 20, 100 - sizeIntro.height, sizeIntro.width, sizeIntro.height);
    
    uiUserIntroTitle.text = strIntro;
}

@end
