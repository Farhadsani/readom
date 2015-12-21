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
import android.widget.Toast;
import com.anysdk.framework.PluginWrapper;
import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;
import com.umeng.analytics.MobclickAgent;


public class AppActivity extends Cocos2dxActivity{

	static String hostIPAdress = "0.0.0.0";
	static AppActivity app = null;
	
	WebView m_webView;//WebView控件
	ImageView m_imageView;//ImageView控件
	FrameLayout m_webLayout;//FrameLayout布局
	LinearLayout m_topLayout;//LinearLayout布局
	Button m_backButton;//关闭按钮
	FrameLayout m_viewTitle; //标题栏
	
	private static LinearLayout tabFrame = null;
	
	private TabHost tab;   //
	private View view1;
	private View view2;
	private View view3;
	
	private Button btn1;
	private Button btn2;
	
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
		
		//初始化一个空布局
//	    m_webLayout = new FrameLayout(this);
//	    DisplayMetrics dm = new DisplayMetrics();
//	    getWindowManager().getDefaultDisplay().getMetrics(dm);
//	    Rect frame = new Rect();    
//	    getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
//	    
//	    int width = frame.width(); // dm.widthPixels;//宽度
//	    int height = frame.height();  // dm.heightPixels ;//高度
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
		
		//2.Set the format of window
		
		// Check the wifi is opened when the native is debug.
		if(nativeIsDebug())
		{
			getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			if(!isNetworkConnected())
			{
//				AlertDialog.Builder builder=new AlertDialog.Builder(this);
//				builder.setTitle("Warning");
//				builder.setMessage("Please open WIFI for debuging...");
//				builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
//					
//					@Override
//					public void onClick(DialogInterface dialog, int which) {
//						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
//						finish();
//						System.exit(0);
//					}
//				});
//
//				builder.setNegativeButton("Cancel", null);
//				builder.setCancelable(true);
//				builder.show();
			}
		}
		hostIPAdress = getHostIpAddress();

