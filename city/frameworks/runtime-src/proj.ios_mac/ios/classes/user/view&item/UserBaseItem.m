#import "UserBaseItem.h"

@implementation UserBaseItem

@synthesize userid, phone, passwd;

- (id)init:(long)pUserid
{
    self = [super init];
    if (self) {
        userid = pUserid;
        if( userid == 0 ){
            phone = @"";
            passwd = @"";
        }else{
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            phone = [defaults stringForKey:@"SHITOUREN_UD_PHONE"];
            passwd = @"";
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
