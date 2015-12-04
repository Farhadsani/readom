//
//  HotTagsView.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/13.
//
//

#import <UIKit/UIKit.h>

@class HotTagsView;

@protocol HotTagsViewDelegate <NSObject>
- (void)hotTagsView:(HotTagsView *)view tagDidOnClick:(NSString *)hotTagId;
@end

@interface HotTagsView : UIView
+ (instancetype)hotTagsView;
@property (nonatomic, weak) id<HotTagsViewDelegate> delegate;
@end
