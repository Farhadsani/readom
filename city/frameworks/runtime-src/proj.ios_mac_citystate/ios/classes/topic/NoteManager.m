/*
 *
 *获取note相关信息的网络请求类，已废弃，但是有代码使用
 *TopicManager同理
*/
#import "NoteManager.h"
#import "NoteItem.h"
#import "TagItem.h"
#import "UserBriefItem.h"
#import "UserManager.h"
#import "LoggerClient.h"

@implementation NoteManager

@synthesize listShow, started, gettingNext, responsing, index;

-(id)init:(long)topicid {
    self = [super init];
    if (self) {
        backIndex = 0;
        listShow = [[NSMutableArray alloc] init];
        setShow = [[NSMutableSet alloc] init];
        listNext = [[NSMutableArray alloc] init];
        started = NO;
        gettingNext = NO;
        responsing = NO;
        index = 0;
        self.topicid = topicid;
    }
    return self;
}

#pragma mark –
#pragma mark ------getNew------

NSString *testNoteStart = @" \
{\"idx\":0,\"ret\":0,\"msg\":\"ok\",\"res\":[ \
{ \
\"noteid\":100000, \
\"complete\":90, \
\"hot\":98765, \
\"note\":\"从前有座山山上有座庙庙里有个和尚在讲故事从前有座山山上有座庙庙里有个和尚在讲故事\", \
\"ctime\":\"2015年7月16日18:35\", \
\"imgs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
], \
\"thumbs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
], \
\"tags\": \
[ \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
], \
\"place\": \
[ \
\"北京\", \
\"朝阳区\", \
\"呼家楼\", \
\"三里屯\", \
\"优衣库试衣间\", \
], \
\"user\": \
{ \
\"userid\":20000009, \
\"name\":\"叶湘-石头人\", \
\"intro\":\"石头人工作室创始人\", \
\"zone\":\"叶湘-石头人的空间\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"thumblink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
}, \
\"liked\":0, \
}, \
{ \
\"noteid\":100001, \
\"complete\":90, \
\"hot\":98765, \
\"note\":\"从前有座山山上有座庙庙里有个和尚在讲故事从前有座山山上有座庙庙里有个和尚在讲故事\", \
\"ctime\":\"2015年7月16日18:35\", \
\"imgs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
], \
\"thumbs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
], \
\"tags\": \
[ \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
], \
\"place\": \
[ \
\"北京\", \
\"三里屯\", \
], \
\"user\": \
{ \
\"userid\":20000009, \
\"name\":\"叶湘-石头人\", \
\"intro\":\"石头人工作室创始人\", \
\"zone\":\"叶湘-石头人的空间\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"thumblink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
}, \
\"liked\":0, \
}, \
{ \
\"noteid\":100002, \
\"complete\":90, \
\"hot\":98765, \
\"note\":\"从前有座山山上有座庙庙里有个和尚在讲故事从前有座山山上有座庙庙里有个和尚在讲故事\", \
\"ctime\":\"2015年7月16日18:35\", \
\"imgs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
], \
\"thumbs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
], \
\"tags\": \
[ \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
], \
\"place\": \
[ \
\"北京\", \
\"三里屯\", \
], \
\"user\": \
{ \
\"userid\":20000009, \
\"name\":\"叶湘-石头人\", \
\"intro\":\"石头人工作室创始人\", \
\"zone\":\"叶湘-石头人的空间\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"thumblink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
}, \
\"liked\":0, \
}, \
]} \
";

