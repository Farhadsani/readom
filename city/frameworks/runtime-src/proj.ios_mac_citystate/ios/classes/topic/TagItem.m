#import "TagItem.h"

@implementation TagItem

@synthesize text;

- (id)init {
    self = [super init];
    if (self) {
		text = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TagItem *copy = [[[self class] allocWithZone: zone] init];
    copy.text = self.text;
    return copy;
}

@end
