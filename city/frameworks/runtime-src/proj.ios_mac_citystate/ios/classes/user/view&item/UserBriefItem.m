#import "UserBriefItem.h"

@implementation UserBriefItem

//@synthesize userid, name, zone, intro, imglink, thumblink, thumbdata, fans, role, headurl, address, phone;

- (id)initData{
    self = [super init];
    if (self) {
        self.userid = 0;
        
        self.name = @"";
        self.phone = @"";
        self.intro = @"";
        self.imglink = @"";
        self.thumblink = @"";
        self.photolink = @[];
        self.photothumb = @[];
        self.fans = 0;
        self.follow = 0;
        self.role = 0;
        self.thumbdata = nil;
        self.address = @"";
        self.telephone = @"";
        self.hobby = @"";
        self.music = @"";
        self.categories = @[];
    }
    return self;
}

- (id)init:(long)pUserid{
    self = [super init];
    if (self) {
        [self initData];
        self.userid = pUserid;
        
        if (self.userid != 0 ){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            self.name = [defaults stringForKey:@"SHITOUREN_UD_NAME"];
            self.phone = [defaults stringForKey:@"SHITOUREN_UD_PHOTO"];
            self.intro = [defaults stringForKey:@"SHITOUREN_UD_INTRO"];
            self.imglink = [defaults stringForKey:@"SHITOUREN_UD_IMGLINK"];
            self.thumblink = [defaults stringForKey:@"SHITOUREN_UD_THUMBLINK"];
            self.photolink = (NSArray *)[defaults stringForKey:@"SHITOUREN_UD_PHOTOLINK"];
            self.photothumb = (NSArray *)[defaults stringForKey:@"SHITOUREN_UD_PHOTOTHUMB"];
            self.thumbdata = [defaults dataForKey:@"SHITOUREN_UD_THUMBDATA"];
            self.fans = [defaults integerForKey:@"SHITOUREN_UD_FANS"];
            self.follow = [defaults integerForKey:@"SHITOUREN_UD_FOLLOW"];
            self.role = (int)[defaults integerForKey:@"SHITOUREN_UD_ROLE"];
            self.categories = [defaults objectForKey:@"SHITOUREN_UD_CATEGORIES"];
            self.address = [defaults stringForKey:@"SHITOUREN_UD_ADDRESS"];
//            if (self.role == Role_Store && ![NSString isEmptyString:[defaults integerForKey:@"SHITOUREN_UD_TELEPHONE"]]) {
                self.telephone = [defaults stringForKey:@"SHITOUREN_UD_TELEPHONE"];
//            }
            self.hobby = [defaults stringForKey:@"SHITOUREN_UD_HOBBY"];
            self.music = [defaults stringForKey:@"SHITOUREN_UD_MUSIC"];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)pZone {
    UserBriefItem *copy = [[[self class] allocWithZone: pZone] init];
    copy.userid = self.userid;
    copy.name = self.name;
    copy.phone = self.phone;
    copy.intro = self.intro;
    copy.imglink = self.imglink;
    copy.thumblink = self.thumblink;
    copy.photolink = self.photolink;
    copy.photothumb = self.photothumb;
    copy.role = self.role;
    copy.thumbdata = self.thumbdata;
    copy.fans = self.fans;
    copy.follow = self.follow;
    copy.categories = self.categories;
    copy.music = self.music;
    copy.address = self.address;
    if (copy.role == Role_Store) {
        copy.telephone = self.telephone;
    }
    copy.hobby = self.hobby;
    return copy;
}

@end
