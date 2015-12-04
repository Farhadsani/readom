//
//  MHTextField.m
//
//  Created by hf on 6/13/15.
//  Copyright (c) 2015 yjmenu.com. All rights reserved.
//

#import "MHTextField.h"
#import "UIView+Addtion.h"

@interface MHTextField(){
    UITextField *_textField;
    BOOL _disabled;
}

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) BOOL hasScrollView;
@property (nonatomic) BOOL invalid;

@property (nonatomic, setter = setToolbarCommand:) BOOL isToolBarCommand;
@property (nonatomic, setter = setDoneCommand:) BOOL isDoneCommand;

@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property (nonatomic , strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) NSMutableArray *textFields;


@end

@implementation MHTextField
@synthesize inf = _inf;

@synthesize required;
@synthesize scrollView;
@synthesize toolbar;
@synthesize keyboardIsShown;
@synthesize keyboardSize;
@synthesize invalid;
@synthesize rootView;
@synthesize scrollViewContentOffset;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)inf{
    if (inf) {
        _inf = [[NSDictionary alloc] initWithDictionary:inf];
    }
    self = [super initWithFrame:frame];
    if (self){
        if (inf && !_inf) {
            _inf = [[NSDictionary alloc] initWithDictionary:inf];
        }
        [self setup];
    }
    return self;
}

//- (void) awakeFromNib{
//    [super awakeFromNib];
//    [self setup];
//}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    NSLog(@"%s  %@",__FUNCTION__,self.inf);
    [self setup];
}

- (void)setup{
//    [self setTintColor:[UIColor blackColor]];
    
    if (_inf && [_inf objectOutForKey:@"delegate"] && ![[_inf objectOutForKey:@"delegate"] isKindOfClass:[NSString class]]) {
        self.textFieldDelegate = [_inf objectOutForKey:@"delegate"];
    }
    
    if (_inf && [_inf objectForKey:V_Parent_View]) {
        self.rootView = [_inf objectForKey:V_Parent_View];
    }
    
    [self markTextFieldsWithTagInView:(self.rootView) ? self.rootView : self.superview];
    
//    if (_inf && [[_inf objectOutForKey:V_ShouldCheckInputChar] integerValue] == CheckChar_YES) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self];
//    }
    if (k_NO_LESS_THAN_IOS(8)) {
        self.delegate = self;
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    }

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self];
    
    if (!_inf) {
        return;
    }
    else if (![_inf objectOutForKey:V_KeyboardLeftButton] && ![_inf objectOutForKey:V_KeyboardMiddleView] && ![_inf objectOutForKey:V_KeyboardRightButton]){
        return;
    }
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
    [toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *leftBarButton = [self creteBarButtonItem:[_inf objectOutForKey:V_KeyboardLeftButton] action:@selector(leftButtonClicked:)];
    UIBarButtonItem *middleBarButton = nil;
    if ([_inf objectOutForKey:V_KeyboardMiddleView] && [[_inf objectOutForKey:V_KeyboardLeftButton] isKindOfClass:[NSString class]] && [[_inf objectOutForKey:V_KeyboardLeftButton] length] > 0) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, ([[UIScreen mainScreen] bounds].size.width)-105, 44)];
        lab.text = [_inf objectOutForKey:V_KeyboardMiddleView];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:16.0];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        middleBarButton = [[UIBarButtonItem alloc] initWithCustomView:lab];
//        [lab release];
    }
    else{
        middleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    UIBarButtonItem *rightBarButton = [self creteBarButtonItem:[_inf objectOutForKey:V_KeyboardRightButton] action:@selector(rightButtonClicked:)];
    
    NSArray *barButtonItems = @[leftBarButton, middleBarButton, rightBarButton];
    
    toolbar.items = barButtonItems;
}

#pragma mark - click method

- (void) doneButtonIsClicked:(id)sender{
    [self setDoneCommand:YES];
    [self resignFirstResponder];
    [self setToolbarCommand:YES];
}

- (void)leftButtonClicked:(id)sender{
    [self doneButtonIsClicked:sender];
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        [self.textFieldDelegate leftBarButtonClicked:self];
    }
}

- (void)rightButtonClicked:(id)sender{
    [self doneButtonIsClicked:sender];
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(rightBarButtonClicked:)]) {
        [self.textFieldDelegate rightBarButtonClicked:self];
    }
}

