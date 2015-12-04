//
//  SearchBox.h
//  citystate
//
//  Created by 小生 on 15/10/25.
//
//


#import <UIKit/UIKit.h>
@class SearchBox;
@protocol SearchBoxDelegate <NSObject>

@optional

- (void)searchBar:(SearchBox *)searchBar textDidChange:(NSString *)searchText;
- (BOOL)searchBar:(SearchBox *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)searchBarSearchButtonClicked:(SearchBox *)searchBar;
- (void)searchBarCancelButtonClicked:(SearchBox *)searchBar;

@end


@interface SearchBox : UIView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *searchIconName;

@property (nonatomic, weak) id<SearchBoxDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
