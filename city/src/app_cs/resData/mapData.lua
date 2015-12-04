

QMapGlobal.userData = {}   -- 保存于登陆用户相关的数据
QMapGlobal.ortherData = {}  -- 其他数据， 不能被改动，由服务器提供
QMapGlobal.systemData = {}  -- 系统数据，不能被改动，由服务器提供或程序运行前内定

-- 模拟数据文件
--  用户数据 
QMapGlobal.userData.userInfo = {
    userid = 0, name="star", image = "star.png", email = "star@shitouren.com", phone = "12345678901", pic = "headImage.jpg",
    addr = "北京市", sex = "boy", desc = "上天入地唯我独尊"
}

-- 用户 去过的景点,用户的游记 目前只支持一个城市一篇游记，用城市的id作为索引
QMapGlobal.userData.userInfo.journeys = {
    -- [2] = {  -- 
    --     journeyid = 1, -- 游记ID， 
    --     cityid = 1,      -- 城市id
    --     title = "青岛自由行",  -- 游记标题
    --     upload = false,     --是否发布
    --     utime = "",      -- 发布时间
    --     journey = {
    --             -- markid ,来自于城市数据中得markid,  mark,用户对景点的点评， pic ,用户拍得照片， lable, 标签， visiteTime,时间
    --         {sightid = 1, order =1, markid = 1, mark = "青岛大学就是一所大学", ctime = "2015-3-6", 
    --             image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}} },
    --         {sightid = 3, order =2, markid = 2, mark = "栈桥", ctime = "2015-3-6", 
    --             image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}} },
    --     }
    -- },     

    -- [1] = {
    --     journeyid = 2,
    --     caption = "桂林是一首诗",
    --     journey = {
            
    --     }
    -- }
}

-- 用户 收藏的数据
QMapGlobal.userData.userInfo.collect = {
    {userid = 111, authorid = 113, cityid = 1, journeyid = 1 }
}

-- 用户 行程
QMapGlobal.userData.userInfo.itinerary = {
    -- 2 = {   -- 青岛， 以城市ID作为索引
    --     -- id ,来自于城市数据中得id
    --     {sightid = 5 ,order = 1},
    --     {sightid = 1  ,order = 2},
    --     {sightid = 10  ,order = 3},
    --     {sightid = 5  ,order = 4},
    --     {sightid = 12  ,order = 5},
    -- },     
    -- 1 = {}   -- 桂林
}

-- QMapGlobal.ortherData.userIDName = {
--     -- [112] = "王远帆",[113] = "朴成哲", [114] = "陈晓琪",[115] = "艳崽",
--     -- [116] = "文德",[117] = "司聪", [118] = "嘉文",[119] = ""
-- }

QMapGlobal.ortherData.labelData = {
    -- [1] = {
    --     -- [sightid] = {{}}   "isowner":false,  -- 是否自己添加    "isliked":true,    -- 自己有没有点赞
    --     [1] = { 
    --             {id = 1, userid = 112, content = "值得一看"},
    --             {id = 2, userid = 112, content = "很好玩，风景优美"},
    --             {id = 3, userid = 113, content = "交通方便，值得去"},
    --             {id = 4, userid = 114, content = "很漂亮，很有意思"},
    --             {id = 5, userid = 115, content = "不值得一去，太远了"}
    --         },
    -- },
    -- [2] = {
    --     -- [sightid] = {{}}   "isowner":false,  -- 是否自己添加    "isliked":true,    -- 自己有没有点赞
    --     [1] = { 
    --             {id = 1, userid = 112, content = "值得一看"},
    --             {id = 2, userid = 112, content = "很好玩，风景优美"},
    --             {id = 3, userid = 113, content = "交通方便，值得去"},
    --             {id = 4, userid = 114, content = "很漂亮，很有意思"},
    --             {id = 5, userid = 115, content = "不值得一去，太远了"}
    --         },
    -- }
}

QMapGlobal.ortherData.commentData = {
    -- guilin = {
    --     [1] = {
    --         { userid = 112, time  = "2015年3月5日", journeyid = 1, markid = 1,
    --             comment = "这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园",
    --             image = {{id = 1, ctime = ""},{id = 2, ctime = ""},{id = 3, ctime = ""},{id = 4, ctime = ""},{id = 5, ctime = ""},{id = 6, ctime = ""}},
    --             title = "桂林之行"
    --         },
    --         { userid = 113, time  = "2015年4月5日", journeyid = 1, markid = 1,
    --             comment = "桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园",
    --             image = {{id = 1, ctime = ""},{id = 2, ctime = ""},{id = 3, ctime = ""},{id = 4, ctime = ""},{id = 5, ctime = ""}},
    --             title = "桂林见闻"
    --         },
    --         { userid = 114, time  = "2015年2月5日", journeyid = 1, markid = 1,
    --             comment = "不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道",
    --             image = {{id = 1, ctime = ""},{id = 2, ctime = ""},{id = 3, ctime = ""},{id = 4, ctime = ""},{id = 5, ctime = ""},{id = 6, ctime = ""}},
    --             title = "桂林其他"
    --         },
    --     },
    -- },

    -- qingdao = {
    --     [1] = {
    --         { userid = 114, time  = "2015年3月5日", journeyid = 1, markid = 1,
    --             comment = "这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园这是一个公园",
    --             image = {{id = 1, ctime = ""},{id = 2, ctime = ""},{id = 3, ctime = ""},{id = 4, ctime = ""},{id = 5, ctime = ""},{id = 6, ctime = ""}},
    --             title = "桂林之行"
    --         },
    --         { userid = 118, time  = "2015年4月5日", journeyid = 1, markid = 1,
    --             comment = "桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园桂林公园",
    --             image = {{id = 1, ctime = ""},{id = 2, ctime = ""},{id = 3, ctime = ""},{id = 4, ctime = ""},{id = 5, ctime = ""}},
    --             title = "桂林见闻"
    --         },
    --         { userid = 116, time  = "2015年2月5日", journeyid = 1, markid = 1,
    --             comment = "不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道不知道",
    --             image = {{id = 1, ctime = ""},{id = 2, ctime = ""},{id = 3, ctime = ""},{id = 4, ctime = ""},{id = 5, ctime = ""},{id = 6, ctime = ""}},
    --             title = "桂林其他"
    --         },
    --     },
    -- }
}