        //for anysdk
        PluginWrapper.init(this); // for plugins
	}
	
	public void initTabFrame(){
		btn1 = new Button(this);
		btn1.setText("地图");
		btn1.setOnTouchListener(new OnTouchListener(){

			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				// TODO Auto-generated method stub
				Debuger.log_w("star:", "openmap");
				app.openmapCallback();
				return false;
			}
			
		});
		btn2 = new Button(this);
		btn2.setText("主页");
		btn2.setOnTouchListener(new OnTouchListener(){

			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				// TODO Auto-generated method stub
				Debuger.log_w("star:", "openuserhome");
				app.openUserHomeCallback();
				return false;
			}
			
		});
		tabFrame.addView(btn1);
		tabFrame.addView(btn2);
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
			}
			catch (IllegalAccessException iae) {
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
	protected void onStart(){
		super.onStart();
//		openWebview();
	}

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
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
    public void onPause(){
        PluginWrapper.onPause();
        super.onPause();
        MobclickAgent.onPause(this);
    }
    @Override
    protected void onNewIntent(Intent intent) {
        PluginWrapper.onNewIntent(intent);
        super.onNewIntent(intent);
        
//        Bundle bundle = intent.getExtras();
//        String name = bundle.getString("scene_name");
//        if( name == "citymap"){
//        	
//        	this.runOnUiThread(new Runnable() {//在主线程里添加别的控件
//    	        public void run() {  
//    	        	openmapCallback();
//    	        }});
//        }else if(name == "userhome"){
//        	openUserHomeCallback();
//        	this.runOnUiThread(new Runnable() {//在主线程里添加别的控件
//    	        public void run() {  
//    	        	openUserHomeCallback();
//    	        }});
//        }
    }
    
    public static String getSSID() {
    	
    	final TelephonyManager tm = (TelephonyManager) app.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
    	 
        final String tmDevice, tmSerial, tmPhone, androidId;
        tmDevice = "" + tm.getDeviceId();
        tmSerial = "" + tm.getSimSerialNumber();
        androidId = "" + android.provider.Settings.Secure.getString(app.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
     
        UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
        String uniqueId = deviceUuid.toString();
    	
    	return uniqueId;
    	
    	
//    	return "8888-8888-8888";
    }
    
    public static void ymOnEvent(String eventName){
    	MobclickAgent.onEvent(app, eventName);
    }
    
    public static String getRequestHeader(){
    	return "User-Agent:shitouren_qmap_android";
    }
    
    public static String getAppVersion(){
    	return app.getVersion();
    }   
    
    /**
     * 获取版本号
     * @return 当前应用的版本号
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
            	if((System.currentTimeMillis()-exitTime) > 2000){  
                    Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_SHORT).show();                                
                    exitTime = System.currentTimeMillis();   
                    
//                    openmapCallback();
//                    openUserHomeCallback();
                    
//                    this.runOnUiThread(new Runnable() {//在主线程里添加别的控件
//            	        public void run() {  
//            	        	openUserHomeCallback();
//            	        }});
                } else {
                    finish();
                    System.exit(0);
                }
            }
            return true;
        }
        return super.dispatchKeyEvent(event);
    }

//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if(keyCode == KeyEvent.KEYCODE_BACK){  // && event.getAction() == KeyEvent.ACTION_DOWN){   
//        	Log.i("qmap", "sssssss");
//            if((System.currentTimeMillis()-exitTime) > 2000){  
//                Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_SHORT).show();                                
//                exitTime = System.currentTimeMillis();   
//            } else {
//                finish();
//                System.exit(0);
//            }
//            return true;   
//        }
//        return super.onKeyDown(keyCode, event);
//    }

	private static native boolean nativeIsLandScape();
	private static native boolean nativeIsDebug();
	public static native void openmapCallback();
	public static native void openUserHomeCallback();
	
	public static AppActivity getAppActivity(){
		return app;
	}
	
	public void openWebview(String strUrl) {
//	    Log.v("TestJacky, openWebView);
		final String _strUrl = strUrl;
	    this.runOnUiThread(new Runnable() {//在主线程里添加别的控件
	        public void run() {   
	        	
	        	m_webLayout = new FrameLayout(app);
	    	    DisplayMetrics dm = new DisplayMetrics();
	    	    getWindowManager().getDefaultDisplay().getMetrics(dm);
	    	    Rect frame = new Rect();    
	    	    getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
	    	    
	    	    int width = frame.width(); // dm.widthPixels;//宽度
	    	    int height = frame.height();  // dm.heightPixels ;//高度
	    	    Log.i("qmap", "w = " + width + ",H = " + height + "///" + dm.widthPixels + "," + dm.heightPixels);
	    	    FrameLayout.LayoutParams lytp = new FrameLayout.LayoutParams(width,height);
	    	    lytp.gravity = Gravity.CENTER;
	    	    addContentView(m_webLayout, lytp);
	    	    
	    	    
	            //初始化webView
	            m_webView = new WebView(app);
	            //设置webView能够执行javascript脚本
	            m_webView.getSettings().setJavaScriptEnabled(true);            
	            //设置可以支持缩放
	            m_webView.getSettings().setSupportZoom(true);//设置出现缩放工具
	            m_webView.getSettings().setBuiltInZoomControls(true);
	            //载入URL
	            m_webView.loadUrl(_strUrl);
	            //使页面获得焦点
	            m_webView.requestFocus();
	            //如果页面中链接，如果希望点击链接继续在当前browser中响应
	            m_webView.setWebViewClient(new WebViewClient(){       
	                public boolean shouldOverrideUrlLoading(WebView view, String url) {   
	                    if(url.indexOf("tel:")<0){
	                        view.loadUrl(url); 
	                    }
	                    return true;       
	                }    
	            });
	            
//	            Rect frame = new Rect();    
//	    	    getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
//	    	    Log.i("qmap", frame.toString());
	             
	            //背景图
	            m_imageView = new ImageView(app);
	            m_imageView.setBackgroundColor(Color.WHITE);
//	            m_imageView.setImageResource(R.drawable.bkgnd);
	            m_imageView.setScaleType(ImageView.ScaleType.FIT_XY);
	            //初始化线性布局 里面加按钮和webView
	            m_topLayout = new LinearLayout(app);      
	            m_topLayout.setOrientation(LinearLayout.VERTICAL);
	            //初始化返回按钮
	            m_backButton = new Button(app);
	            m_backButton.setBackgroundResource(R.drawable.webback);
//	            m_backButton.setPadding(10, 20, 0, 20);
//	            m_backButton.setScaleX((float) 0.8);
//	            m_backButton.setScaleY((float) 0.8);
//	            m_backButton.set
	          
	            LinearLayout.LayoutParams lypt=new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
	            lypt.gravity=Gravity.LEFT | Gravity.CENTER_HORIZONTAL;
	            m_backButton.setLayoutParams(lypt);            
	            m_backButton.setOnClickListener(new OnClickListener() {                    
	                public void onClick(View v) {
	                    removeWebView();
	                }
	            });
	            
	            m_viewTitle = new FrameLayout(app);
	            FrameLayout.LayoutParams lytp1 = new FrameLayout.LayoutParams(width,100);
	            lytp1.gravity = Gravity.CENTER;
	            m_viewTitle.setLayoutParams(lytp1);
//	            m_backButton.setTop(top)
	       
	            //把image加到主布局里
	            m_webLayout.addView(m_imageView);
	            
//	            m_viewTitle.addView(m_backButton);
	            //把webView加入到线性布局
//	            m_topLayout.addView(m_viewTitle);
	            m_topLayout.addView(m_backButton);
	            m_topLayout.addView(m_webView);                
	            //再把线性布局加入到主布局
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
			AppActivity.openmapCallback();
		}else if(strName == "userhome")
		{
			AppActivity.openUserHomeCallback();
		}
	}
}
