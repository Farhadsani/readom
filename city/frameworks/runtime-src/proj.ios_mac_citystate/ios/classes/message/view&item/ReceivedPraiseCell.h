//
//  ReceivedPraiseCell.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/18.
//
//

#import <UIKit/UIKit.h>

@interface ReceivedPraiseCell : UITableViewCell{
    UIImageView * userLogo;
    UIView * _section_3;
}
@property (nonatomic, retain) NSMutableDictionary * data_dict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data_dict;

- (CGFloat)calHeightOfCell;


@end
