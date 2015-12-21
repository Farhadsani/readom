package com.shitouren.city.mine;


import java.util.Timer;

import com.shitouren.citystate.R;
import com.shitouren.fragment.MineFansFragment;
import com.shitouren.fragment.MineFocusFragment;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.InputMethodManager;
import android.view.Window;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class WithGoodFriendActivity extends FragmentActivity implements OnClickListener {

	//topbar布局
	TextView tvTopbarMiddle,tvTopbarRight;
	ImageView ivTopbarLeft,ivTopbarRight;
	RelativeLayout rlLeftTV,rlRightTV;
	ViewPager twoViewPager;
	View leftViewLine;
	
	private int mWidth;
	private int mHeight;
	private PopupWindow window;
	private EditText etSearch;
	private TextView tvSearch;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_good_friend_activity);
		mWidth = Utils.windowXY(this)[0];
		mHeight = Utils.windowXY(this)[1];
		
		/**
		 * 头布局
		 */
		initTopbarView();
		/**
		 * viewpager
		 */
		initViewPager();
	}

	private void initViewPager() {
		// TODO Auto-generated method stub
		rlLeftTV = (RelativeLayout) findViewById(R.id.rlLeftTV);
		rlRightTV = (RelativeLayout) findViewById(R.id.rlRightTV);
		twoViewPager = (ViewPager) findViewById(R.id.twoViewPager);
		leftViewLine = (View) findViewById(R.id.leftViewLine);
		
		rlLeftTV.setOnClickListener(this);
		rlRightTV.setOnClickListener(this);
		twoViewPager.setAdapter(new WithGoodFriendPagerAdater(getSupportFragmentManager()));
		twoViewPager.setOnPageChangeListener(new OnPageChangeListener() {
			
			@Override
			public void onPageSelected(int arg0) {
				// TODO Auto-generated method stub
				int one = mWidth/2;
				Animation animation = null;
				if (arg0 == 0) {
					animation = new TranslateAnimation(one, 0, 0, 0);
				} else if (arg0 == 1) {
					animation = new TranslateAnimation(0, one, 0, 0);
				}
				animation.setFillAfter(true);
				animation.setDuration(200);
				leftViewLine.startAnimation(animation);
			}
			
			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void onPageScrollStateChanged(int arg0) {
				// TODO Auto-generated method stub
				
			}
		});
	}

	private void initTopbarView() {
		// TODO Auto-generated method stub
		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		tvTopbarRight = (TextView) findViewById(R.id.tvTopbarRight);
		ivTopbarLeft =  (ImageView) findViewById(R.id.ivTopbarLeft);
		ivTopbarRight =  (ImageView) findViewById(R.id.ivTopbarRight);
		tvTopbarMiddle.setText("好友关系");
		ivTopbarRight.setVisibility(View.VISIBLE);
		ivTopbarRight.setImageResource(R.drawable.sousuo);
		tvTopbarMiddle.setOnClickListener(this);
		ivTopbarRight.setOnClickListener(this);
		ivTopbarLeft.setOnClickListener(this);
	}
	
	class WithGoodFriendPagerAdater extends FragmentStatePagerAdapter{

		public WithGoodFriendPagerAdater(FragmentManager fm) {
			super(fm);
			// TODO Auto-generated constructor stub
		}

		@Override
		public Fragment getItem(int arg0) {
			// TODO Auto-generated method stub
			Fragment fragment = null;
			switch (arg0) {
			case 0:
				fragment = new MineFocusFragment();
				break;
			case 1:
				fragment = new MineFansFragment();
				break;

			default:
				break;
			}
			return fragment;
		}

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return 2;
		}
		
	}
	

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
		switch (v.getId()) {
		case R.id.tvTopbarMiddle:
			break;
		case R.id.ivTopbarRight:
			showSearchPW(); 
//			InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
//			imm.showSoftInput(etSearch, InputMethodManager.HIDE_NOT_ALWAYS);
			break;
		case R.id.ivTopbarLeft:
			finish();
			break;
			//popwindow取消
		case R.id.tvSearch:
			window.dismiss();
			break;
			
			
		/**
		 * viewpager控制
		 */
		case R.id.rlLeftTV:
			twoViewPager.setCurrentItem(0);
			break;
		case R.id.rlRightTV:
			twoViewPager.setCurrentItem(1);
			break;

		default:
			break;
		}
		
	}
	

	private void showSearchPW() {
		// TODO Auto-generated method stub
		LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = inflater.inflate(R.layout.mine_good_friend_search_popupwindow, null);
		etSearch = (EditText) view.findViewById(R.id.etSearch);
		tvSearch = (TextView) view.findViewById(R.id.tvSearch);
		tvSearch.setOnClickListener(this);
		window = new PopupWindow(view, 
				WindowManager.LayoutParams.MATCH_PARENT, 
				WindowManager.LayoutParams.WRAP_CONTENT);
		// 设置popWindow弹出窗体可点击，这句话必须添加，并且是true
		window.setFocusable(true);
		// 实例化一个ColorDrawable颜色为半透明
	    ColorDrawable dw = new ColorDrawable(0xb0000000);
	    window.setBackgroundDrawable(dw);

	    
	    // 在底部显示
	    window.showAtLocation(
				rlLeftTV,
				Gravity.TOP, 0, getStatusBarHeight());
		// window.update(width, height)
		LayoutParams viewLayoutParams = view.getLayoutParams();
		int viewHeight = viewLayoutParams.height;
		window.update(0, getStatusBarHeight(), mWidth, dip2px(50));
	}

	public int getStatusBarHeight() {
		int result = 0;
		int resourceId = getResources().getIdentifier("status_bar_height",
				"dimen", "android");
		if (resourceId > 0) {
			result = getResources().getDimensionPixelSize(resourceId);
		}
		return result;
	}
	 public int dip2px(int dip) {
	        final float scale = this.getResources().getDisplayMetrics().density;
	        return (int) (dip * scale + 0.5f);
	    }

}
