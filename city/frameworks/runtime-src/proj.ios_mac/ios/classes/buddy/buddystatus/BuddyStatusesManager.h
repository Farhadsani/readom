//
//  BuddyStatusesManager.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

/*
 * 存储好友动态数据的
 *
 */

#import <Foundation/Foundation.h>
#import "BuddyStatusNoteItemFrame.h"

@interface BuddyStatusesManager : NSObject
+ (void)addNoteItemFrame:(BuddyStatusNoteItemFrame *)noteItemFrame;
+ (NSMutableArray *)allNoteItemFrames;
+ (void)removeAllNoteItemFrames;
@end
