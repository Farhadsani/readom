//
//  BuddyView.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

#import <UIKit/UIKit.h>
#import "BuddyManager.h"
#import "BuddyCell.h"

@protocol BuddyListDelegate <NSObject>

@optional
-(void)selectItem:(NSInteger)index;
-(void)onRelationShip:(long)index;
-(void)onUnRelationShip:(long)index;
@end

@interface BuddyListView : UIView<UITableViewDataSource,UITableViewDelegate, BuddyCellDelegate>{
    NSMutableArray *tableData;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) BuddyManager *buddyManager;
@property (assign, nonatomic) id<BuddyListDelegate> delegate;

-(void)refreshData:(int) index;

@end
