//
//  PersonalTopicViewController.h
//  qmap
//
//  Created by hf on 15/8/21.
//
//

/*
 *【话题】界面
 *功能：查看所有话题列表
 *
 */
#import "BaseViewController.h"
#import "CollectCell.h"
#import "BuddyStatusCell.h"
#import "NoteItem.h"
#import "TopicCellInCollect.h"

@interface PersonalTopicViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,BuddyStatusCellDelegate>

@end
