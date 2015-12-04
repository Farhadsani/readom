/****************************************************************************
 Copyright (c) 2010-2011 cocos2d-x.org
 Copyright (c) 2010      Ricardo Quesada
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "RootViewController.h"
#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#include "ConfigParser.h"

@interface RootViewController (){
    UIView * bar;
    UILabel * navTitleLab;
    UIButton * leftBtnItem;
    UIButton * rightBtnItem;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.forceHiddenNavAndTabbar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    InfoLog(@"navigationBar.frame:%@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self show];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (bar) {
        [self.view bringSubviewToFront:bar];
    }
    
    [self show];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([((UINavigationController *)self.navigationController).viewControllers count] > 1) {
        [self hideTabBar:YES animation:YES];
    }
}

- (void)show{
    if (self.forceHiddenNavAndTabbar) {
        return;
    }
    [self hideTabBar:NO animation:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (ConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationIsLandscape( interfaceOrientation );
    }else{
        return UIInterfaceOrientationIsPortrait( interfaceOrientation );
    }
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    if (ConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
//        return UIInterfaceOrientationMaskPortraitUpsideDown;
        return UIInterfaceOrientationMaskPortrait;
    }
#endif
}

- (BOOL) shouldAutorotate {
    if (ConfigParser::getInstance()->isLanscape()) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    cocos2d::GLView *glview = cocos2d::Director::getInstance()->getOpenGLView();

    if (glview)
    {
        CCEAGLView *eaglview = (CCEAGLView*) glview->getEAGLView();

        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden
{
    return NO;
}



- (void)setupLeftButton:(NSString *)leftTitle
                leftImg:(UIImage *)leftImg
                leftSEL:(SEL)leftAction
               navTitle:(NSString *)title
            rightButton:(NSString *)rightTitle
               rightImg:(UIImage *)rightImg
               rightSEL:(SEL)rightAction
{
    if (!bar && !bar.superview) {
        bar = [UIView view_sub:@{V_Parent_View:self.view,
                                 V_Height:@64,
                                 V_BGColor:clear_color,
                                 V_Tag:num(k_NavBarTag),
                                 }];
        [bar addAlphaView:[UIColor color:yello_color] alpha:0.9],
        [self.view addSubview:bar];
    }
    
    if (!navTitleLab) {
        navTitleLab = [UIView label:@{V_Frame:rectStr(0, 20, bar.width, 44),
                                      V_Text:@"",
                                      V_Color:darkblack_color,
                                      V_Font_Size:num(18),
                                      V_Font_Family:k_fontName_FZZY,
                                      V_TextAlign:num(TextAlignCenter),
                                      }];
        [bar addSubview:navTitleLab];
    }
    if (title) {
        navTitleLab.text = title;
    }
    
    if (!leftBtnItem) {
        leftBtnItem = [UIView button:@{V_Frame:rectStr(10, 20, 50, 44),
                                       V_Title:@"",
                                       V_Img:@"",
                                       V_Color:darkblack_color,
                                       V_Font_Size:num(14),
                                       V_Font_Family:k_fontName_FZZY,
                                       V_Delegate:self,
                                       V_SEL:selStr(leftAction),
                                       V_HorizontalAlign:num(HorizontalCenter),
                                       V_VerticalAlign:num(VerticalCenter),
                                       }];
        [bar addSubview:leftBtnItem];
    }
    
    if (leftTitle) {
        CGFloat wid = [leftTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width+5;
        leftBtnItem.frame = CGRectMake(leftBtnItem.x, leftBtnItem.y, wid, leftBtnItem.height);
        [leftBtnItem setTitle:leftTitle forState:UIControlStateNormal];
    }
    if (leftImg){
        [leftBtnItem setImage:leftImg forState:UIControlStateNormal];
    }
    
    
    if (!rightBtnItem) {
        rightBtnItem = [UIView button:@{V_Frame:rectStr(bar.width - 50 - 10, 20, 50, 44),
                                        V_Title:@"",
                                        V_Img:@"",
                                        V_Color:darkblack_color,
                                        V_Font_Size:num(14),
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Delegate:self,
                                        V_SEL:selStr(rightAction),
                                        V_HorizontalAlign:num(HorizontalCenter),
                                        V_VerticalAlign:num(VerticalCenter),
                                        }];
        [bar addSubview:rightBtnItem];
    }
    
    if (rightTitle) {
        CGFloat wid = [rightTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width+5;
        rightBtnItem.frame = CGRectMake(bar.width - wid - 10, rightBtnItem.y, wid, rightBtnItem.height);
        [rightBtnItem setTitle:rightTitle forState:UIControlStateNormal];
    }
    if (rightImg){
        [rightBtnItem setImage:rightImg forState:UIControlStateNormal];
    }
    
    [self.view bringSubviewToFront:bar];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
