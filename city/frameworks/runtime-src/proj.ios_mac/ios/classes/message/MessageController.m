//
//  MessageController.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/28.
//
//


/*
 *【消息】界面
 *功能：查看[我的消息]、[宠物消息]、[收到的赞]、[系统消息]
 *
 */

#import "MessageController.h"
#import "MyMsgViewController.h"
#import "PetMsgViewController.h"
#import "ReceivedPraiseViewController.h"
#import "SysMsgViewController.h"

@interface MessageController ()

@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    [self setupMainView];
}

- (void)setupMainView{
    CGFloat lineHieght = 60;
    CGFloat imgMargin = 15;
    if (kScreenHeight == 480) {
        lineHieght = 45;
        imgMargin = 10;
    }
    UIView * backView = [UIView view_sub:@{V_Parent_View:self.contentView,
                                           V_Frame:rectStr(15, 15, self.contentView.width-30, 4*lineHieght),
                                           V_Border_Color:green_color,
                                           V_Border_Width:@0.5,
                                           V_Border_Radius:@5,
                                           }];
    [self.contentView addSubview:backView];
    
    NSArray * titles = @[@"我的消息",@"宠物消息",@"收到的赞",@"系统消息"];
    NSArray * images = @[@"msg_1",@"msg_2",@"msg_3",@"msg_4"];
    NSInteger i = 0;
    CGFloat y = 0;
    
    for (NSString * title in titles) {
        i = [titles indexOfObject:title];
        UIImageView * imgv = [UIView imageView:@{V_Parent_View:backView,
                                                 V_Frame:rectStr(imgMargin, y+imgMargin, lineHieght-imgMargin*2, lineHieght-imgMargin*2),
                                                 V_Img:[images objectAtExistIndex:i],
                                                 V_ContentMode:num(ModeCenter),
                                                 V_Border_Radius:strFloat((lineHieght-imgMargin*2)/2.0),
                                                 V_BGColor:rgb(232, 172, 76),
                                                 V_Tag:num(i),
                                                 V_Delegate:self,
                                                 V_SEL:selStr(@selector(clickIndex:)),
                                                 }];
        [backView addSubview:imgv];
        
        UILabel * lab = [UIView label:@{V_Parent_View:backView,
                                        V_Left_View:imgv,
                                        V_Height:strFloat(lineHieght),
                                        V_Margin_Top:strFloat(y),
                                        V_Margin_Left:@15,
                                        V_Text:title,
                                        V_Tag:num(i),
                                        V_Delegate:self,
                                        V_SEL:selStr(@selector(clickIndex:)),
                                        V_Font_Size:@16,
                                        V_Font_Family:k_fontName_FZZY,
                                        V_Color:UIColorFromRGB(0x5d493d, 1.0f)
                                        }];
        [backView addSubview:lab];
        
        UIView * line = [UIView view_sub:@{V_Parent_View:lab,
                                           V_Over_Flow_Y:num(OverFlowBottom),
                                           V_Height:@0.5,
                                           V_BGColor:green_color,
                                           }];
        [lab addSubview:line];
        
        UIImageView * imagL = [UIView imageView:@{V_Parent_View:backView,
                                                  V_Over_Flow_X:num(OverFlowRight),
                                                  V_Margin_Top:strFloat(y),
                                                  V_Width:strFloat(lineHieght/2.0),
                                                  V_Height:strFloat(lineHieght),
                                                  V_Img:@"arr",
                                                  V_ContentMode:num(ModeCenter),
                                                  }];
        [backView addSubview:imagL];
        
        y += lineHieght;
    }
}

- (void)clickIndex:(UIView *)sender{
    InfoLog(@"%d", (int)sender.tag);
    
    UIViewController * vc = nil;
    
    switch (sender.tag) {
        case 0:{
            vc = [[[MyMsgViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            vc.title = @"我的消息";
        }
            break;
        case 1:{
            vc = [[[PetMsgViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            vc.title = @"宠物消息";
        }
            break;
        case 2:{
            vc = [[[ReceivedPraiseViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            vc.title = @"收到的赞";
        }
            break;
        case 3:{
            vc = [[[SysMsgViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            vc.title = @"系统消息";
        }
            break;
            
        default:
            break;
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickLeftBackButtonItem:(UIButton *)sender{
    [super clickLeftBarButtonItem];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self baseBack:nil];
}

- (void)baseBack:(id)sender{
    [self baseDeckAndNavBack];
    [self backUserHome];
//    if( callback ){
//        callback( 1 );
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
