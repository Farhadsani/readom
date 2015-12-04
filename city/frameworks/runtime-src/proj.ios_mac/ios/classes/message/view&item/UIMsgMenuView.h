//
//  UIMsgMenuView.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol UIMsgMenuViewDelegate <NSObject>

@optional
-(void)onCleanAll;
-(void)onHideMsgMenu;

@end

@interface UIMsgMenuView : UIView
{
    UIView *uiMenuView;
    UIButton *uiBtnClean;
    UIButton *uiBtnCancel;
}
@property (assign, nonatomic)id<UIMsgMenuViewDelegate> delegate;
@end
