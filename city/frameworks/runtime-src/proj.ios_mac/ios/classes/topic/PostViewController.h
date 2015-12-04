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

@interface PostViewController : BaseViewController <UIActionSheetDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PostThumbCellDelegate,PostTagViewDelegate, ZYQAssetPickerControllerDelegate>
{
    UIScrollView            *uiContainer;
    UIImageView             *uiPostBg;
    UITextView              *uiPostView;
    UICollectionView        *uiThumbColl;
    ASProgressPopUpView     *uiProgress;
    UILabel                 *uiComplete;
    
    NSMutableArray          *urls;
    NSMutableArray          *thumbs;
    
    PostTagView             *uiTagView;
    PostTagView             *uiPlaceView;
    
    UIButton                *uiPostBtn;
    int                     numInSection;
    int                     postImgLimit;
    int                     postTextLimit;
}
@property (strong, nonatomic) TopicItem     *note;
@property (assign, atomic)    int index;

@end