NSString *testNoteNext = @" \
{\"idx\":0,\"ret\":0,\"msg\":\"ok\",\"res\":[ \
{ \
\"noteid\":100003, \
\"complete\":90, \
\"hot\":98765, \
\"note\":\"从前有座山山上有座庙庙里有个和尚在讲故事从前有座山山上有座庙庙里有个和尚在讲故事\", \
\"ctime\":\"2015年7月16日18:35\", \
\"imgs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
], \
\"thumbs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
], \
\"tags\": \
[ \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
], \
\"place\": \
[ \
\"北京\", \
\"三里屯\", \
], \
\"user\": \
{ \
\"userid\":20000009, \
\"name\":\"叶湘-石头人\", \
\"intro\":\"石头人工作室创始人\", \
\"zone\":\"叶湘-石头人的空间\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"thumblink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
}, \
\"liked\":0, \
}, \
{ \
\"noteid\":100004, \
\"complete\":90, \
\"hot\":98765, \
\"note\":\"从前有座山山上有座庙庙里有个和尚在讲故事从前有座山山上有座庙庙里有个和尚在讲故事\", \
\"ctime\":\"2015年7月16日18:35\", \
\"imgs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
], \
\"thumbs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
], \
\"tags\": \
[ \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
], \
\"place\": \
[ \
\"北京\", \
\"三里屯\", \
], \
\"user\": \
{ \
\"userid\":20000009, \
\"name\":\"叶湘-石头人\", \
\"intro\":\"石头人工作室创始人\", \
\"zone\":\"叶湘-石头人的空间\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"thumblink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
}, \
\"liked\":0, \
}, \
{ \
\"noteid\":100005, \
\"complete\":90, \
\"hot\":98765, \
\"note\":\"从前有座山山上有座庙庙里有个和尚在讲故事从前有座山山上有座庙庙里有个和尚在讲故事\", \
\"ctime\":\"2015年7月16日18:35\", \
\"imgs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
], \
\"thumbs\": \
[ \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
], \
\"tags\": \
[ \
\"花样美男\", \
\"帅绝人寰\", \
\"迷人不眨眼\", \
], \
\"place\": \
[ \
\"北京\", \
\"三里屯\", \
], \
\"user\": \
{ \
\"userid\":20000009, \
\"name\":\"叶湘-石头人\", \
\"intro\":\"石头人工作室创始人\", \
\"zone\":\"叶湘-石头人的空间\", \
\"imglink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/0\", \
\"thumblink\":\"http://wx.qlogo.cn/mmopen/wcib2GksmGOkGrCbUocCQiaricFExz41y44ibJ2R1BH72aFrsY7iaabru23jORGhibCXrnIhDicMBLBP4Y0RUf0ums6mA/132\", \
}, \
\"liked\":0, \
}, \
]} \
";

