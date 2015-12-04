//
//  CollectCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import <UIKit/UIKit.h>

#import "CollectItem.h"

typedef enum OpType{
    note_like = 0,  //关注某话题（topic）下发表的某一条内容（note）
    topic_like,     //关注话题
    note_post,      //在某一个话题下，发表的一条或多条内容
}OpType;

@protocol CollectCellDelegate;

@interface CollectCell : UITableViewCell <ReqestDelegate>
{
    UIImageView *uiTypeImage;
    UIImageView *uiTypeBackground;
    UIButton    *uiBtnSelect;
    UIButton    *uiBtnHide;
    
    UILabel     *uiTitle_topic;
    UILabel     *uiTitle_note;
}
@property (nonatomic, assign) long userid;
@property (nonatomic, retain) CollectItem * dataItem;
@property (nonatomic, retain) NSIndexPath * indexPath;
@property (nonatomic) BOOL canEdit;
@property (nonatomic, assign) id<CollectCellDelegate> delegate;

@property (nonatomic, retain) UIButton    *uiBtnSelect;

- (void)refreshUI:(CollectItem *)item frmae:(CGRect)rect;
- (void)setupUI:(CollectItem *)item frmae:(CGRect)rect;

- (OpType)getOpType:(CollectItem *)item;

- (void)requestCancelCollect:(id)sender;

@end



@protocol CollectCellDelegate <NSObject>

@optional
- (void)didHiddenCollectCell:(CollectCell *)CollectCell;

- (void)beginSelectedCollectCell:(CollectCell *)CollectCell;

@end
