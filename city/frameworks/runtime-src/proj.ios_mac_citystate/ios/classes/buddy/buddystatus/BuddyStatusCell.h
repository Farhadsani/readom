//
//  BuddyStatusCell.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddyStatusNoteItemFrame.h"
#import "BuddyStatusToolBar.h"

@class BuddyStatusCell;

@protocol BuddyStatusCellDelegate <NSObject>
@optional
- (void)buddyStatusCell:(BuddyStatusCell *)cell userIconBtnDidOnClick:(UIButton *)button;
- (void)buddyStatusCellrequestComment:(NSInteger)feedid;
@end

@interface BuddyStatusCell : UITableViewCell
@property (nonatomic, strong) BuddyStatusNoteItemFrame *noteItemFrame;
@property (nonatomic, weak) id<BuddyStatusCellDelegate> delegate;
+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
