#import "UserBriefItem.h"

@implementation UserBriefItem

@synthesize userid, name, zone, intro, imglink, thumblink, thumbdata;

- (id)init:(long)pUserid
{
    self = [super init];
    if (self) {
        userid = pUserid;
        if( userid == 0 ){
            name = @"";
            zone = @"";
            intro = @"";
            imglink = @"";
            thumblink = @"";
            thumbdata = nil;
        }else{
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            name = [defaults stringForKey:@"SHITOUREN_UD_NAME"];
            zone = [defaults stringForKey:@"SHITOUREN_UD_ZONE"];
            intro = [defaults stringForKey:@"SHITOUREN_UD_INTRO"];
            imglink = [defaults stringForKey:@"SHITOUREN_UD_IMGLINK"];
            thumblink = [defaults stringForKey:@"SHITOUREN_UD_THUMBLINK"];
            thumbdata = [defaults dataForKey:@"SHITOUREN_UD_THUMBDATA"];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)pZone {
    UserBriefItem *copy = [[[self class] allocWithZone: pZone] init];
    copy.userid = self.userid;
    copy.name = self.name;
    copy.zone = self.zone;
    copy.intro = self.intro;
    copy.imglink = self.imglink;
    copy.thumblink = self.thumblink;
    copy.thumbdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumblink]];
    return copy;
}

@end
