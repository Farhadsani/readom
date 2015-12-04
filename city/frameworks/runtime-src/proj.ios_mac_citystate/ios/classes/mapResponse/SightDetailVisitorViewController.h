//
//  SightDetailVisitorViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/20.
//
//

#import "BaseViewController.h"

@interface SightDetailVisitorViewController : BaseViewController
@property (nonatomic, assign) long sightid;
@property (nonatomic, strong) NSMutableArray *buddyStatusNoteItemFrame;
@property (nonatomic, weak) UITableView  *tableView;
@end
