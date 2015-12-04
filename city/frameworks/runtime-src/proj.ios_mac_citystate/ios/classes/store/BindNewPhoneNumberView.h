//
//  BindNewPhoneNumber.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/17.
//
//

#import <UIKit/UIKit.h>

@class BindNewPhoneNumberView;

@protocol BindNewPhoneNumberViewDelegate <NSObject>
- (void)bindNewPhoneNumberView:(BindNewPhoneNumberView *)view withSuccessPhoneNumber:(NSString *)phone;
@end

@interface BindNewPhoneNumberView : UIView
+ (instancetype)bindNewPhoneNumberView;
@property (nonatomic, weak) id<BindNewPhoneNumberViewDelegate> delegate;
@end
