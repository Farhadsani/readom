package org.cocos2dx.lua;

import com.shitouren.utils.Debuger;

public class ToolFunction {
	
	//�򿪾������
	public static void openSightIntro(int sightID, String sightName, String sightDescs){
		Debuger.log_w("star:", "openSightIntro��������������" + sightID  +"   " + sightName + "  " + sightDescs);
		
	}
	
	//��Ƭ����Ϣ
	public static void openCategory(int sightID, int categoryType, String categoryID){
		Debuger.log_w("star:", "openCategory��������������" + sightID  +"   " + categoryType + "  " + categoryID);
	}
	
	//����ҳ���û����ű��������ҳ��ťʱ��֪ͨAndroid
	public static void onMainPage(){
		Debuger.log_w("star:", "open main page��������������" );
	}
	
	//С�����棬�����������
	public static void openHotBall(int userID){
		Debuger.log_w("star:", "openHotBall��������������" + userID );
	}
	
	//С�����棬�����ʯͷ��
	public static void userLogin(){
		Debuger.log_w("star:", "userLogin��������������" );
	}
	
	//С�����棬�����ɽ��������
	public static void openAbout(){
		Debuger.log_w("star:", "openAbout��������������" );
	}
	
	//С�����棬�����Ը�أ�Ȫˮ�����û�����
	public static void openDetail(int userID){
		Debuger.log_w("star:", "openDetail��������������" + userID);
	}
	
	//С�����棬 ������䣬�ղ�
	public static void openCollect(int userID){
		Debuger.log_w("star:", "openCollect��������������" + userID);
	}
	
	//С�����棬��������� ����
	public static void openSpeak(){
		Debuger.log_w("star:", "openSpeak��������������");
	}
	
	// С�����棬�������������
	public static void openBuddy(){
		Debuger.log_w("star:", "openBuddy��������������");
	}
	
	//С�����棬�����������̬
	public static void openLighthouse(int userID){
		Debuger.log_w("star:", "openLighthouse��������������" + userID);
	}
	
	//С�����棬�����ʼ�
	public static void openSendmail(int userID){
		Debuger.log_w("star:", "openSendmail��������������" + userID);
	}
	
	//С�����棬�����䣨�Լ��ģ�
	public static void openMail(){
		Debuger.log_w("star:", "openMail��������������");
	}
	
	//������֪ͨ�����ű�����������Ϻ�֪ͨAndroid
	//name:��������,loading:���س�����citymap:���е�ͼ������userhome:�������ĳ�����С����
	public static void sceneLoadOver(String name){
		Debuger.log_w("star:", "sceneLoadOver��������������" + name);
	}
}
