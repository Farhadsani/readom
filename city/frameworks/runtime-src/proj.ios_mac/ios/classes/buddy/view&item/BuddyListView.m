//
//  BuddyView.m
//  qmap
//
//  Created by 石头人6号机 on 15/7/21.
//
//

#import "BuddyListView.h"
#import "BuddyItem.h"

@implementation BuddyListView

@synthesize  tableView, buddyManager, delegate;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0f)];
        
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.width-20, self.height)];
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setBackgroundColor:UIColorFromRGB(0xffffff, 1.0f)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.layer.cornerRadius = 3;
        tableView.layer.masksToBounds = YES;
        tableView.layer.borderColor = [UIColor color:green_color].CGColor;
        tableView.layer.borderWidth = 0.5;

        [self addSubview:tableView];
    }
    return self;
}

-(void)refreshData:(int)index{
    tableData = [buddyManager getTableData:index];
    [tableView reloadData];
}

#pragma TableView的处理

-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if(tableData != nil)
    {
        count = tableData.count;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuddyCell *cell = [[BuddyCell alloc] init];
    if (tableData != nil)
    {
        BuddyItem *item =  [tableData objectAtExistIndex:indexPath.row];
        cell.delegate = self;
        [cell start:item : indexPath.row];
    }
    
    UIView * line = [UIView view_sub:@{V_Parent_View:cell,
                                       V_BGColor:rgb(222, 177, 103),
                                       V_Margin_Left:@10,
                                       V_Margin_Right:@30,
                                       V_Over_Flow_Y:num(OverFlowBottom),
                                       V_Height:@0.5,
                                       }];
    [cell addSubview:line];
    
    return cell;
}

-(void)tableView:(UITableView *)pTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BuddyItem *item =  [tableData objectAtExistIndex:indexPath.row];
    if ([[UserManager sharedInstance] isCurrentUser:item.userid]) {
        InfoLog(@"选择了自己%ld", item.userid);
        return;
    }
    
    if( self.delegate ){
        [self.delegate selectItem:indexPath.row];
    }
    return;
}

#pragma cell的处理
- (void)BuddyCell:(BuddyCell *)cell onRelationShip:(long)index{
    InfoLog(@"listView  ..%ld", index);
    
    BuddyItem *item = [buddyManager getBoddyItem:index];
    [buddyManager requestFollow:item.userid from:cell];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRelationShip:)]) {
        [self.delegate onRelationShip:index];
    }
}

- (void)BuddyCell:(BuddyCell *)cell onUnRelationShip:(long)index{
    InfoLog(@"listView  ..%ld", index);
    
    BuddyItem *item = [buddyManager getBoddyItem:index];
    [buddyManager requestUnFollow:item.userid from:cell];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onUnRelationShip:)]) {
        [self.delegate onUnRelationShip:index];
    }
}

@end
