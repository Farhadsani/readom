package com.shitouren.city;

import com.shitouren.fragment.AttentionFragment;
import com.shitouren.fragment.HotFragment;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.Utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.RadioGroup.OnCheckedChangeListener;

public class SquareActivity extends FragmentActivity implements IActivity {

	private RelativeLayout rlHot;
	private RelativeLayout rlAttention;
	private TextView tvHot;
	private TextView tvAttention;

	private LinearLayout llBottomTag;
	private View viewHot;
	private View viewAttention;

	private ViewPager viewPager;

	private int mWidth;
	@SuppressLint("InlinedApi")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.square_activity);

		
		mWidth = Utils.windowXY(this)[0];

		initTestData();
		initView();
		setLisener();
		parseIntent();
	}

	@Override
	public void initData() {

	}

	@Override
	public void initView() {
		rlHot = (RelativeLayout) findViewById(R.id.rlHot);
		rlAttention = (RelativeLayout) findViewById(R.id.rlAttention);
		tvHot = (TextView) findViewById(R.id.tvHot);
		tvAttention = (TextView) findViewById(R.id.tvAttention);

		llBottomTag = (LinearLayout) findViewById(R.id.llBottomTag);
		viewHot = (View) findViewById(R.id.viewHot);
		viewAttention = (View) findViewById(R.id.viewAttention);

		viewPager = (ViewPager) findViewById(R.id.pagerSquare);

		viewPager.setAdapter(new SquarePagerAdapter(getSupportFragmentManager()));
	}

	@Override
	public void setLisener() {
		viewPager.setOnPageChangeListener(new OnPageChangeListener() {
			int one = mWidth/2;
			@Override
			public void onPageSelected(int arg0) {
				Animation animation = null;
				if (arg0 == 0) {
					animation = new TranslateAnimation(one, 0, 0, 0);
//					viewAttention.setBackgroundDrawable(null);
//					viewHot.setBackgroundResource(R.drawable.horital_yellow_line);
				} else if (arg0 == 1) {
					animation = new TranslateAnimation(0, one, 0, 0);
//					viewHot.setBackgroundDrawable(null);
//					viewAttention.setBackgroundResource(R.drawable.horital_yellow_line);
				}
				animation.setFillAfter(true);
				animation.setDuration(300);
				viewHot.startAnimation(animation);
			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {
			}

			@Override
			public void onPageScrollStateChanged(int arg0) {
			}
		});

		rlHot.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				viewAttention.setBackgroundDrawable(null);
				viewHot.setBackgroundResource(R.drawable.horital_yellow_line);

				viewPager.setCurrentItem(0);
			}
		});
		rlAttention.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				viewHot.setBackgroundDrawable(null);
				viewAttention.setBackgroundResource(R.drawable.horital_yellow_line);
				viewPager.setCurrentItem(1);
			}
		});

	}

	@Override
	public void parseIntent() {

	}

	@Override
	public void initTestData() {

	}

	class SquarePagerAdapter extends FragmentStatePagerAdapter {

		public SquarePagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int arg0) {

			switch (arg0) {
			case 0:
				return new HotFragment();
			case 1:
				return new AttentionFragment();
			}
			return null;
		}

		@Override
		public int getCount() {
			return 2;
		}

	}

}
