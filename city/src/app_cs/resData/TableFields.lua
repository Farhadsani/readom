
--  字段资源表，描述了数据库中得表的字段

return {

	-- 城市表  city
	cityFields = {   
            {name = "cityid", attri = " INTEGER PRIMARY KEY  NOT NULL  UNIQUE"},
            {name = "name", attri = " VARCHAR NOT NULL  UNIQUE"},
            {name = "cname", attri = " TEXT NOT NULL"},
            {name = "posX", attri = " INTEGER NOT NULL"},
            {name = "posY", attri = " INTEGER NOT NULL"},
            {name = "provid", attri = " INTEGER"},
            {name = "bgcolortop", attri = " VARCHAR NOT NULL "},
            {name = "bgcolorend", attri = " VARCHAR NOT NULL "},
            {name = "version", attri = " INTEGER"},          -- 
            {name = "versioninfo", attri = " INTEGER "},     -- 
            {name = "cardver", attri = " INTEGER "},    -- 卡牌的版本
            -- {name = "clickcount", attri = " INTEGER "},
        },

    -- 景点表    sight_base_[cityid]
    sight_base_Fields = {
            {name = "sightid", attri = " INTEGER PRIMARY KEY  NOT NULL  UNIQUE"},
            {name = "name", attri = " VARCHAR NOT NULL  UNIQUE"},
            {name = "cname", attri = " TEXT NOT NULL"},
            {name = "image", attri = " VARCHAR"},
            {name = "desc", attri = " TEXT"}
    	},

    -- 景点描述表  sight_desc_[cityid]
    sight_desc_Fields = {
            {name = "sightid", attri = " INTEGER NOT NULL"},
            {name = "descid", attri = " INTEGER NOT NULL"},
            {name = "content", attri = " TEXT NOT NULL"}
        },

    -- 游记基础表  journey_base_[cityid]
    journey_base_Fields = {
	        {name = "userid", attri = " INTEGER PRIMARY KEY  NOT NULL  UNIQUE"},
	        {name = "journeyid", attri = " INTEGER "},
	        {name = "title", attri = " TEXT NOT NULL"},
	        {name = "upload", attri = " BOOL NOT NULL "},
	        {name = "utime", attri = " VARCHAR "},
	        {name = "order", attri = " VARCHAR "}
	    },

    -- 游记信息表  journey_info_[cityid]
    journey_info_Fields = {
	        {name = "userid", attri = " INTEGER  NOT NULL "},
	        {name = "journeyid", attri = " INTEGER "},
	        {name = "sightid", attri = " INTEGER NOT NULL"},
	        -- {name = "order", attri = " INTEGER NOT NULL "},
	        {name = "markid", attri = " INTEGER "}
	    },


    -- 游记图片表  journey_image_[cityid]
    journey_image_Fields = {
	        {name = "userid", attri = " INTEGER  NOT NULL "},
	        {name = "markid", attri = " INTEGER "},
	        {name = "imageid", attri = " INTEGER NOT NULL"},
	        {name = "ctime", attri = " VARCHAR "},
        },
        
    -- 游记点评表  journey_mark_[cityid]
    journey_mark_Fields = {
            {name = "userid", attri = " INTEGER  NOT NULL "},
            {name = "markid", attri = " INTEGER "},
            {name = "mark", attri = " TEXT NOT NULL"},
            {name = "ctime", attri = " VARCHAR "},
        },

    -- 卡牌表
    card_fields = {
            -- {name = "cityid", attri = " INTEGER NOT NULL "},
            {name = "cardid", attri = " INTEGER NOT NULL "},
            {name = "cardname", attri = " TEXT NOT NULL "},
            {name = "imgid", attri = " INTEGER "},
            {name = "desc", attri = " TEXT "},
            {name = "source", attri = " INTEGER "},
            {name = "starlevel", attri = " INTEGER "},
            {name = "type", attri = " INTEGER "},
            {name = "iscollect", attri = " INTEGER "},
            {name = "collectcount", attri = " INTEGER "}
        },

    -- 卡牌关键字
    card_label_fields = {
            {name = "cardid", attri = " INTEGER NOT NULL "},
            {name = "label", attri = " TEXT NOT NULL"},
        },

    city_click_fields = {
            {name = "cityid", attri = " INTEGER PRIMARY KEY  NOT NULL  UNIQUE"},
            {name = "userid", attri = " INTEGER NOT NULL "},
            {name = "clickcount", attri = "INTEGER NOT NULL"}
        },
}




