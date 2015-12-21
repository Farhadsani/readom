package com.shitouren.city.mine;

import com.shitouren.city.mine.WithGoodFriendActivity.WithGoodFriendPagerAdater;
import com.shitouren.fragment.MineFansFragment;
import com.shitouren.qmap.R;
import com.shitouren.fragment.MineFocusFragment;
import com.shitouren.fragment.MinePersonalFragment;
import com.shitouren.fragment.MinePraiseFragment;
import com.shitouren.utils.Utils;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class PersonalDynamicActivity extends FragmentActivity implements OnClickListener {

	
	//topbar布局
		TextView tvTopbarMiddle,tvTopbarRight,tvLeft,tvRight;
		ImageView ivTopbarLeft,ivTopbarRight;
		RelativeLayout rlLeftTV,rlRightTV;
		ViewPager twoViewPager;
		View leftViewLine;
		
		
		private int mWidth;
	@Override
	protected void onCreate(Bundle arg0) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(arg0);
		setContentView(R.layout.mine_personal_dynamic_avtivity);
		mWidth = Utils.windowXY(this)[0];
		
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
		tvLeft =  (TextView) findViewById(R.id.tvLeft);
		tvRight =  (TextView) findViewById(R.id.tvRight);
		twoViewPager = (ViewPager) findViewById(R.id.twoViewPager);
		leftViewLine = (View) findViewById(R.id.leftViewLine);
		tvLeft.setText("个人");
		tvRight.setText("已赞");
		
		rlLeftTV.setOnClickListener(this);
		rlRightTV.setOnClickListener(this);
		twoViewPager.setAdapter(new PersonalDynamicPagerAdater(getSupportFragmentManager()));
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
		tvTopbarMiddle.setText("个人动态");
		tvTopbarMiddle.setOnClickListener(this);
		ivTopbarRight.setOnClickListener(this);
		ivTopbarLeft.setOnClickListener(this);
		
	}

	class PersonalDynamicPagerAdater extends FragmentStatePagerAdapter{

		public PersonalDynamicPagerAdater(FragmentManager fm) {
			super(fm);
			// TODO Auto-generated constructor stub
		}

		@Override
		public Fragment getItem(int arg0) {
			// TODO Auto-generated method stub
			Fragment fragment = null;
			switch (arg0) {
			case 0:
				fragment = new MinePersonalFragment();
				break;
			case 1:
				fragment = new MinePraiseFragment();
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
			break;
		case R.id.ivTopbarLeft:
			finish();
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
}
