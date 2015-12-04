//
//  BuddyStatusNoteThumbView.h
//  shitouren-qmap-ios
//
//  Created by 小玛依 on 15/8/21.
//  Copyright (c) 2015年 com.shitouren.qmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddyStatusNoteItem.h"

@interface BuddyStatusNoteThumbView : UIView
@property (nonatomic, strong) BuddyStatusNoteItem *noteItem;
/**
 *  返回该控件的尺寸
 */
+ (CGSize)size;
@end
