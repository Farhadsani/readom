package com.shitouren.citystate;

import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.app.TabActivity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TabHost;
import android.widget.TextView;

import org.cocos2dx.lua.AppActivity;

import com.shitouren.qmap.R;
@SuppressWarnings("deprecation")
public class MainActivity extends TabActivity implements OnClickListener {
	private static final String TAG = "MainActivity";
	public static String TAB_TAG_INDEX = "index";
	public static String TAB_TAG_SQUARE = "square";
	public static String TAB_TAG_PUBLISH = "publish";
	public static String TAB_TAG_MESSAGE = "message";
	public static String TAB_TAB_MINE = "mine";
	public static TabHost mTabHost;
	static final int COLOR1 = Color.parseColor("#838992");
	static final int COLOR2 = Color.parseColor("#b87721");
	public static ImageView imgIndex, imgSquare, imgPublish, imgMessage, imgMine;
	public static TextView tvIndex, tvSquare, tvPublish, tvMessage, tvMine;

	Intent indexIntent, squareIntent, publishIntent, messageIntent, mineIntent;

	private static int mCurTabId = R.id.layoutIndex;

	// Animation
	private Animation left_in, left_out;
	private Animation right_in, right_out;
	private Animation up_in, up_out;
	private Animation bottom_up_in;
	private static Animation bottom_up_out;

	private View view;
	public static LinearLayout mainBottom;

	private String formTag = "";

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		view = LayoutInflater.from(this).inflate(R.layout.main, null);
		setContentView(view);
		
		Debuger.log_w("MainActivity","onCreate");

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		prepareAnim();
		prepareIntent();
		setupIntent();
		prepareView();

	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		Debuger.log_w("MainActivity","onDestroy");
	}

	public void replaceContentView(String id, Intent newIntent) {
		View view = getLocalActivityManager().startActivity(id,
				newIntent)
				.getDecorView();
		this.setContentView(view);
	}
	
	private void prepareAnim() {
		left_in = AnimationUtils.loadAnimation(this, R.anim.left_in);
		left_out = AnimationUtils.loadAnimation(this, R.anim.left_out);
		right_in = AnimationUtils.loadAnimation(this, R.anim.right_in);
		right_out = AnimationUtils.loadAnimation(this, R.anim.right_out);
		up_in = AnimationUtils.loadAnimation(this, R.anim.push_up_in);
		up_out = AnimationUtils.loadAnimation(this, R.anim.push_up_out);
		bottom_up_in = AnimationUtils.loadAnimation(this, R.anim.bottom_up_in);
		bottom_up_out = AnimationUtils.loadAnimation(this, R.anim.bottom_up_out);
	}

	private void prepareView() {
		imgIndex = (ImageView) findViewById(R.id.imgIndex);
		imgSquare = (ImageView) findViewById(R.id.imgSquare);
		imgPublish = (ImageView) findViewById(R.id.imgPublish);
		imgMessage = (ImageView) findViewById(R.id.imgMessage);
		imgMine = (ImageView) findViewById(R.id.imgMine);
		findViewById(R.id.layoutIndex).setOnClickListener(this);
		findViewById(R.id.layoutSquare).setOnClickListener(this);
		findViewById(R.id.layoutPublish).setOnClickListener(this);
		findViewById(R.id.layoutMessage).setOnClickListener(this);
		findViewById(R.id.layoutMine).setOnClickListener(this);
		tvIndex = (TextView) findViewById(R.id.tvIndex);
		tvSquare = (TextView) findViewById(R.id.tvSquare);
		tvMessage = (TextView) findViewById(R.id.tvMessage);
		tvMine = (TextView) findViewById(R.id.tvMine);

		mainBottom = (LinearLayout) findViewById(R.id.mainbottom);
		mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);

	}

	private void prepareIntent() {

		indexIntent = new Intent(this, AppActivity.class);

		squareIntent = new Intent(this, SquareActivity.class);

		publishIntent = new Intent(this, PubishActivity.class);

		messageIntent = new Intent(this, MessageActivity.class);

		mineIntent = new Intent(this, AppActivity.class);
//		mineIntent = new Intent(this,
//				IndexActivity.class);
	}

	private void setupIntent() {

		mTabHost = getTabHost();

		mTabHost.addTab(buildTabSpec(TAB_TAG_INDEX, R.string.index, R.drawable.index_selector, indexIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_SQUARE, R.string.square, R.drawable.square_selector, squareIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_PUBLISH, R.string.publish, R.drawable.publish, publishIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_MESSAGE, R.string.message, R.drawable.message_selector, messageIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_INDEX, R.string.mine, R.drawable.mine_selector, mineIntent));
	}

	private TabHost.TabSpec buildTabSpec(String tag, int resLabel, int resIcon, final Intent content) {
		return mTabHost.newTabSpec(tag).setIndicator(getString(resLabel), getResources().getDrawable(resIcon))
				.setContent(content);
	}

	public static void setCurrentTabByTag(String tab) {
		mTabHost.setCurrentTabByTag(tab);
	}

	@Override
	public void onClick(View v) {

		// TODO Auto-generated method stub
		if (mCurTabId == v.getId()) {
			return;
		}

		imgIndex.setImageResource(R.drawable.index_normal);
		imgSquare.setImageResource(R.drawable.square_normal);
		imgMessage.setImageResource(R.drawable.message_normal);
		imgMine.setImageResource(R.drawable.mine_normal);
		tvIndex.setTextColor(COLOR1);
		tvSquare.setTextColor(COLOR1);
		tvMessage.setTextColor(COLOR1);
		tvMine.setTextColor(COLOR1);
		int checkedId = v.getId();
		int o;

		if (mCurTabId < checkedId)
			o = 0;
		else
			o = 1;

		if (checkedId == R.id.layoutPublish) {
			o = 2;
		}

//		if (0 == o)
//			mTabHost.getCurrentView().startAnimation(left_out);
//		else if (1 == o)
//			mTabHost.getCurrentView().startAnimation(right_out);
//		else
//			mTabHost.getCurrentView().startAnimation(up_out);
		if(2 == o){
			mTabHost.getCurrentView().startAnimation(up_out);
		}
		switch (checkedId) {

		case R.id.layoutIndex:
			mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);
			imgIndex.setImageResource(R.drawable.index_selected);
			tvIndex.setTextColor(COLOR2);
			AppActivity.printMsg("citymap");

			break;

		case R.id.layoutSquare:
			mTabHost.setCurrentTabByTag(TAB_TAG_SQUARE);
			imgSquare.setImageResource(R.drawable.square_selected);
			tvSquare.setTextColor(COLOR2);

			break;
		case R.id.layoutPublish:
			Debuger.log_w(TAG, "mCurTabId:"+mCurTabId);
			publishIntent.putExtra("tagid", mCurTabId);
			mTabHost.setCurrentTabByTag(TAB_TAG_PUBLISH);
			imgPublish.setImageResource(R.drawable.publish);

			break;

		case R.id.layoutMessage:
			mTabHost.setCurrentTabByTag(TAB_TAG_MESSAGE);
			imgMessage.setImageResource(R.drawable.message_selected);
			tvMessage.setTextColor(COLOR2);

			break;
		case R.id.layoutMine:
			mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);
			imgMine.setImageResource(R.drawable.mine_selected);
			tvMine.setTextColor(COLOR2);

			AppActivity.printMsg("userhome");
			break;
		default:
			break;
		}

