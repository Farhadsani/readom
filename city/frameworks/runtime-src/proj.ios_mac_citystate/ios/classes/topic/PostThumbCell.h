/*
 *[发表]中添加图片的控件
 *
 */
#import "UIImageView+WebCache.h"

@protocol PostThumbCellDelegate;

@interface PostThumbCell : UICollectionViewCell {
}
@property (strong, nonatomic) UIButton      *uiAddPhotoBtn;
@property (strong, nonatomic) UIImageView   *uiImgView;
@property (copy, nonatomic) NSIndexPath     *indexPath;
@property (strong, nonatomic) id<PostThumbCellDelegate> delegate;

-(void)startImg:(UIImage*)pImg :(NSIndexPath*)pIndexPath;
-(void)startBtn:(id<PostThumbCellDelegate>)pDelegate :(NSIndexPath*)pIndexPath;
@end

@protocol PostThumbCellDelegate<NSObject>
@optional
- (void)PTHCDadd;
- (void)PTHCDdelete:(NSIndexPath*)indexPath;
@end
