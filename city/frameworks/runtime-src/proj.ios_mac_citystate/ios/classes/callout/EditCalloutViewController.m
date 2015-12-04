//
//  EditCalloutViewController.m
//  citystate
//
//  Created by 小生 on 15/10/9.
//
//

#import "EditCalloutViewController.h"
#import "UserManager.h"
#import "BRPlaceholderTextView.h"
#import "NSString+Extension.h"
#import "CalloutViewController.h"

@interface EditCalloutViewController ()
@property (nonatomic, strong) BRPlaceholderTextView *textView;
@property (nonatomic, assign) int index;

@end

@implementation EditCalloutViewController

- (void)variableInit{
    [super variableInit];
    self.textLimit = 20;
    self.placeHolder = @" 添加喊话内容";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _titleName;
    [self setupRightBackButtonItem:@"确定" img:@"" del:self sel:@selector(post)];
    
    CGRect mainRect = [[UIScreen mainScreen]bounds];
    CGFloat padding = 10;
    CGFloat calloutX = 0;
    //    CGFloat calloutW = mainRect.size.width - padding * 2;
    CGFloat calloutW = mainRect.size.width;
    CGFloat calloutH = mainRect.size.height / 7;
    
    _textView = [self createTextView:CGRectMake(calloutX, padding, calloutW, calloutH)];
    [self.contentView addSubview:_textView];
    if (self.num == 0) {
        _textView.text = [UserManager sharedInstance].callout1;
    }
    else if (self.num == 1){
        _textView.text = [UserManager sharedInstance].callout2;
    }
    else{
        _textView.text = [UserManager sharedInstance].callout3;
    }
    
    if (self.defaultText) {
        _textView.text = self.defaultText;
    }
    [self.contentView sendSubviewToBack:_textView];
}

- (BRPlaceholderTextView *)createTextView:(CGRect)frame{
    BRPlaceholderTextView *textView = [[BRPlaceholderTextView alloc] initWithFrame:frame];
    textView.placeholder = self.placeHolder;
    textView.maxTextLength = self.textLimit;
    textView.textColor = k_defaultTextColor;
    [textView setFont:[UIFont fontWithName:k_fontName_FZZY size:15.0]];
    textView.layer.cornerRadius = 3;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = k_defaultLineColor.CGColor;
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.text = [NSString stringWithFormat:@"%d字以内", (int)self.textLimit];
    maxLabel.font = [UIFont fontWithName:k_fontName_FZXY size:11];
    maxLabel.textColor = yello_color;
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    maxLabelSize = [maxLabel.text stringSize:maxLabel.font];
    maxLabel.frame = CGRectMake(CGRectGetWidth(textView.frame) - maxLabelSize.width - 5, CGRectGetHeight(textView.frame) - maxLabelSize.height, maxLabelSize.width, maxLabelSize.height);
    [self.contentView addSubview:maxLabel];
    
    return textView;
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)post{
    if (self.postUrl && self.postKey) {
        [self postOthers:self.postUrl key:self.postKey];
    }
    else{
        [self postCallout];
    }
}

- (void)postCallout{
    NSString *centent1 = [UserManager sharedInstance].callout1;
    NSString *centent2 = [UserManager sharedInstance].callout2;
    NSString *centent3 = [UserManager sharedInstance].callout3;
    
    if (self.num == 0) {
        centent1 = _textView.text;
    }else if (self.num == 1){
        centent2= _textView.text;
    }else{
        centent3 = _textView.text;
    }
    
    NSDictionary * params = @{@"content1": (centent1)?centent1:@"",
                              @"content2": (centent2)?centent2:@"",
                              @"content3": (centent3)?centent3:@""
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:k_api_shout_update,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)postOthers:(NSString *)url key:(NSString *)key{
    NSDictionary * params = @{key:_textView.text,
                              };
    NSDictionary * dict = @{@"idx":str((++self.index)%1000),
                            @"ver":[Device appBundleShortVersion],
                            @"params":params,
                            };
    NSDictionary * d = @{k_r_url:url,
                         k_r_delegate:self,
                         k_r_postData:dict,
                         };
    [[ReqEngine shared] tryRequest:d];
}

- (void)didFinishLoad:(Reqest *)req responseData:(NSData *)responseData result:(id)result{
    if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:k_api_shout_update]) {
        if (self.num == 0) {
            [UserManager sharedInstance].callout1 = _textView.text;
        }else if (self.num == 1){
            [UserManager sharedInstance].callout2 = _textView.text;
        }else{
            [UserManager sharedInstance].callout3 = _textView.text;
        }
        [self clickLeftBackButtonItem:nil];
        
        if (_passValueDelegate && [_passValueDelegate respondsToSelector:@selector(passCalloutValue:)]) {
            [_passValueDelegate passCalloutValue:_textView.text];
        }
        if (_passValueDelegate && [_passValueDelegate respondsToSelector:@selector(VC:passCalloutValue:)]) {
            [_passValueDelegate VC:self passCalloutValue:_textView.text];
        }
    }
    else if ([[req.data_dict objectOutForKey:k_r_url] hasSuffix:self.postUrl]) {
        [self clickLeftBackButtonItem:nil];
        
        if (_passValueDelegate && [_passValueDelegate respondsToSelector:@selector(passCalloutValue:)]) {
            [_passValueDelegate passCalloutValue:_textView.text];
        }
        if (_passValueDelegate && [_passValueDelegate respondsToSelector:@selector(VC:passCalloutValue:)]) {
            [_passValueDelegate VC:self passCalloutValue:_textView.text];
        }
    }
}

@end
