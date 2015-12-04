//
//  CollectHidddenListViewController.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/6.
//
//

/*
 *【隐藏动态】界面
 *功能：展示隐藏动态列表
 *取消隐藏动态
 */

//#import "BaseUIViewController.h"
#import "BaseViewController.h"
#import "CollectManager.h"
#import "CollectCell.h"

@protocol CollectHidddenListVCDelegate;

@interface CollectHidddenListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, CollectCellDelegate>{
    
}
@property (nonatomic, assign) id<CollectHidddenListVCDelegate> delegate;


@end


@protocol CollectHidddenListVCDelegate <NSObject>


@end
