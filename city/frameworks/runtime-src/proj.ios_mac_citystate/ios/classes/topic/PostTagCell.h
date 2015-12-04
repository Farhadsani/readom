
@protocol PostTagCellDelegate;

@interface PostTagCell : UICollectionViewCell {
}

@property (strong, nonatomic) UILabel       *uiTagLabel;
@property (strong, nonatomic) UITextField   *uiTagField;
@property (copy, nonatomic) NSIndexPath     *indexPath;
@property (strong, nonatomic) id<PostTagCellDelegate> delegate;

-(void)startLabel:(id<PostTagCellDelegate>)pDelegate :(NSIndexPath*)pIndexPath :(NSString*)pTag :(UIColor*)pColor :(CGFloat)height;
-(void)startField:(UITextField*)pTagField;

@end

@protocol PostTagCellDelegate<NSObject>
@optional
- (void)PTGCDdelete:(NSIndexPath*)indexPath;
@end