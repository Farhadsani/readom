//
//  SystemMsgView.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/10.
//
//

#import <UIKit/UIKit.h>
#import "MsgManager.h"

@interface SystemMsgView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tvMsg;
}

@property(strong, nonatomic) MsgManager *manager;
@property(assign, nonatomic) id<MsgDelegate> delegate;

-(void) refreshTabelView;

@end
