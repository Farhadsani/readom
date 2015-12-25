package com.shitouren.citystate;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.client.CookieStore;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.app.AppManager;
import com.shitouren.app.GlobleApplication;
import com.shitouren.bean.SquareHot;
import com.shitouren.bean.User;
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.ActivityUtils;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class LoginPhoneActivity extends Activity implements IActivity, OnClickListener {
	private final String TAG = "LoginPhoneActivity";
	private Context ctx;

	private ImageView ivBack;

	private EditText etPhone;
	private EditText etPwd;

	private LinearLayout llLogin;

	private AjaxParams params;
	private FinalHttp http;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.login_activity);

		ctx = LoginPhoneActivity.this;
		http = new FinalHttp();
		http.addHeader("Cookie", "shitouren_ssid=" + AppManager.getSSID(this));
		http.addHeader("User-Agent", "shitouren_qmap_android");

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		initView();
		setLisener();
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {

	}

	@Override
	public void initView() {
		ivBack = (ImageView) findViewById(R.id.ivBackLogin);

		etPhone = (EditText) findViewById(R.id.etPhoneLogin);
		etPwd = (EditText) findViewById(R.id.etPwdLogin);

		llLogin = (LinearLayout) findViewById(R.id.llLogin);
	}

	@Override
	public void setLisener() {
		ivBack.setOnClickListener(this);
		llLogin.setOnClickListener(this);
	}

	@Override
	public void parseIntent() {

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.ivBackLogin:
			LoginPhoneActivity.this.finish();
			break;
		case R.id.llLogin:
			if (verifyFormat()) {
				login();
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

	private void login() {
		Debuger.log_w(TAG, "login");
		params = new AjaxParams();
		List<String> lists = new ArrayList<String>();
		{
			lists.add("from");
			lists.add(Contacts.PHONE);
			lists.add("phone");
			lists.add(etPhone.getText().toString().trim());
			lists.add("passwd");
			lists.add(Utils.getMD5Str(etPwd.getText().toString().trim()));

		}
		params = HttpParamsUtil.getParams(ctx, params, 0, lists);
		Debuger.log_w(TAG, "register:" + params.getParamString());
		http.post(Contacts.BASE_URL + Contacts.SIGNIN, params, new AjaxCallBack<String>() {
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
					if (0 == jsonObject.getInt("ret")) {
						Debuger.showToastShort(ctx, jsonObject.getString("msg"));
						DefaultHttpClient client = (DefaultHttpClient) http.getHttpClient();
						CookieStore cookieStore = client.getCookieStore();
						List<Cookie> cookies = cookieStore.getCookies();

						GlobleApplication.cookieStore = cookieStore;
						for (int i = 0; i < cookies.size(); i++) {

							Utils.saveStrInShared(ctx, Contacts.COOKIE, cookies.get(i).getName(),
									cookies.get(i).getValue());

							Debuger.log_w(TAG, "- domain " + cookies.get(i).getDomain());
							Debuger.log_w(TAG, "- path " + cookies.get(i).getPath());
							Debuger.log_w(TAG, "- value " + cookies.get(i).getValue());
							Debuger.log_w(TAG, "- name " + cookies.get(i).getName());
							Debuger.log_w(TAG, "- port " + cookies.get(i).getPorts());
							Debuger.log_w(TAG, "- comment " + cookies.get(i).getComment());
							Debuger.log_w(TAG, "- commenturl" + cookies.get(i).getCommentURL());
							Debuger.log_w(TAG, "- all " + cookies.get(i).toString());
						}

						GlobleApplication.shitouren_check = Utils.getStrFromShared(ctx, Contacts.COOKIE,
								"shitouren_check");
						GlobleApplication.shitouren_verify = Utils.getStrFromShared(ctx, Contacts.COOKIE,
								"shitouren_verify");

						Debuger.log_w(TAG, "shitouren_check:"+GlobleApplication.shitouren_check);
						Debuger.log_w(TAG, "shitouren_verify:"+GlobleApplication.shitouren_verify);
						String res = jsonObject.optString("res");
						Utils.saveStrInShared(ctx, Contacts.USER, Contacts.USER_RES, res);

						ActivityUtils.startActivityAndFinish(LoginPhoneActivity.this, MainActivity.class);
					} else {
						Debuger.showToastShort(ctx, jsonObject.getString("msg"));
					}

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
}
