package com.shitouren.citystate;

import com.shitouren.fragment.IndexConsumFragment;
import com.shitouren.fragment.IndexSocialFragment;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.Utils;

import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class IndexSocialActivity extends FragmentActivity implements IActivity {
	private static final String TAG = "IndexSocialActivity";

	// topBarLayout布局
	private LinearLayout llTopbarLeft;
	private ImageView ivTopbarleft;

	private TextView tvTopbarMiddle;
	// topBarLayout布局

	private RelativeLayout rlHot;
	private RelativeLayout rlAttention;
	private TextView tvHot;
	private TextView tvAttention;

	private LinearLayout llBottomTag;
	private View viewHot;
	private View viewAttention;

	private ViewPager viewPager;

	private int mWidth;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.index_social_activity);

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		initTestData();
		initData();
		initView();
		setLisener();
		parseIntent();

		viewPager.setAdapter(new SquarePagerAdapter(getSupportFragmentManager()));
	}

	@Override
	public void initTestData() {
		mWidth = Utils.windowXY(this)[0];
	}

	@Override
	public void initData() {

	}

	@Override
	public void initView() {
		rlHot = (RelativeLayout) findViewById(R.id.rlLeft);
		rlAttention = (RelativeLayout) findViewById(R.id.rlRight);
		tvHot = (TextView) findViewById(R.id.tvLeft);
		tvAttention = (TextView) findViewById(R.id.tvRight);

		llBottomTag = (LinearLayout) findViewById(R.id.llBottomTag);
		viewHot = (View) findViewById(R.id.viewLeft);
		viewAttention = (View) findViewById(R.id.viewRight);

		viewPager = (ViewPager) findViewById(R.id.pagerSquare);

		tvHot.setText("社交指数");
		tvAttention.setText("消费指数");

		// topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);

		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		// topBarLayout布局
		initTopBarLayout();
	}

	private void initTopBarLayout() {
		tvTopbarMiddle.setText(getResources().getString(R.string.indexSocialTitle));

		ivTopbarleft.setImageResource(R.drawable.xiangyoubaise);
		llTopbarLeft.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				IndexSocialActivity.this.finish();
			}
		});
	}

	@Override
	public void setLisener() {
		viewPager.setOnPageChangeListener(new OnPageChangeListener() {
			int one = mWidth / 2;

			@Override
			public void onPageSelected(int arg0) {
				Animation animation = null;
				if (arg0 == 0) {
					animation = new TranslateAnimation(one, 0, 0, 0);
				} else if (arg0 == 1) {
					animation = new TranslateAnimation(0, one, 0, 0);
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

	class SquarePagerAdapter extends FragmentStatePagerAdapter {

		public SquarePagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int arg0) {

			switch (arg0) {
			case 0:
				return new IndexSocialFragment();
			case 1:
				return new IndexConsumFragment();
			}
			return null;
		}

		@Override
		public int getCount() {
			return 2;
		}

	}

}
