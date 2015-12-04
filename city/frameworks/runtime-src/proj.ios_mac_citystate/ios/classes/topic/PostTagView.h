#import "PostTagCell.h"

@protocol PostTagViewDelegate;

@interface PostTagView : UIView<PostTagCellDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate> {
    UIImageView             *uiTagBg;
    UITextField             *uiTagField;
    NSMutableArray          *uiTagLabels;
    UICollectionView        *uiTagColl;
    UIColor                 *uiTagColor;
    int                     postTagLimit;
}
@property (strong, nonatomic) NSMutableArray      *tags;
@property (strong, nonatomic) id<PostTagViewDelegate> delegate;
@property (nonatomic, strong) UIColor * uiTagColor;
@property (nonatomic) CGFloat tagHeight;

-(void)start:(id<PostTagViewDelegate>)pDelegate :(NSString *)placeholder :(UIColor*)pColor;
@end

@protocol PostTagViewDelegate<NSObject>
@optional
- (void)PTVDreload;
@end
