package com.shitouren.city.mine;

import com.shitouren.citystate.R;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class WithCityActivity extends Activity implements OnClickListener {

	LinearLayout llWithCityShare,llWithCityWeiXin,llWithCityWeiBo,llWithCityFeedback,llWithCityHaoPing;
	int mHeigh;
	private ImageView ivShareFriend;
	private ImageView ivShareWeiBo;
	private ImageView ivShareQQ;
	private RelativeLayout rlShareCancel;
	private PopupWindow window;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_with_city_activity);
		
		mHeigh = Utils.windowXY(this)[1];
		
		initview();
	}
	private void initview() {
		// TODO Auto-generated method stub
		llWithCityShare = (LinearLayout) findViewById(R.id.llWithCityShare);
		llWithCityWeiXin = (LinearLayout) findViewById(R.id.llWithCityWeiXin);
		llWithCityWeiBo = (LinearLayout) findViewById(R.id.llWithCityWeiBo);
		llWithCityFeedback = (LinearLayout) findViewById(R.id.llWithCityFeedback);
		llWithCityHaoPing = (LinearLayout) findViewById(R.id.llWithCityHaoPing);
		ImageView ivTopbarRight = (ImageView) findViewById(R.id.ivTopbarRight);
		
		llWithCityShare.setOnClickListener(this);
		llWithCityWeiXin.setOnClickListener(this);
		llWithCityWeiBo.setOnClickListener(this);
		llWithCityFeedback.setOnClickListener(this);
		llWithCityHaoPing.setOnClickListener(this);
		
	}
	
	private void showSharePW() {
		// TODO Auto-generated method stub
		LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = inflater.inflate(R.layout.mine_with_city_share_popupwindow, null);
		
		window = new PopupWindow(view, 
				WindowManager.LayoutParams.MATCH_PARENT, 
				WindowManager.LayoutParams.WRAP_CONTENT);
		// 设置popWindow弹出窗体可点击，这句话必须添加，并且是true
		window.setFocusable(true);
		// 实例化一个ColorDrawable颜色为半透明
	    ColorDrawable dw = new ColorDrawable(0xb0000000);
	    window.setBackgroundDrawable(dw);

	    
	    // 设置popWindow的显示和消失动画
	    window.setAnimationStyle(R.style.mypopwindow_anim_style);
	    // 在底部显示
	    window.showAtLocation(WithCityActivity.this.findViewById(R.id.llWithCityShare),
	        Gravity.BOTTOM, 0, 0);
	    
	    ivShareFriend = (ImageView) view.findViewById(R.id.ivShareFriend);
	    ivShareWeiBo = (ImageView) view.findViewById(R.id.ivShareWeiBo);
	    ivShareQQ = (ImageView) view.findViewById(R.id.ivShareQQ);
	    rlShareCancel = (RelativeLayout) view.findViewById(R.id.rlShareCancel);
	    ivShareFriend.setImageResource(R.drawable.withcitysharepengyouquan);
	    ivShareFriend.setOnClickListener(this);
		ivShareWeiBo.setOnClickListener(this);
		ivShareQQ.setOnClickListener(this);
		rlShareCancel.setOnClickListener(this);
	}
	
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.llWithCityShare:
			showSharePW();
			break;
		case R.id.llWithCityWeiXin:
			
			break;
		case R.id.llWithCityWeiBo:
			
			break;
		case R.id.llWithCityFeedback:
			
			break;
		case R.id.llWithCityHaoPing:
			
			break;

			/**
			 * PopupWindow选择键
			 */
			//分享朋友
		case R.id.ivShareFriend:
			break;
			//分享微博
		case R.id.ivShareWeiBo:
			break;
			//分享QQ
		case R.id.ivShareQQ:
			break;
			//分享取消
		case R.id.rlShareCancel:
			window.dismiss();
			break;
		default:
			break;
		}
		
	}
}