-- 网络返回的游记
QMapGlobal.ortherData.journeyData = {
    -- [1]= {
    --         {
    --             cityid = 1,     -- 城市id
    --             userid = 112,   -- 作者id
    --             username = "王远帆",
    --             desc = "神龙见首不见尾",
    --             -- image = "1",
    --             journeyid = 1, -- 游记ID， 
    --             title = "桂林自由行",  -- 游记标题
    --             -- upload = false,     --是否发布
    --             utime = "",      -- 发布时间  
    --             journey = {
    --                     -- markid ,来自于城市数据中得markid,  mark,用户对景点的点评， pic ,用户拍得照片， lable, 标签， visiteTime,时间
    --                 {sightid = 1, order =1, markid = 1, mark = "象山以神奇著称。其神奇，首先是形神毕似，其次是在鼻腿之间造就一轮临水明月，构成“象山水月”奇景", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 2, order =2, markid = 2, mark = "气势宏伟，值得一游", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 4, order =3, markid = 3, mark = "桂林市面积最大、景致最集中的综合性公园，园内山峰秀丽、流水清澈、石林奇峻、洞穴幽深、风韵独特", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 5, order =4, markid = 4, mark = "栈桥", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 19, order =5, markid = 5, mark = "青岛大学就是一所大学", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 9, order =6, markid = 6, mark = "栈桥", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 11, order =7, markid = 7, mark = "青岛大学就是一所大学", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 13, order =8, markid = 8, mark = "栈桥", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --             }
    --         },
 
 
    -- [2]= {
    --         {
    --             cityid = 2,     -- 城市id
    --             userid = 112,   -- 作者id
    --             username = "王远帆",
    --             desc = "神龙见首不见尾",
    --             -- image = "1",
    --             journeyid = 1, -- 游记ID， 
    --             title = "桂林自由行",  -- 游记标题
    --             -- upload = false,     --是否发布
    --             utime = "",      -- 发布时间  
    --             journey = {
    --                     -- markid ,来自于城市数据中得markid,  mark,用户对景点的点评， pic ,用户拍得照片， lable, 标签， visiteTime,时间
    --                 {sightid = 1, order =1, markid = 1, mark = "象山以神奇著称。其神奇，首先是形神毕似，其次是在鼻腿之间造就一轮临水明月，构成“象山水月”奇景", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 2, order =2, markid = 2, mark = "气势宏伟，值得一游", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 4, order =3, markid = 3, mark = "桂林市面积最大、景致最集中的综合性公园，园内山峰秀丽、流水清澈、石林奇峻、洞穴幽深、风韵独特", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 5, order =4, markid = 4, mark = "栈桥", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 19, order =5, markid = 5, mark = "青岛大学就是一所大学", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 9, order =6, markid = 6, mark = "栈桥", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 11, order =7, markid = 7, mark = "青岛大学就是一所大学", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --                 {sightid = 13, order =8, markid = 8, mark = "栈桥", ctime = "2015-3-6", 
    --                     image = {{id = 1, ctime = ""}, {id = 2, ctime = ""}, {id = 3, ctime = ""}, {id = 4, ctime = ""}, {id = 5, ctime = ""}, {id = 6, ctime = ""}} },
    --             }
    --         },
    --     }
}

QMapGlobal.systemData.sightDescCaption = {
    {caption = "最美季节", color = cc.c3b(255,117,119) }, {caption = "开放时间", color = cc.c3b(0,201,191)}, 
    {caption = "游览时间", color = cc.c3b(128, 166, 255)}, 
    {caption = "主要看点", color = cc.c3b(233, 148, 212)}, {caption = "大家印象", color = cc.c3b(115, 204, 119)}, 
    {caption = "推荐理由", color = cc.c3b(0, 187, 220)}, {caption = "门票价格", color = cc.c3b(255, 173, 46)}, 
    {caption = "游览Tips", color = cc.c3b(115, 227, 255)}, {caption = "交通线路", color = cc.c3b(188, 152, 255)}
}

-- 系统数据
-- 地图数据，包含所有可选城市
QMapGlobal.systemData.mapData = {
    -- 以cityid作为索引
    [1] = {cityid = 1, name = "guilin", pos = {x = 100,y = 120}, cname = "桂林", provid = 0, version = 0, 
        download = true, tColor = {r = 211, g = 229, b = 163, z = 255}, bColor =  {r = 211, g = 229, b = 163, z = 255}, versioninfo = 0,
        isNative = true,
        sight = {    -- 桂林 37个景点
        -- 以sightid作为索引
            [1] = {sightid = 1, name = "1", cname = "象鼻山2", image = {1,2,3,4,5,6,7},
                desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "淡季(12-3月):07:00-21:30\r\n旺季(4-11月):06:30-21:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "象鼻山、水月洞、普贤塔、象眼岩"}, 
                        {descid = 5, content = "山像一头站在江边伸鼻豪饮漓江甘泉的巨象。"}, 
                        {descid = 6, content = "桂林市城徽，桂林山水的象征，元"}, 
                        {descid = 7, content = "75元/人"}, 
                    }},

            [2] = {sightid = 2, name = "2", cname = "靖江王府", image = {1,2,3,4},

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "08:30-17:30"},  
                        {descid = 3, content = "1-3小时"}, 
                        {descid = 4, content = "独秀峰、王府、摩崖石刻"}, 
                        {descid = 5, content = "王城之于桂林，犹如故宫之于帝都"}, 
                        {descid = 6, content = "国内保保护最完整的明代藩王府"}, 
                        {descid = 7, content = "独秀峰·靖江王城景区通票130元/人"},
                    }},

            [4] = {sightid = 4, name = "4", cname = "七星公园", image = {1,2,3,4,5,6,7,8,9,10},
                    type = 2,
                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "夏季：06:00-19:30\r\n冬季：06:30-19:00"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "七星山、骆驼山、花桥、桂海碑林、七星岩"}, 
                        {descid = 5, content = "空气很清新，环境很幽静，公园景色美"}, 
                        {descid = 6, content = "桂林最大，游客最盛，历史性最长的综合性公园"}, 
                        {descid = 7, content = "75元/人"}, 
                    }},
            [5] = {sightid = 5, name = "5", cname = "日月双塔", image = {1,2,3,4,5,6},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [6] = {sightid = 6, name = "6", cname = "漓江", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [8] = {sightid = 8, name = "8", cname = "叠彩山", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [9] = {sightid = 9, name = "9", cname = "伏波山", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [10] = {sightid = 10, name = "10", cname = "老人山", image = {1,2,3,4,5,6,7,8,9},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [11] = {sightid = 11, name = "11", cname = "两江四湖", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [12] = {sightid = 12, name = "12", cname = "木龙湖", image = {1,2,3,4,5,6,7,8,9,10},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [13] = {sightid = 13, name = "13", cname = "刘三姐大观园", image = {1,2,3,4,5,6,7,8,9,10,11,12},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [14] = {sightid = 14, name = "14", cname = "芦笛岩", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [15] = {sightid = 15, name = "15", cname = "南溪山公园", image = {1,2,3,4,5,6,7,8,9,10},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [16] = {sightid = 16, name = "16", cname = "正阳步行街", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [17] = {sightid = 17, name = "17", cname = "尧山", image = {1,2,3,4,5,6,7,8},
                    type = 2,
                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [18] = {sightid = 18, name = "18", cname = "穿山公园", image = {1,2,3,4,5},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [19] = {sightid = 19, name = "19", cname = "桂林植物园", image = {1,2},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [20] = {sightid = 20, name = "20", cname = "西山公园", image = {1,2,3,4,5,6,7},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [21] = {sightid = 21, name = "21", cname = "两江四湖", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [22] = {sightid = 22, name = "22", cname = "木龙湖", image = {1,2,3,4,5,6,7,8,9,10},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [23] = {sightid = 23, name = "23", cname = "刘三姐大观园", image = {1,2,3,4,5,6,7,8,9,10,11,12},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [24] = {sightid = 24, name = "24", cname = "芦笛岩", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [25] = {sightid = 25, name = "25", cname = "南溪山公园", image = {1,2,3,4,5,6,7,8,9,10},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [26] = {sightid = 26, name = "26", cname = "正阳步行街", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [27] = {sightid = 27, name = "27", cname = "尧山", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [28] = {sightid = 28, name = "28", cname = "穿山公园", image = {1,2,3,4,5},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [29] = {sightid = 29, name = "29", cname = "桂林植物园", image = {1,2},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [30] = {sightid = 30, name = "30", cname = "桂林植物园", image = {1,2},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [31] = {sightid = 31, name = "31", cname = "两江四湖", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [32] = {sightid = 32, name = "32", cname = "木龙湖", image = {1,2,3,4,5,6,7,8,9,10},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [33] = {sightid = 33, name = "33", cname = "刘三姐大观园", image = {1,2,3,4,5,6,7,8,9,10,11,12},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [34] = {sightid = 34, name = "34", cname = "芦笛岩", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [35] = {sightid = 35, name = "35", cname = "南溪山公园", image = {1,2,3,4,5,6,7,8,9,10},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [36] = {sightid = 36, name = "36", cname = "正阳步行街", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [37] = {sightid = 37, name = "37", cname = "尧山", image = {1,2,3,4,5,6,7,8},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [38] = {sightid = 38, name = "38", cname = "穿山公园", image = {1,2,3,4,5},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            [39] = {sightid = 39, name = "39", cname = "桂林植物园", image = {1,2},

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-22:30"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "双塔灯光、水下水族馆"}, 
                        {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
                        {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
                        {descid = 7, content = "登塔35元/人"}, 
                    }},
            -- [40] = {sightid = 40, name = "40", cname = "国贸片区", image = {1,2},
            --         type = 2,
            --         desc = {
            --             {descid = 1, content = "4月-10月"}, 
            --             {descid = 2, content = "08:00-22:30"},  
            --             {descid = 3, content = "1小时"}, 
            --             {descid = 4, content = "双塔灯光、水下水族馆"}, 
            --             {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
            --             {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
            --             {descid = 7, content = "登塔35元/人"}, 
            --         }},
            -- [41] = {sightid = 41, name = "41", cname = "中关村片区", image = {1,2},
            --         type = 2,
            --         desc = {
            --             {descid = 1, content = "4月-10月"}, 
            --             {descid = 2, content = "08:00-22:30"},  
            --             {descid = 3, content = "1小时"}, 
            --             {descid = 4, content = "双塔灯光、水下水族馆"}, 
            --             {descid = 5, content = "晚上的双塔上都会打开灯光，非常漂亮"}, 
            --             {descid = 6, content = "日月双塔是夜游两江四湖最主要的景点之一"}, 
            --             {descid = 7, content = "登塔35元/人"}, 
            --         }},
        }
    },

    [2] = {cityid = 2, name = "qingdao", pos = {x = 100,y = 120}, cname = "青岛", provid = 0, version = 0, 
        download = true, tColor = {r = 154, g = 204, b = 141, z = 255}, bColor = {r = 154, g = 204, b = 141, z = 255}, versioninfo = 0,
        isNative = true,
        sight = {
            [1] = {sightid = 1, name = "1", cname = "栈桥", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "回澜阁"}, 
                        {descid = 5, content = "青岛最浪漫的地方之一"}, 
                        {descid = 6, content = "青岛的重要标志性建筑物和著名风景游览点"}, 
                        {descid = 7, content = "免费（进回澜阁4元）"}, 
                    }},
            [2] = {sightid = 2, name = "2", cname = "八大关", image = {1, 2, 3, 4,5,6}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "2~3个小时"}, 
                        {descid = 4, content = "德国占日留下的建筑群"}, 
                        {descid = 5, content = "公园与庭院融合在一起，到处是郁郁葱葱的树木，四季盛开的鲜花，十条马路的行道树品种各异。"}, 
                        {descid = 6, content = "体现青岛“红瓦绿树、碧海蓝天”特点的风景区"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [3] = {sightid = 3, name = "3", cname = "极地海洋世界", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "8：00-17：30"},  
                        {descid = 3, content = "3-4小时"}, 
                        {descid = 4, content = "白鲸、海象、北极熊、企鹅等珍稀的极地动物"}, 
                        {descid = 5, content = "青岛极地海洋世界是青岛旅游的一大亮点，其最大的特色是动物表演，主要有两个动物表演馆，一是极地馆，二是欢乐剧场；每天有好几场表演"}, 
                        {descid = 6, content = "是目前国内最大、拥有极地海洋动物品种最全、数量最多的场馆。"}, 
                        {descid = 7, content = "180元（淡季150元）"}, 
                    }},
            [4] = {sightid = 4, name = "4", cname = "小青岛", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "旺季7:30-18:00，淡季8:00-17:00"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "灯塔、琴女。"}, 
                        {descid = 5, content = "小青岛山岩峻秀，林木蓊郁，红礁碧浪，绿树白塔，如一幅美丽的图画。"}, 
                        {descid = 6, content = "” 琴屿飘灯”被誉为青岛十大景观之一，被作为青岛市的标志之一。"}, 
                        {descid = 7, content = "旺季（4月1日-10月31日 ）15元/人，淡季（11月1日-3月31日）10元/人，无学生票"}, 
                    }},
            [5] = {sightid = 5, name = "5", cname = "石老人景区", image = {1, 2, 3, 4,5}, 

                    desc = {
                        {descid = 1, content = "4月-7月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "2~3个小时"}, 
                        {descid = 4, content = "石老人石柱，海水浴场"}, 
                        {descid = 5, content = "石老人来源于海边的一个天然石柱，远看就像是一个坐着的老人一样；现在周围已经打造成度假区了，配套设施也比较完善"}, 
                        {descid = 6, content = "我国基岩海岸典型的海蚀柱景观，青岛著名的观光景点。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [6] = {sightid = 6, name = "6", cname = "五四广场", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = " 1-2小时"}, 
                        {descid = 4, content = " 分布于中轴线上的市政府办公大楼、隐式喷泉、点阵喷泉、《五月的风》雕塑、海上百米喷泉等。"}, 
                        {descid = 5, content = "东部新市区的主要文化景观。"}, 
                        {descid = 6, content = "因青岛为中国近代史上伟大的五四运动导火索而得名。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [7] = {sightid = 7, name = "7", cname = "基督教堂", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "8:00-16:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "礼堂、钟楼。"}, 
                        {descid = 5, content = "花岗石的德国古堡式建筑"}, 
                        {descid = 6, content = "基督教堂是青岛著名的宗教建筑，国家重点文物保护单位。"}, 
                        {descid = 7, content = "4元/人"}, 
                    }},
            [8] = {sightid = 8, name = "8", cname = "天主教堂", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "每天6:00平日弥撒，周日8:00-9:00主日弥撒"},  
                        {descid = 3, content = "30分钟"}, 
                        {descid = 4, content = "钟塔，铜钟。"}, 
                        {descid = 5, content = "拍摄婚纱最佳取景之地。"}, 
                        {descid = 6, content = "这是基督教建筑艺术的杰作，由德国设计师毕娄哈依据哥德式和罗马式建筑风格而设计，人们习惯称之为天主教堂。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [9] = {sightid = 9, name = "9", cname = "奥帆中心", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "5-8月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = " 2-3小时"}, 
                        {descid = 4, content = "奥运祥云火炬雕塑，场馆前的帆船雕塑建筑"}, 
                        {descid = 5, content = "赏日落、拍摄夕阳的绝佳之地"}, 
                        {descid = 6, content = "奥帆中心是青岛的一大地标景观，这里矗立着巨大的北京奥运火炬与奥运五环，而港湾中停满的帆船更是壮观。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [10] = {sightid = 10, name = "10", cname = "青岛啤酒街", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "青岛啤酒厂"}, 
                        {descid = 5, content = "彩色街，卡通街，亮化街，雕塑街。"}, 
                        {descid = 6, content = "青岛市乃至全省唯一集旅游、餐饮、娱乐、休闲等多种功能于一体的室内步行商业街。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [11] = {sightid = 11, name = "11", cname = "中山路", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "栈桥，商业步行街"}, 
                        {descid = 5, content = "这里是最著名的商业街了，汇聚了很多老字号，繁华、喧嚣，买卖兴隆。"}, 
                        {descid = 6, content = "百年历史、闻名全国的商业街，曾经是青岛的“名片”，也可以说是青岛商业的“母脉”。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [12] = {sightid = 12, name = "12", cname = "德国风情街", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = " 1-2小时"}, 
                        {descid = 4, content = "一公里的德国式建筑"}, 
                        {descid = 5, content = "老城区有很多德占日占期修建的老建筑。"}, 
                        {descid = 6, content = "岛的金融经济中心，被称作是“青岛的华尔街"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [13] = {sightid = 13, name = "13", cname = "青岛国际啤酒城", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "6-8月"}, 
                        {descid = 2, content = "白天（10:00~15:00 ）\r\n晚上（15:00~22:00）"},  
                        {descid = 3, content = "2个小时"}, 
                        {descid = 4, content = "啤酒文化"}, 
                        {descid = 5, content = "融旅游、文化、体育、经贸于一体的国家级大型节庆活动"}, 
                        {descid = 6, content = "青岛国际啤酒城是亚洲最大的国际啤酒都会、一年一度的青岛国际啤酒节的举行地。"}, 
                        {descid = 7, content = "白天票10元，夜晚票20元"}, 
                    }},
            [14] = {sightid = 14, name = "14", cname = "第一海水浴场", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "2个小时"}, 
                        {descid = 4, content = "亚洲最大的海水浴场"}, 
                        {descid = 5, content = "自然条件属于世界一流的，白天阳光太强。风景还不错，夏天人很多很热闹"}, 
                        {descid = 6, content = "青岛海滨风景区的精华所在，呈半月形，面广沙平，既无暗礁隐壑，又无旋涡狂涛。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            -- [15] = {sightid = 15, name = "15", cname = "青岛电视塔", image = {1, 2, 3, 4}, 

            --         desc = {
            --             {descid = 1, content = "四季皆宜"}, 
            --             {descid = 2, content = "8：00-17：30"},  
            --             {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
            --             {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
            --             {descid = 5, content = "四季皆宜"}, 
            --             {descid = 6, content = "130元"}, 
            --             {descid = 7, content = "免费"}, 
            --         }},
            [16] = {sightid = 16, name = "16", cname = "天幕城", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "09:00-21:00"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "青岛纺织博物馆，荧光屏幕，各国美食餐厅，小型旅馆和购物商店。"}, 
                        {descid = 5, content = "熠熠星空、湛蓝天际、五彩夕霞等，如油画般变幻多姿，别有一番特色。"}, 
                        {descid = 6, content = "集旅游、餐饮、娱乐、休闲等多种功能于一体的室内步行商业街。"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [17] = {sightid = 17, name = "17", cname = "湛山寺", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "8：00-17：00"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "佛教文化"}, 
                        {descid = 5, content = "青岛市区里唯一的佛寺，交通方便，香火旺盛。"}, 
                        {descid = 6, content = "文革期间，此刹一度被毁。1983年，湛山寺被列为全国重点寺院。"}, 
                        {descid = 7, content = "5元/人"}, 
                    }},
            [18] = {sightid = 18, name = "18", cname = "中山公园", image = {1, 2, 3, 4,5,6}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "9:00-21:00"},  
                        {descid = 3, content = "2小时"}, 
                        {descid = 4, content = "孙文莲池、动物园、欢动世界。"}, 
                        {descid = 5, content = "三面环山，南向大海，樱花会、深秋菊展"}, 
                        {descid = 6, content = "公园三面环山，南向大海，青岛最大的综合性公园"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [19] = {sightid = 19, name = "19", cname = "海军博物馆", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "旺季（5月1日—10月31日）8:00-18:00\r\n淡季（11月1日—4月30日）8:30-17:00"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "军服礼品展厅、武器装备展区和海上展舰区"}, 
                        {descid = 5, content = "海军博物馆面积很大，陈列的展品丰富，非常适合带孩子一起来了解中国海军发展历史。"}, 
                        {descid = 6, content = "海军博物馆由海军创建，是中国唯一的一座全面反映中国海军发展的军事博物馆。"}, 
                        {descid = 7, content = "60元/人"}, 
                    }},
            [20] = {sightid = 20, name = "20", cname = "信号山公园", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = ""},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "其中一座建筑中有一个30分钟可转360°的双层观景台，你站在这里可一览青岛全貌。这个以欧式风格规划建设的公园因山得名，即信号山公园。"}, 
                        {descid = 5, content = "半傍时分，站在信号山公园的山顶上，当晚霞把迎宾馆的建筑映得通红时，便成就了青岛新十景之一的“红楼暮霞”"}, 
                        {descid = 6, content = "德国占领时期，山顶上曾建立了当时青岛的第一个无线军用电台"}, 
                        {descid = 7, content = "门票13元"}, 
                    }},
            -- [21] = {sightid = 21, name = "21", cname = "青岛电视塔", image = {1, 2, 3, 4}, 

            --         desc = {
            --             {descid = 1, content = "四季皆宜"}, 
            --             {descid = 2, content = "8：00-17：30"},  
            --             {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
            --             {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
            --             {descid = 5, content = "四季皆宜"}, 
            --             {descid = 6, content = "130元"}, 
            --             {descid = 7, content = "免费"}, 
            --         }},
            [22] = {sightid = 22, name = "22", cname = "小鱼山", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = ""}, 
                        {descid = 2, content = "7:30—18:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = ""}, 
                        {descid = 5, content = "山虽不高却能远眺，登山俯瞰，栈桥、小青岛、鲁迅公园、海水浴场、八大关等景观尽收眼底；虽不大却因地处市区而颇显突出，为游人视线所瞩。"}, 
                        {descid = 6, content = "小鱼山公园是青岛市第一座古典风格的山头园林公园。"}, 
                        {descid = 7, content = "15元"}, 
                    }},
            [23] = {sightid = 23, name = "23", cname = "海底世界", image = {1, 3}, 

                    desc = {
                        {descid = 1, content = " 全年皆宜"}, 
                        {descid = 2, content = "8：00-17：30"},  
                        {descid = 3, content = " 3-4小时"}, 
                        {descid = 4, content = "海底世界馆,梦幻水母馆,+海兽馆,海洋生物馆,淡水馆,抹香鲸馆"}, 
                        {descid = 5, content = ""}, 
                        {descid = 6, content = "它是在原青岛海豚表演馆的基础上投资兴建的集吃、住、行、游、购、娱为一体，以海洋公园为主题的大型开放式旅游项目。 是目前国内最大、拥有极地海洋动物品种最全、数量最多的场馆。"}, 
                        {descid = 7, content = "通票150元。"}, 
                    }},
            [24] = {sightid = 24, name = "24", cname = "青岛电视塔", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "8:00~21:00"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "青岛日出，夜景。"}, 
                        {descid = 5, content = "远景很漂亮，不仅可以欣赏高处美丽的风景，而且展现了青岛的美丽的一面。非常好的地方，看到的风景也很好。"}, 
                        {descid = 6, content = "青岛电视塔。塔高232米，堪称“中国第一钢塔”，在世界上仅次于巴黎 埃菲尔铁塔和日本 东京电视塔。"}, 
                        {descid = 7, content = "一层至球四：100.00元 球三以下（含球三）：80.00元 十层以下（含十层）：50.00元"}, 
                    }},
            [25] = {sightid = 25, name = "25", cname = "第二海水浴场", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "6月-8月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "3~4小时"}, 
                        {descid = 4, content = "收费海滨浴场，砂质水质保护得更好，更适合游泳。"}, 
                        {descid = 5, content = "第二、三海滨浴场都是收费的，相比第一浴场水质更干净，沙质更细软"}, 
                        {descid = 6, content = "位于汇泉湾东侧的太平湾内， 德占青岛之初，德国总督常骑马到此狩猎，下海游泳，以后辟为海水浴场。"}, 
                        {descid = 7, content = "夏季入场2.00元, 更衣冲水10.00元"}, 
                    }},
            [26] = {sightid = 26, name = "26", cname = "台东夜市", image = {1}, 

                    desc = {
                        {descid = 1, content = "6月-10月"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "3小时"}, 
                        {descid = 4, content = "小吃、烧烤、娱乐、购物步行街。"}, 
                        {descid = 5, content = "白天在下海游泳，晚上来台东夜市购物，或者吃一顿海鲜烧烤，是很多来过青岛的游客津津乐道的经历"}, 
                        {descid = 6, content = "青岛商业街台东夜市是青岛目前最大的商圈"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [27] = {sightid = 27, name = "27", cname = "迎宾馆", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "8:30-17:00"},  
                        {descid = 3, content = "30分钟"}, 
                        {descid = 4, content = "建筑结构，文化历史。"}, 
                        {descid = 5, content = "内部宫庭式木质结构，外观古堡式建筑"}, 
                        {descid = 6, content = "德国威廉时代典型的建筑式样， 是德国侵占青岛后的总督官邸。"}, 
                        {descid = 7, content = "15元/人"}, 
                    }},
            [28] = {sightid = 28, name = "28", cname = "青岛博物馆", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "9：00—17：00"},  
                        {descid = 3, content = "2小时"}, 
                        {descid = 4, content = "参观各种古代工艺品与书画，了解青岛的悠远历史。"}, 
                        {descid = 5, content = "青岛博物馆也是来青岛之后必须要逛逛的地方之一"}, 
                        {descid = 6, content = "青岛市博物馆是集历史、艺术、人文为一体的综合性、多功能、现代化博物馆"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [29] = {sightid = 29, name = "29", cname = "青岛植物园", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "4-9月"}, 
                        {descid = 2, content = "8：00-17：30"},  
                        {descid = 3, content = "3小时"}, 
                        {descid = 4, content = "听涛阁，法国楼，中日友好园，茶园"}, 
                        {descid = 5, content = "植物园感觉人还是比较少的，很清静，适合静静的散步"}, 
                        {descid = 6, content = "青岛植物园是以林木花卉等观赏植物为主的集科研科普、花木繁育和观赏于一体的综合性旅游景点。"}, 
                        {descid = 7, content = "森林乐园10元、植物精品园5元"}, 
                    }},
            [30] = {sightid = 30, name = "30", cname = "中国海洋大学", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "全天开放"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "德式建筑"}, 
                        {descid = 5, content = "百年老校，历史底蕴深厚，景色也很不错"}, 
                        {descid = 6, content = "中国最美的十大高校之一"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [31] = {sightid = 31, name = "31", cname = "鲁迅公园", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "9:00-16:00"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "高大的海岸礁石"}, 
                        {descid = 5, content = "临海公园，可以看看海景"}, 
                        {descid = 6, content = "红礁、碧浪、青松、幽径，逶迤多姿，淡雅清新"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            -- [32] = {sightid = 32, name = "32", cname = "青岛电视塔", image = {1, 2, 3, 4}, 

            --         desc = {
            --             {descid = 1, content = "四季皆宜"}, 
            --             {descid = 2, content = "8：00-17：30"},  
            --             {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
            --             {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
            --             {descid = 5, content = "四季皆宜"}, 
            --             {descid = 6, content = "130元"}, 
            --             {descid = 7, content = "免费"}, 
            --         }},
            [33] = {sightid = 33, name = "33", cname = "天后宫", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "9:00-16:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "山门、福鼎、圣母殿、财神殿、龙王殿、六十甲子星宿神殿、民俗博物馆"}, 
                        {descid = 5, content = "院落并不大，是沿海一座具有民俗文化的建筑"}, 
                        {descid = 6, content = "建筑艺术和彩绘艺术都是首屈一指"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [34] = {sightid = 34, name = "34", cname = "德国监狱旧址博物", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "淡季（12-3月）：07:00-21:30\r\n旺季（4-11月）：06:30-21:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = ""}, 
                        {descid = 5, content = "还原了当时囚禁犯人的场景，底层的刑场很是阴森"}, 
                        {descid = 6, content = "集监狱建筑群、司法文物收藏为一体的特色博物馆"}, 
                        {descid = 7, content = "25元/人"}, 
                    }},
            -- [35] = {sightid = 35, name = "35", cname = "青岛电视塔", image = {1, 2, 3, 4}, 

            --         desc = {
            --             {descid = 1, content = "四季皆宜"}, 
            --             {descid = 2, content = "8：00-17：30"},  
            --             {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
            --             {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
            --             {descid = 5, content = "四季皆宜"}, 
            --             {descid = 6, content = "130元"}, 
            --             {descid = 7, content = "免费"}, 
            --         }},
            [36] = {sightid = 36, name = "36", cname = "第三海水浴场", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "6月-8月最佳，适宜游泳"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "1天"}, 
                        {descid = 4, content = "海滨风光"}, 
                        {descid = 5, content = "个人感觉第三浴场最美，现代建筑与蔚蓝的大海带来的巨大视觉冲击"}, 
                        {descid = 6, content = "游客较少，沙子细软，水较浅且干净"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            -- [37] = {sightid = 37, name = "37", cname = "青岛电视塔", image = {1, 2, 3, 4}, 

            --         desc = {
            --             {descid = 1, content = "四季皆宜"}, 
            --             {descid = 2, content = "8：00-17：30"},  
            --             {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
            --             {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
            --             {descid = 5, content = "四季皆宜"}, 
            --             {descid = 6, content = "130元"}, 
            --             {descid = 7, content = "免费"}, 
            --         }},
            [38] = {sightid = 38, name = "38", cname = "青岛山炮台", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "8：00-17：30"},  
                        {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
                        {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
                        {descid = 5, content = "四季皆宜"}, 
                        {descid = 6, content = "130元"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [39] = {sightid = 39, name = "39", cname = "音乐广场", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "8：30-17：00（16：30停止售票）"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "地下军事建筑"}, 
                        {descid = 5, content = "德国修建的工事，设施保留的很齐全，里面通道很复杂"}, 
                        {descid = 6, content = "亚洲唯一的一战战场遗址"}, 
                        {descid = 7, content = "15元/人"}, 
                    }},
            [40] = {sightid = 40, name = "40", cname = "劈柴院", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "5月-10月，各类海鲜都比较新鲜"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "2-3小时"}, 
                        {descid = 4, content = "各色小吃"}, 
                        {descid = 5, content = "在劈柴院吃饭需谨慎，如果真想吃先问好价钱。"}, 
                        {descid = 6, content = "青岛最为著名的吃货集散地"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [41] = {sightid = 41, name = "41", cname = "青岛火车站", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = " 1-2小时"}, 
                        {descid = 4, content = "德式建筑风格"}, 
                        {descid = 5, content = "外观很漂亮，交通比较便利，目前为止最喜欢的火车站"}, 
                        {descid = 6, content = "建在海边，车站是纯粹的德国文艺复兴风格"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [42] = {sightid = 42, name = "42", cname = "胶澳总督府旧址", image = {2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "里面不允许进去参观，可在外面拍照留念"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "总督府大楼"}, 
                        {descid = 5, content = "看外观很气派，现在是政府机关，青岛人大常委会和政协的办公地点"}, 
                        {descid = 6, content = "建筑气势雄伟，充满奥匈帝国的霸气"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [43] = {sightid = 43, name = "43", cname = "花石楼", image = {2, 3}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "08:00-18:00"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "自由奔放的欧式海滨别墅"}, 
                        {descid = 5, content = "不大但设计得很巧妙，站在花石楼的每一层都能看见第二浴场的景色"}, 
                        {descid = 6, content = "蒋介石公馆，西方多种建筑风格融合的佳品"}, 
                        {descid = 7, content = "5.00元\r\n联票（小青岛+小鱼山+八大关花石楼+奥帆博物馆+中国水准零点景区）：104.00元"}, 
                    }},
            [44] = {sightid = 44, name = "44", cname = "闻一多故居", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "全天开放"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "南欧风格建筑，闻一多生平"}, 
                        {descid = 5, content = "海洋大学鱼山校区里面的一个名人故居，几乎全被爬墙虎给爬满了"}, 
                        {descid = 6, content = "位于海大校园，人文气息浓厚"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [45] = {sightid = 45, name = "45", cname = "康有为故居", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "9:00-17:00"},  
                        {descid = 3, content = "1小时"}, 
                        {descid = 4, content = "康有为生平及戊戌变法的历史照片、文献和实物"}, 
                        {descid = 5, content = "里面有康有为亲手种下的银杏树，坐在下面吹风非常舒服"}, 
                        {descid = 6, content = "一代革命家曾经住过的地方"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [46] = {sightid = 46, name = "46", cname = "邮电博物馆", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "夏8:30-17:00\r\n冬9:00-16:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "老式邮电设备"}, 
                        {descid = 5, content = "里面陈列很多老式电话，有各种明信片出售，也可以自己带明信片进去盖章。"}, 
                        {descid = 6, content = "建筑风格独特，了解邮电的历史及文物的同时还能买精致的邮票及明信片"}, 
                        {descid = 7, content = "一楼免费，明信片15-30元不等"}, 
                    }},
            [47] = {sightid = 47, name = "47", cname = "观象山公园", image = {1}, 

                    desc = {
                        {descid = 1, content = "4月-10月"}, 
                        {descid = 2, content = "空"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "观象台旧址，各种植物"}, 
                        {descid = 5, content = "没有一个游人，满树满树的槐花，香气扑鼻"}, 
                        {descid = 6, content = "山上植被条件较好，园内铺栽草坪3万平方米"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [48] = {sightid = 48, name = "48", cname = "老舍故居", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "旺季8:00-18:00\r\n淡季8:30-16:30"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "老舍生平的作品和事迹"}, 
                        {descid = 5, content = "院子墙上有骆驼祥子的小人书漫画，简单易懂"}, 
                        {descid = 6, content = "这里是老舍写《骆驼祥子》的地方"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [49] = {sightid = 49, name = "49", cname = "海信广场", image = {1, 2, 3}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "空"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "各种奢侈品"}, 
                        {descid = 5, content = "青岛最高档的商场之一，外装内装都很奢华."}, 
                        {descid = 6, content = "国内著名高级百货店"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            [50] = {sightid = 50, name = "50", cname = "百丽广场", image = {1, 2}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "空"},  
                        {descid = 3, content = "1-2小时"}, 
                        {descid = 4, content = "国际品牌，美食广场，真冰滑冰场"}, 
                        {descid = 5, content = "时尚且又符合亲民的定位，年轻潮人的聚集地。"}, 
                        {descid = 6, content = "人气比较高的综合性购物广场"}, 
                        {descid = 7, content = "免费"}, 
                    }},
            -- [51] = {sightid = 51, name = "51", cname = "胶州湾大桥", image = {1, 2, 3, 4}, 

            --         desc = {
            --             {descid = 1, content = "四季皆宜"}, 
            --             {descid = 2, content = "8：00-17：30"},  
            --             {descid = 3, content = "独秀峰、王府、摩崖石刻"}, 
            --             {descid = 4, content = "靖江王府是我国现存最大最完整的明代藩王府"}, 
            --             {descid = 5, content = "四季皆宜"}, 
            --             {descid = 6, content = "130元"}, 
            --         }},
            [52] = {sightid = 52, name = "52", cname = "青岛大学", image = {1, 2, 3, 4}, 

                    desc = {
                        {descid = 1, content = "四季皆宜"}, 
                        {descid = 2, content = "全天"},  
                        {descid = 3, content = "2个小时"}, 
                        {descid = 4, content = "繁华但不喧闹，背依浮山，面朝大海，校园风景秀丽，被誉为青岛东部花园"}, 
                        {descid = 5, content = "春天樱花绽放，夏天睡莲初醒，秋天漫步在梧桐树下，冬天有皑皑白雪的陪伴"}, 
                        {descid = 6, content = "青岛大学，是山东省与青岛市共同建设的重点综合性大学"}, 
                        {descid = 7, content = "免费"}, 
                    }},
        }
    },

    -- [3] = {cityid = 3, name = "changsha", pos = {x = 100, y = 120}, cname = "长沙", provid = 0, version = 1, download = true, 
    --     sight = {
    --         [1] = {sightid = 1, name = "1", cname = "橘子洲", image = {1, 2, 3, 4}, 

    --                 desc = {
    --                     {descid = 1, content = "四季皆宜"}, 
    --                     {descid = 2, content = "全天"},  
    --                     {descid = 3, content = "2个小时"}, 
    --                     {descid = 4, content = "繁华但不喧闹，背依浮山，面朝大海，校园风景秀丽，被誉为青岛东部花园"}, 
    --                     {descid = 5, content = "春天樱花绽放，夏天睡莲初醒，秋天漫步在梧桐树下，冬天有皑皑白雪的陪伴"}, 
    --                     {descid = 6, content = "青岛大学，是山东省与青岛市共同建设的重点综合性大学"}, 
    --                     {descid = 7, content = "免费"}, 
    --                 }},
    --         [10] = {sightid = 1, name = "1", cname = "太平街", image = {1, 2, 3, 4}, 

    --                 desc = {
    --                     {descid = 1, content = "四季皆宜"}, 
    --                     {descid = 2, content = "全天"},  
    --                     {descid = 3, content = "2个小时"}, 
    --                     {descid = 4, content = "繁华但不喧闹，背依浮山，面朝大海，校园风景秀丽，被誉为青岛东部花园"}, 
    --                     {descid = 5, content = "春天樱花绽放，夏天睡莲初醒，秋天漫步在梧桐树下，冬天有皑皑白雪的陪伴"}, 
    --                     {descid = 6, content = "青岛大学，是山东省与青岛市共同建设的重点综合性大学"}, 
    --                     {descid = 7, content = "免费"}, 
    --                 }},
    --     }
    -- },
}

    
-- 以cityID为下标的一组数据， 记录了城市的特产
QMapGlobal.specialityDatas = {
--     [1] = {    

-- }
}

QMapGlobal.cardDatas = {
    -- [2] = {
    --     --
    -- }
}

QMapGlobal.tempCityBall = {
    
}

QMapGlobal.userClickCityData = {
    -- [2] = 10,   -- 城市ID为索引，值是点击次数
}


------
-- return {
--     cityid = 1,
--     [1] = {
--         sightid = 1, name = "1", cname = "橘子洲", 
--         desc = {
--             {descid = 1, content = "四季皆宜"}, 
--             {descid = 1, content = "四季皆宜"}, 
--         }
--     }
--     [2] = {

--     }
-- }












