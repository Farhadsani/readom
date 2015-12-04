//
//  BuddyManager.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/22.
//
//

#import <Foundation/Foundation.h>
#import "BuddyItem.h"
#import "BuddyCell.h"

typedef enum BuddyShowType{
    OnlySquare = 0,         //未登录，不是去看别人的个人空间
    FanAndFollow,           //看别人的个人空间（无论是否登录）
    FanAndFollowAndSquare   //已登录，看自己的个人空间
}BuddyShowType;

@protocol BuddyManagerDelegate <NSObject>

@optional
- (void)didGetResult:(NSString *)type error:(NSError *)error reqData:(NSDictionary *)data_dict;
- (void)didAddFollow:(NSString *)userId result:(NSDictionary *)result error:(NSError *)error from:(id)cell;
- (void)didRemoveFollow:(NSString *)userId result:(NSDictionary *)result error:(NSError *)error from:(id)cell;
- (void)didGetbuddycount:(NSString *)userId result:(NSDictionary *)result error:(NSError *)error;

@end


@interface BuddyManager : NSObject{
    NSMutableArray *curList;
    BOOL showLoadingFlag;
}

@property (strong, atomic) NSMutableArray *frendList;
@property (strong, atomic) NSMutableArray *fansList;
@property (strong, atomic) NSMutableArray *ortherList;
@property (copy, atomic) BuddyItem *mainUser;
@property (assign, nonatomic) id<BuddyManagerDelegate> delegate;

- (BuddyShowType)getBuddyShowType;

-(void)requestfrendDataBegin:(long)begin limit:(long)limit;
- (void)requestData:(NSInteger)index userid:(long)userID begin:(long)begin limit:(long)limit;

//请求统计接口
- (void)requestGetbuddycount:(long)userID;

//关注用户
- (void)requestFollow:(long)userID from:(BuddyCell *)cell;
//取消关注用户
-(void)requestUnFollow:(long)userID from:(BuddyCell *)cell;

-(NSMutableArray*) getTableData:(int) index;
-(BuddyItem* ) getBoddyItem:(NSInteger) index;

@end
