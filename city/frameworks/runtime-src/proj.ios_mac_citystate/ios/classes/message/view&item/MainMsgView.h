//
//  MainMsgView.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/10.
//
//

#import <UIKit/UIKit.h>

@interface MainMsgItem : NSObject
@property(copy, atomic) NSString *imageName;
@property(copy, atomic) NSString *title;
@end

@protocol MainMsgViewDelegate <NSObject>

@optional
-(void)switchToMyMsg;
-(void)switchToPetMsg;
-(void)switchToSupportMsg;
-(void)switchToSystemMsg;

@end

@interface MainMsgView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tv;
    NSMutableArray *array;
}

@property(assign, nonatomic) id<MainMsgViewDelegate> delegate;

@end
