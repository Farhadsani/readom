//
//  BuddyStatusesManager.m
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/20.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

/*
 * 存储好友动态数据的
 *
 */
#import "BuddyStatusesManager.h"

@implementation BuddyStatusesManager
static NSMutableArray *_noteItemFrames;

+ (void)initialize
{
    _noteItemFrames = [NSMutableArray array];
}

+ (void)addNoteItemFrame:(BuddyStatusNoteItemFrame *)noteItemFrame;
{
    [_noteItemFrames addObject:noteItemFrame];
}

+ (NSMutableArray *)allNoteItemFrames
{
    return _noteItemFrames;
}

+ (void)removeAllNoteItemFrames
{
    [_noteItemFrames removeAllObjects];
}
@end
