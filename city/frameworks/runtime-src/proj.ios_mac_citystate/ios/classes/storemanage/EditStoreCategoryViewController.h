//
//  EditStoreCategoryViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/11/3.
//
//

#import "BaseViewController.h"

@protocol EditStoreCategoryVCDelegate <NSObject>

- (void)didChangeStoreCategory:(NSArray *)categorys;

@end

@interface EditStoreCategoryViewController : BaseViewController

@property (nonatomic, retain) id<EditStoreCategoryVCDelegate> delegate;

@end
