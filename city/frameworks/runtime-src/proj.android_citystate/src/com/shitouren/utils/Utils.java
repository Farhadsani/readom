package com.shitouren.utils;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.drawable.BitmapDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewStub;
import android.view.WindowManager;
import android.view.animation.AnimationUtils;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

public class Utils {
	private static String verName = "";
	private static int screenWidth = 0;
	private static int screenHeight = 0;

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

	// 程序第一次获取宽高后缓存在全局参数里，不用每次使用都要计算屏幕宽高，节省cpu，内存和电量
	public static int[] windowXY(Context context) {
		int[] wh = new int[2];
		if (screenWidth != 0 && screenHeight != 0) {
			wh[0] = screenWidth;
			wh[1] = screenHeight;
		} else {
			DisplayMetrics displayMetrics = new DisplayMetrics();
			((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
			screenWidth = displayMetrics.widthPixels;
			screenHeight = displayMetrics.heightPixels;
			wh[0] = screenWidth;
			wh[1] = screenHeight;
		}
		return wh;
	}

	// 判断是否有网络连接
	// 频繁联网耗电增加，没网时候不做联网操作，省电
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

	public static String getMD5Str(String s) {
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

	public static String getTime() {
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		String time = "";
		try {
			java.util.Date currentdate = new java.util.Date();// 当前时间

			Timestamp now = new Timestamp(System.currentTimeMillis());// 获取系统当前时间

			String str = sdf.format(currentdate);

			time = "今天 " + str;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return time;
	}

	public static void showNoMessage(View view, String info) {
		if (view != null) {
			LinearLayout ll = (LinearLayout) view.findViewById(R.id.llNoMessage);
			ll.setPadding(ll.getPaddingLeft(), ll.getPaddingTop() + 500, ll.getPaddingRight(), ll.getPaddingBottom());

			TextView tv = (TextView) view.findViewById(R.id.tvNoMessage);
			tv.setText(info);
		}
	}

	static PopupWindow popupWindow;
	//个数为4或5的时候的布局
	static View viewShare;
	static LinearLayout llShare;
	static LinearLayout llAttention;
	//个数为3时的布局
	static View viewShareApp;
	static LinearLayout llShareApp;
	
	

	public static void pop_Input(final Context context, int count) {
		View view = View.inflate(context, R.layout.share, null);
		ViewStub vsContent = (ViewStub) view.findViewById(R.id.vsShareContent);
		ViewStub vsApp = (ViewStub) view.findViewById(R.id.vsShareApp);
		switch (count) {
		case 3:
			vsApp.inflate();
			viewShareApp = view.findViewById(R.id.viewShareApp);
			llShareApp = (LinearLayout) view.findViewById(R.id.llShareApp);
			
			viewShareApp.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.friendShareApp).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.weixinShareApp).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.sinaShareApp).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.btnCancelShareApp).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});
			break;
		case 4:
			vsContent.inflate();
			viewShare = view.findViewById(R.id.viewShare);
			llShare = (LinearLayout) view.findViewById(R.id.llShare);
			llAttention = (LinearLayout) view.findViewById(R.id.llAttention);
			
			llAttention.setVisibility(View.GONE);
			
			viewShare.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});

			view.findViewById(R.id.ivWeixin).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "微信");
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.ivFriend).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "微信朋友圈");
					popupWindow.dismiss();
					
				}
			});
			view.findViewById(R.id.ivSina).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "新浪微博");
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.ivQzone).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "QQ空间");
					popupWindow.dismiss();
				}
			});
			break;
		case 5:
			vsContent.inflate();
			viewShare = view.findViewById(R.id.viewShare);
			llShare = (LinearLayout) view.findViewById(R.id.llShare);
			llAttention = (LinearLayout) view.findViewById(R.id.llAttention);
			
			viewShare.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					popupWindow.dismiss();
				}
			});

			view.findViewById(R.id.ivWeixin).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "微信");
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.ivFriend).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "微信朋友圈");
					popupWindow.dismiss();
					
				}
			});
			view.findViewById(R.id.ivSina).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "新浪微博");
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.ivQzone).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "QQ空间");
					popupWindow.dismiss();
				}
			});
			view.findViewById(R.id.ivAttention).setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					Debuger.showToastShort(context, "添加关注");
					popupWindow.dismiss();
				}
			});
			break;
		}
		

		

		

		if (popupWindow != null && popupWindow.isShowing()) {
			return;
		} else if (popupWindow != null && !popupWindow.isShowing()) {
//			viewShare.startAnimation(AnimationUtils.loadAnimation(context, R.anim.alpha_in));
//			llShare.startAnimation(AnimationUtils.loadAnimation(context, R.anim.pop_up));
			popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
		} else {
			popupWindow = new PopupWindow(view, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
			popupWindow.setFocusable(true);
			popupWindow.setOutsideTouchable(true);
			popupWindow.setBackgroundDrawable(new BitmapDrawable());
//			viewShare.startAnimation(AnimationUtils.loadAnimation(context, R.anim.alpha_in));
//			llShare.startAnimation(AnimationUtils.loadAnimation(context, R.anim.pop_up));
//			popupWindow.setAnimationStyle(R.style.popWindowAnim);
			popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
			popupWindow.update();
		}

	}
	
	
	public static boolean isImage(String fileName) {
        return fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || fileName.endsWith(".png");
    }
	
	public static boolean isSDcardOK() {
        return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
    }
}
