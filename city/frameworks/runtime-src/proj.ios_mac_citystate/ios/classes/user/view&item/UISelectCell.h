//
//  UISelectCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/3.
//
//

#import <UIKit/UIKit.h>

@interface UISelectCell : UITableViewCell
{
    
    UIImageView *uiImageback;
    UILabel *uiLabelItem;
}

-(void)setItemName:(NSString*)name;
@end
