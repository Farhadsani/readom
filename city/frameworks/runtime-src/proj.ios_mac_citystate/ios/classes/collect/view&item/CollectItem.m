//
//  CollectItem.m
//  qmap
//
//  Created by 石头人6号机 on 15/8/7.
//
//

#import "CollectItem.h"
#import "NSString+Addtion.h"

@implementation CollectItem

@synthesize userid, imglink, name, type, feedid, ctime, imglinkArr, tags, content, liked, likecount, commented, commentscount, areaid, place;
- (id)init {
    self = [super init];
    if (self) {
        userid = 0;
        imglink = @"";
        name = @"";
        type = 0;
        feedid = 0;
        ctime = @"";
        imglinkArr = [[NSMutableArray alloc]init];
        tags = [[NSMutableArray alloc]init];
        content = @"";
        liked = 0;
        likecount = 0;
        commented = 0;
        commentscount = 0;
        areaid = 0;
        place = [[NSMutableArray alloc]init];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)z {
    CollectItem *copy = [[[self class] allocWithZone: z] init];
    copy.userid = self.userid;
    copy.imglink = self.imglink;
    copy.name = self.name;
    copy.type = self.type;
    copy.ctime = self.ctime;
    copy.feedid = self.feedid;
    copy.imglinkArr = self.imglinkArr;
    copy.tags = self.tags;
    copy.content = self.content;
    copy.liked = self.liked;
    copy.likecount = self.likecount;
    copy.commentscount = self.commentscount;
    copy.content = self.content;
    copy.areaid = self.areaid;
    copy.place = self.place;
    return copy;
}

- (CGFloat)imageViewBGHeight {
    CGFloat imageViewBGHeight = 0;
    if (self.imglinkArr.count == 0) {
        imageViewBGHeight = 0;
    } else if (self.imglinkArr.count <= 3) {
        imageViewBGHeight = 80 + 5;
    } else if (self.imglinkArr.count <= 6) {
        imageViewBGHeight = 80 * 2 + 2 * 5;
    } else {
        imageViewBGHeight = 80 * 3 + 3 * 5;
    }
    return imageViewBGHeight;
}

- (CGFloat)contentLabelHeight:(CGFloat)width {
    CGFloat contentHeight = 0;
    if (self.content.length > 0) {
        contentHeight = [[NSAttributedString attrContent:self.content fontName:k_fontName_FZXY fontsize:14 color:darkGary_color lineHeight:20 align:NSTextAlignmentLeft] heightForWidth:width];
    }
    return contentHeight;
}

- (CGFloat)adressViewBGHeight{
    CGFloat adressHeight = 0;
    if (self.place.count == 0) {
        adressHeight = 0;
    }else{
        adressHeight =30;
    }
    return adressHeight;
}

- (CGFloat)tagsViewBGHeight{
    CGFloat tagsHeight = 0;
    if (self.tags.count == 0) {
        tagsHeight = 0;
    }else{
        tagsHeight = 30;
    }
    return tagsHeight;
}
@end
