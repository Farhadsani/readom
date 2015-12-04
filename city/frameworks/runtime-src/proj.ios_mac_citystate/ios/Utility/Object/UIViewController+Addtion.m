//
//  UIView+Category.m
//  
//
//  Created by hf on 13-7-1.
//  Copyright (c) 2015年 shitouren. All rights reserved.
//

#import "UIView+Addtion.h"
#import "WebViewController.h"

@implementation UIViewController (Addtion)

#pragma mark - web view
//webView打开页面
- (void)openWebView:(NSString *)urlStr localXml:(NSString *)path title:(NSString *)title otherInfo:(NSDictionary *)info{
    WebViewController * webVC = [[[WebViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    if (![NSString isEmptyString:title]) {
        webVC.title = title;
        [webVC.myTitle setString:title];
    }
    
    if (![NSString isEmptyString:urlStr]) {
        [webVC.urlString setString:urlStr];
    }
    else if (![NSString isEmptyString:path]){
        [webVC.localXmlPath setString:path];
    }
    
    if (info) {
        [webVC.otherInfo removeAllObjects];
        [webVC.otherInfo setNonEmptyValuesForKeysWithDictionary:info];
        
        NSString * openType = ([info objectOutForKey:@"openType"])?[info objectOutForKey:@"openType"]:@"push";
        if ([openType isEqualToString:@"present"]) {
            webVC.isNavBarHidden = YES;
            webVC.isPush = NO;
            [self presentViewController:webVC animated:YES completion:^{
                
            }];
        }
        else if ([openType isEqualToString:@"push"]) {
            if (self.navigationController) {
                NSString * hidNav = ([info objectOutForKey:@"hidNav"])?[info objectOutForKey:@"hidNav"]:@"NO";
                webVC.isNavBarHidden = ([hidNav isEqualToString:@"YES"])?YES:NO;
                webVC.isPush = YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
            else{
                webVC.isNavBarHidden = YES;
                webVC.isPush = NO;
                [self presentViewController:webVC animated:YES completion:^{
                    
                }];
            }
        }
    }
    else{
        if (self.navigationController) {
            webVC.isNavBarHidden = NO;
            webVC.isPush = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else{
            webVC.isNavBarHidden = YES;
            webVC.isPush = NO;
            [self presentViewController:webVC animated:YES completion:^{
                
            }];
        }
    }
}

- (void)callTelephone:(NSString *)teleNumber{
    if (teleNumber.length > 0 && [teleNumber rangeOfString:@"null"].location == NSNotFound) {
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"拨打" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"电话" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@":" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"：" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"," withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"，" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@"_" withString:@""];
        teleNumber = [teleNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * number = [NSString stringWithFormat:@"tel://%@", teleNumber];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:number]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"该号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"该号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

//利用webview打电话，打完会回到原应用程序
//- (void)tel
//{
//    // 提示：不要将webView添加到self.view，如果添加会遮挡原有的视图
//    // 懒加载
//    if (_webView == nil) {
//        _webView = [[UIWebView alloc] init];
//    }
//    NSLog(@"%p", _webView);
//    
//    //    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    //    [self.view addSubview:_webView];
//    
//    NSURL *url = [NSURL URLWithString:@"tel://10010"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    [_webView loadRequest:request];
//}

- (void)sendmail:(id<MFMailComposeViewControllerDelegate>)del{
    // 1. 先判断能否发送邮件
//    if (![MFMailComposeViewController canSendMail]) {
//        // 提示用户设置邮箱
//        return;
//    }
    
    // 2. 实例化邮件控制器，准备发送邮件
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    // 1) 主题 xxx的工作报告
    [controller setSubject:@"我的工作报告"];
    // 2) 收件人
    [controller setToRecipients:@[@"4800607@gmail.com"]];
    
    // 3) cc 抄送
    // 4) bcc 密送(偷偷地告诉，打个小报告)
    // 5) 正文
    [controller setMessageBody:@"这是我的<font color=\"blue\">工作报告</font>，请审阅！<BR />P.S. 我的头像牛X吗？" isHTML:YES];
    
    // 6) 附件
    UIImage *image = [UIImage imageNamed:@"头像1.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    // 1> 附件的二进制数据
    // 2> MIMEType 使用什么应用程序打开附件
    // 3> 收件人接收时看到的文件名称
    // 可以添加多个附件
    [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"头像.png"];
    
    // 7) 设置代理
    [controller setMailComposeDelegate:del];
    
    // 显示控制器
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)setBackButtonDescription:(NSString *)str{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = (str)?str:@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
}

- (void)setupLeftBackButtonItem:(NSString *)str img:(NSString *)imgName action:(SEL)action{
    NSString * iname = nil;
    UIColor * titleColor = [UIColor color:darkblack_color];
    iname = @"base-back";
    if (imgName) {
        iname = imgName;
    }
    UIImage * img = [UIImage imageNamed:iname];
    
    CGFloat navHeight = k_DEFAULT_NAVIGATION_BAR_HEIGHT;
    UIButton * leftButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButtonItem.frame = CGRectMake(0, 0, 80, navHeight);
    leftButtonItem.backgroundColor = [UIColor color:clear_color];
    
    UIImageView * imgv = [UIView imageView:@{V_Frame:rectStr(0, 0, (img)?20:0, navHeight),
                                             V_Img:(img)?img:@"",
                                             V_ContentMode:num(ModeLeft)}];
    [leftButtonItem addSubview:imgv];
    
    NSString * title = nil;
//    if (self.navigationController && [self.navigationController.viewControllers containsObject:self]) {
//        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
//        if (index >= 1) {
//            id vc = [self.navigationController.viewControllers objectAtExistIndex:index-1];
//            if (vc && ((UIViewController *)vc).title) {
//                title = ((UIViewController *)vc).title;
//            }
//        }
//    }
    if (str) {
        title = str;
    }
    title = (title)?title:@"";
    CGFloat titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width+5;
    leftButtonItem.frame = CGRectMake(0, 0, imgv.x+imgv.width+10+titleWidth, navHeight);
    
    UILabel * lab = [UIView label:@{V_Frame:rectStr(imgv.x+imgv.width+10, 0, titleWidth, navHeight),
                                    V_Text:title,
                                    V_Color:titleColor,
                                    V_Font_Size:num(14),
                                    V_Common_Style:@{V_Font_Family:k_defaultFontName,
                                                     V_Font_Weight:num(FontWeightNormal),
                                                     },
                                    }];
    [leftButtonItem addSubview:lab];
    
    if (action) {
        [leftButtonItem addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [leftButtonItem addTarget:self action:@selector(clickLeftBackButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonItem] autorelease];
//    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)clickLeftBarButtonItem{
    [[ReqEngine shared] cancelRequests];
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [self clickLeftBarButtonItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)setupRightBackButtonItem:(NSString *)str img:(NSString *)imgName del:(id)del sel:(SEL)action{
    UIColor * titleColor = [UIColor color:darkblack_color];
//    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).skinIndex == 1) {
//        titleColor = [UIColor color:white_color];
//    }
//    titleColor = [UIColor color:white_color];
    
    CGFloat navHeight = k_DEFAULT_NAVIGATION_BAR_HEIGHT;
    UIButton * rightView = nil;
    if (![NSString isEmptyString:str]) {
        NSString * title = (str)?str:@"";
        CGFloat titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width+2;
        
        rightView = [UIView button:@{V_Frame:rectStr(0, 0, titleWidth, navHeight),
                                     V_Title:title,
                                     V_Color:titleColor,
                                     V_Font_Size:num(14),
                                     V_HorizontalAlign:num(HorizontalRight),
                                     V_Font_Family:k_fontName_FZZY,
                                     V_Delegate:(del)?del:self,
                                     V_SEL:selStr(action)}];
//        rightView.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    else if (![NSString isEmptyString:imgName]){
        rightView = [UIView button:@{V_Frame:rectStr(0, 0, 45, navHeight),
                                     V_Img:(imgName)?imgName:@"",
                                     V_HorizontalAlign:num(HorizontalRight),
                                     V_Delegate:(del)?del:self,
                                     V_SEL:selStr(action)}];
    }
    
    if (rightView) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightView] autorelease];
    }
    return rightView;
}

- (void)showConfirmSelectedView:(NSArray *)titleList defaultSelected:(NSString *)defaultTitle action:(SEL)selector hasBackColor:(BOOL)isHas clickBackDismiss:(BOOL)clickBackHidden animation:(BOOL)isAnimate
{
    if (![NSArray isNotEmpty:titleList]) {
        return;
    }
    
    UIView * superView = APPLICATION.window;
    
    if ([superView viewWithTag:23623]) {
        return;
        //        [[superView viewWithTag:23623] removeFromSuperview];
    }
    
    UIView * backView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, superView.width, superView.height)] autorelease];
    backView.tag = 23623;
    [superView addSubview:backView];
    
    if (isHas) {
        backView.backgroundColor = [UIColor color:black_color];
        backView.alpha = 0.4;
    }
    else{
        backView.backgroundColor = [UIColor color:clear_color];
    }
    
    if (clickBackHidden) {
        UIControl * clickBackView = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, superView.width, superView.height)] autorelease];
        [backView addSubview:clickBackView];
        [clickBackView addTarget:self action:@selector(hiddenSelectedView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        backView.userInteractionEnabled = NO;
    }
    
    CGFloat lineHeight = 50;
    CGFloat y = superView.height/2.0;
    if ([titleList count] * lineHeight < y) {
        y = superView.height - [titleList count] * lineHeight;
    }
    CGFloat height = lineHeight * [titleList count];
    if (height > [UIScreen mainScreen].bounds.size.height * 0.5) {
        height = [UIScreen mainScreen].bounds.size.height * 0.5;
    }
    UIScrollView * sv = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, y, superView.width, height)] autorelease];
    sv.backgroundColor = [UIColor color:k_defaultViewControllerBGColor];
//    sv.layer.borderColor = [UIColor grayColor].CGColor;
//    sv.layer.borderWidth = 0.5;
    sv.tag = backView.tag+1;
    
    CGFloat origin_y = 0;
    for (int i = 0; i < titleList.count; i++) {
        NSString *title = titleList[i];
        UIView * innerBack = [[UIView alloc] initWithFrame:CGRectMake(0, origin_y, sv.width, lineHeight)];
        [sv addSubview:innerBack];
        
        CGFloat titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontName_FZZY size:14.0]}].width;
        titleWidth += 40;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setFrame:CGRectMake((innerBack.width-titleWidth)/2.0, (lineHeight-30)/2.0, titleWidth, 30)];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:k_fontName_FZZY size:14.0]];
        
        if ([title isEqualToString:@"取消"]) {
            [btn setTitleColor:[UIColor color:k_defaultTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
        else{
            [btn setTitleColor:[UIColor color:k_defaultTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
        //        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor color:k_defaultTextColor]] forState:UIControlStateHighlighted];
        
        if ([defaultTitle isEqualToString:title]) {
            btn.highlighted = YES;
        }

        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        [innerBack addSubview:btn];
        
        UIButton *tapBtn = [[UIButton alloc] initWithFrame:innerBack.bounds];
        tapBtn.backgroundColor = [UIColor clearColor];
        [tapBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [tapBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [tapBtn setTitle:title forState:UIControlStateNormal];
        tapBtn.tag = [titleList indexOfObject:title];
        [innerBack addSubview:tapBtn];
        
        if (selector) {
            [tapBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [tapBtn addTarget:self action:@selector(hiddenSelectedView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if ([title isEqual:[titleList objectAtExistIndex:titleList.count - 2]]) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, innerBack.height-1.0, sv.width, 5.0)];
            line.backgroundColor = rgb(226, 226, 226);
            line.alpha = 0.5;
            [innerBack addSubview:line];
        }
        
        origin_y += lineHeight;
    }
    
    sv.contentSize = CGSizeMake(sv.width, [titleList count] * lineHeight);
    [superView addSubview:sv];
    
    if (isAnimate) {
        backView.alpha = 0;
        sv.frame = CGRectMake(sv.x, superView.height, sv.width, sv.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0.4;
            sv.frame = CGRectMake(sv.x, superView.height-sv.height, sv.width, sv.height);
            
        } completion:^(BOOL finished) {
        }];
    }
}


- (void)showConfirmSelectedView:(NSArray *)titleList action:(SEL)selector hasBackColor:(BOOL)isHas clickBackDismiss:(BOOL)clickBackHidden animation:(BOOL)isAnimate{
    [self showConfirmSelectedView:titleList defaultSelected:nil action:selector hasBackColor:isHas clickBackDismiss:clickBackHidden animation:isAnimate];
   }

- (void)hiddenSelectedView{
    UIView * view = [APPLICATION.window viewWithTag:23623];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [view removeFromSuperview];
            }
        }];
    }
    
    view = [APPLICATION.window viewWithTag:23623+1];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
            view.frame = CGRectMake(view.x, APPLICATION.window.height, view.width, view.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [view removeFromSuperview];
            }
        }];
    }
}


