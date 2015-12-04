/*
 *[发表]页面
 *功能：发表说说、标签、位置标签、添加图片、显示完成度
 *调用相册库、拍照。
 */
#import "BaseViewController.h"
#import "PostThumbCell.h"
#import "PostTagView.h"
#import "TopicItem.h"
#import "UITextView+Placeholder.h"
#import "ASProgressPopUpView.h"
#import "ZYQAssetPickerController.h"
#import "PlaceTagViewController.h"

@interface PostViewController : BaseViewController <UIActionSheetDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PostThumbCellDelegate,PostTagViewDelegate, ZYQAssetPickerControllerDelegate,PlaceTagVCDelegate>{
    
}
@property (strong, nonatomic) TopicItem     *note;

@end

