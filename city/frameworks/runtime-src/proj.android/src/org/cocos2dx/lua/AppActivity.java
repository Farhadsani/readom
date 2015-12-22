/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.ArrayList;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.format.Formatter;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.WindowManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.PopupWindow;
import android.widget.Toast;
import com.anysdk.framework.PluginWrapper;
import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;
import com.umeng.analytics.MobclickAgent;

public class AppActivity extends Cocos2dxActivity {

	static String hostIPAdress = "0.0.0.0";
	static AppActivity app = null;
	
	WebView m_webView;//WebView锟截硷拷
	ImageView m_imageView;//ImageView锟截硷拷
	FrameLayout m_webLayout;//FrameLayout锟斤拷锟斤拷
	LinearLayout m_topLayout;//LinearLayout锟斤拷锟斤拷
	Button m_backButton;//锟截闭帮拷钮
	FrameLayout m_viewTitle; //锟斤拷锟斤拷锟斤拷

	PopupWindow popupWindow;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.i("qmap", "onCreate");
		app = this;
		
//		view1 = new View(this);
//		
//		tabFrame = new LinearLayout(this);
//		LinearLayout.LayoutParams lytp = new LinearLayout.LayoutParams(300,100);
//	    lytp.gravity = Gravity.BOTTOM;
//		tab = new TabHost(this);
////		tab.setup();
//		tab.addTab(tab.newTabSpec("tab1").setIndicator(view1)); 
//		tabFrame.addView(tab);
//		addContentView(tabFrame, lytp);
//		
//		initTabFrame();
		
		//锟斤拷始锟斤拷一锟斤拷锟秸诧拷锟斤拷
//	    m_webLayout = new FrameLayout(this);
//	    DisplayMetrics dm = new DisplayMetrics();
//	    getWindowManager().getDefaultDisplay().getMetrics(dm);
//	    Rect frame = new Rect();    
//	    getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
//	    
//	    int width = frame.width(); // dm.widthPixels;//锟斤拷锟�
//	    int height = frame.height();  // dm.heightPixels ;//锟竭讹拷
//	    Log.i("qmap", "w = " + width + ",H = " + height + "///" + dm.widthPixels + "," + dm.heightPixels);
//	    FrameLayout.LayoutParams lytp = new FrameLayout.LayoutParams(width,height);
//	    lytp.gravity = Gravity.CENTER;
//	    addContentView(m_webLayout, lytp);
	    //-----------------------------
		
		
	    
		if(nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}

		// 2.Set the format of window

		// Check the wifi is opened when the native is debug.
		if (nativeIsDebug()) {
			getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
					WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			if (!isNetworkConnected()) {
				// AlertDialog.Builder builder=new AlertDialog.Builder(this);
				// builder.setTitle("Warning");
				// builder.setMessage("Please open WIFI for debuging...");
				// builder.setPositiveButton("OK",new
				// DialogInterface.OnClickListener() {
				//
				// @Override
				// public void onClick(DialogInterface dialog, int which) {
				// startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
				// finish();
				// System.exit(0);
				// }
				// });
				//
				// builder.setNegativeButton("Cancel", null);
				// builder.setCancelable(true);
				// builder.show();
			}
		}
		hostIPAdress = getHostIpAddress();

