//
//  EditCalloutViewController.h
//  citystate
//
//  Created by 小生 on 15/10/9.
//
//

#import "BaseViewController.h"
#import "UITextView+PlaceHolder.h"

@class EditCalloutViewController;
@protocol PassCalloutValueDelegate <NSObject>

@optional
- (void)passCalloutValue:(NSString *)value;

- (void)VC:(EditCalloutViewController *)vc passCalloutValue:(NSString *)value;

@end

@interface EditCalloutViewController : BaseViewController

@property (nonatomic, assign) NSInteger textLimit;      //可输入的字数限制（默认20字）
@property (nonatomic, strong) NSString * placeHolder;   //提示字符(默认： 添加喊话内容)
@property (nonatomic, strong) NSString * defaultText;      //初始化输入的字符(默认：喊话内容，注意：喊话页面，不能设置此变量)
@property (nonatomic, strong) NSString * postUrl;       //请求接口
@property (nonatomic, strong) NSString * postKey;       //请求接口中需要上传的字段名称

@property (nonatomic, strong) NSString * titleName;     //页面的Title
@property (nonatomic, assign) NSInteger num;            //专属于喊话页面参数：第几个喊话内容

@property (nonatomic, retain) id<PassCalloutValueDelegate>passValueDelegate;

@end
