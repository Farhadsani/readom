//
//  BuddyTopButton.h
//  qmap
//
//  Created by hf on 15/9/10.
//
//

#import <UIKit/UIKit.h>

@interface BuddyTopButton : UIControl{
    UILabel * titleLabel;
    UILabel * numLabel;
}
@property(nonatomic, retain) UIButton * containButton;
@property(nonatomic, retain) NSString * title;
@property(nonatomic) NSInteger num;
@property(nonatomic) CGFloat buttonWidth;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title number:(NSInteger)num tag:(NSInteger)tg;

- (void)updateUI;

- (void)selected:(BOOL)isSelected;
- (void)num:(NSInteger)num;
- (void)selected:(BOOL)isSelected num:(NSInteger)num;

@end
