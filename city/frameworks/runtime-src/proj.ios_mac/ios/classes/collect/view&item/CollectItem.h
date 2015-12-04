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

@property(copy, atomic)NSString * feedID;
@property(copy, atomic)NSString *optype;
@property(copy, atomic)NSString * topicID;
@property(copy, atomic)NSString *title;
@property(copy, atomic)NSString * noteID;
@property(copy, atomic)NSString *note;
@property(strong, atomic)NSMutableArray *note_thumbs;


- (id)initWithData:(NSDictionary *)inf;


@end

//
//‘feedid’: 33333333,
//'optype': 'note_like',
//'data': {
//    'topicid': 1111111111,
//    'topic_title': 'wrdwefsdfsd'
//    'noteid': 22222222222,
//    'note': '马上上当发送到丰盛的范德萨发士大夫',
//    'note_thumbs': ['img1', ‘img2']
//                    }