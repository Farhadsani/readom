//
//  CollectCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import <UIKit/UIKit.h>
#import "CollectItem.h"
#import "CollectBarView.h"
#import "BuddyStatusNoteTagsView.h"
#import "BuddyStatusNoteItem.h"
#import "BuddyStatusNoteItemFrame.h"
#import "SDPhotoBrowser.h"

typedef enum OpType{
    note_like = 0,  //关注某话题（topic）下发表的某一条内容（note）
    topic_like,     //关注话题
    note_post,      //在某一个话题下，发表的一条或多条内容
}OpType;

@protocol CollectCellDelegate;

@interface CollectCell : UITableViewCell <ReqestDelegate,SDPhotoBrowserDelegate>
{
    UIImageView *userIcon;
    UILabel * userName;
    UILabel * content;
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
@property (nonatomic, retain) CollectBarView *toolBar;
@property (nonatomic, retain) BuddyStatusNoteTagsView *tagsView;
@property (nonatomic, retain) BuddyStatusNoteTagsView *placeTagsView;
@property (nonatomic, retain) UIView *bgView; // 背景图片

@property (nonatomic, retain) NSMutableArray *imageArr;

@property (nonatomic, retain) BuddyStatusNoteItemFrame *noteItemFrame;

@property (nonatomic, retain) UIButton    *uiBtnSelect;

//- (void)refreshUI:(CollectItem *)item frmae:(CGRect)rect;
- (void)setupUI:(CollectItem *)item frmae:(CGRect)rect;

- (OpType)getOpType:(CollectItem *)item;

- (void)requestCancelCollect:(id)sender;
+ (CGFloat)cellHeightWith:(CollectItem *)item;

@end



@protocol CollectCellDelegate <NSObject>

@optional
- (void)didHiddenCollectCell:(CollectCell *)CollectCell;

- (void)beginSelectedCollectCell:(CollectCell *)CollectCell;

@end
