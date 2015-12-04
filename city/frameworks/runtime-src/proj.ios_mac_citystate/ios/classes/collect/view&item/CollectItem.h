//
//  CollectItem.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import <Foundation/Foundation.h>

@interface CollectItem : NSObject
{
    
}
@property(assign, atomic)long userid;
@property(copy, atomic)NSString *name;
@property(copy, atomic)NSString *imglink;
@property(assign ,atomic)long type;
@property(assign ,atomic)long feedid;
@property(copy,atomic)NSString * ctime;
@property(copy, atomic)NSMutableArray *imglinkArr;
@property(copy, atomic)NSMutableArray *tags;
@property(copy, atomic)NSString *content;
@property(assign ,atomic)long liked;
@property(assign ,atomic)long likecount;
@property(assign ,atomic)long commented;
@property(assign ,atomic)long commentscount;
@property(assign ,atomic)long areaid;
@property(copy, atomic)NSMutableArray *place;

@property(assign, atomic)long topicID;

@property (nonatomic, assign, readonly) CGFloat imageViewBGHeight;
@property (nonatomic, assign, readonly) CGFloat adressViewBGHeight;
@property (nonatomic, assign, readonly) CGFloat tagsViewBGHeight;



- (CGFloat)contentLabelHeight:(CGFloat)width;
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

@end

