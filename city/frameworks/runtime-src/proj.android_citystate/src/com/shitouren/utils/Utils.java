package com.shitouren.utils;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import com.shitouren.entity.Contacts;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.widget.Toast;

public class Utils {
	private static String verName = "";

	public static String getSSID(Context context) {

		final TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

		final String tmDevice, tmSerial, tmPhone, androidId;
		tmDevice = "" + tm.getDeviceId();
		tmSerial = "" + tm.getSimSerialNumber();
		androidId = "" + android.provider.Settings.Secure.getString(context.getContentResolver(),
				android.provider.Settings.Secure.ANDROID_ID);

		UUID deviceUuid = new UUID(androidId.hashCode(), ((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		String uniqueId = deviceUuid.toString();

		return uniqueId;
	}

	public static int[] windowXY(Context context) {
		DisplayMetrics displayMetrics = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
		int width = displayMetrics.widthPixels;
		int height = displayMetrics.heightPixels;
		int[] wh = new int[2];
		wh[0] = width;
		wh[1] = height;
		return wh;
	}

	// 判断是否有网络连接
	public static boolean isNetworkAvailable(Context context) {
		if (context != null) {
			ConnectivityManager connectivity = (ConnectivityManager) context
					.getSystemService(Context.CONNECTIVITY_SERVICE);
			if (connectivity == null) {
				Log.i("NetWorkState", "Unavailabel");
				return false;
			} else {
				NetworkInfo[] info = connectivity.getAllNetworkInfo();
				if (info != null) {
					for (int i = 0; i < info.length; i++) {
						if (info[i].getState() == NetworkInfo.State.CONNECTED) {
							Log.i("NetWorkState", "Availabel");
							return true;
						}
					}
				}
			}
		} else {
			return false;
		}
		return false;
	}

	// Toast显示Long提示信息
	public static void showToastLong(Context context, String msg) {
		Toast.makeText(context, msg, Toast.LENGTH_LONG).show();
	}

	// Toast显示Short提示信息
	public static void showToastShort(Context context, String msg) {
		Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
	}

	// dp转化为px
	public static int dip2px(Context context, float dpValue) {
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (dpValue * scale + 0.5f);
	}

	// px转化为dp
	public static int px2dip(Context context, float pxValue) {
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (pxValue / scale + 0.5f);
	}

	// 存储String到Shared中
	public static void saveStrInShared(Context context, String name, String key, String msg) {
		SharedPreferences preferences = context.getSharedPreferences(name, context.MODE_PRIVATE);
		preferences.edit().putString(key, msg).commit();
	}

	// 从shared中取String
	public static String getStrFromShared(Context context, String name, String key) {
		SharedPreferences preferences = context.getSharedPreferences(name, context.MODE_PRIVATE);
		return preferences.getString(key, "");
	}

	public static String getApkVersionName(Context context) {
		if (!TextUtils.isEmpty(verName)) {
			return verName;
		} else {
			PackageManager pm = context.getPackageManager();
			PackageInfo pi;
			try {
				pi = pm.getPackageInfo(context.getPackageName(), 0);// getPackageName()是你当前类的包名，0代表是获取版本信息
				verName = pi.versionName;
			} catch (NameNotFoundException e) {
				e.printStackTrace();
			}
			return verName;
		}
	}

	// 原生版本的MD5
	public static String getMD5(String info) {
		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			md5.update(info.getBytes("UTF-8"));
			byte[] encryption = md5.digest();

			StringBuffer strBuf = new StringBuffer();
			for (int i = 0; i < encryption.length; i++) {
				if (Integer.toHexString(0xff & encryption[i]).length() == 1) {
					strBuf.append("0").append(Integer.toHexString(0xff & encryption[i]));
				} else {
					strBuf.append(Integer.toHexString(0xff & encryption[i]));
				}
			}

			return strBuf.toString();
		} catch (NoSuchAlgorithmException e) {
			return "";
		} catch (UnsupportedEncodingException e) {
			return "";
		}
	}

	public static String getMD5Str(String s){
		return getHmacMd5Str(s, Contacts.MD5_KEY);
	}
	// 衍生版本的MD5
	public static String getHmacMd5Str(String s, String keyString) {
		String sEncodedString = null;
		try {
			SecretKeySpec key = new SecretKeySpec((keyString).getBytes("UTF-8"), "HmacMD5");
			Mac mac = Mac.getInstance("HmacMD5");
			mac.init(key);

			byte[] bytes = mac.doFinal(s.getBytes("ASCII"));

			StringBuffer hash = new StringBuffer();

			for (int i = 0; i < bytes.length; i++) {
				String hex = Integer.toHexString(0xFF & bytes[i]);
				if (hex.length() == 1) {
					hash.append('0');
				}
				hash.append(hex);
			}
			sEncodedString = hash.toString();
		} catch (UnsupportedEncodingException e) {
		} catch (InvalidKeyException e) {
		} catch (NoSuchAlgorithmException e) {
		}
		return sEncodedString;
	}

	public static boolean isMobileNO(String mobiles) {

		Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
		Matcher m = p.matcher(mobiles);
		
		return m.matches();

	}
}