//		if (0 == o)
//			mTabHost.getCurrentView().startAnimation(left_in);
//		else if (1 == o)
//			mTabHost.getCurrentView().startAnimation(right_in);
//		else {
//			mainBottom.startAnimation(bottom_up_in);
//			mTabHost.getCurrentView().startAnimation(up_in);
//			mainBottom.setVisibility(View.GONE);
//		}
		if(2 == o)
		{
			mainBottom.startAnimation(bottom_up_in);
			mTabHost.getCurrentView().startAnimation(up_in);
			mainBottom.setVisibility(View.GONE);
		}

		mCurTabId = checkedId;
	}

	public static void setTabItem(int id){
		mCurTabId = id;
		mainBottom.setVisibility(View.VISIBLE);
		switch (id) {

		case R.id.layoutIndex:
			mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);
			imgIndex.setImageResource(R.drawable.index_selected);
			tvIndex.setTextColor(COLOR2);

			break;

		case R.id.layoutSquare:
			mTabHost.setCurrentTabByTag(TAB_TAG_SQUARE);
			if(null == imgSquare){
				Debuger.log_w(TAG, "imgSquare is null");
			}
			imgSquare.setImageResource(R.drawable.square_selected);
			tvSquare.setTextColor(COLOR2);

			break;
		case R.id.layoutPublish:
			mTabHost.setCurrentTabByTag(TAB_TAG_PUBLISH);
			break;

		case R.id.layoutMessage:
			mTabHost.setCurrentTabByTag(TAB_TAG_MESSAGE);
			imgMessage.setImageResource(R.drawable.message_selected);
			tvMessage.setTextColor(COLOR2);

			break;
		case R.id.layoutMine:
			mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);
			imgMine.setImageResource(R.drawable.mine_selected);
			tvMine.setTextColor(COLOR2);

			break;
		default:
			break;
		}
		
		mainBottom.startAnimation(bottom_up_out);
	}
	
	private void showPopupWindow(View view) {

		// 涓�涓����瀹�涔����甯�灞�锛�浣�涓烘�剧ず������瀹�
		View contentView = LayoutInflater.from(this).inflate(R.layout.publish_activity, null);

		final PopupWindow popupWindow = new PopupWindow(contentView, LayoutParams.MATCH_PARENT,
				Utils.windowXY(this)[1] * 3 / 4, true);

		popupWindow.setTouchable(true);

		// popupWindow.setTouchInterceptor(new OnTouchListener() {
		//
		// @Override
		// public boolean onTouch(View v, MotionEvent event) {
		//
		// Log.i("mengdd", "onTouch : ");
		//
		// return false;
		// // 杩����濡����杩����true���璇�锛�touch浜�浠跺��琚�������
		// // ��������� PopupWindow���onTouchEvent涓�琚�璋����锛�杩���风�瑰�诲����ㄥ�哄�����娉�dismiss
		// }
		// });

		// 濡����涓�璁剧疆PopupWindow���������锛����璁烘����瑰�诲����ㄥ�哄��杩����Back�����芥��娉�dismiss寮规��
		// ���瑙�寰�杩�������API���涓�涓�bug
		// popupWindow.setBackgroundDrawable(getResources().getDrawable(
		// R.drawable.selectmenu_bg_downward));

		// 璁剧疆濂藉����颁��������show
		popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);

	}

}