-(void)getStart:(int)limit
{
    if( started ){
        Log(@"already started");
        SendNotify(@"SHITOUREN_NOTE_LIST_ERR",nil);
        return;
    }
    started = YES;
    @synchronized(self){
        self.gettingNext = YES;
    }
    
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"topicid\":\"%ld\",\"begin\":\"%d\",\"limit\":\"%d\",\"userid\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],self.topicid,0,limit,[UserManager sharedInstance].userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_NOTE_LIST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    [UserManager sharedInstance].ss.ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid, nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         if (error == nil) {
                      NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//         if ( YES ){
//             NSData *testData = [testNoteStart dataUsingEncoding:NSUTF8StringEncoding];
//             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSArray *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
//                 if ( YES ) {
                                      if ( resIdx == index ) {
                     for (NSDictionary * itemDict in resRes){
                         NoteItem *item = [[NoteItem alloc] init];
                         item.topicid = self.topicid;
                         item.noteid = [[itemDict objectForKey:@"noteid"] longValue];
                         item.like_count = [[itemDict objectForKey:@"like_count"] intValue];
                         item.text = [itemDict objectForKey:@"note"];
                         item.ctime = [itemDict objectForKey:@"ctime"];
                         NSArray *imgArr = [itemDict objectForKey:@"imgs"];
                         for (NSString *imgOne in imgArr) {
                             [item.imgs addObject:imgOne];
                         }
                         NSArray *thumbArr = [itemDict objectForKey:@"thumbs"];
                         for (NSString *thumbOne in thumbArr) {
                             [item.thumbs addObject:thumbOne];
                         }
                         NSDictionary *userDic = [itemDict objectForKey:@"user"];
                         UserBriefItem *briefItem = [[UserBriefItem alloc] init];
                         briefItem = [UserBriefItem objectWithKeyValues:userDic];
                         
                         UIImage * img = [[UserManager sharedInstance] getRealLogoImageFromBrifItem:briefItem];
                         if (img) {
                             briefItem.thumbdata = UIImagePNGRepresentation(img);
                             if (!briefItem.thumbdata) {
                                 briefItem.thumbdata = UIImageJPEGRepresentation(img, 0);
                             }
                         }
                         
                         item.brief = briefItem;
                         NSArray *tagArr = [itemDict objectForKey:@"tags"];
                         for (NSString *tagOne in tagArr) {
                             TagItem *tagItem = [[TagItem alloc] init];
                             tagItem.text = tagOne;
                             [item.tags addObject:tagItem];
                         }
                         NSArray *placeArr = [itemDict objectForKey:@"place"];
                         for (NSString *placeOne in placeArr) {
                             TagItem *placeItem = [[TagItem alloc] init];
                             placeItem.text = placeOne;
                             [item.place addObject:placeItem];
                         }
                         item.liked = [[itemDict objectForKey:@"liked"] boolValue];
                         [listShow addObject:item];
                         [setShow addObject:[NSString stringWithFormat:@"%ld",item.noteid]];
                         backIndex++;
                     }
                     Log(@"%ld loaded. next is %d",self.topicid,backIndex);
                     SendNotify(@"SHITOUREN_NOTE_LIST_START",nil);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_NOTE_LIST_FAIL",resDict);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
                 SendNotify(@"SHITOUREN_NOTE_LIST_TIMEOUT",nil);
             } else {
                 Log(@"request err");
                 SendNotify(@"SHITOUREN_NOTE_LIST_ERR",nil);
             }
         }
         @synchronized(self){
             self.gettingNext = NO;
         }
         [self httpNext:limit];
     }];
}

-(void)getNext :(int)limit
{
    @synchronized(self){
        if(self.gettingNext){
            return;
        }
        self.gettingNext = YES;
    }
    //    Log(@"next : %lu",(unsigned long)listNext.count);
    if(listNext.count > 0){
        int nextCount = 0;
        for( NoteItem *one in listNext ){
            if( [setShow containsObject:[NSString stringWithFormat:@"%ld",one.noteid]] ){
                continue;
            }
            ++nextCount;
            [listShow addObject:one];
            [setShow addObject:[NSString stringWithFormat:@"%ld",one.noteid]];
        }
        [listNext removeAllObjects];
        @synchronized(self){
            self.gettingNext = NO;
        }
        SendNotify(@"SHITOUREN_NOTE_LIST_SUCC",nil);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self httpNext:limit];
        });
    }
}

