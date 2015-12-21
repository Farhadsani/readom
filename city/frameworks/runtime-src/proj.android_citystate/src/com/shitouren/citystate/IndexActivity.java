package com.shitouren.citystate;

import java.util.ArrayList;
import java.util.List;

import com.shitouren.adapter.IndexIntroductionAdapter;
import com.shitouren.bean.IndexIntroduction;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class IndexActivity extends Activity implements OnClickListener, IActivity {
	private static final String TAG = "IndexActivity";

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
		setContentView(R.layout.index_activity);

		Debuger.log_w(TAG, "onCreate");
		ctx = IndexActivity.this;

		Intent intent = getIntent();
		String name = intent.getStringExtra("name");
		Debuger.log_w(TAG, "name:" + name);

		initData();

		findViewById(R.id.tv).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				pop_Input();
			}
		});
	}

	@Override
	protected void onStart() {
		super.onStart();
		Debuger.log_w(TAG, "onStart");
	}

	@Override
	protected void onRestart() {
		super.onRestart();
		Debuger.log_w(TAG, "onRestart");
	}

	@Override
	protected void onResume() {
		super.onResume();
		Debuger.log_w(TAG, "onResume");
	}

	@Override
	protected void onPause() {
		super.onPause();
		Debuger.log_w(TAG, "onPause");
	}

	@Override
	protected void onStop() {
		super.onStop();
		Debuger.log_w(TAG, "onStop");
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Debuger.log_w(TAG, "onDestroy");
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		Debuger.log_w(TAG, "onNewIntent");
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
				IndexActivity.this.finish();
			}
		});
	}
}
