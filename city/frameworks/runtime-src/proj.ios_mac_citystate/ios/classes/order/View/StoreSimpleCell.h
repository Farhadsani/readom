//
//  StoreSimpleCell.h
//  citystate
//
//  Created by hf on 15/10/13.
//
//

#import <UIKit/UIKit.h>
#import "StoreSimpleIntro.h"
#import "RatingView.h"

#define k_store__simple_cell_height 110

@protocol StoreSimpleCellDelegate;

@interface StoreSimpleCell : UITableViewCell

@property (nonatomic, retain) StoreSimpleIntro * storeSimpleIntro;
@property (nonatomic, assign) id<StoreSimpleCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;

+ (instancetype)cellForTableView:(UITableView *)tableView;

- (void)setupCell;

@end

#pragma mark -
#pragma mark StoreSimpleCellDelegate

@protocol StoreSimpleCellDelegate <NSObject>

@optional
- (void)didClickCell:(StoreSimpleCell *)cell;

@end

