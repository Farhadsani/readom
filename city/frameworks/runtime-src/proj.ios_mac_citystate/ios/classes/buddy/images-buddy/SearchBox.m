//
//  SearchBox.m
//  citystate
//
//  Created by 小生 on 15/10/25.
//
//

#import "SearchBox.h"

@interface SearchBox () <UITextFieldDelegate> {
    UIView      *_searchView;
    UIImageView *_searchImageView;
    UITextField *_searchTextField;
    UIButton    *_cancelButton;
}

@end

@implementation SearchBox

- (void)dealloc {
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectZero];
        searchView.layer.masksToBounds = YES;
        searchView.layer.cornerRadius = 13;
        searchView.backgroundColor = [UIColor clearColor];
        [self addSubview:searchView];
        _searchView = searchView;
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = @"搜索全部关注";
        [searchView addSubview:textField];
        _searchTextField = textField;
        

        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44 - 16, 44 - 16)];
        leftImageView.image = [UIImage imageNamed:@"search_bar"];
        leftImageView.contentMode = UIViewContentModeCenter;
        _searchImageView = leftImageView;
        
        textField.leftView = leftImageView;
        textField.leftViewMode = UITextFieldViewModeAlways;
                
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _cancelButton = button;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _searchView.frame = CGRectMake(0, 8, CGRectGetWidth(self.bounds) - 55, 44 - 16);
    _searchTextField.frame = CGRectMake(0, 0, CGRectGetWidth(_searchView.bounds), 44 - 16);
    _cancelButton.frame = CGRectMake(CGRectGetMaxX(_searchView.frame), 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(_searchView.frame), 44);
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _searchTextField.placeholder = placeholder;
}

- (void)setSearchIconName:(NSString *)searchIconName {
    _searchIconName = searchIconName;
    _searchImageView.image = [UIImage imageNamed:searchIconName];
}

- (void)textDidChange:(UITextField *)textField {
    UITextRange *markedTextRange = [textField markedTextRange];
    NSString *text = [textField textInRange:markedTextRange];
    //获取输入待确认部分
    if(text.length > 0) {
        return;
    }
    //    NSLog(@"%@",textFild);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField               // called when 'return' key pressed. return NO to ignore.
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}



@end
