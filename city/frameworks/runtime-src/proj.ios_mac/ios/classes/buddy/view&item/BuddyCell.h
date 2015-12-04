//
//  BuddyCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

#import <UIKit/UIKit.h>
#import "BuddyItem.h"

@class BuddyCell;
@protocol BuddyCellDelegate <NSObject>

@optional
- (void)BuddyCell:(BuddyCell *)cell onRelationShip:(long)index;
- (void)BuddyCell:(BuddyCell *)cell onUnRelationShip:(long)index;

@end

@interface BuddyCell : UITableViewCell{
    
}

@property (strong, nonatomic) UIImageView *uiUserImage;
@property (strong, nonatomic) BuddyItem        *modelItem;

@property (strong, nonatomic) UILabel        *uiUserName;
@property (strong, nonatomic) UILabel        *uiZone;
//@property (strong, nonatomic) UILabel        *uiTopicchannel;
@property (strong, nonatomic) UIButton *uiBtn;
@property (assign, nonatomic) id<BuddyCellDelegate> delegate;

-(void)start:(BuddyItem*) item :(long)index;

- (void)doAfterHandelFollow:(BOOL)isFollow result:(NSDictionary *)result;

@end
