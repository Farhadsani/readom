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
import java.util.List;
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
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.telephony.TelephonyManager;
import android.text.format.Formatter;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.view.WindowManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.PopupWindow;
import android.widget.Toast;
import com.anysdk.framework.PluginWrapper;
import com.shitouren.adapter.IndexIntroductionAdapter;
import com.shitouren.bean.IndexIntroduction;
import com.shitouren.citystate.IndexActivity;
import com.shitouren.inter.IActivity;
import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;
import com.umeng.analytics.MobclickAgent;

public class AppActivity extends Cocos2dxActivity implements IActivity,OnClickListener{

	static String hostIPAdress = "0.0.0.0";
	static AppActivity app = null;
	
	WebView m_webView;//WebView锟截硷拷
	ImageView m_imageView;//ImageView锟截硷拷
	FrameLayout m_webLayout;//FrameLayout锟斤拷锟斤拷
	LinearLayout m_topLayout;//LinearLayout锟斤拷锟斤拷
	Button m_backButton;//锟截闭帮拷钮
	FrameLayout m_viewTitle; //锟斤拷锟斤拷锟斤拷

	
	
	// topBarLayout布局
		private LinearLayout llTopbarLeft;
		private ImageView ivTopbarleft;

		private TextView tvTopbarMiddle;
		// topBarLayout布局

		private Context ctx;
		private PopupWindow popupWindow;

		private TextView tvTitle;
		private RelativeLayout rl1;
		private TextView tv1;

		private RelativeLayout rl2;
		private TextView tv2;

		private RelativeLayout rl3;
		private TextView tv3;

		private LinearLayout llBootomTag;
		private View view1;
		private View view2;
		private View view3;

		private ViewPager pager;
		private List<View> views;
		LayoutInflater mInflater;
		
		private View viewPager1;
		private View viewPager2;
		private View viewPager3;
		
		private ListView lvPager1;
		private List<IndexIntroduction> introLists;
		private IndexIntroductionAdapter introAdapter;

		private int mWidth;
		private int curPager = 0;
		private int bmpW;
		private int offset;
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
//				View view = View.inflate(AppActivity.this, R.layout.pop_window, null);
//				WindowManager window = (WindowManager) AppActivity.this.getSystemService(Context.WINDOW_SERVICE);
//				int screenwith = window.getDefaultDisplay().getWidth();
//				int screenHeight = window.getDefaultDisplay().getHeight();
//
//				popupWindow = new PopupWindow(view, screenwith, screenHeight * 4 / 5);
//				popupWindow.setFocusable(true);
//				popupWindow.setOutsideTouchable(true);
//				popupWindow.setBackgroundDrawable(new BitmapDrawable());
//				popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
				pop_Input();
			}
		});

	}

	public void popDown() {
		if (popupWindow != null)
			popupWindow.dismiss();
	}
	
	
	
	private void pop_Input() {
		View view = View.inflate(this, R.layout.pop_window, null);
		WindowManager window = (WindowManager) this.getSystemService(Context.WINDOW_SERVICE);
		int screenwith = window.getDefaultDisplay().getWidth();
		int screenHeight = window.getDefaultDisplay().getHeight();

		initView(view);

		popupWindow = new PopupWindow(view, screenwith, screenHeight * 4 / 5);
		popupWindow.setFocusable(true);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
	}

	private void initView(View view) {
		tvTitle = (TextView) view.findViewById(R.id.tvTitleIndexPop);
		rl1 = (RelativeLayout) view.findViewById(R.id.rl1);
		tv1 = (TextView) view.findViewById(R.id.tv1);

		rl2 = (RelativeLayout) view.findViewById(R.id.rl2);
		tv2 = (TextView) view.findViewById(R.id.tv2);

		rl3 = (RelativeLayout) view.findViewById(R.id.rl3);
		tv3 = (TextView) view.findViewById(R.id.tv3);

		llBootomTag = (LinearLayout) findViewById(R.id.llBottomTag);
		view1 = view.findViewById(R.id.view1);
		view2 = view.findViewById(R.id.view2);
		view3 = view.findViewById(R.id.view3);

		pager = (ViewPager) view.findViewById(R.id.pagerIndexPop);

		views = new ArrayList<View>();
		mInflater = getLayoutInflater();
		views.add(viewPager1 = mInflater.inflate(R.layout.pager_layout1, null));
		views.add(viewPager2 = mInflater.inflate(R.layout.pager_layout2, null));
		views.add(viewPager3 = mInflater.inflate(R.layout.pager_layout3, null));
		
		initPagerView();

		pager.setAdapter(new MyPagerAdapter(views));
		pager.setCurrentItem(0);
		pager.setOnPageChangeListener(new MyOnPageChangeListener());

		rl1.setOnClickListener(this);
		rl2.setOnClickListener(this);
		rl3.setOnClickListener(this);
	}

	
	private void initPagerView(){
		lvPager1 = (ListView) viewPager1.findViewById(R.id.listPagerLayout1);
		introLists = new ArrayList<IndexIntroduction>();
		for(int i=0;i<9;i++){
			introLists.add(null);
		}
		introAdapter = new IndexIntroductionAdapter(ctx, introLists);
		lvPager1.setAdapter(introAdapter);
	}
	class MyPagerAdapter extends PagerAdapter {
		private List<View> views;

		public MyPagerAdapter(List<View> views) {
			this.views = views;
		}

		@Override
		public void destroyItem(View container, int position, Object object) {
			((ViewPager) container).removeView(views.get(position));
		}

		@Override
		public int getCount() {
			return views.size();
		}

		@Override
		public Object instantiateItem(View container, int position) {
			((ViewPager) container).addView(views.get(position), 0);
			return views.get(position);
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

	}

	class MyOnPageChangeListener implements OnPageChangeListener {
		int one = mWidth / 3;

		@Override
		public void onPageScrollStateChanged(int arg0) {

		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {

		}

		@Override
		public void onPageSelected(int arg0) {
			Animation animation = null;
			switch (arg0) {
			case 0:
				if (curPager == 1) {
					animation = new TranslateAnimation(one, 0, 0, 0);
				} else if (curPager == 2) {
					animation = new TranslateAnimation(one * 2, 0, 0, 0);
				}
				break;
			case 1:
				if (curPager == 0) {
					animation = new TranslateAnimation(0, one, 0, 0);
				} else if (curPager == 2) {
					animation = new TranslateAnimation(one * 2, one, 0, 0);
				}
				break;
			case 2:
				if (curPager == 0) {
					animation = new TranslateAnimation(0, one * 2, 0, 0);
				} else if (curPager == 1) {
					animation = new TranslateAnimation(one, one * 2, 0, 0);
				}
				break;
			}
			curPager = arg0;
			animation.setFillAfter(true);
			animation.setDuration(300);
			view1.startAnimation(animation);
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.rl1:
			pager.setCurrentItem(0);
			break;
		case R.id.rl2:
			pager.setCurrentItem(1);
			break;
		case R.id.rl3:
			pager.setCurrentItem(2);
			break;
		}
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {
		mWidth = Utils.windowXY(this)[0];
	}

	@Override
	public void initView() {
		// topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);

		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		// topBarLayout布局
		initTopBarLayout();
	}

	@Override
	public void setLisener() {

	}

	@Override
	public void parseIntent() {

	}
	
	private void initTopBarLayout() {
		tvTopbarMiddle.setText(getResources().getString(R.string.statementTitle));

		ivTopbarleft.setImageResource(R.drawable.xiangyoubaise);
		llTopbarLeft.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				AppActivity.this.finish();
			}
		});
	}

}
