//
//  BuddyStatusCommentCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import <UIKit/UIKit.h>
#import "BuddyStatusCommentFrame.h"

@interface BuddyStatusCommentCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) BuddyStatusCommentFrame *buddyStatusCommentFrame;
@end
