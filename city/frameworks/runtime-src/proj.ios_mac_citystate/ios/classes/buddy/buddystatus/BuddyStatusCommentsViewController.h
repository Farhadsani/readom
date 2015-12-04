//
//  BuddyStatusCommentsViewController.h
//  citystate
//
//  Created by 石头人6号机 on 15/10/26.
//
//

#import "BaseViewController.h"

typedef void (^BackBlk)(long fid);
@interface BuddyStatusCommentsViewController : BaseViewController
@property (nonatomic, assign) long feedid;
@property (nonatomic, copy) BackBlk backBlk;
@end
