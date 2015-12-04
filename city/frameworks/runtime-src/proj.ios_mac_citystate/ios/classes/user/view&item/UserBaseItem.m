#import "UserBaseItem.h"

@implementation UserBaseItem

//@synthesize userid, phone, passwd;

- (id)init:(long)pUserid
{
    self = [super init];
    if (self) {
        self.userid = pUserid;
        self.phone = @"";
        self.passwd = @"";
        if (self.userid != 0 ){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            self.phone = [defaults stringForKey:@"SHITOUREN_UD_PHONE"];
            self.passwd = @"";
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UserBaseItem *copy = [[[self class] allocWithZone: zone] init];
    copy.userid = self.userid;
    copy.phone = self.phone;
    copy.passwd = self.passwd;
    return copy;
}

@end
