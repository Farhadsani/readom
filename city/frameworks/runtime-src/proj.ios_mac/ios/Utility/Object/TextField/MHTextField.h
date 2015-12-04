//
//  MHTextField.h
//
//  Created by hf on 6/13/15.
//  Copyright (c) 2015 yjmenu.com. All rights reserved.
//

//注：本对象的父视图只能是UIScrollView

#import <UIKit/UIKit.h>

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

@optional
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;

@optional
- (void)leftBarButtonClicked:(MHTextField *)textField;
- (void)rightBarButtonClicked:(MHTextField *)textField;

- (void)textFieldDidBeginEditing:(MHTextField *)textField notify:(NSNotification *)notify;
- (void)textFieldDidEndEditing:(MHTextField *)textField notify:(NSNotification *)notify;
- (void)textFieldDidChangeValue:(MHTextField *)textField notify:(NSNotification *)notify;
- (void)textFieldDidClickReturn:(MHTextField *)textField;

@end

@interface MHTextField : UITextField <UITextFieldDelegate>

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) CGPoint scrollViewContentOffset;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;

@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;

@property(nonatomic, retain) NSDictionary * inf;

- (BOOL) validate;

- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)inf;

- (void)setSuperRootView:(UIView *)view;

@end
