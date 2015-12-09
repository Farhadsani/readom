package com.shitouren.citystate;

import org.json.JSONException;
import org.json.JSONObject;

import com.shitouren.app.AppManager;
import com.shitouren.entity.Contacts;
import com.shitouren.utils.ActivityUtils;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class LoginActivity extends Activity implements OnClickListener {
	private static final String TAG = "LoginActivity";

	ImageView ivLoginPhoneBack,ivLoginPhone;
	private ImageView ivLoginWeixin;
	
	private IWXAPI api;
	
	private FinalHttp http;
	private AjaxParams params;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_login_activity1);
		
		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}
		
		api = WXAPIFactory.createWXAPI(this, Contacts.APP_ID, false);
		api.registerApp(Contacts.APP_ID);
		
		ivLoginPhoneBack = (ImageView) findViewById(R.id.ivLoginPhoneBack);
		ivLoginPhone = (ImageView) findViewById(R.id.ivLoginPhone);
		ivLoginWeixin = (ImageView) findViewById(R.id.ivLoginWeixin);
		
		ivLoginPhone.setOnClickListener(this);
		ivLoginPhoneBack.setOnClickListener(this);
		ivLoginWeixin.setOnClickListener(this);
		
		params = new AjaxParams();
		http = AppManager.getFinalHttp(this);
		
		Intent intent = getIntent();
		String code = intent.getStringExtra("data");
		if(!TextUtils.isEmpty(code)){
			getAccessTokenAndOpenId(code);
		}
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

		case R.id.ivLoginWeixin:
			api.openWXApp();
			wxLogin();
			break;
		default:
			break;
		}
		
	}
	
	private void wxLogin(){
		Debuger.log_w(TAG, "wxLogin");
		final SendAuth.Req req = new SendAuth.Req();
	    req.scope = "snsapi_userinfo";
	    req.state = "city_wx_login";
	    api.sendReq(req);
	}
	
	private void getAccessTokenAndOpenId(String code){
		
		if(params == null){
			Debuger.log_w(TAG, "params:"+params);
		}
		params.put("appid", Contacts.APP_ID);
		params.put("secret", Contacts.APP_SECRET);
		params.put("code", code);
		params.put("grant_type", Contacts.WX_GRANT_TYPE);
		http.get(Contacts.WX_ACCESS_TOKEN_URL, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
				Debuger.showToastShort(LoginActivity.this, "加载中……");
			}
			@Override
			public void onSuccess(String t) {
				super.onSuccess(t);
				Debuger.showToastShort(LoginActivity.this, "获取Access成功");
				try {
					JSONObject object = new JSONObject(t);
					if(object.has("errcode")){
						Debuger.showToastShort(LoginActivity.this, object.getString("errmsg"));
					}else{
						Debuger.log_w(TAG, t);
						String res = object.toString();
						Utils.saveStrInShared(LoginActivity.this, Contacts.WX_TOKEN, Contacts.TOKEN_JSON, res);
						
						ActivityUtils.startActivity(LoginActivity.this, BindPhoneActivity.class);
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				super.onFailure(t, errorNo, strMsg);
				Debuger.showToastShort(LoginActivity.this, "获取Access失败");
			}
		});
	}

}
