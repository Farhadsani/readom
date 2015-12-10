package com.shitouren.citystate;


import com.shitouren.fragment.MyHelpFragment;
import com.shitouren.fragment.MyMessageFragment;
import com.shitouren.fragment.PetMessageFragment;
import com.shitouren.fragment.SysMessageFragment;
import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.graphics.BitmapFactory;
import android.opengl.Matrix;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.RadioGroup;
import android.widget.TextView;

public class MessageActivity extends FragmentActivity implements OnClickListener {
	

	/**
	 * 四个导航
	 */
	private TextView tv_my_message;
	private TextView tv_pet_message;
	private TextView tv_my_help;
	private TextView tv_sys_message;
	ImageView iv_mymessage;
	ImageView iv_petmessage;
	ImageView iv_myhelp;
	ImageView iv_sysmessage;
	
	/** 
     * 页面
     */  
	private ViewPager messagePager;
    private int mWidth;
	
    //当前卡条
    private int currentInt = 0;
    //动画位移
    private int offset;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.message_activity);
//		mWidth = Utils.windowXY(this)[0];
		//初始化
		
		initview();
	}


	private void initview() {
		tv_my_message = (TextView) findViewById(R.id.tv_my_message);
		tv_pet_message = (TextView) findViewById(R.id.tv_pet_message);
		tv_my_help = (TextView) findViewById(R.id.tv_my_help);
		tv_sys_message = (TextView) findViewById(R.id.tv_sys_message);
		
		//下划线
		iv_mymessage = (ImageView) findViewById(R.id.iv_mymessage);
//		iv_petmessage = (ImageView) findViewById(R.id.iv_petmessage);
//		iv_myhelp = (ImageView) findViewById(R.id.iv_myhelp);
//		iv_sysmessage = (ImageView) findViewById(R.id.iv_sysmessage);
		
		
		tv_my_message.setOnClickListener(this);
		tv_pet_message.setOnClickListener(this);
		tv_my_help.setOnClickListener(this);
		tv_sys_message.setOnClickListener(this);
		
		mWidth = BitmapFactory.decodeResource(getResources(), R.drawable.horital_yellow_line).getWidth();
		DisplayMetrics dm = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(dm);
		int screenw = dm.widthPixels;
		offset = (screenw/4 - mWidth/4)/2;
		android.graphics.Matrix matrix = new android.graphics.Matrix();
		matrix.setScale(0.25f, 1);
		matrix.postTranslate(offset, 0);
		iv_mymessage.setImageMatrix(matrix);
		
		Debuger.log_w("*********screenw:"+screenw);
		Debuger.log_w("*********mWidth:"+mWidth);
		Debuger.log_w("*********offset:"+offset );
		
		iv_mymessage.setBackgroundResource(R.drawable.horital_yellow_line);
		messagePager = (ViewPager) findViewById(R.id.messagePager);
		messagePager.setAdapter(new MessagePagerAdater(getSupportFragmentManager()));
		messagePager.setOnPageChangeListener(new OnPageChangeListener() {
			int number = mWidth/4;
			int one = offset*2 +mWidth/4;
//			int one = mWidth/4;
			int two = one*2;
			int three = one*3;
			@Override
			public void onPageSelected(int arg0) {
				// TODO Auto-generated method stub
				Animation animation = null;
				switch (arg0) {
				case 0:
					if (currentInt == 1) {
						animation = new TranslateAnimation(one, 0, 0, 0);
					} else if (currentInt == 2) {
						animation = new TranslateAnimation(two, 0, 0, 0);
					} else if (currentInt == 3) {
						animation = new TranslateAnimation(three, 0, 0, 0);
					}
					break;
				case 1:
					if (currentInt == 0) {
						animation = new TranslateAnimation(0, one, 0, 0);
					} else if (currentInt == 2) {
						animation = new TranslateAnimation(two, one, 0, 0);
					} else if (currentInt == 3) {
						animation = new TranslateAnimation(three, one, 0, 0);
					}
					break;
				case 2:
					if (currentInt == 0) {
						animation = new TranslateAnimation(0, two, 0, 0);
					} else if (currentInt == 1) {
						animation = new TranslateAnimation(one, two, 0, 0);
					} else if (currentInt == 3) {
						animation = new TranslateAnimation(three, two, 0, 0);
					}
					break;
				case 3:
					if (currentInt == 0) {
						animation = new TranslateAnimation(0, three, 0, 0);
					} else if (currentInt == 1) {
						animation = new TranslateAnimation(one, three, 0, 0);
					} else if (currentInt == 2) {
						animation = new TranslateAnimation(two, three, 0, 0);
					}
					break;

				default:
					break;
				}
				currentInt = arg0;
				animation.setFillAfter(true);
				animation.setDuration(200);
				iv_mymessage.startAnimation(animation);
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


	//点击进入相应的message
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
//		iv_mymessage.setBackgroundResource(R.color.background_white);
//		iv_petmessage.setBackgroundResource(R.color.background_white);
//		iv_myhelp.setBackgroundResource(R.color.background_white);
//		iv_sysmessage.setBackgroundResource(R.color.background_white);
		
		
		switch (v.getId()) {
		case R.id.tv_my_message:
//			iv_mymessage.setBackgroundResource(R.drawable.horital_yellow_line);
			messagePager.setCurrentItem(0);
//			myMessage = new MyMessageFragment();
//			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, myMessage).commit();
			break;
		case R.id.tv_pet_message:
//			iv_petmessage.setBackgroundResource(R.drawable.horital_yellow_line);
			messagePager.setCurrentItem(1);
//			petMessage = new PetMessageFragment();
//			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, petMessage).commit();
			break;
		case R.id.tv_my_help:
//			iv_myhelp.setBackgroundResource(R.drawable.horital_yellow_line);
			messagePager.setCurrentItem(2);
//			myHelp = new MyHelpFragment();
//			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, myHelp).commit();
			break;
		case R.id.tv_sys_message:
//			iv_sysmessage.setBackgroundResource(R.drawable.horital_yellow_line);
			messagePager.setCurrentItem(3);
//			sysMessage = new SysMessageFragment();
//			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, sysMessage).commit();
			break;

		default:
			break;
		}
		
	}

	class MessagePagerAdater extends FragmentStatePagerAdapter{

		public MessagePagerAdater(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {
			// TODO Auto-generated method stub
			iv_mymessage.setBackgroundResource(R.color.background_white);
//			iv_petmessage.setBackgroundResource(R.color.background_white);
//			iv_myhelp.setBackgroundResource(R.color.background_white);
//			iv_sysmessage.setBackgroundResource(R.color.background_white);
			Fragment fragment = null;
			switch (position) {
			case 0:
//				iv_mymessage.setBackgroundResource(R.drawable.horital_yellow_line);
				fragment = new MyMessageFragment();
				break;
			case 1:
//				iv_mymessage.setBackgroundResource(R.drawable.horital_yellow_line);
				fragment = new PetMessageFragment();
				break;
			case 2:
//				iv_mymessage.setBackgroundResource(R.drawable.horital_yellow_line);
				fragment = new MyHelpFragment();
				break;
			case 3:
//				iv_mymessage.setBackgroundResource(R.drawable.horital_yellow_line);
				fragment = new SysMessageFragment();
				break;

			default:
				break;
			}
			return fragment;
		}

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return 4;
		}
		
	}


}
