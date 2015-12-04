//
//  CollectItem.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import "CollectItem.h"

@implementation CollectItem

@synthesize feedID, optype, topicID, title, noteID, note, note_thumbs;
- (id)initWithData:(NSDictionary *)inf {
    self = [super init];
    if (self) {
        feedID = 0;
        optype = @"";
        topicID = 0;
        title = @"";
        noteID = 0;
        note = @"";
        note_thumbs = [[NSMutableArray alloc]init];
        [self setupValue:inf];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)z {
    CollectItem *copy = [[[self class] allocWithZone: z] init];
    copy.feedID = self.feedID;
    copy.optype = self.optype;
    copy.topicID = self.topicID;
    copy.title = self.title;
    copy.noteID = self.noteID;
    copy.note = self.note;
    copy.note_thumbs = self.note_thumbs;
    return copy;
}

- (void)setupValue:(NSDictionary *)inf{
    if (![NSDictionary isNotEmpty:inf]) {
        return;
    }
    
    self.feedID = [self getValueOfKey:@"feedid" FromDate:inf];
    self.optype = [self getValueOfKey:@"optype" FromDate:inf];
    self.topicID = [self getValueOfKey:@"topicid" FromDate:inf];
    self.title = [self getValueOfKey:@"title" FromDate:inf];
    self.noteID = [self getValueOfKey:@"noteid" FromDate:inf];
    self.note = [self getValueOfKey:@"note" FromDate:inf];
    self.note_thumbs = [self getValueOfKey:@"note_thumbs" FromDate:inf];
}

- (id)getValueOfKey:(NSString *)key FromDate:(NSDictionary *)inf{
    if ([inf objectOutForKey:key]) {
        return [inf objectOutForKey:key];
    }
    
    NSDictionary * data = [inf objectForKey:@"data"];
    if (data && [data objectOutForKey:key]) {
        return [data objectOutForKey:key];
    }
    
    return @"null";
}

@end
