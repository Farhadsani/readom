//
//  ExponentViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/10.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

/**
 *  指数界面
 */

@protocol ExponentVCDelegate;
@interface ExponentViewController : BaseViewController

@property(nonatomic, strong) id<ExponentVCDelegate> delegate;

@end

#pragma mark -
#pragma mark ExponentVCDelegate

@protocol ExponentVCDelegate <NSObject>

@optional
- (void)ViewController:(ExponentViewController *)vc didSelectedIndexType:(MapIndexType)indexType indexID:(NSString *)indexId;

@end