- (void)showTipView:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) {
        return;
    }
    
    UIView * toView = [inf objectOutForKey:k_ToView];
    if (!toView) {
        return;
    }
    NSInteger tag = 28326;
    UIView * v = [toView viewWithTag:tag];
    if (v) {
        [v removeFromSuperview];
    }
    
    NSString * showMsg = [inf objectOutForKey:k_ShowMsg];
    if (!toView || !showMsg || ![inf objectOutForKey:k_ListCount]) {
        return;
    }
    NSString * listCount = strObj([inf objectOutForKey:k_ListCount]);
    
    if ([listCount integerValue] > 0) {
        return;
    }
    
    CGFloat left = 20;
    CGFloat top = 80;
    if ([inf objectOutForKey:k_OffsetY]) {
        top = [[inf objectOutForKey:k_OffsetY] floatValue];
    }
    UIView * bot = [UIView view_sub:@{V_Parent_View:toView,
                                      V_Margin_Top:strFloat(top),
                                      V_Margin_Left:strFloat(left),
                                      V_Margin_Right:strFloat(left),
                                      V_Color:clear_color,
                                      V_Tag:num(tag),
                                      }];
    [toView addSubview:bot];
    
    NSString * imgName = @"tips_no_result";
    if ([inf objectOutForKey:k_ShowImgName]) {
        imgName = [inf objectOutForKey:k_ShowImgName];
    }
    UIImageView * imgv = [UIView imageView:@{V_Parent_View:bot,
                                             V_Height:@70,
                                             V_Img:imgName,
                                             V_ContentMode:num(ModeCenter),
                                             }];
    [bot addSubview:imgv];
    
    CGFloat wid = toView.width - 2*left;
    NSInteger line = [NSString numberOfLineWithText:showMsg font:[UIFont fontWithName:k_fontName_FZXY size:15.0] superWidth:wid breakLineChar:nil];
    UILabel * lab = [UIView label:@{V_Parent_View:bot,
                                    V_Last_View:imgv,
                                    V_Margin_Top:strFloat(8),
                                    V_Margin_Left:strFloat(left),
                                    V_Margin_Right:strFloat(left),
                                    V_Height:strFloat(25*line),
                                    V_NumberLines:num(line),
                                    V_Font_Size:@15,
                                    V_Font_Family:k_fontName_FZXY,
                                    V_Color:k_defaultTipTextColor,
                                    V_Text:showMsg,
                                    V_TextAlign:num(TextAlignCenter),
                                    V_Tag:num(tag),
                                    V_NumberLines:num(3),
                                    }];
    [bot addSubview:lab];
    if (![inf objectOutForKey:k_OffsetY]) {
        CGFloat hei = lab.y + lab.height;
        CGFloat y = (toView.height-hei)/2.0 - 100;
        if (y <= 20) {
            y = top;
        }
        bot.frame = CGRectMake(bot.x, y, bot.width, hei);
    }
}

@end