- (UIBarButtonItem *)creteBarButtonItem:(id)description action:(SEL)sel{
    id title = nil;
    SEL act = sel;
    
    if (!description) {
        title = @"";
        act = nil;
    }
    else{
        title = description;
    }
    
    if ([title isKindOfClass:[NSString class]] && ((NSString *)title).length == 0) {
        act = nil;
    }
    
    UIBarButtonItem *BarButton = nil;
    if ([title isKindOfClass:[NSString class]] && [title rangeOfString:@"."].location == NSNotFound) {
        //文字
        BarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:sel];
    }
    else if ([title isKindOfClass:[UIImage class]] || ([title isKindOfClass:[NSString class]] && [title rangeOfString:@"."].location != NSNotFound)){
        //图片
        UIImage * img = nil;
        if ([title isKindOfClass:[UIImage class]]) {
            img = title;
        }
        else{
            img = [UIImage imageNamed:title];
        }
        
        if (img) {
            BarButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:sel];
        }
    }
    else if ([title isKindOfClass:[UIView class]]){
        BarButton = [[UIBarButtonItem alloc] initWithCustomView:title];
    }
    
    return BarButton;
}

- (void)markTextFieldsWithTagInView:(UIView*)view{
    if (!view) return;
    
    if (!self.textFields) {
        self.textFields = [[NSMutableArray alloc]init];
    }
    [self.textFields removeAllObjects];
    
    int index = 0;
    if ([self.textFields count] == 0){
        for(UIView *subView in view.subviews){
            if ([subView isKindOfClass:[UITextField class]]){
//                MHTextField *textField = (MHTextField*)subView;
                subView.tag = index;
                [self.textFields addObject:subView];
                index++;
            }
        }
    }
}

//- (void)setRootView:(UIView *)view{
//    if (!view) return;
//    
//    if (![view isEqual:self.superview]) {
//        [self markTextFieldsWithTagInView:view];
//    }
//}

- (void)setSuperRootView:(UIView *)view{
    if (!view) return;
    
    self.rootView = view;
    
    if (![view isEqual:self.superview]) {
        [self markTextFieldsWithTagInView:view];
    }
}

#pragma mark keyboard notification

-(void) keyboardWillShow:(NSNotification *) notification{
    if (_textField == nil) return;
    if (keyboardIsShown) return;
    if (![_textField isKindOfClass:[MHTextField class]]) return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    
    scrollViewContentOffset = scrollView.contentOffset;
    
    [self scrollToField];
    
    self.keyboardIsShown = YES;
}
-(void) keyboardDidShow:(NSNotification *) notification{
    if (_textField == nil) return;
    if (keyboardIsShown) return;
    if (![_textField isKindOfClass:[MHTextField class]]) return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    
    scrollViewContentOffset = scrollView.contentOffset;
    
    [self scrollToField];
    
    self.keyboardIsShown = YES;
}

-(void) keyboardWillHide:(NSNotification *) notification
{
    NSTimeInterval duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        if (_isDoneCommand){
//            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
        }
     }];
    
    keyboardIsShown = NO;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self];
}


- (void) nextButtonIsClicked:(id)sender
{
    NSInteger tagIndex = self.tag;
    MHTextField *textField =  [self.textFields objectAtIndex:++tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:++tagIndex];

    [self becomeActive:textField];
}

- (void) previousButtonIsClicked:(id)sender
{
    NSInteger tagIndex = self.tag;
    
    MHTextField *textField =  [self.textFields objectAtIndex:--tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:--tagIndex];
    
    [self becomeActive:textField];
}

- (void)becomeActive:(UITextField*)textField
{
    [self setToolbarCommand:YES];
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}

- (void)setBarButtonNeedsDisplayAtTag:(int)tag
{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;
    
    for (int index = 0; index < [self.textFields count]; index++) {

        UITextField *textField = [self.textFields objectAtIndex:index];
    
        if (index < tag)
            previousBarButtonEnabled |= textField.isEnabled;
        else if (index > tag)
            nexBarButtonEnabled |= textField.isEnabled;
    }
    
    if (self.previousBarButton) {
        self.previousBarButton.enabled = previousBarButtonEnabled;
    }
    if (self.nextBarButton) {
        self.nextBarButton.enabled = nexBarButtonEnabled;
    }
}

