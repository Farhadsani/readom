//
//  MyStoreGoodsSelectImgView.m
//  citystate
//
//  Created by 石头人6号机 on 15/10/30.
//
//

#import "MyStoreGoodsSelectImgView.h"
#import "UIButton+WebCache.h"

#define MyStoreGoodsSelectImgViewFont [UIFont fontWithName:k_fontName_FZZY size:15]

@interface MyStoreGoodsSelectImgView ()
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (retain, nonatomic) IBOutlet UIImageView *deleteIcon;
@end

@implementation MyStoreGoodsSelectImgView
+ (instancetype)myStoreGoodsSelectImgView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyStoreGoodsSelectImgView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    CALayer *layer = self.iconBtn.layer;
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;
    self.addBtn.titleLabel.font = MyStoreGoodsSelectImgViewFont;
    [self.addBtn setTitleColor:gray_color forState:UIControlStateNormal];
}

- (void)setStoreGoodsDetail:(StoreGoodsDetail *)storeGoodsDetail
{
    _storeGoodsDetail = storeGoodsDetail;
    
    if(storeGoodsDetail.imglink) {
        [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:storeGoodsDetail.imglink] forState:UIControlStateSelected];
        self.iconBtn.selected = YES;
        self.deleteIcon.hidden = NO;
        self.addBtn.hidden = YES;
    } else {
        self.deleteIcon.hidden = YES;
    }
}

- (IBAction)addBtnDidOnClik
{
    if (self.iconBtn.selected) {
        self.image = nil;
        self.storeGoodsDetail.imglink = @"";
        self.iconBtn.selected = NO;
        self.deleteIcon.hidden = YES;
        self.addBtn.hidden = NO;
    } else {
        if ([self.delegate respondsToSelector:@selector(myStoreGoodsSelectImgViewAddBtnDidOnClik:)]) {
            [self.delegate myStoreGoodsSelectImgViewAddBtnDidOnClik:self];
        }
    }
}

- (void)setThumb:(UIImage *)thumb
{
    _thumb = thumb;
    
    if (thumb != nil) {
        [self.iconBtn setImage:thumb forState:UIControlStateSelected];
        self.iconBtn.selected = YES;
        self.deleteIcon.hidden = NO;
        self.addBtn.hidden = YES;
    }
}
@end
