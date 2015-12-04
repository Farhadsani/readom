//
//  SocialIndexCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/23.
//
//

#import <UIKit/UIKit.h>
#import "BuddyStatusUser.h"

#define SocialIndexCell_ID @"SocialIndexCell"
#define SocialIndexCellSubviewsMargin 6
#define SocialIndexCellUserIconWH 45
#define SocialIndexCellHeight (SocialIndexCellUserIconWH + 2 * SocialIndexCellSubviewsMargin)

#define SocialIndexCellUserNameFont [UIFont fontWithName:k_fontName_FZZY size:16]
#define SocialIndexCellIntroFont [UIFont fontWithName:k_fontName_FZZY size:14]

@interface SocialIndexCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) BuddyStatusUser *buddyStatusUser;
@end
