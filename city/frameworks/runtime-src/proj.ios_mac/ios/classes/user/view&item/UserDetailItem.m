#import "UserDetailItem.h"

@implementation UserDetailItem

@synthesize userid, sex, sexot, love, horo;

- (id)init:(long)pUserid
{
    self = [super init];
    if (self) {
        userid = pUserid;
        if( userid == 0 ){
            sex = @"";
            sexot = @"";
            love = @"";
            horo = @"";
        }else{
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            sex = [defaults stringForKey:@"SHITOUREN_UD_SEX"];
            sexot = [defaults stringForKey:@"SHITOUREN_UD_SEXOT"];
            love = [defaults stringForKey:@"SHITOUREN_UD_LOVE"];
            horo = [defaults stringForKey:@"SHITOUREN_UD_HORO"];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UserDetailItem *copy = [[[self class] allocWithZone: zone] init];
    copy.userid = self.userid;
    copy.sex = self.sex;
    copy.sexot = self.sexot;
    copy.love = self.love;
    copy.horo = self.horo;
    return copy;
}

@end
