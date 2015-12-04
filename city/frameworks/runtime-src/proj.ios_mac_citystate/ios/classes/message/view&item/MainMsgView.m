//
//  MainMsgView.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/10.
//
//

#import "MainMsgView.h"

@implementation MainMsgItem
@synthesize imageName, title;
- (id)init:(NSString*)t :(NSString*)name
{
    self = [super init];
    if (self) {
        imageName = name;
        title = t;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MainMsgItem *copy = [[[self class] allocWithZone: zone] init];
    copy.imageName = self.imageName;
    copy.title = self.title;
    return copy;
}
@end

@implementation MainMsgView
@synthesize delegate;

CGFloat cellHeight = 60;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0f)];
        
        array = [[NSMutableArray alloc]init];
        [array addObject:[[MainMsgItem alloc]init:@"我的消息" :@"msg_1.png"]];
        [array addObject:[[MainMsgItem alloc]init:@"宠物消息" :@"msg_2.png"]];
        [array addObject:[[MainMsgItem alloc]init:@"收到的赞" :@"msg_3.png"]];
        [array addObject:[[MainMsgItem alloc]init:@"系统消息" :@"msg_4.png"]];
        
        tv = [[UITableView alloc]initWithFrame:CGRectMake(25, 20, frame.size.width - 50,  cellHeight * 4)];
        [tv setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tv setShowsVerticalScrollIndicator:NO];
        [tv setBackgroundColor:UIColorFromRGB(0xf1f1f1, 1.0f)];
        tv.dataSource = self;
        tv.delegate = self;
        [tv setBackgroundColor:UIColorFromRGB(0xf7f8f9, 1.0f)];
        tv.layer.cornerRadius = 10;
        tv.layer.borderColor = UIColorFromRGB(0x99d472, 1.0f).CGColor;
        tv.layer.borderWidth = 1;
        
        [self addSubview:tv];
        
    }
    return self;
}

-(void)onSelectItem:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    [tv selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self tableViewSelectItem:btn.tag];
}

-(void)tableViewSelectItem:(long)index
{
    InfoLog(@"当前选中了。。。%ld", index);
    switch (index) {
        case 0:
            [delegate switchToMyMsg];
            break;
        case 1:
            [delegate switchToPetMsg];
            break;
        case 2:
            [delegate switchToSupportMsg];
            break;
        case 3:
            [delegate switchToSystemMsg];
            break;
            
        default:
            break;
    }
}


#pragma TableView的处理

-(NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}

-(CGFloat)tableView:(UITableView *)pTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, pTableView.frame.size.width, cellHeight)];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"msg_bg_1.png"]];
    
    MainMsgItem *item = [array objectAtExistIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    [img setImage:[UIImage imageNamed:item.imageName]];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(pTableView.frame.size.width-50, (cellHeight-40)/2, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"base-3-1.png"] forState:UIControlStateNormal];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(onSelectItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:btn];
    [cell.imageView addSubview:img];
    return cell;
}

-(void)tableView:(UITableView *)pTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableViewSelectItem:indexPath.row];
    return;
}

@end
