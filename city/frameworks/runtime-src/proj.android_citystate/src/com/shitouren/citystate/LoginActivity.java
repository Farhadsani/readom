package com.shitouren.citystate;

import com.shitouren.utils.ActivityUtils;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class LoginActivity extends Activity implements OnClickListener {

	ImageView ivLoginPhoneBack,ivLoginPhone;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_login_activity1);
		ivLoginPhoneBack = (ImageView) findViewById(R.id.ivLoginPhoneBack);
		ivLoginPhone = (ImageView) findViewById(R.id.ivLoginPhone);
		
		ivLoginPhone.setOnClickListener(this);
		ivLoginPhoneBack.setOnClickListener(this);
	}
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.ivLoginPhone:
			ActivityUtils.startActivity(LoginActivity.this, LoginPhoneActivity.class);
			break;
		case R.id.ivLoginPhoneBack:
			overridePendingTransition(R.anim.in_from_righ, R.anim.out_to_left);
			finish();
			break;

		default:
			break;
		}
		
	}
}
