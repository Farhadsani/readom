package com.shitouren.fragment;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.adapter.MyMessageAdapter;
import com.shitouren.adapter.SquareAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.app.GlobleApplication;
import com.shitouren.bean.MyMessage;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.listview.XListView;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

public class MyMessageFragment extends BaseFragment {

	private View view;
	private XListView my_listview;
	private ProgressBar my_pbar;

	private List<MyMessage> myMessageList;
	private MyMessageAdapter myMessageAdapter;

	private AjaxParams params;
	private FinalHttp finalhttp;
	private String url = Contacts.BASE_URL + Contacts.MY_MESSAGE;

	// 添加数据
	@Override
	public void initData(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		// params = new AjaxParams();
//		 finalhttp = AppManager.getFinalHttp(getActivity());
//		 initmymessagedata();

	}

	// 加载布局
	@Override
	public View initView(LayoutInflater inflater) {
		// TODO Auto-generated method stub
		view = inflater.inflate(R.layout.message_mymessage, null);
		my_listview = (XListView) view.findViewById(R.id.my_listview);
		my_pbar = (ProgressBar) view.findViewById(R.id.my_pbar);
		params = new AjaxParams();
		finalhttp = AppManager.getFinalHttp(getActivity());
		initmymessagedata();
		return inflater.inflate(R.layout.message_mymessage, null);
	}

	private void initmymessagedata() {
		// TODO Auto-generated method stub
		Map<String, Object> mymessagemap = new HashMap<String, Object>();
		Map<String, Object> mymessagemap1 = new HashMap<String, Object>();
		mymessagemap1.put("userid", "72431");
		mymessagemap1.put("begin", 0);
		mymessagemap1.put("limit", 10);
		JSONObject obj = new JSONObject(mymessagemap1);
		mymessagemap.put("idx", 0);
		mymessagemap.put("ver", "1.0.0");
		mymessagemap.put("params", obj);
		JSONObject object = new JSONObject(mymessagemap);

		params.put("postData", object.toString());
		
		String verify = Utils.getStrFromShared(getActivity(), Contacts.COOKIE, "shitouren_verify");
		String check = Utils.getStrFromShared(getActivity(), Contacts.COOKIE, "shitouren_check");
		
		Debuger.log_w("Set-Cookie", "verify:"+verify);
		Debuger.log_w("cookie", "check:"+check);
//		finalhttp.configCookieStore(GlobleApplication.cookieStore);
		finalhttp.addHeader("Cookie","shitouren_ssid="+AppManager.getSSID(getActivity())+";"+"shitouren_verify="+verify+";"+"shitouren_check="+check);
//		finalhttp.addHeader("Cookie","shitouren_check="+check,true);
		finalhttp.post(url, params, new AjaxCallBack<String>() {

			@Override
			public void onStart() {
				// TODO Auto-generated method stub
				my_pbar.setVisibility(View.VISIBLE);
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				// TODO Auto-generated method stub
				Debuger.log_w(t);
				my_pbar.setVisibility(View.GONE);
				try {
					JSONObject obj = new JSONObject(t);
					if ("ok".endsWith(obj.getString("msg"))) {
						String res = obj.optString("res");
						if(res!=null&&!res.equals("[]")){
							Type type = new TypeToken<List<MyMessage>>() {}.getType();
							Gson gson = new Gson();
							myMessageList = gson.fromJson(res, type);
							
							myMessageAdapter = new MyMessageAdapter(getActivity(), myMessageList);
							
							if (myMessageAdapter != null) {
								my_listview.setAdapter(myMessageAdapter);
							}
						}
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				super.onSuccess(t);
			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				// TODO Auto-generated method stub
				Debuger.log_w("*********"+strMsg);
				my_pbar.setVisibility(View.GONE);
				super.onFailure(t, errorNo, strMsg);
			}
			
		});
		
	}
}
