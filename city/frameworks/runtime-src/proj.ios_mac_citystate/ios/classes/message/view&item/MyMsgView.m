//
//  MyMsgView.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/10.
//
//

#import "MyMsgView.h"
#import "MsgCell.h"
#import "MsgItem.h"

@implementation MyMsgView

@synthesize manager, delegate;

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


#pragma TableView的处理
-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    return manager.myMsgList.count;
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tvMsg cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [[MsgCell alloc] init];
 
    MsgItem *item =  [manager.myMsgList objectAtExistIndex:indexPath.row];
    [cell setCell:item];
    return cell;
}

-(void)tableView:(UITableView *)pTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if( self.delegate ){
        [self.delegate myMsgDelegate:indexPath.row];
    }
    return;
}

@end
