//
//  BuddyTopButton.m
//  qmap
//
//  Created by hf on 15/9/10.
//
//

#import "BuddyTopButton.h"

@implementation BuddyTopButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title number:(NSInteger)num tag:(NSInteger)tg{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.tag = tg;
        self.title = @"";
        self.num = 0;
        self.buttonWidth = frame.size.width;
        self.selected = NO;
        if (![NSString isEmptyString:title]) {
            self.title = title;
        }
        if (num >= 0) {
            self.num = num;
        }
        
        [self setupMainView];
    }
    return self;
}

#pragma mark - life Cycle
//- (void)drawRect:(CGRect)rect {
//    [self setupMainView];
//}

- (void)updateUI{
    [self setupMainView];
}

- (void)selected:(BOOL)isSelected{
    self.selected = isSelected;
    [_containButton setSelected:isSelected];
    
    if (self.selected) {
        _containButton.layer.borderColor = [UIColor color:green_color].CGColor;
        _containButton.layer.borderWidth = 1.0;
    }
    else{
        _containButton.layer.borderWidth = 0;
    }
}

- (void)num:(NSInteger)num{
    self.num = num;
    numLabel.text = str(self.num);
    
    if (self.num <= 0) {
        titleLabel.frame = CGRectMake(0, 0, _containButton.width, _containButton.height);
        numLabel.frame = CGRectMake(numLabel.x, 0, 0, _containButton.height);
    }
}

- (void)selected:(BOOL)isSelected num:(NSInteger)num{
    self.num = num;
    numLabel.text = str(self.num);
    
    [self selected:isSelected];
    
    if (self.num <= 0) {
        titleLabel.frame = CGRectMake(0, 0, _containButton.width, _containButton.height);
        numLabel.frame = CGRectMake(numLabel.x, 0, 0, _containButton.height);
    }
}


#pragma mark - delegate (CallBack)

#pragma mark request delegate callback

#pragma mark other delegate callback

#pragma mark - action such as: click touch tap slip ...

#pragma mark - request method

#pragma mark - init & dealloc
- (void)setupMainView{
    [self removeAllSubviews];
    
    CGFloat x = (self.width - self.buttonWidth)/2.0;
    CGFloat height = 23;
    CGFloat y = (self.height - height)/2.0;
    CGFloat width = self.buttonWidth;
    
    self.containButton = [UIView button:@{V_Parent_View:self,
                                          V_Frame:rectStr(x, y, width, height),
                                          V_Selected:num((self.selected)?@1:@0),
                                          V_Click_Enable:num(Click_No),
                                          V_Border_Color:green_color,
                                          V_Border_Radius:strFloat(height/2.0),
                                          V_Border_Width:@0,
                                          }];
    [self addSubview:_containButton];
    
    CGFloat titleFontsize = 14.0;
    CGFloat numFontsize = 13.0;
    UIFont * titleFont = [UIFont fontWithName:k_fontName_FZZY size:titleFontsize];
    UIFont * numFont = [UIFont fontWithName:k_fontName_FZXY size:numFontsize];
    CGFloat titleWidth = [self.title sizeWithAttributes:@{NSFontAttributeName:titleFont}].width+3;
    CGFloat numWidth = [str(self.num) sizeWithAttributes:@{NSFontAttributeName:numFont}].width+3;
    CGFloat space = (_containButton.width - titleWidth - numWidth) / 2.0;
    if (space < 0) {
        space = 0;
    }
    
    if (self.num <= 0) {
        space = 0;
        numWidth = 0;
        titleWidth = _containButton.width;
    }
    
    titleLabel = [UIView label:@{V_Parent_View:_containButton,
                                 V_Frame:rectStr(space, 0, titleWidth, _containButton.height),
                                 V_Text:self.title,
                                 V_Font_Size:strFloat(titleFontsize),
                                 V_Color:green_color,
                                 V_Font:titleFont,
                                 V_TextAlign:num(TextAlignCenter),
                                 }];
    [_containButton addSubview:titleLabel];
    
    numLabel = [UIView label:@{V_Parent_View:_containButton,
                               V_Frame:rectStr(titleLabel.x+titleLabel.width, 0, numWidth, _containButton.height),
                               V_Text:str(self.num),
                               V_Font_Size:strFloat(numFontsize),
                               V_Font:numFont,
                               V_Color:darkZongSeColor,
                               V_TextAlign:num(TextAlignCenter),
                               }];
    [_containButton addSubview:numLabel];
}

#pragma mark - other method
#pragma mark

@end
