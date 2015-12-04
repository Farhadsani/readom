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
- (void)BuddyCell:(BuddyCell *)cell iconButton:(long)index;
@end

@interface BuddyCell : UITableViewCell{
    
}

@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) BuddyItem        *modelItem;

@property (strong, nonatomic) UILabel        *userName;
@property (strong, nonatomic) UILabel        *userIntro;
//@property (strong, nonatomic) UILabel        *uiTopicchannel;
@property (strong, nonatomic) UIButton *buddyBtn;
@property (assign, nonatomic) id<BuddyCellDelegate> delegate;

-(void)start:(BuddyItem*) item :(long)index;


@end
