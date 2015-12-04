//
//  BuddyStatusCommentInputView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import <UIKit/UIKit.h>

@class BuddyStatusCommentInputView;

@protocol BuddyStatusCommentInputViewDelegate <NSObject>
- (void)buddyStatusCommentInputView:(BuddyStatusCommentInputView *)view sendBtnDidOnClick:(UIButton *)btn;
@end

@interface BuddyStatusCommentInputView : UIView
@property (nonatomic, assign) long feedid;
- (CGFloat)addedHeight;
- (void)quit;
@property (nonatomic, weak) id<BuddyStatusCommentInputViewDelegate> delegate;
@end