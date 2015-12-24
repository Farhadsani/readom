package com.shitouren.app;

import java.util.Stack;
import java.util.UUID;

import com.shitouren.entity.Contacts;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.exception.AfinalException;


public class AppManager {

	private static Stack<Activity> activityStack;
	private static AppManager instance;
	private static FinalHttp finalHttp;
	private static String tmDevice, tmSerial, androidId;

	private AppManager()
	{

	}
	
	
	
	public static  String getSSID(Context context){
		final TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

		tmDevice = "" + tm.getDeviceId();
		tmSerial = "" + tm.getSimSerialNumber();
		androidId = "" + android.provider.Settings.Secure.getString(context.getContentResolver(),
				android.provider.Settings.Secure.ANDROID_ID);

		UUID deviceUuid = new UUID(androidId.hashCode(), ((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		String uniqueId = deviceUuid.toString();
		return uniqueId;
	}
	/**
	 * 单例创建一个FinalHttp
	 * @return
	 */
	public static FinalHttp getFinalHttp(Context context){
		if(finalHttp == null){
			finalHttp = new FinalHttp();
			finalHttp.addHeader("Cookie", "shitouren_ssid="+getSSID(context));
			finalHttp.addHeader("User-Agent", "shitouren_qmap_android");
		}
		
		String verify = GlobleApplication.shitouren_verify;
		String check = GlobleApplication.shitouren_check;
		if(!TextUtils.isEmpty(check)&&!TextUtils.isEmpty(verify)){
			finalHttp.addHeader("Cookie","shitouren_ssid="+AppManager.getSSID(context)+";"+"shitouren_verify="+verify+";"+"shitouren_check="+check);
		}
		return finalHttp;
	}
	public static FinalHttp getFinalHttp(Context context,String cookie){
		if(finalHttp == null){
			finalHttp = new FinalHttp();
			finalHttp.addHeader("Cookie", "shitouren_ssid="+getSSID(context)+";"+cookie);
			finalHttp.addHeader("User-Agent", "shitouren_qmap_android");
		}
		return finalHttp;
	}

	/**
	 * ��һʵ��
	 */
	public static AppManager getAppManager()
	{
		if (instance == null)
		{
			instance = new AppManager();
		}
		return instance;
	}

	/**
	 * ���Activity����ջ
	 */
	public void addActivity(Activity activity)
	{
		if (activityStack == null)
		{
			activityStack = new Stack<Activity>();
		}
		activityStack.add(activity);
	}

	/**
	 * ��ȡ��ǰActivity����ջ�����һ��ѹ��ģ�
	 */
	public Activity currentActivity()
	{
		Activity activity = activityStack.lastElement();
		return activity;
	}

	/**
	 * ������ǰActivity����ջ�����һ��ѹ��ģ�
	 */
	public void finishActivity()
	{
		Activity activity = activityStack.lastElement();
		finishActivity(activity);
	}

	/**
	 * ����ָ����Activity
	 */
	public void finishActivity(Activity activity)
	{
		if (activity != null)
		{
			activityStack.remove(activity);
			activity.finish();
			activity = null;
		}
	}

	/**
	 * �Ƴ�ָ����Activity
	 */
	public void removeActivity(Activity activity)
	{
		if (activity != null)
		{
			activityStack.remove(activity);
			activity = null;
		}
	}

	/**
	 * ����ָ��������Activity
	 */
	public void finishActivity(Class<?> cls)
	{
		for (Activity activity : activityStack)
		{
			if (activity.getClass().equals(cls))
			{
				finishActivity(activity);
			}
		}
	}

	/**
	 * ��������Activity
	 */
	public void finishAllActivity()
	{
		for (int i = 0, size = activityStack.size(); i < size; i++)
		{
			if (null != activityStack.get(i))
			{
				activityStack.get(i).finish();
			}
		}
		activityStack.clear();
	}

	/**
	 * �˳�Ӧ�ó���
	 * 
	 * @param context
	 *            ������
	 * @param isBackground
	 *            �Ƿ񿪿�����̨����
	 */
	public void AppExit(Context context, Boolean isBackground)
	{
		try
		{
			finishAllActivity();
			ActivityManager activityMgr = (ActivityManager) context
					.getSystemService(Context.ACTIVITY_SERVICE);
			activityMgr.restartPackage(context.getPackageName());
		} catch (Exception e)
		{

		} finally
		{
			// ע�⣬������к�̨�������У��벻Ҫ֧�ִ˾���
			if (!isBackground)
			{
				System.exit(0);
			}
		}
	}
}
