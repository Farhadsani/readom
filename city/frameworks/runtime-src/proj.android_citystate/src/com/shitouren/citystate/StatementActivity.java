package com.shitouren.citystate;

import com.shitouren.inter.IActivity;

import android.app.Activity;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

public class StatementActivity extends Activity implements IActivity {
	private static final String TAG = "StatementActivity";

	// topBarLayout布局
	private LinearLayout llTopbarLeft;
	private ImageView ivTopbarleft;

	private TextView tvTopbarMiddle;
	// topBarLayout布局

	// progressBar
	private ProgressBar bar;

	// WebView
	private WebView wv;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.statement_activity);

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}
		
		initView();
		initData();
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {
		// WebView加载web资源
		wv.loadUrl("http://m.baidu.com");
		// 覆盖WebView默认使用第三方或系统默认浏览器打开网页的行为，使网页用WebView打开
		wv.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				// 返回值是true的时候控制去WebView打开，为false调用系统浏览器或第三方浏览器
				view.loadUrl(url);
				return true;
			}
		});

		// 启用支持javascript
		wv.getSettings().setJavaScriptEnabled(true);
		//使用缓存
//		wv.getSettings().setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
		//不使用缓存
		wv.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);


		wv.setWebChromeClient(new WebChromeClient() {
			@Override
			public void onProgressChanged(WebView view, int newProgress) {
				if (newProgress == 100) {
					// 网页加载完成
					bar.setVisibility(view.GONE);
				} else {
					// 加载中
					bar.setVisibility(view.VISIBLE);
				}

			}
		});
	}

	@Override
	public void initView() {
		// topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);

		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		// topBarLayout布局
		initTopBarLayout();

		// progressBar
		bar = (ProgressBar) findViewById(R.id.progressBar);
		// WebView
		wv = (WebView) findViewById(R.id.wvStatement);
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
				StatementActivity.this.finish();
			}
		});
	}

	// 改写物理按键——返回的逻辑
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (wv.canGoBack()) {
				wv.goBack();// 返回上一页面
				return true;
			} else {
				StatementActivity.this.finish();// 退出页面
			}
		}
		return super.onKeyDown(keyCode, event);
	}

}
