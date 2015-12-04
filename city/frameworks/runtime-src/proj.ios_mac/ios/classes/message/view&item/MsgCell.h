//
//  MsgCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/7/29.
//
//

#import <UIKit/UIKit.h>

@interface MsgCell : UITableViewCell{
    UIImageView * userLogo;
}
@property (nonatomic, retain) NSMutableDictionary * data_dict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data_dict;

- (CGFloat)calHeightOfCell;

@end
