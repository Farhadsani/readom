package org.cocos2dx.lua;

import com.shitouren.utils.Debuger;

public class ToolFunction {
	
	//打开景点介绍
	public static void openSightIntro(int sightID, String sightName, String sightDescs){
		Debuger.log_w("star:", "openSightIntro。。。。。。。" + sightID  +"   " + sightName + "  " + sightDescs);
		
	}
	
	//打开片区信息
	public static void openCategory(int sightID, int categoryType, String categoryID){
		Debuger.log_w("star:", "openCategory。。。。。。。" + sightID  +"   " + categoryType + "  " + categoryID);
	}
	
	//打开主页，用户当脚本点击了主页按钮时，通知Android
	public static void onMainPage(){
		Debuger.log_w("star:", "open main page。。。。。。。" );
	}
	
	//小岛界面，点击了热气球
	public static void openHotBall(int userID){
		Debuger.log_w("star:", "openHotBall。。。。。。。" + userID );
	}
	
	//小岛界面，点击了石头人
	public static void userLogin(){
		Debuger.log_w("star:", "userLogin。。。。。。。" );
	}
	
	//小岛界面，点击火山顶，关于
	public static void openAbout(){
		Debuger.log_w("star:", "openAbout。。。。。。。" );
	}
	
	//小岛界面，点击许愿池（泉水），用户详情
	public static void openDetail(int userID){
		Debuger.log_w("star:", "openDetail。。。。。。。" + userID);
	}
	
	//小岛界面， 点击宝箱，收藏
	public static void openCollect(int userID){
		Debuger.log_w("star:", "openCollect。。。。。。。" + userID);
	}
	
	//小岛界面，点击大嘴鸟， 喊话
	public static void openSpeak(){
		Debuger.log_w("star:", "openSpeak。。。。。。。");
	}
	
	// 小岛界面，点击帆船，出访
	public static void openBuddy(){
		Debuger.log_w("star:", "openBuddy。。。。。。。");
	}
	
	//小岛界面，点击灯塔，动态
	public static void openLighthouse(int userID){
		Debuger.log_w("star:", "openLighthouse。。。。。。。" + userID);
	}
	
	//小岛界面，发送邮件
	public static void openSendmail(int userID){
		Debuger.log_w("star:", "openSendmail。。。。。。。" + userID);
	}
	
	//小岛界面，打开邮箱（自己的）
	public static void openMail(){
		Debuger.log_w("star:", "openMail。。。。。。。");
	}
	
	//功能性通知，当脚本场景加载完毕后，通知Android
	//name:场景名称,loading:加载场景；citymap:城市地图场景；userhome:个人中心场景（小岛）
	public static void sceneLoadOver(String name){
		Debuger.log_w("star:", "sceneLoadOver。。。。。。。" + name);
	}
}
