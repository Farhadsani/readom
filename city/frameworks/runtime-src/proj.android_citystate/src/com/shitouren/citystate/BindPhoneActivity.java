package com.shitouren.citystate;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.app.AppManager;
import com.shitouren.bean.WXToken;
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.ActivityUtils;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class BindPhoneActivity extends Activity implements IActivity, OnClickListener {
	private Context ctx = null;
	private final String TAG = "BindPhoneActivity";

	private ImageView ivBack;

	private EditText etPhone;

	private EditText etPwd;

	private EditText etVerCode;
	private LinearLayout llVerCode;
	private TextView tvVerCode;

	private LinearLayout llOk;
	private TextView tvOk;

	private String res;
	private WXToken token;

	private int time = 60;
	private final int TIMEDOWN = 0x1;
	private Timer timer;
	private TimerTask task;
	private Handler handler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case TIMEDOWN:
				if (0 != time) {
					tvVerCode.setText("再次发送(" + time + ")");
				} else {
					time = 60;
					tvVerCode.setText("发送验证码");
					llVerCode.setEnabled(true);
					timer.cancel();
				}

				break;

			default:
				break;
			}
		};
	};
	
	private String wxUserName = "";
	private String wxHeadUrl = "";

	private AjaxParams params;
	private FinalHttp http;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.bind_phone_activity);

		ctx = BindPhoneActivity.this;
		
		initView();
		initData();
		setLisener();
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {
		res = Utils.getStrFromShared(ctx, Contacts.WX_TOKEN, Contacts.TOKEN_JSON);
		Type type = new TypeToken<WXToken>() {
		}.getType();
		Gson gson = new Gson();
		token = gson.fromJson(res, type);
		getUserInfo();
	}

	@Override
	public void initView() {
		ivBack = (ImageView) findViewById(R.id.ivBackBindPhone);

		etPhone = (EditText) findViewById(R.id.etPhoneBindPhone);

		etPwd = (EditText) findViewById(R.id.etPwdBindPhone);

		etVerCode = (EditText) findViewById(R.id.etVerCodeBindPhone);
		llVerCode = (LinearLayout) findViewById(R.id.llVerCodeBindPhone);
		tvVerCode = (TextView) findViewById(R.id.tvVerCodeBindPhone);

		llOk = (LinearLayout) findViewById(R.id.llOkBindPhone);
		tvOk = (TextView) findViewById(R.id.tvOkBindPhone);

	}

	@Override
	public void setLisener() {
		ivBack.setOnClickListener(this);
		llVerCode.setOnClickListener(this);
		llOk.setOnClickListener(this);
	}

	@Override
	public void parseIntent() {

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.ivBackBindPhone:
			BindPhoneActivity.this.finish();
			break;
		case R.id.llVerCodeBindPhone:
			if (verifyFormat()) {
				sendSms();
			}
			break;
		case R.id.llOkBindPhone:
			if (verifyFormat()) {
				if(!TextUtils.isEmpty(etVerCode.getText().toString().trim())){
					register();
				}
			}
			break;
		}
	}

	private boolean verifyFormat() {
		String phone = etPhone.getText().toString().trim();
		String pwd = etPwd.getText().toString().trim();
		if (TextUtils.isEmpty(phone) || !Utils.isMobileNO(phone)) {
			Debuger.showToastShort(ctx, "手机号码有误或者不能为空!");
			return false;
		}
		if (TextUtils.isEmpty(pwd) || pwd.length() < 6) {
			Debuger.showToastShort(ctx, "密码不能为空或者少于6位!");
			return false;
		}

		return true;
	}

	
	private void getUserInfo(){
		params = new AjaxParams();
		http = AppManager.getFinalHttp(ctx);
		params.put("access_token", token.getAccess_token());
		params.put("openid", token.getOpenid());
		http.get(Contacts.WX_USERINFO_URL, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}
			@Override
			public void onSuccess(String t) {
				super.onSuccess(t);
				Debuger.log_w(TAG, t);
				try {
					JSONObject jsonObject = new JSONObject(t);
					wxUserName = jsonObject.getString("nickname");
					wxHeadUrl = jsonObject.getString("headimgurl");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				super.onFailure(t, errorNo, strMsg);
			}
		});
	}
	
	private void sendSms() {
		params = new AjaxParams();
		http = AppManager.getFinalHttp(ctx);
		
		List<String> lists = new ArrayList<String>();
		lists.add("phone");
		lists.add(etPhone.getText().toString().trim());
		lists.add("type");
		lists.add(Contacts.REGISTER);
		params = HttpParamsUtil.getParams(ctx, params, 0, lists);
		Debuger.log_w(TAG, "sendsms:"+params.getParamString());
		http.post(Contacts.BASE_URL + Contacts.SEND_SMS, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				super.onSuccess(t);
				Debuger.log_w(TAG, t);
				try {
					JSONObject jsonObject = new JSONObject(t);
					Debuger.showToastShort(ctx, jsonObject.getString("msg"));
					showTimeDown();
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				super.onFailure(t, errorNo, strMsg);
			}
		});

	}
	
	private void register(){
		params = new AjaxParams();
		http = AppManager.getFinalHttp(ctx);
		
		List<String> lists = new ArrayList<String>();
		{
			lists.add("phone");lists.add(etPhone.getText().toString().trim());
			lists.add("passwd");lists.add(Utils.getMD5Str(etPwd.getText().toString().trim()));
			lists.add("name");lists.add(wxUserName);
			lists.add("headurl");lists.add(wxHeadUrl);
			lists.add("verify");lists.add(etVerCode.getText().toString().trim());
			lists.add("unionid");lists.add(token.getUnionid());
			lists.add("from");lists.add("weixin");
			
		}
		params = HttpParamsUtil.getParams(ctx, params, 0, lists);
		Debuger.log_w(TAG, "register:"+params.getParamString());
		http.post(Contacts.BASE_URL+Contacts.SIGNUP, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}
			@Override
			public void onSuccess(String t) {
				super.onSuccess(t);
				Debuger.log_w(TAG, t);
				try {
					JSONObject jsonObject = new JSONObject(t);
					String res = jsonObject.optString("res");
					Utils.saveStrInShared(ctx, Contacts.USER, Contacts.USER_RES, res);
					ActivityUtils.startActivityAndFinish(BindPhoneActivity.this, MainActivity.class);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				
			}
			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				super.onFailure(t, errorNo, strMsg);
			}
		});
		
	}

	private void showTimeDown() {
		tvVerCode.setText("再次发送(" + time + ")");
		llVerCode.setEnabled(false);
		
		timer = new Timer();
		task = new TimerTask() {
			@Override
			public void run() {
				try {
					while(time>0){
						Thread.sleep(1000);
						time--;
						Message message = new Message();
						message.what = TIMEDOWN;
						message.obj = time;
						handler.sendMessage(message);
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		};
		timer.schedule(task, 0);
	}

}
