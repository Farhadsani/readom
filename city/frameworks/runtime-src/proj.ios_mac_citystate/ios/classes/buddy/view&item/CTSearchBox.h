//
//  CTSearchBox.h
//  citystate
//
//  Created by 小生 on 15/10/25.
//
//


#import <UIKit/UIKit.h>
@class CTSearchBox;
@protocol CTSearchBoxDelegate <NSObject>

@optional

- (void)searchBar:(CTSearchBox *)searchBar textDidChange:(NSString *)searchText;
- (BOOL)searchBar:(CTSearchBox *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)searchBarSearchButtonClicked:(CTSearchBox *)searchBar;
- (void)searchBarCancelButtonClicked:(CTSearchBox *)searchBar;

@end

@interface CTSearchBox : UIView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *cancelBtnName;

@property (nonatomic, copy) NSString *searchIconName;

@property (nonatomic, weak) id<CTSearchBoxDelegate>delegate;

//@property (nonatomic, copy) NSString *searchContent;

- (instancetype)initWithFrame:(CGRect)frame;

- (NSString *)getSearchContent;

- (void)resignTextField;

@end
