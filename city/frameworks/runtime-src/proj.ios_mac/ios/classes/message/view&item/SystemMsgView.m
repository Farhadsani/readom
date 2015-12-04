//
//  SystemMsgView.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/10.
//
//

#import "SystemMsgView.h"
#import "SystemMsgCell.h"

@implementation SystemMsgView

@synthesize delegate, manager;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        
        tvMsg = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [tvMsg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [tvMsg setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tvMsg setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0f)];
        tvMsg.dataSource = self;
        tvMsg.delegate = self;
        
        [self addSubview:tvMsg];
        
    }
    return self;
}

- (void)refreshTabelView
{
    [tvMsg reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma TableView的处理

-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    //    return topicManager.listShow.count+1;
    //    NSInteger count = 0;
    //    if(manager.msgList.count != nil)
    //    {
    //        count = tableData.count;
    //    }
    return manager.systemMsgList.count;
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if([indexPath row] == topicManager.listShow.count) {
    //        return 60+44;
    //    }
    UITableViewCell *cell = [self tableView:tvMsg cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if( [indexPath row] == topicManager.listShow.count ) {
    //        return loadMoreCell;
    //    }
    SystemMsgCell *cell = [[SystemMsgCell alloc] init];
    //    if (tableData != nil)
    //    {
    MsgItem *item =  [manager.systemMsgList objectAtExistIndex:indexPath.row];
    [cell setCell:item];
    //    }
    return cell;
}

-(void)tableView:(UITableView *)pTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if([indexPath row] == topicManager.listShow.count) {
    //        return;
    //    }
    if( self.delegate ){
        [self.delegate systemMsgDelegate:indexPath.row];
    }
    return;
}

@end
