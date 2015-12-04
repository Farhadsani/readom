//
//  CollectViewController.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/6.
//
//
/*
 *【个人动态】界面
 *功能：展示【个人动态】列表、查看话题
 * 编辑内容：隐藏、显示
 */

//#import "BaseUIViewController.h"
#import "BaseViewController.h"
#import "CollectManager.h"
#import "CollectCell.h"
#import "CollectHidddenListViewController.h"

@protocol CollectVCDelegate;

@interface CollectViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, CollectCellDelegate, CollectHidddenListVCDelegate>
@property (nonatomic, assign) id<CollectVCDelegate> delegate;

@end


