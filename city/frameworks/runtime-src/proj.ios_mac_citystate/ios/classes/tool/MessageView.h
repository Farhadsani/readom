//
//  MessageView.h
//  qmap
//
//  Created by 石头人6号机 on 15/9/8.
//
//

#import <Foundation/Foundation.h>

@interface MessageView : NSObject
+ (void)showMessageView:(NSString *)msg delayTime:(NSTimeInterval)time;
+ (void)showMessageView:(NSString *)msg;
+ (void)hiddenMessageView;
@end
