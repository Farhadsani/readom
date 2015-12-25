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
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.shitouren.adapter.SquareAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.parser.SquareParser;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class AttentionFragment extends Fragment implements IActivity {
	private static final String TAG = "AttentionFragment";

	// View控件和框架类
	private PullToRefreshListView pullToRefreshListView;
	private SquareAdapter adapter;
	private List<SquareHot> squareHotList;

	private ViewStub stub;
	private TextView tvInfo;
	private ProgressBar bar;

	private AjaxParams params;
	private FinalHttp http;

	// 数据区
	private int curBegin = 0;
	private int curLimit = 10;
	private int idx = 0;// 自增的参数

	// 0x1是上刷新，0x2是下拉刷新
	private int refresh = 0x1;

	private final int FIRST_LOAD = 0x1;
	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case FIRST_LOAD:
				adapter = new SquareAdapter(getActivity(), squareHotList, bar);
				pullToRefreshListView.setAdapter(adapter);
				break;
			}
		};
	};

	private View view;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		view = inflater.inflate(R.layout.attention_fragment, container, false);

		pullToRefreshListView = (PullToRefreshListView) view.findViewById(R.id.listviewAttention);
		pullToRefreshListView.setMode(Mode.BOTH);

		stub = (ViewStub) view.findViewById(R.id.vsNoMessageAttention);
		bar = (ProgressBar) view.findViewById(R.id.progressBar);

		ILoadingLayout startLabels = pullToRefreshListView.getLoadingLayoutProxy(true, false);
		startLabels.setPullLabel("下拉可以刷新");// 刚下拉时，显示的提示
		startLabels.setRefreshingLabel("正在帮您刷新");// 刷新时
		startLabels.setReleaseLabel("松开立即刷新");// 下来达到一定距离时，显示的提示
		//
		ILoadingLayout endLabels = pullToRefreshListView.getLoadingLayoutProxy(false, true);
		endLabels.setPullLabel("上拉可以加载更多数据");// 刚下拉时，显示的提示
		endLabels.setRefreshingLabel("正在帮您刷新");// 刷新时
		endLabels.setReleaseLabel("松开立即加载更多数据");// 下来达到一定距离时，显示的提示

		params = new AjaxParams();
		http = AppManager.getFinalHttp(getActivity());

		setLisener();
		return view;
	}

	@Override
	public void setUserVisibleHint(boolean isVisibleToUser) {
		super.setUserVisibleHint(isVisibleToUser);
		if (getUserVisibleHint()) {
			// 为了实现页面刚进来上拉刷新加载，必须为adapter开始初始化数据，listview.setAdapter才行
			squareHotList = new ArrayList<SquareHot>();
			pullToRefreshListView.onRefreshComplete();
			pullToRefreshListView.setRefreshing(true);

			Message msg = handler.obtainMessage();
			msg.what = FIRST_LOAD;
			handler.sendMessage(msg);
			// 界面刚启动就开始上拉刷新加载
			if (Utils.isNetworkAvailable(getActivity())) {
				// initData();
			} else {
				Utils.showToastShort(getActivity(), "没有网络连接!");
				// stub.setVisibility(View.VISIBLE);
				stub.inflate();
				Utils.showNoMessage(view, "没有网络连接");
			}
		}
	}

	@Override
	public void onStart() {
		super.onStart();
		Debuger.log_w(TAG, "onStart");
	}

	@Override
	public void onResume() {
		super.onResume();
		Debuger.log_w(TAG, "onResume");
	}

	private void setAdapter() {
		if (0x1 == refresh) {
			Debuger.log_w(TAG, "new Adapter");
			adapter = new SquareAdapter(getActivity(), squareHotList, bar);
			pullToRefreshListView.setAdapter(adapter);
		} else {
			Debuger.log_w(TAG, "adapter.notifyDataSetChanged");
			adapter.notifyDataSetChanged();
		}

	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {

		if (0x1 == refresh) {
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

		String verify = Utils.getStrFromShared(getActivity(), Contacts.COOKIE, "shitouren_verify");
		String check = Utils.getStrFromShared(getActivity(), Contacts.COOKIE, "shitouren_check");

		http.addHeader("Cookie", "shitouren_ssid=" + AppManager.getSSID(getActivity()) + ";" + "shitouren_verify="
				+ verify + ";" + "shitouren_check=" + check);
		http.post(Contacts.BASE_URL + Contacts.SQUARE_ATTENTION, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				Debuger.log_w(t);
				// 每次刷新访问参数变化
				curBegin = curLimit + 1;
				curLimit = HttpParamsUtil.incrementLimit(curLimit);
				idx = HttpParamsUtil.incrementIdx(idx);
				// 刷新控件停止
				pullToRefreshListView.setVisibility(View.VISIBLE);
				pullToRefreshListView.onRefreshComplete();
				bar.setVisibility(View.GONE);

				SquareParser parser = new SquareParser();

				try {
					JSONObject jsonObject = new JSONObject(t);
					if (0 == jsonObject.getInt("ret")) {
						String res = jsonObject.optString("res");
						if (!TextUtils.isEmpty(res)&&!"{}".equals(res)&&!"[]".equals(res)) {
							Type type = new TypeToken<List<SquareHot>>() {}.getType();
							Gson gson = new Gson();
							if (0x1 == refresh) {
								squareHotList = gson.fromJson(res, type);
							} else {
								List<SquareHot> lists = new ArrayList<SquareHot>();
								lists = gson.fromJson(res, type);
								squareHotList.addAll(lists);
							}

							if (squareHotList == null || squareHotList.size() == 0) {
								Utils.showNoMessage(stub, "暂无好友");
							}

							setAdapter();
						}else{
							pullToRefreshListView.setVisibility(View.GONE);
							Utils.showNoMessage(view, "暂无好友");
						}
					} else {
						loginPop();
						pullToRefreshListView.setVisibility(View.GONE);
						Utils.showNoMessage(view, "暂无数据");
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				super.onSuccess(t);
			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				// idx是统计并发请求，不管失败成功都要自增1
				idx = HttpParamsUtil.incrementIdx(idx);
				Debuger.log_w("onFailure", strMsg);
				pullToRefreshListView.onRefreshComplete();
				bar.setVisibility(View.GONE);
				Utils.showNoMessage(view, "网络异常");
				super.onFailure(t, errorNo, strMsg);
			}
		});
	}

	@Override
	public void initView() {
		pullToRefreshListView = (PullToRefreshListView) view.findViewById(R.id.listviewAttention);
		pullToRefreshListView.setMode(Mode.BOTH);

		stub = (ViewStub) view.findViewById(R.id.vsNoMessageAttention);

		ILoadingLayout startLabels = pullToRefreshListView.getLoadingLayoutProxy(true, false);
		startLabels.setPullLabel("下拉可以刷新");// 刚下拉时，显示的提示
		startLabels.setRefreshingLabel("正在帮您刷新");// 刷新时
		startLabels.setReleaseLabel("松开立即刷新");// 下来达到一定距离时，显示的提示
		//
		ILoadingLayout endLabels = pullToRefreshListView.getLoadingLayoutProxy(false, true);
		endLabels.setPullLabel("上拉可以加载更多数据");// 刚下拉时，显示的提示
		endLabels.setRefreshingLabel("正在帮您刷新");// 刷新时
		endLabels.setReleaseLabel("松开立即加载更多数据");// 下来达到一定距离时，显示的提示
	}

	@Override
	public void setLisener() {
		// pull-to-refresh第二种方法
		pullToRefreshListView.setOnRefreshListener(new OnRefreshListener2() {

			@Override
			public void onPullDownToRefresh(PullToRefreshBase refreshView) {
				refreshView.getLoadingLayoutProxy().setLastUpdatedLabel("最后更新: " + Utils.getTime());
				refresh = 0x1;
				if (squareHotList.size() > 1) {
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
	}

	PopupWindow popupWindow = null;

	private void loginPop() {
		View view = View.inflate(getActivity(), R.layout.login_need, null);
		LinearLayout all = (LinearLayout) view.findViewById(R.id.llAll);
		LinearLayout cancel = (LinearLayout) view.findViewById(R.id.llCancel);
		LinearLayout login = (LinearLayout) view.findViewById(R.id.llLogin);
		all.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				popupWindow.dismiss();
			}
		});
		cancel.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				popupWindow.dismiss();
			}
		});
		login.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				popupWindow.dismiss();
			}
		});
		if (popupWindow != null && popupWindow.isShowing()) {
			return;
		} else if (popupWindow != null && !popupWindow.isShowing()) {
			// viewShare.startAnimation(AnimationUtils.loadAnimation(context,
			// R.anim.alpha_in));
			// llShare.startAnimation(AnimationUtils.loadAnimation(context,
			// R.anim.pop_up));
			popupWindow.showAtLocation(view, Gravity.CENTER, 0, 0);
		} else {
			popupWindow = new PopupWindow(view, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
			popupWindow.setFocusable(true);
			popupWindow.setOutsideTouchable(true);
			popupWindow.setBackgroundDrawable(new BitmapDrawable());
			// viewShare.startAnimation(AnimationUtils.loadAnimation(context,
			// R.anim.alpha_in));
			// llShare.startAnimation(AnimationUtils.loadAnimation(context,
			// R.anim.pop_up));
			// popupWindow.setAnimationStyle(R.style.popWindowAnim);
			popupWindow.showAtLocation(view, Gravity.CENTER, 0, 0);
			popupWindow.update();
		}
	}

	@Override
	public void parseIntent() {

	}
}
