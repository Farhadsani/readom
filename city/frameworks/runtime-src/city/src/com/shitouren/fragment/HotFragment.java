package com.shitouren.fragment;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.adapter.SquareAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.bean.SquareHot;
import com.shitouren.city.R;
import com.shitouren.entity.Contacts;
import com.shitouren.listview.XListView;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class HotFragment extends Fragment {

	private XListView listView;
	private SquareAdapter adapter;
	private List<SquareHot> squareHotList;

	private AjaxParams params;
	private FinalHttp http;

	
	private ProgressBar bar;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

		View view = inflater.inflate(R.layout.hot_fragment, null);

		listView = (XListView) view.findViewById(R.id.listviewHotFragment);

		bar = (ProgressBar) view.findViewById(R.id.barHotFragment);
		
		params = new AjaxParams();
		http = AppManager.getFinalHttp(getActivity());

		// initTestData();
		initData();

		// adapter = new SquareAdapter(getActivity(), list);
		// listView.setAdapter(adapter);
		return view;
	}

	private void initTestData() {
//		list = new ArrayList<Object>();
//		String name = "";
//		for (int i = 0; i < 5; i++) {
//			list.add((Object) (name + i));
//		}
	}

	private void initData() {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("begin", 0);
		map1.put("limit", 20);
		JSONObject jsonObject = new JSONObject(map1);
		map.put("idx", 0);
		map.put("ver", "1.0.0");
		map.put("params", jsonObject);
		JSONObject object = new JSONObject(map);

		params.put("postData", object.toString());

		http.post(Contacts.BASE_URL + Contacts.SQUARE_HOT, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				bar.setVisibility(View.VISIBLE);
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				Debuger.log_w(t);
				bar.setVisibility(View.GONE);
				try {
					JSONObject jsonObject = new JSONObject(t);
					if ("ok".endsWith(jsonObject.getString("msg"))) {
						String res = jsonObject.optString("res");
						Type type = new TypeToken<List<SquareHot>>() {}.getType();
						Gson gson = new Gson();
						squareHotList = gson.fromJson(res, type);
						
						adapter = new SquareAdapter(getActivity(), squareHotList);
						listView.setAdapter(adapter);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				super.onSuccess(t);
			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				// TODO Auto-generated method stub
				bar.setVisibility(View.GONE);
				super.onFailure(t, errorNo, strMsg);
			}
		});
	}
}
