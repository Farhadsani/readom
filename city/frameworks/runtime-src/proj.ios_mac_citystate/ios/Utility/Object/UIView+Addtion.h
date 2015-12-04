//
//  UIView+Addtion.h
//  
//
//  Created by hf on 14-1-17.
//  Copyright (c) 2014年 hf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextField.h"

@interface ImgControl : UIControl
@property(nonatomic, retain) id customView;

@end

#define kAlphaViewTag 8323


@interface UIView (Addtion)

- (void)addAlphaView:(UIColor *)backgroundColor alpha:(CGFloat)alphaNmu;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
+ (BOOL)isViewClass:(id)obj;
+ (BOOL)isViewControllerClass:(id)obj;

//容器
+ (UITextView *)textView:(NSDictionary *)inf;
+ (UIView *)view_sub:(NSDictionary *)inf;
+ (UIScrollView *)scrollView:(NSDictionary *)inf;
+ (UIControl *)control:(NSDictionary *)inf;

+ (UILabel *)label:(NSDictionary *)inf;
+ (UIImageView *)imageView:(NSDictionary *)inf;
+ (UITextField *)textFiled:(NSDictionary *)inf;
+ (UIButton *)button:(NSDictionary *)inf;

+ (UIImage *)getImg:(id)obj;

- (void)resetFrameHeightOfView:(UIView *)view;
- (void)resetFrameWidthOfView:(UIView *)view;

@end

/**************************** common ****************************/

#define V_Common_Style @"common_style"      //公共的样式，只允许字典类型，用于组合样式，减少重复代码

#define V_Root_VC @"root_viewController"    //当前的viewController

#define V_Parent_View @"parent_view"        //父view

#define V_Last_View @"last_view"            //上一个view
#define V_Next_View @"next_view"            //下一个view
#define V_Left_View @"left_view"            //左边的view
#define V_Right_View @"right_view"          //右边的view

#define V_Frame @"frame"                    //创建的view的frame，优先级最高

//控制view本身的的位置和大小，默认margin值都相对于父view
//不支持百分比
//例外情况1：当有@"last_view"值时，@"margin_top"值表示相对于上一个view
//例外情况2：当有@"next_view"值时，@"margin_bottom"值表示相对于上一个view
//例外情况3：当有@"left_view"值时，@"margin_left"值表示相对于左边的view
//例外情况4：当有@"right_view"值时，@"margin_right"值表示相对于左边的view
#define V_Margin @"margin"
#define V_Margin_Left @"margin_left"
#define V_Margin_Right @"margin_right"
#define V_Margin_Top @"margin_top"
#define V_Margin_Bottom @"margin_bottom"

//优先级次于frame
//支持百分比
//如果没有设置frame、width，有@"last_view"，则继承上一个view的width
//如果没有设置frame、width，有@"left_view"，则w为屏幕宽度 减 左边的view的宽度
//如果没有@"last_view"，没有@"left_view"，则继承屏幕width
#define V_Width @"width"
#define V_Height @"height"                  //如果没有height值，没有frame值，有@"last_view"，则继承上一个view的height

//与width结合使用，优先级高于“margin与左右的view结合使用”，当width值为百分比时，需要设置parent_view值
//OverFlow=OverFlowLeft时，margin_left有效，向右偏移margin_left值
//OverFlow=OverFlowRight时，margin_right有效，向左偏移margin_right值
#define V_Over_Flow_X @"over_flow_x"
typedef enum OverFlowX{
    OverFlowLeft = 0,
    OverFlowXCenter,
    OverFlowRight
}OverFlowX;

//与height结合使用，优先级高于“margin与上下的view结合使用”，当height值为百分比时，需要设置parent_view值
//OverFlow=OverFlowTop时，margin_top有效，向下偏移margin_top值
//OverFlow=OverFlowBottom时，margin_bottom有效，向上偏移margin_bottom值
#define V_Over_Flow_Y @"over_flow_y"
typedef enum OverFlowY{
    OverFlowTop = 0,
    OverFlowYCenter,
    OverFlowBottom
}OverFlowY;


//控制view的透明度
#define V_Alpha @"alpha"

//控制view的标记
#define V_Tag @"tag"

#define V_Hidden @"hidden"
typedef enum Hidden{
    HiddenNO = 0,
    HiddenYES
}Hidden;

//控制view是否可以响应事件
#define V_Click_Enable @"ClickEnabled"
typedef enum ClickEnabled{
    Click_Yes = 0,
    Click_No
}ClickEnabled;

//控制view的边框
#define V_Border_Color @"borde_color"
#define V_Border_Width @"border_width"
#define V_Border_Radius @"border_radius"

//控制view上显示的文字颜色和字体
#define V_Color @"color"
#define V_Color_S @"color_selected"
#define V_Color_C @"color_clicked"
#define V_Color_Enable @"color_enable"

#define V_Font @"font"

#define V_Font_Size @"font_size"
#define V_Font_Family @"font_family"
#define V_Font_Weight @"font_weight"    //字体粗细(默认细体)
typedef enum FontWeight{
    FontWeightNormal = 0,
    FontWeightBold
}FontWeight;