- (void) selectInputView:(UITextField *)textField
{
    if (_isDateField){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (![textField.text isEqualToString:@""]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/YY"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        [textField setInputView:datePicker];
    }
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    
    NSDate *selectedDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YY"];
    
    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
    
    [self validate];
}

- (void)scrollToField
{
    CGRect textFieldRect = _textField.frame;
    
    CGRect aRect = self.window.bounds;
    
    aRect.origin.y = -scrollView.contentOffset.y;
    if (self.toolbar) {
        aRect.size.height -= keyboardSize.height + self.toolbar.frame.size.height + 22 + 20;
    }
    else{
        aRect.size.height -= keyboardSize.height + 22 + 20;
    }
    
    CGPoint textRectBoundary = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height);
   
    UIView * sv = (self.rootView) ? self.rootView : self.superview;
    if (!CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y > 0) {
        CGPoint scrollPoint = CGPointMake(0.0, sv.frame.origin.y + _textField.frame.origin.y + _textField.frame.size.height - aRect.size.height);
        
        if (scrollPoint.y < 0) scrollPoint.y = 0;
        
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (BOOL) validate
{
    self.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
    
    if (required && [self.text isEqualToString:@""]){
        return NO;
    }
    else if (_isEmailField){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text]){
            return NO;
        }
    }
    
    if (_inf && [_inf objectForKey:V_BGColor]) {
        [self setBackgroundColor:[UIColor color:[_inf objectForKey:V_BGColor]]];
    }
    else{
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return YES;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled)
        [self setBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *) notification{
//    UITextField *textField = (UITextField*)[notification object];
    UITextField *textField = self;
    
    _textField = textField;
    
    if (_inf && [_inf objectForKey:V_BGImg_S]) {
        textField.background = [UIView getImg:[_inf objectOutForKey:V_BGImg_S]];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setBarButtonNeedsDisplayAtTag:(int)textField.tag];
    
    id sv = (self.rootView) ? self.rootView : self.superview;
    if ([sv isKindOfClass:[UIScrollView class]] && self.scrollView == nil)
        self.scrollView = (UIScrollView*)sv;
    
    [self selectInputView:textField];
    if (toolbar) {
        [self setInputAccessoryView:toolbar];
    }
    
    [self setDoneCommand:NO];
    [self setToolbarCommand:NO];
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:notify:)]) {
        [self.textFieldDelegate textFieldDidBeginEditing:self notify:notification];
    }
}

- (void)textFieldDidEndEditing:(NSNotification *) notification{
//    UITextField *textField = (UITextField*)[notification object];
    UITextField *textField = self;
    
    if (_inf && [_inf objectForKey:V_BGImg]) {
        textField.background = [UIView getImg:[_inf objectOutForKey:V_BGImg]];
    }
    
    [self validate];
    
    _textField = nil;
    
    if (_isDateField && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM/dd/YY"];
        
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:notify:)]) {
        [self.textFieldDelegate textFieldDidEndEditing:self notify:notification];
    }
}
//- (void)textFieldDidChangeValue:(NSNotification *) notification{
//    UITextField *textField = self;
//    if (_isDateField && [textField.text isEqualToString:@""] && _isDoneCommand){
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        
//        [dateFormatter setDateFormat:@"MM/dd/YY"];
//        
//        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
//    }
//    
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:textField.text attributes:@{NSForegroundColorAttributeName : [UIColor color:darkblack_color],NSKernAttributeName : @(2.3f)}];
//    [textField setAttributedText:attributedString];
//    
//    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidChangeValue:notify:)]) {
//        [self.textFieldDelegate textFieldDidChangeValue:self notify:notification];
//    }
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_inf && [[_inf objectOutForKey:V_HasLetterSpace] integerValue] == HasLetterSpace_YES) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:textField.text attributes:@{NSForegroundColorAttributeName : [UIColor color:darkblack_color],NSKernAttributeName : @(2.3f)}];
        [textField setAttributedText:attributedString];
    }
//    Info(@"%@", textField.attributedText);
//    Info(@"textField.text: %@", textField.text);
//    Info(@"string: %@", string);
//    Info(@"range: %d  %d", range.length, range.location);
//    
//    NSString * s = nil;
//    if (string.length > 0) {
//        s = [NSString stringWithFormat:@"%@%@",textField.text,string];
//        s = [s substringToIndex:range.location-range.length+1];
//    }
//    else{
//        s = [NSString stringWithFormat:@"%@",textField.text];
//        s = [s substringToIndex:range.location-range.length+1];
//    }
//    Info(@"s: %@", s);
    
//    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidChangeValue:notify:)]) {
//        [self.textFieldDelegate textFieldDidChangeValue:self notify:nil];
//    }
//    [self textFiledEditChanged:[NSNotification notificationWithName:nil object:textField]];
    return YES;
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
//    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    NSString *lang = [[[UITextInputMode activeInputModes] objectAtIndex:0] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        Info(@"zh-Hans:%@",toBeString);
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
//            Info(@"没有高亮 toBeString:%@", toBeString);
            if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidChangeValue:notify:)]) {
                [self.textFieldDelegate textFieldDidChangeValue:self notify:obj];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
//            Info(@"高亮 toBeString:%@", toBeString);
        }
    }
//     //中文输入法以外的语种情况
    else{
//        Info(@"English:%@",toBeString);
        if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidChangeValue:notify:)]) {
            [self.textFieldDelegate textFieldDidChangeValue:self notify:obj];
        }
    }
    
    
//    if (toBeString.length > 35) {
//        textField.text = [toBeString substringToIndex:35-1];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
    
    [self validate];
    
    _textField = nil;
    
    if (_isDateField && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM/dd/YY"];
        
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
    
    [self doneButtonIsClicked:nil];
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidClickReturn:)]) {
        [self.textFieldDelegate textFieldDidClickReturn:self];
    }
    return YES;
}

@end
