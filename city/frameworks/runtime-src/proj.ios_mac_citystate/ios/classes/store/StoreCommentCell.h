//
//  StoreCommentCell.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/14.
//
//

#import <UIKit/UIKit.h>
#import "StoreCommentFrame.h"

#define StoreCommentCell_ID @"StoreCommentCell"

@interface StoreCommentCell : UITableViewCell
@property (nonatomic, strong) StoreCommentFrame *storeCommentFrame;
+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
