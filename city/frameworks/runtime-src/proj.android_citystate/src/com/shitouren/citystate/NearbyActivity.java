package com.shitouren.citystate;

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
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.parser.SquareParser;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewStub;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class NearbyActivity extends Activity implements IActivity {
	private static final String TAG = "NearbyActivity";
	private Context ctx;

	// ////////////////////////View控件和框架类/////////////////////////
	// topBarLayout布局
	private LinearLayout llTopbarLeft;
	private ImageView ivTopbarleft;

	private TextView tvTopbarMiddle;

	private RelativeLayout rlTopBarRight;
	private ImageView ivTopBarRight;
	// topBarLayout布局

	private PullToRefreshListView pullToRefreshListView;
	private ViewStub stub;
	private View view;
	//////////////////////// 数据区域///////////////////////////////////////
	private SquareAdapter adapter;
	private List<SquareHot> squareHotList;
	private int curBegin = 0;
	private int curLimit = 10;
	private int idx = 0;// 自增的参数
	// 0x1是上刷新，0x2是下拉刷新
	private int refresh = 0x1;
	private final int FIRST_LOAD = 0x1;
	///////////////////////// 网络获取/////////////////////////////////////////////
	private AjaxParams params;
	private FinalHttp http;
	////////////////////////// Handler/////////////////////////////////////////////////
	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case FIRST_LOAD:
				adapter = new SquareAdapter(ctx, squareHotList);
				pullToRefreshListView.setAdapter(adapter);
				break;
			}
		};
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ctx = NearbyActivity.this;
		view = LayoutInflater.from(ctx).inflate(R.layout.nearby_activity, null);
		setContentView(view);
		
		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		initView();
		setLisener();
		initTestData();
		initData();

		squareHotList = new ArrayList<SquareHot>();
		pullToRefreshListView.onRefreshComplete();
		pullToRefreshListView.setRefreshing(true);

		Message msg = handler.obtainMessage();
		msg.what = FIRST_LOAD;
		handler.sendMessage(msg);
		// 界面刚启动就开始上拉刷新加载
		if (Utils.isNetworkAvailable(ctx)) {
			initTestData();
		} else {
			Utils.showToastShort(ctx, "没有网络连接!");
			// stub.setVisibility(View.VISIBLE);
			stub.inflate();
			Utils.showNoMessage(view, "没有网络连接");
		}
	}

	//////////////////////////// 继承方法和类///////////////////////////////////////////

	@Override
	public void initView() {
		// topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);

		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);

		rlTopBarRight = (RelativeLayout) findViewById(R.id.rlTopbarRight);
		ivTopBarRight = (ImageView) findViewById(R.id.ivTopbarRight);
		// topBarLayout布局
		initTopBarLayout();

		pullToRefreshListView = (PullToRefreshListView) findViewById(R.id.listviewNearBy);
		pullToRefreshListView.setMode(Mode.BOTH);

		stub = (ViewStub) findViewById(R.id.vsNoMessageNearBy);

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
		http = AppManager.getFinalHttp(ctx);
	}

	@Override
	public void initTestData() {
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

		http.post(Contacts.BASE_URL + Contacts.SQUARE_HOT, params, new AjaxCallBack<String>() {
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
				pullToRefreshListView.onRefreshComplete();

				SquareParser parser = new SquareParser();

				try {
					JSONObject jsonObject = new JSONObject(t);
					if ("ok".endsWith(jsonObject.getString("msg"))) {
						String res = jsonObject.optString("res");
						Type type = new TypeToken<List<SquareHot>>() {
						}.getType();
						Gson gson = new Gson();
						if (0x1 == refresh) {
							squareHotList = gson.fromJson(res, type);
						} else {
							List<SquareHot> lists = new ArrayList<SquareHot>();
							lists = gson.fromJson(res, type);
							squareHotList.addAll(lists);
						}

						if (squareHotList == null || squareHotList.size() == 0) {
							Utils.showNoMessage(stub, "暂无动态");
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
				// idx是统计并发请求，不管失败成功都要自增1
				idx = HttpParamsUtil.incrementIdx(idx);
				Debuger.log_w("onFailure", strMsg);
				pullToRefreshListView.onRefreshComplete();
				Utils.showNoMessage(stub, "网络异常");
				super.onFailure(t, errorNo, strMsg);
			}
		});
	}

	@Override
	public void initData() {

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
				if (Utils.isNetworkAvailable(ctx)) {
					Debuger.log_w(TAG, "excute on PullDown");
					initTestData();
				} else {
					Utils.showToastShort(ctx, "没有网络连接!");
					pullToRefreshListView.onRefreshComplete();
				}
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase refreshView) {
				refresh = 0x2;
				if (Utils.isNetworkAvailable(ctx)) {
					initTestData();
				} else {
					Utils.showToastShort(ctx, "没有网络连接!");
					pullToRefreshListView.onRefreshComplete();
				}
			}
		});
		
		llTopbarLeft.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				NearbyActivity.this.finish();
			}
		});
	}

	@Override
	public void parseIntent() {

	}

	/////////////////////////////// 成员方法////////////////////////////////////////////

	private void setAdapter() {
		if (0x1 == refresh) {
			Debuger.log_w(TAG, "new Adapter");
			adapter = new SquareAdapter(ctx, squareHotList);
			pullToRefreshListView.setAdapter(adapter);
		} else {
			Debuger.log_w(TAG, "adapter.notifyDataSetChanged");
			adapter.notifyDataSetChanged();
		}

	}

	private void initTopBarLayout() {
		ivTopbarleft.setVisibility(View.VISIBLE);
		ivTopbarleft.setImageResource(R.drawable.xiangyoubaise);

		tvTopbarMiddle.setText(getResources().getString(R.string.nearbyTitle));

	}

}
