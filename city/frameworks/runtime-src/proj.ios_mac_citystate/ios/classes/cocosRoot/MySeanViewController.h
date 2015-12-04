//
//  MySeanViewController.h
//  citystate
//
//  Created by 小生 on 15/10/15.
//
//

#import "BaseViewController.h"

@interface MySeanViewController : BaseViewController
{
    NSMutableArray          *thumbs;

}
@property (nonatomic, copy) void(^cancel)();

@end
