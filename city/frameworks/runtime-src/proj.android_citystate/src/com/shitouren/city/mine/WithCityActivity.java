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
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class WithCityActivity extends Activity implements OnClickListener {

	LinearLayout llWithCityShare,llWithCityWeiXin,llWithCityWeiBo,llWithCityFeedback,llWithCityHaoPing;
	int mHeigh;
	private ImageView tvShareFriend;
	private ImageView tvShareWeiBo;
	private ImageView tvShareQQ;
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
	
//	@Override
//	protected void onStart() {
//		// TODO Auto-generated method stub
//		backgroundAlpha(1.0f);
//		super.onStart();
//	}
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
	
	/** 
     * 设置添加屏幕的背景透明度 
     * @param bgAlpha 
     */  
    public void backgroundAlpha(float bgAlpha)  
    {  
        WindowManager.LayoutParams lp = getWindow().getAttributes();  
        lp.alpha = bgAlpha; //0.0-1.0  
        getWindow().setAttributes(lp);  
    }
	
	private void showSharePW() {
		// TODO Auto-generated method stub
		backgroundAlpha(0.3f);
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
//	    window.setAnimationStyle(R.style.mypopwindow_anim_style);
	    // 在底部显示
	    window.showAtLocation(WithCityActivity.this.findViewById(R.id.llWithCityShare),
	        Gravity.BOTTOM, 0, 0);
	    
	    window.setOnDismissListener(new OnDismissListener() {
			@Override
			public void onDismiss() {
				// TODO Auto-generated method stub
				rlShareCancel.setBackgroundResource(R.drawable.withcitysharequxiao);
				backgroundAlpha(1.0f);
				
			}
		});
	    
	    tvShareFriend =  (ImageView) view.findViewById(R.id.tvShareFriend);
	    tvShareWeiBo = (ImageView) view.findViewById(R.id.tvShareWeiBo);
	    tvShareQQ =  (ImageView) view.findViewById(R.id.tvShareQQ);
	    rlShareCancel = (RelativeLayout) view.findViewById(R.id.rlShareCancel);
	    
	    tvShareFriend.setOnClickListener(this);
	    tvShareWeiBo.setOnClickListener(this);
	    tvShareQQ.setOnClickListener(this);
		rlShareCancel.setOnClickListener(this);
		tvShareFriend.setBackgroundResource(R.drawable.withcitysharepengyouquanweixuanzhong);
		tvShareWeiBo.setBackgroundResource(R.drawable.withcityshareweiboweixuanzhong);
		tvShareQQ.setBackgroundResource(R.drawable.withcityshareqqkongjianweixuanzhong);
		rlShareCancel.setBackgroundResource(R.drawable.withcitysharequxiaoweixuanzhong);
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
		case R.id.tvShareFriend:
			tvShareFriend.setBackgroundResource(R.drawable.withcitysharepengyouquan);
			tvShareWeiBo.setBackgroundResource(R.drawable.withcityshareweiboweixuanzhong);
			tvShareQQ.setBackgroundResource(R.drawable.withcityshareqqkongjianweixuanzhong);
			rlShareCancel.setBackgroundResource(R.drawable.withcitysharequxiaoweixuanzhong);
			break;
			//分享微博
		case R.id.tvShareWeiBo:
			tvShareWeiBo.setBackgroundResource(R.drawable.withcityshareweibo);
			tvShareFriend.setBackgroundResource(R.drawable.withcitysharepengyouquanweixuanzhong);
			tvShareQQ.setBackgroundResource(R.drawable.withcityshareqqkongjianweixuanzhong);
			rlShareCancel.setBackgroundResource(R.drawable.withcitysharequxiaoweixuanzhong);
			break;
			//分享QQ
		case R.id.tvShareQQ:
			tvShareQQ.setBackgroundResource(R.drawable.withcityshareqqkongjian);
			tvShareFriend.setBackgroundResource(R.drawable.withcitysharepengyouquanweixuanzhong);
			tvShareWeiBo.setBackgroundResource(R.drawable.withcityshareweiboweixuanzhong);
			rlShareCancel.setBackgroundResource(R.drawable.withcitysharequxiaoweixuanzhong);
			break;
			//分享取消
		case R.id.rlShareCancel:
			rlShareCancel.setBackgroundResource(R.drawable.withcitysharequxiao);
			tvShareFriend.setBackgroundResource(R.drawable.withcitysharepengyouquanweixuanzhong);
			tvShareWeiBo.setBackgroundResource(R.drawable.withcityshareweiboweixuanzhong);
			tvShareQQ.setBackgroundResource(R.drawable.withcityshareqqkongjianweixuanzhong);
			window.dismiss();
			break;
		default:
			break;
		}
		
	}
}