-(void)httpNext:(int)limit
{
    @synchronized(self){
        self.gettingNext = YES;
    }
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"topicid\":\"%ld\",\"begin\":\"%d\",\"limit\":\"%d\",\"userid\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],self.topicid,0,limit,[UserManager sharedInstance].userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_NOTE_LIST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    [UserManager sharedInstance].ss.ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid, nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
                  if (error == nil) {
                      NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//         if ( YES ){
//             NSData *testData = [testNoteNext dataUsingEncoding:NSUTF8StringEncoding];
//             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSArray *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
//                 if ( YES ) {
                                      if ( resIdx == index ) {
                     for (NSDictionary * itemDict in resRes){
                         NoteItem *item = [[NoteItem alloc] init];
                         item.topicid = self.topicid;
                         item.noteid = [[itemDict objectForKey:@"noteid"] longValue];
                         item.like_count = [[itemDict objectForKey:@"like_count"] intValue];
                         item.text = [itemDict objectForKey:@"note"];
                         item.ctime = [itemDict objectForKey:@"ctime"];
                         NSArray *imgArr = [itemDict objectForKey:@"imgs"];
                         for (NSString *imgOne in imgArr) {
                             [item.imgs addObject:imgOne];
                         }
                         NSArray *thumbArr = [itemDict objectForKey:@"thumbs"];
                         for (NSString *thumbOne in thumbArr) {
                             [item.thumbs addObject:thumbOne];
                         }
                         NSDictionary *userDic = [itemDict objectForKey:@"user"];
                         UserBriefItem *briefItem = [[UserBriefItem alloc] init];
                         briefItem = [UserBriefItem objectWithKeyValues:userDic];
                        
                         UIImage * img = [[UserManager sharedInstance] getRealLogoImageFromBrifItem:briefItem];
                         if (img) {
                             briefItem.thumbdata = UIImagePNGRepresentation(img);
                             if (!briefItem.thumbdata) {
                                 briefItem.thumbdata = UIImageJPEGRepresentation(img, 0);
                             }
                         }
                         
                         item.brief = briefItem;
                         NSArray *tagArr = [itemDict objectForKey:@"tags"];
                         for (NSString *tagOne in tagArr) {
                             TagItem *tagItem = [[TagItem alloc] init];
                             tagItem.text = tagOne;
                             [item.tags addObject:tagItem];
                         }
                         NSArray *placeArr = [itemDict objectForKey:@"place"];
                         for (NSString *placeOne in placeArr) {
                             TagItem *placeItem = [[TagItem alloc] init];
                             placeItem.text = placeOne;
                             [item.place addObject:placeItem];
                         }
                         item.liked = [[itemDict objectForKey:@"liked"] boolValue];
                         [listNext addObject:item];
                         backIndex++;
                     }
                     Log(@"%ld loaded. next is %d",self.topicid,backIndex);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
             } else {
                 Log(@"request err");
             }
         }
         @synchronized(self){
             self.gettingNext = NO;
         }
     }];
}

-(BOOL)likePost:(long)noteid {
    @synchronized(self){
        if(self.responsing){
            Log(@"request handing");
            NSString *note = [NSString stringWithFormat:@"%ld",noteid];
            SendNotify(@"SHITOUREN_NOTE_LIKE_POST_TIMEOUT",note);
            return NO;
        }
        self.responsing = YES;
    }
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"topicid\":\"%ld\",\"noteid\":\"%ld\",\"userid\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],self.topicid,noteid,[UserManager sharedInstance].userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_NOTE_LIKE_POST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置cookie
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];

    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
                 if ( resIdx == index ) {
                     NoteItem *item = nil;
                     for (NoteItem * itemOne in listShow){
                         if( itemOne.noteid == noteid){
                             item = itemOne;
                         }
                     }
                     if( item != nil ){
                         if ([[resRes objectForKey:@"liked"] boolValue]) {
                             item.liked = YES;
                             item.like_count++;
                         }

                     }
                     Log(@"%ld liked by %ld",noteid,[UserManager sharedInstance].userid);
                     SendNotify(@"SHITOUREN_NOTE_LIKE_POST_SUCC",nil);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_NOTE_LIKE_POST_FAIL",resDict);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
                 SendNotify(@"SHITOUREN_NOTE_LIKE_POST_TIMEOUT",nil);
             } else {
                 Log(@"request err");
                 SendNotify(@"SHITOUREN_NOTE_LIKE_POST_ERR",nil);
             }
         }
         @synchronized(self){
             self.responsing = NO;
         }
     }];
    return YES;
}

