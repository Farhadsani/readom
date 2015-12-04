//
//  OrderCommentViewController.h
//  citystate
//
//  Created by hf on 15/10/15.
//
//

/**
 *  发表评论
 */

#import "BaseViewController.h"
#import "OrderIntro.h"
#import "PostThumbCell.h"
#import "UITextView+Placeholder.h"
#import "ZYQAssetPickerController.h"
#import "RatingView.h"

@protocol OrderCommentVCDelegate;
@interface OrderCommentViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ZYQAssetPickerControllerDelegate,PostThumbCellDelegate, RatingViewDelegate>

@property (nonatomic, retain) OrderIntro * orderIntro;
@property (nonatomic, assign) id<OrderCommentVCDelegate> delegate;

@end


#pragma mark -
#pragma mark OrderCommentVCDelegate

@protocol OrderCommentVCDelegate <NSObject>

@optional
- (void)OrderCommentViewController:(OrderCommentViewController *)vc data:(OrderIntro*)orderIntro;

@end

