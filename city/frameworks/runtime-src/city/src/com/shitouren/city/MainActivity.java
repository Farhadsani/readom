package com.shitouren.city;

import com.shitouren.utils.Utils;

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
import android.widget.PopupWindow;
import android.widget.TabHost;
import android.widget.TextView;

@SuppressWarnings("deprecation")
public class MainActivity extends TabActivity implements OnClickListener {
	public static String TAB_TAG_INDEX = "index";
	public static String TAB_TAG_SQUARE = "square";
	public static String TAB_TAG_PUBLISH = "publish";
	public static String TAB_TAG_MESSAGE = "message";
	public static String TAB_TAB_MINE = "mine";
	public static TabHost mTabHost;
	static final int COLOR1 = Color.parseColor("#838992");
	static final int COLOR2 = Color.parseColor("#b87721");
	ImageView imgIndex, imgSquare, imgPublish, imgMessage, imgMine;
	TextView tvIndex, tvSquare, tvPublish, tvMessage, tvMine;

	Intent indexIntent, squareIntent, publishIntent, messageIntent, mineIntent;

	int mCurTabId = R.id.layoutIndex;

	// Animation
	private Animation left_in, left_out;
	private Animation right_in, right_out;

	
	private View view ;
	/** Called when the activity is first created. */
	
	//我改动的地方，我在eclipse中git commit  

	@Override
	public void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		view = LayoutInflater.from(this).inflate(R.layout.main, null);
		setContentView(view);

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		prepareAnim();
		prepareIntent();
		setupIntent();
		prepareView();

	}

	private void prepareAnim() {
		left_in = AnimationUtils.loadAnimation(this, R.anim.left_in);
		left_out = AnimationUtils.loadAnimation(this, R.anim.left_out);
		right_in = AnimationUtils.loadAnimation(this, R.anim.right_in);
		right_out = AnimationUtils.loadAnimation(this, R.anim.right_out);
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

		mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);

	}

	private void prepareIntent() {

		indexIntent = new Intent(this, IndexActivity.class);

		squareIntent = new Intent(this, SquareActivity.class);

		publishIntent = new Intent(this, PubishActivity.class);

		messageIntent = new Intent(this, MessageActivity.class);

		mineIntent = new Intent(this, MineActivity.class);

	}

	private void setupIntent() {

		mTabHost = getTabHost();

		mTabHost.addTab(buildTabSpec(TAB_TAG_INDEX, R.string.index, R.drawable.index_selector, indexIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_SQUARE, R.string.square, R.drawable.square_selector, squareIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_PUBLISH, R.string.publish, R.drawable.publish, publishIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAG_MESSAGE, R.string.message, R.drawable.message_selector, messageIntent));

		mTabHost.addTab(buildTabSpec(TAB_TAB_MINE, R.string.mine, R.drawable.mine_selector, mineIntent));
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
		final boolean o;
		if (mCurTabId < checkedId)
			o = true;
		else
			o = false;
		if (o)
			mTabHost.getCurrentView().startAnimation(left_out);
		else
			mTabHost.getCurrentView().startAnimation(right_out);
		switch (checkedId) {

		case R.id.layoutIndex:
			mTabHost.setCurrentTabByTag(TAB_TAG_INDEX);
			imgIndex.setImageResource(R.drawable.index_selected);
			tvIndex.setTextColor(COLOR2);

			break;

		case R.id.layoutSquare:
			mTabHost.setCurrentTabByTag(TAB_TAG_SQUARE);
			imgSquare.setImageResource(R.drawable.square_selected);
			tvSquare.setTextColor(COLOR2);

			break;
		case R.id.layoutPublish:
//			mTabHost.setCurrentTabByTag(TAB_TAG_PUBLISH);
//			imgPublish.setImageResource(R.drawable.publish);

			showPopupWindow(view);
			break;

		case R.id.layoutMessage:
			mTabHost.setCurrentTabByTag(TAB_TAG_MESSAGE);
			imgMessage.setImageResource(R.drawable.message_selected);
			tvMessage.setTextColor(COLOR2);

			break;
		case R.id.layoutMine:
			mTabHost.setCurrentTabByTag(TAB_TAB_MINE);
			imgMine.setImageResource(R.drawable.mine_selected);
			tvMine.setTextColor(COLOR2);

			break;
		default:
			break;
		}

		if (o)
			mTabHost.getCurrentView().startAnimation(left_in);
		else
			mTabHost.getCurrentView().startAnimation(right_in);
		mCurTabId = checkedId;
	}

	
	private void showPopupWindow(View view) {

        // 一个自定义的布局，作为显示的内容
        View contentView = LayoutInflater.from(this).inflate(
                R.layout.publish_activity, null);

        final PopupWindow popupWindow = new PopupWindow(contentView,
                LayoutParams.MATCH_PARENT, Utils.windowXY(this)[1]*3/4, true);

        popupWindow.setTouchable(true);

//        popupWindow.setTouchInterceptor(new OnTouchListener() {
//
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//
//                Log.i("mengdd", "onTouch : ");
//
//                return false;
//                // 这里如果返回true的话，touch事件将被拦截
//                // 拦截后 PopupWindow的onTouchEvent不被调用，这样点击外部区域无法dismiss
//            }
//        });

        // 如果不设置PopupWindow的背景，无论是点击外部区域还是Back键都无法dismiss弹框
        // 我觉得这里是API的一个bug
//        popupWindow.setBackgroundDrawable(getResources().getDrawable(
//                R.drawable.selectmenu_bg_downward));

        // 设置好参数之后再show
        popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);

    }

}