#define V_tintColor @"tintColor"

//控制view的背景颜色
#define V_BGColor @"backgroundColor"   //正常情况
#define V_BGColor_S @"backgroundColor_selected" //选中时
#define V_BGColor_C @"backgroundColor_clicked"  //点击时

//控制view的背景图片(值都为图片名称)
#define V_BGImg @"backgroundImage"
#define V_BGImg_S @"backgroundImage_selected"
#define V_BGImg_C @"backgroundImage_clicked"
#define V_BGImg_Unabled @"backgroundImage_unabled"

/**************************** label textFiled ****************************/
//控制view的内部子视图的位置偏移(label、button、textField、imageView)，不改变view本身的位置和大小
//不支持百分比
#define V_Padding @"padding"
#define V_Padding_Left @"padding_left"
#define V_Padding_Right @"padding_right"
#define V_Padding_Top @"padding_top"
#define V_Padding_Bottom @"padding_bottom"

/**************************** button ****************************/
#define V_ContentEdge @"contentEdge"    //按钮上的所有内容偏移
#define V_TitleEdge @"titleEdge"    //按钮上的title偏移
#define V_ImageEdge @"imageEdge"    //按钮上的image偏移

/**************************** label textFiled ****************************/
#define V_Text @"text"
#define V_Text_S @"text_selected"
#define V_Text_C @"text_clicked"

/**************************** textFiled ****************************/
#define V_HasLetterSpace @"HasLetterSpace"  //字符之间含有间隔（注意：如果有间隔，则不能一边输入字符一边检测字符）
typedef enum HasLetterSpace{
    HasLetterSpace_NO = 0,
    HasLetterSpace_YES
}HasLetterSpace;

#define V_ShouldCheckInputChar @"ShouldCheckInputChar"  //是否能一边输入字符一边检测字符
typedef enum ShouldCheckInputChar{
    CheckChar_NO = 0,
    CheckChar_YES
}ShouldCheckInputChar;

#define V_PlaceHoldTextColor @"placeHoldTextColor"
#define V_PlaceHoldTextFont @"placeHoldTextFont"

/**************************** label button ****************************/
#define V_NumberLines @"numberLines"

/**************************** control button ****************************/
#define V_Title @"title"
#define V_Title_S @"title_selected"
#define V_Title_C @"title_clicked"
#define V_Selected @"selected"                      //按钮当前是否是选中状态(默认未选中；0:未选中，1：已选中)
typedef enum Selected{
    SelectedNO = 0,
    SelectedYES
}Selected;
#define V_SEL @"SEL_action"                         //回调函数
#define V_Delegate @"delegate"                      //回调代理对象


/**************************** button imageView ****************************/
#define V_Img @"image"
#define V_Img_S @"image_selected"
#define V_Img_C @"image_clicked"

/**************************** imageView ****************************/
#define V_ContentMode @"contentMode"
typedef enum ContentMode{
    ModeFill = 0,
    ModeAspectFit,
    ModeAspectFill,
    ModeLeft,
    ModeCenter,
    ModeRight,
    ModeTop,
    ModeBottom
}ContentMode;

#define V_AnimationImages @"AnimationImages"
#define V_Duration @"Duration"
#define V_RepeatCount @"RepeatCount"

/**************************** textFiled ****************************/
#define V_Placeholder @"placeholder"
#define V_LeftImage @"leftImage"
#define V_LeftText @"leftTitle"
#define V_RightImage @"rightImage"

#define V_LeftImageMarginLeft @"leftImageMarginLeft"
#define V_LeftTextMarginLeft @"leftTextMarginLeft"

#define V_IsSecurity @"isSecurity"
typedef enum IsSecurity{
    SecurityNO = 0,
    SecurityYES
}IsSecurity;
#define V_KeyboardType @"keyboardType"
typedef enum KeyboardType{
    SysKeyboardDefault = 0,
    Number,
    Email,
    Url
}KeyboardType;
#define V_ReturnKeyType @"returnKeyType"
typedef enum ReturnKeyType{
    SysReturnKeyDefault = 0,
    Go,
    Next,
    Search,
    Done,
    Send
}ReturnKeyType;

#define V_KeyboardLeftButton @"keyboardLeftButton"
#define V_KeyboardRightButton @"keyboardRightButton"
#define V_KeyboardMiddleView @"keyboardMiddleView"
#define V_KeyboardBottomView @"keyboardBottomView"


/**************************** label button ****************************/
#define V_TextAlign @"textAlign"//label的text居中方式
typedef enum TextAlign{
    TextAlignLeft = 0,
    TextAlignCenter,
    TextAlignRight
}TextAlign;

#define V_HorizontalAlign @"HorizontalAlignment"    //button的内容title（image）水平居中
typedef enum HorizontalAlignment{
    HorizontalLeft = 0,
    HorizontalCenter,
    HorizontalRight
}HorizontalAlignment;

#define V_VerticalAlign @"VerticalAlignment"        //button的内容title（image）垂直居中
typedef enum VerticalAlignment{
    VerticalTop = 0,
    VerticalCenter,
    VerticalBottom
}VerticalAlignment;