-(BOOL)likeDel:(long)noteid {
    @synchronized(self){
        if(self.responsing){
            Log(@"request handing");
            NSString *note = [NSString stringWithFormat:@"%ld",noteid];
            SendNotify(@"SHITOUREN_NOTE_LIKE_DEL_TIMEOUT",note);
            return NO;
        }
        self.responsing = YES;
    }
    NSString *postData = [NSString stringWithFormat:@"{\"idx\":%d,\"ver\":\"%@\",\"params\":{\"topicid\":\"%ld\",\"noteid\":\"%ld\",\"userid\":\"%ld\"}}",((++index)%1000),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],self.topicid,noteid,[UserManager sharedInstance].userid];
    NSString *postStr = [NSString stringWithFormat:@"postData=%@",postData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SHITOUREN_API_NOTE_LIKE_DEL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:k_User_Agent forHTTPHeaderField:@"User-Agent"];
    
    // 设置cookie
    NSString *ssid = [UserManager sharedInstance].ss.ssid;
    NSString *ssid_check = [UserManager sharedInstance].ss.ssid_check;
    NSString *ssid_verify = [UserManager sharedInstance].ss.ssid_verify;
    NSDictionary *dictCookiessid = [NSDictionary dictionaryWithObjectsAndKeys:
                                    k_NSHTTPCookieName_SSID, NSHTTPCookieName,
                                    ssid, NSHTTPCookieValue,
                                    @"/", NSHTTPCookiePath,
                                    SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                    nil];
    NSHTTPCookie *cookiessid = [NSHTTPCookie cookieWithProperties:dictCookiessid];
    
    NSDictionary *dictCookiecheck = [NSDictionary dictionaryWithObjectsAndKeys:
                                     k_NSHTTPCookieName_CHECK, NSHTTPCookieName,
                                     ssid_check, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                     nil];
    NSHTTPCookie *cookiecheck = [NSHTTPCookie cookieWithProperties:dictCookiecheck];
    
    NSDictionary *dictCookieverify = [NSDictionary dictionaryWithObjectsAndKeys:
                                      k_NSHTTPCookieName_VERIFY, NSHTTPCookieName,
                                      ssid_verify, NSHTTPCookieValue,
                                      @"/", NSHTTPCookiePath,
                                      SHITOUREN_DOMAIN, NSHTTPCookieDomain,
                                      nil];
    NSHTTPCookie *cookieverify = [NSHTTPCookie cookieWithProperties:dictCookieverify];
    NSArray *arrCookies = [NSArray arrayWithObjects: cookiessid,cookiecheck,cookieverify,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection
     sendAsynchronousRequest  : request
     queue : [NSOperationQueue mainQueue]
     completionHandler : ^(NSURLResponse* response, NSData* data, NSError* error) {
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
         //         int responseStatusCode = [httpResponse statusCode];
         //         Log(@"status code : %d",responseStatusCode);
         if (error == nil) {
             NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             int resIdx = [[resDict objectForKey:@"idx"] intValue];
             int resRet = [[resDict objectForKey:@"ret"] intValue];
             NSString *msg = [resDict objectForKey:@"msg"];
             NSDictionary *resRes = [resDict objectForKey:@"res"];
             if (resRet==0) {
                 if ( resIdx == index ) {
                     NoteItem *item = nil;
                     for (NoteItem * itemOne in listShow){
                         if( itemOne.noteid == noteid){
                             item = itemOne;
                         }
                     }
                     if( item != nil ){
                         if (![[resRes objectForKey:@"liked"] boolValue]) {
                             item.liked = NO;
                             item.like_count--;
                         }                     }
                     Log(@"%ld liked by %ld",noteid,[UserManager sharedInstance].userid);
                     SendNotify(@"SHITOUREN_NOTE_LIKE_DEL_SUCC",nil);
                 } else {
                     // 已经是过期的请求
                 }
             } else {
                 Log(@"request false : %@",msg);
                 SendNotify(@"SHITOUREN_NOTE_LIKE_DEL_FAIL",resDict);
             }
         } else {
             if( [error code] == NSURLErrorTimedOut ){
                 Log(@"request timeout");
                 SendNotify(@"SHITOUREN_NOTE_LIKE_DEL_TIMEOUT",nil);
             } else {
                 Log(@"request err");
                 SendNotify(@"SHITOUREN_NOTE_LIKE_DEL_ERR",nil);
             }
         }
         @synchronized(self){
             self.responsing = NO;
         }
     }];
    return YES;
}

@end
