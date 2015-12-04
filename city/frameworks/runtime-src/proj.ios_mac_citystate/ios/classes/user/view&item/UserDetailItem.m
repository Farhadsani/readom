#import "UserDetailItem.h"

@implementation UserDetailItem

//@synthesize userid, sex, sexot, love, horo;

- (id)init:(long)pUserid
{
    self = [super init];
    if (self) {
        _userid = pUserid;
        _sex = @"";
        _sexot = @"";
        _love = @"";
        _horo = @"";
        if (_userid != 0 ){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            _sex = [defaults stringForKey:@"SHITOUREN_UD_SEX"];
            _sexot = [defaults stringForKey:@"SHITOUREN_UD_SEXOT"];
            _love = [defaults stringForKey:@"SHITOUREN_UD_LOVE"];
            _horo = [defaults stringForKey:@"SHITOUREN_UD_HORO"];
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
