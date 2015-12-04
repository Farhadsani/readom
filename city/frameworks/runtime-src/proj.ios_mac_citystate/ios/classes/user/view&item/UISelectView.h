//
//  UISelectView.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/31.
//
//

#import <UIKit/UIKit.h>

@protocol UISelectViewDelegate <NSObject>

@optional
-(void)selItemForSelectView:(long)styleIndex :(long)index;

@end

@interface UISelectView : UIView<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UIButton *uiOKBtn;
    UIImageView *uiLine;
    
    UIView *view;
    NSMutableArray *btnArray;
    NSMutableArray* arrayData;
    
    long selIndex;
    UITableView *uiListView;
    
    long style;
}

@property (assign, nonatomic) id <UISelectViewDelegate> delegate;

- (void)addSubItem:(NSArray*)arrItemNames;
- (void)setDefaultSelectItem:(long)s :(long)index;

- (void)fadeIn;
- (void)fadeOut;
@end

