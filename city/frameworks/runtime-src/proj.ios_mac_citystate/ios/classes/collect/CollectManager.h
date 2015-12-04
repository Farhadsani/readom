//
//  CollectManager.h
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import <Foundation/Foundation.h>
#import "CollectItem.h"

@interface CollectManager : NSObject
{
    
}

@property (strong, atomic) NSMutableArray *collectData;

- (void)requestData:(long)userID :(long)begin :(long)limit :(int)hide;

@end
