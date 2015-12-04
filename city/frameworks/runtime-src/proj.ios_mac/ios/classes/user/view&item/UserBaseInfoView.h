//
//  UserBaseInfoView.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/30.
//
//

#import <UIKit/UIKit.h>

@interface UserBaseInfoView : UIView
{
    UILabel *uiZoneTitle;
    UILabel *uiUserZoneTitle;
    UILabel *uiIntroTitle;
    UILabel *uiUserIntroTitle;
}

-(void)setInfo:(NSString*)strZone :(NSString*)strIntro;
@end
