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
import com.handmark.pulltorefresh.library.ILoadingLayout;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.shitouren.adapter.SquareAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class HotFragment extends Fragment {
	private static final String TAG = "HotFragment";

	//View控件和框架类
	private PullToRefreshListView pullToRefreshListView;
	private ListView listView;
	private SquareAdapter adapter;
	private List<SquareHot> squareHotList;

	private AjaxParams params;
	private FinalHttp http;

	//数据区
	private int curBegin = 0;
	private int curLimit = 10;
	private int idx = 0;//自增的参数
	
	//0x1是上刷新，0x2是下拉刷新
	private int refresh = 0x1;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

		View view = inflater.inflate(R.layout.hot_fragment, null);

		pullToRefreshListView = (PullToRefreshListView) view.findViewById(R.id.listviewHotFragment);
		pullToRefreshListView.setMode(Mode.BOTH);

		listView = pullToRefreshListView.getRefreshableView();

		ILoadingLayout startLabels = pullToRefreshListView.getLoadingLayoutProxy(true, false);
		startLabels.setPullLabel("下拉刷新...");// 刚下拉时，显示的提示
		startLabels.setRefreshingLabel("正在载入...");// 刷新时
		startLabels.setReleaseLabel("放开刷新...");// 下来达到一定距离时，显示的提示

		ILoadingLayout endLabels = pullToRefreshListView.getLoadingLayoutProxy(false, true);
		endLabels.setPullLabel("上拉刷新...");// 刚下拉时，显示的提示
		endLabels.setRefreshingLabel("正在载入...");// 刷新时
		endLabels.setReleaseLabel("放开刷新...");// 下来达到一定距离时，显示的提示

		params = new AjaxParams();
		http = AppManager.getFinalHttp(getActivity());

		//pull-to-refresh第一种方法
//		pullToRefreshListView.setOnRefreshListener(new OnRefreshListener<ListView>() {
//
//			@Override
//			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
//				if (pullToRefreshListView.isHeaderShown()) {
//					Debuger.log_w(TAG, "isHeaderShown");
//					if (Utils.isNetworkAvailable(getActivity())) {
//						Debuger.log_w(TAG, "excute on PullDown");
//						initData();
//					} else {
//						Utils.showToastShort(getActivity(), "没有网络连接!");
//						pullToRefreshListView.onRefreshComplete();
//					}
//				} else {
//					Debuger.log_w(TAG, "isFooterShown");
//					if (Utils.isNetworkAvailable(getActivity())) {
//						initData();
//					} else {
//						Utils.showToastShort(getActivity(), "没有网络连接!");
//						pullToRefreshListView.onRefreshComplete();
//					}
//				}
//			}
//		});
		//pull-to-refresh第二种方法
		pullToRefreshListView.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				refresh = 0x1;
				if(squareHotList.size()>1){
					squareHotList.clear();
				}
				if (Utils.isNetworkAvailable(getActivity())) {
					Debuger.log_w(TAG, "excute on PullDown");
					initData();
				} else {
					Utils.showToastShort(getActivity(), "没有网络连接!");
					pullToRefreshListView.onRefreshComplete();
				}
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				refresh = 0x2;
				if (Utils.isNetworkAvailable(getActivity())) {
					initData();
				} else {
					Utils.showToastShort(getActivity(), "没有网络连接!");
					pullToRefreshListView.onRefreshComplete();
				}
			}
		});

		//为了实现页面刚进来上拉刷新加载，必须为adapter开始初始化数据，listview.setAdapter才行
		squareHotList = new ArrayList<SquareHot>();
		squareHotList.add(new SquareHot(false));
		adapter = new SquareAdapter(getActivity(), squareHotList);
		listView.setAdapter(adapter);
		//界面刚启动就开始上拉刷新加载
		pullToRefreshListView.setRefreshing(true);
		return view;
	}

	private void initTestData() {
		// list = new ArrayList<Object>();
		// String name = "";
		// for (int i = 0; i < 5; i++) {
		// list.add((Object) (name + i));
		// }
	}

	private void initData() {
		
		if(0x1 == refresh){
			curBegin = 0;
			curLimit = HttpParamsUtil.LIMIT;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("begin", curBegin);
		map1.put("limit", curLimit);
		JSONObject jsonObject = new JSONObject(map1);
		map.put("idx", idx);
		map.put("ver", "1.0.0");
		map.put("params", jsonObject);
		JSONObject object = new JSONObject(map);

		params.put("postData", object.toString());

		http.post(Contacts.BASE_URL + Contacts.SQUARE_HOT, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				 Debuger.log_w(t);
				//每次刷新访问参数变化
				curBegin = curLimit+1;
				curLimit = HttpParamsUtil.incrementLimit(curLimit);
				idx = HttpParamsUtil.incrementIdx(idx);
				//刷新控件停止
				pullToRefreshListView.onRefreshComplete();
				
				try {
					JSONObject jsonObject = new JSONObject(t);
					if ("ok".endsWith(jsonObject.getString("msg"))) {
						String res = jsonObject.optString("res");
						Type type = new TypeToken<List<SquareHot>>() {}.getType();
						Gson gson = new Gson();
						if(0x1 == refresh){
							squareHotList = gson.fromJson(res, type);
						}else{
							List<SquareHot> lists = new ArrayList<SquareHot>();
							lists = gson.fromJson(res, type);
							squareHotList.addAll(lists);
						}
						
						setAdapter();
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				super.onSuccess(t);
			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				
				//idx是统计并发请求，不管失败成功都要自增1
				idx = HttpParamsUtil.incrementIdx(idx);
				
				pullToRefreshListView.onRefreshComplete();
				super.onFailure(t, errorNo, strMsg);
			}
		});
	}
	
	private void setAdapter(){
		if(0x1 == refresh){
			Debuger.log_w(TAG, "new Adapter");
			adapter = new SquareAdapter(getActivity(), squareHotList);
			listView.setAdapter(adapter);
		}else{
			Debuger.log_w(TAG, "adapter.notifyDataSetChanged");
			adapter.notifyDataSetChanged();
		}
		
	}
}
