//
//  MsgManager.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import <Foundation/Foundation.h>
#import "MsgItem.h"
#import "SupportMsgItem.h"

@interface MsgManager : NSObject
{
}
@property (strong, atomic) NSMutableArray *msgList;

@property (strong, atomic) NSMutableArray *myMsgList;
@property (strong, atomic) NSMutableArray *petMsgList;
@property (strong, atomic) NSMutableArray *systemMsgList;
@property (strong, atomic) NSMutableArray *supportMsgList;

- (void) requestDate;

-(void)requestMyMsgDate :(long)begin :(long)limit;
-(void)sendMsg :(long)userID :(NSString*)strContent;
-(void)delMyMsgData;

- (void)requestPetData :(long)begin :(long)limit;
- (void)sendPetMsg :(long)userID :(NSString*)strContent;
- (void)delPetMsgData;

- (void)requestSystemData :(long)begin :(long)limit;
- (void)delSystemMsgData;

- (void)requestSupportData;

- (MsgItem*)getMyMsgItem :(long)index;
- (MsgItem*)getPetMsgItem :(long)index;
- (MsgItem*)getSystemMsgItem :(long)index;
- (SupportMsgItem*)getSupportMsgItem :(long)index;



@end

@protocol MsgDelegate <NSObject>

@optional
- (void)myMsgDelegate:(long)index;
- (void)petMsgDelegate:(long)index;
- (void)systemMsgDelegate:(long)index;
- (void)supportMsgDelegate:(long)index;

@end