		// for anysdk
		PluginWrapper.init(this); // for plugins
	}
	
	private boolean isNetworkConnected() {
		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm != null) {
			NetworkInfo networkInfo = cm.getActiveNetworkInfo();
			ArrayList networkTypes = new ArrayList();
			networkTypes.add(ConnectivityManager.TYPE_WIFI);
			try {
				networkTypes.add(ConnectivityManager.class.getDeclaredField("TYPE_ETHERNET").getInt(null));
			} catch (NoSuchFieldException nsfe) {
			} catch (IllegalAccessException iae) {
				throw new RuntimeException(iae);
			}
			if (networkInfo != null && networkTypes.contains(networkInfo.getType())) {
				return true;
			}
		}
		return false;
	}

	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}

	public static String getLocalIpAddress() {
		return hostIPAdress;
	}

	@Override
	protected void onStart() {
		super.onStart();
		// openWebview();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		PluginWrapper.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	protected void onResume() {
		super.onResume();
		PluginWrapper.onResume();
		MobclickAgent.onResume(this);
	}

	@Override
	public void onPause() {
		PluginWrapper.onPause();
		super.onPause();
		MobclickAgent.onPause(this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		PluginWrapper.onNewIntent(intent);
		super.onNewIntent(intent);
	}

	public static String getSSID() {

		final TelephonyManager tm = (TelephonyManager) app.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);

		final String tmDevice, tmSerial, tmPhone, androidId;
		tmDevice = "" + tm.getDeviceId();
		tmSerial = "" + tm.getSimSerialNumber();
		androidId = "" + android.provider.Settings.Secure.getString(app.getContentResolver(),
				android.provider.Settings.Secure.ANDROID_ID);

		UUID deviceUuid = new UUID(androidId.hashCode(), ((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		String uniqueId = deviceUuid.toString();

		return uniqueId;

		// return "8888-8888-8888";
	}

	public static void ymOnEvent(String eventName) {
		MobclickAgent.onEvent(app, eventName);
	}

	public static String getRequestHeader() {
		return "User-Agent:shitouren_qmap_android";
	}

	public static String getAppVersion() {
		return app.getVersion();
	}

	/**
	 * 锟斤拷取锟芥本锟斤拷
	 * 
	 * @return 锟斤拷前应锟矫的版本锟斤拷
	 */
	public String getVersion() {
		try {
			PackageManager manager = this.getPackageManager();
			PackageInfo info = manager.getPackageInfo(this.getPackageName(), 0);
			return info.versionName;
		} catch (Exception e) {
			e.printStackTrace();
			return "1.0.0";
		}
	}

    
    
	private long exitTime = 0;

	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
			if (event.getAction() == KeyEvent.ACTION_DOWN && event.getRepeatCount() == 0) {
				if ((System.currentTimeMillis() - exitTime) > 2000) {
					Toast.makeText(getApplicationContext(), "锟劫帮拷一锟斤拷锟剿筹拷锟斤拷锟斤拷", Toast.LENGTH_SHORT).show();
					exitTime = System.currentTimeMillis();
				} else {
					finish();
					System.exit(0);
				}
			}
			return true;
		}
		return super.dispatchKeyEvent(event);
	}

	private static native boolean nativeIsLandScape();

	private static native boolean nativeIsDebug();
	public static native void openmapCallback(int categoryType, String categoryID);
	public static native void openUserHomeCallback(long userID, String name, String intro, String zone, String thumb, String img);
	

	public static AppActivity getAppActivity() {
		return app;
	}

	public void openWebview(String strUrl) {
		// Log.v("TestJacky, openWebView);
		final String _strUrl = strUrl;
		this.runOnUiThread(new Runnable() {// 锟斤拷锟斤拷锟竭筹拷锟斤拷锟斤拷颖锟侥控硷拷
			public void run() {

				m_webLayout = new FrameLayout(app);
				DisplayMetrics dm = new DisplayMetrics();
				getWindowManager().getDefaultDisplay().getMetrics(dm);
				Rect frame = new Rect();
				getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);

				int width = frame.width(); // dm.widthPixels;//锟斤拷锟�
				int height = frame.height(); // dm.heightPixels ;//锟竭讹拷
				Log.i("qmap", "w = " + width + ",H = " + height + "///" + dm.widthPixels + "," + dm.heightPixels);
				FrameLayout.LayoutParams lytp = new FrameLayout.LayoutParams(width, height);
				lytp.gravity = Gravity.CENTER;
				addContentView(m_webLayout, lytp);

				// 锟斤拷始锟斤拷webView
				m_webView = new WebView(app);
				// 锟斤拷锟斤拷webView锟杰癸拷执锟斤拷javascript锟脚憋拷
				m_webView.getSettings().setJavaScriptEnabled(true);
				// 锟斤拷锟矫匡拷锟斤拷支锟斤拷锟斤拷锟斤拷
				m_webView.getSettings().setSupportZoom(true);// 锟斤拷锟矫筹拷锟斤拷锟斤拷锟脚癸拷锟斤拷
				m_webView.getSettings().setBuiltInZoomControls(true);
				// 锟斤拷锟斤拷URL
				m_webView.loadUrl(_strUrl);
				// 使页锟斤拷锟矫斤拷锟斤拷
				m_webView.requestFocus();
				// 锟斤拷锟揭筹拷锟斤拷锟斤拷锟斤拷樱锟斤拷锟斤拷希锟斤拷锟斤拷锟斤拷锟斤拷蛹锟斤拷锟斤拷诘锟角�browser锟斤拷锟斤拷应
				m_webView.setWebViewClient(new WebViewClient() {
					public boolean shouldOverrideUrlLoading(WebView view, String url) {
						if (url.indexOf("tel:") < 0) {
							view.loadUrl(url);
						}
						return true;
					}
				});

				// Rect frame = new Rect();
				// getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
				// Log.i("qmap", frame.toString());

				// 锟斤拷锟斤拷图
				m_imageView = new ImageView(app);
				m_imageView.setBackgroundColor(Color.WHITE);
				// m_imageView.setImageResource(R.drawable.bkgnd);
				m_imageView.setScaleType(ImageView.ScaleType.FIT_XY);
				// 锟斤拷始锟斤拷锟斤拷锟皆诧拷锟斤拷 锟斤拷锟斤拷影锟脚ワ拷锟�webView
				m_topLayout = new LinearLayout(app);
				m_topLayout.setOrientation(LinearLayout.VERTICAL);
				// 锟斤拷始锟斤拷锟斤拷锟截帮拷钮
				m_backButton = new Button(app);
				m_backButton.setBackgroundResource(R.drawable.webback);
				// m_backButton.setPadding(10, 20, 0, 20);
				// m_backButton.setScaleX((float) 0.8);
				// m_backButton.setScaleY((float) 0.8);
				// m_backButton.set

				LinearLayout.LayoutParams lypt = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
						LinearLayout.LayoutParams.WRAP_CONTENT);
				lypt.gravity = Gravity.LEFT | Gravity.CENTER_HORIZONTAL;
				m_backButton.setLayoutParams(lypt);
				m_backButton.setOnClickListener(new OnClickListener() {
					public void onClick(View v) {
						removeWebView();
					}
				});

				m_viewTitle = new FrameLayout(app);
				FrameLayout.LayoutParams lytp1 = new FrameLayout.LayoutParams(width, 100);
				lytp1.gravity = Gravity.CENTER;
				m_viewTitle.setLayoutParams(lytp1);
				// m_backButton.setTop(top)

				// 锟斤拷image锟接碉拷锟斤拷锟斤拷锟斤拷锟斤拷
				m_webLayout.addView(m_imageView);

				// m_viewTitle.addView(m_backButton);
				// 锟斤拷webView锟斤拷锟诫到锟斤拷锟皆诧拷锟斤拷
				// m_topLayout.addView(m_viewTitle);
				m_topLayout.addView(m_backButton);
				m_topLayout.addView(m_webView);
				// 锟劫帮拷锟斤拷锟皆诧拷锟街硷拷锟诫到锟斤拷锟斤拷锟斤拷
				m_webLayout.addView(m_topLayout);
			}
		});
	}

	public void removeWebView() {
		m_webLayout.removeView(m_imageView);
		m_imageView.destroyDrawingCache();

		m_webLayout.removeView(m_topLayout);
		m_topLayout.destroyDrawingCache();

		m_topLayout.removeView(m_webView);
		m_webView.destroy();

		m_topLayout.removeView(m_backButton);
		m_backButton.destroyDrawingCache();
	}
	
	public static void printMsg(String strName){
		Debuger.log_w("bangbang:", "printMsg");
		if (app == null)
			return;
		if (strName == "citymap")
		{
			AppActivity.openmapCallback(0, "");
		}else if(strName == "userhome")
		{
			AppActivity.openUserHomeCallback(1, "name", "intro", "zone", "thumb", "img");
		}
	}

	public void popUp() {
		AppActivity.this.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				View view = View.inflate(AppActivity.this, R.layout.pop_window, null);
				WindowManager window = (WindowManager) AppActivity.this.getSystemService(Context.WINDOW_SERVICE);
				int screenwith = window.getDefaultDisplay().getWidth();
				int screenHeight = window.getDefaultDisplay().getHeight();

				popupWindow = new PopupWindow(view, screenwith, screenHeight * 4 / 5);
				popupWindow.setFocusable(true);
				popupWindow.setOutsideTouchable(true);
				popupWindow.setBackgroundDrawable(new BitmapDrawable());
				popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
			}
		});

	}

	public void popDown() {
		if (popupWindow != null)
			popupWindow.dismiss();
	}

}
