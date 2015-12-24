package com.shitouren.entity;

public class Contacts {
	// 发表界面最多可发表的图片数量
	public static final int PUBLISH_PIC_NUM = 9;
	// 发表界面用户选择图片上时最多展示的最近图片数量
	public static final int LATEEST_PIC_NUM = 100;

	///////////////////////////////// 接口/////////////////////////////////////////////
	public static final String BASE_URL = "http://citystate.shitouren.com/";
	// 广场接口
	public static final String SQUARE_HOT = "api/feed/hot";
	// 消息接口
	public static final String MY_MESSAGE = "api/message/user";
	public static final String SYS_MESSAGE = "api/message/system";
	// 用户接口
	public static final String SIGNIN = "api/user/signin";
	public static final String SIGNUP = "api/user/signup";
	//附近动态接口
	public static final String NEARBY = "api/feed/nearby";
	public static final String SOCIAL_INDEX = "api/category/social/list";
	public static final String SOCIAL_INDEX_TAG = "api/category/tag/list";
	public static final String CONSUM_INDEX = "api/category/cost/list";
	public static final String SQUARE_ATTENTION = "api/feed/follow";
	public static final String ZAN_POST = "api/feed/like/post";//点赞
	public static final String ZAN_DEL = "api/feed/like/del";//取消赞
	public static final String COMMENT_LIST = "api/feed/comment/list";//评论列表
	public static final String COMMENT_POST = "api/feed/comment/post";//发表评论

	// 微信登录接口
	public static final String APP_ID = "wxcee6a0851b3ea57f";
	public static final String APP_SECRET = "d4624c36b6795d1d99dcf0547af5443d";
	public static final String WX_ACCESS_TOKEN_URL = "https://api.weixin.qq.com/sns/oauth2/access_token";
	public static final String WX_USERINFO_URL = "https://api.weixin.qq.com/sns/userinfo";
	public static final String WX_GRANT_TYPE = "authorization_code";

	// 绑定手机号
	public static final String SEND_SMS = "api/user/sendsms";
	public static final String FIND = "find";
	public static final String REGISTER = "register";
	public static final String PHONE = "phone";

	////////////////////////////////// 常量//////////////////////////////////////////////
	public static final String WX_TOKEN = "wxToken";
	public static final String TOKEN_JSON = "tokenJson";
	public static final String MD5_KEY = "Sk4Ys7sPTx+gT5ssPHXV4ieKwPMKB0czjb+2rVfICMo=";

	/////////////////////////////////// Shared///////////////////////////////////////////////
	public static final String USER = "user";
	public static final String USER_RES = "res";
	public static final String COOKIE = "res";
	public static final String SHITOUREN_CHECK = "shitouren_check";
	public static final String SHITOUREN_VERIFY = "shitouren_verify";

	//指数界面简介对应的TAG标签
	public static final String INTRO_1 = "最美季节";
	public static final String INTRO_2 = "开放时间";
	public static final String INTRO_3 = "游览时间";
	public static final String INTRO_4 = "主要看点";
	public static final String INTRO_5 = "大家印象";
	public static final String INTRO_6 = "推荐理由";
	public static final String INTRO_7 = "门票价格";
	public static final String INTRO_8 = "游览Tips";
	public static final String INTRO_9 = "交通线路";
}
