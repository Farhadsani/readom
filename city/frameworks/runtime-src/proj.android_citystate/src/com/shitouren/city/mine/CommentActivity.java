package com.shitouren.city.mine;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.shitouren.adapter.CommentAdapter;
import com.shitouren.adapter.SquareAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.bean.Comment;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.parser.SquareParser;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class CommentActivity extends Activity implements IActivity {
	private static final String TAG = "CommentActivity";
	// topBarLayout布局
	private LinearLayout llTopbarLeft;
	private ImageView ivTopbarleft;

	private TextView tvTopbarMiddle;
	// topBarLayout布局

	// progressBar
	private ProgressBar bar;

	private PullToRefreshListView pullToRefreshListView;
	private CommentAdapter adapter;
	private List<Comment> squareHotList;

	private AjaxParams params;
	private FinalHttp http;

	// 数据区
	private int curBegin = 0;
	private int curLimit = 5;
	private int idx = 0;// 自增的参数
	private int feedid;

	// 0x1是上刷新，0x2是下拉刷新
	private int refresh = 0x1;

	private final int FIRST_LOAD = 0x1;
	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case FIRST_LOAD:
				adapter = new CommentAdapter(squareHotList, CommentActivity.this);
				pullToRefreshListView.setAdapter(adapter);
				break;
			}
		};
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.comment_activity);

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		initView();

		params = new AjaxParams();
		http = AppManager.getFinalHttp(getApplicationContext());

		setLisener();

		feedid = getIntent().getIntExtra("feedid", 0);

		// 为了实现页面刚进来上拉刷新加载，必须为adapter开始初始化数据，listview.setAdapter才行
		squareHotList = new ArrayList<Comment>();
		pullToRefreshListView.onRefreshComplete();
		pullToRefreshListView.setRefreshing(true);

		Message msg = handler.obtainMessage();
		msg.what = FIRST_LOAD;
		handler.sendMessage(msg);
		// 界面刚启动就开始上拉刷新加载
		if (Utils.isNetworkAvailable(getApplicationContext())) {
			initData();
		} else {
			Utils.showToastShort(getApplicationContext(), "没有网络连接!");
			// stub.setVisibility(View.VISIBLE);
			// stub.inflate();
			// Utils.showNoMessage(view, "没有网络连接");
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
		map1.put("feedid", feedid);
		map1.put("begin", curBegin);
		map1.put("limit", curLimit);
		JSONObject jsonObject = new JSONObject(map1);
		map.put("idx", idx);
		map.put("ver", "1.0.0");
		map.put("params", jsonObject);
		JSONObject object = new JSONObject(map);

		params.put("postData", object.toString());

		http.post(Contacts.BASE_URL + Contacts.COMMENT_LIST, params, new AjaxCallBack<String>() {
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
				bar.setVisibility(View.GONE);

				SquareParser parser = new SquareParser();

				try {
					JSONObject jsonObject = new JSONObject(t);
					if (0 == jsonObject.getInt("ret")) {
						String res = jsonObject.optString("res");
						if (!"{}".equals(res) && !"[]".equals(res)) {
							Type type = new TypeToken<List<Comment>>() {
							}.getType();
							Gson gson = new Gson();
							if (0x1 == refresh) {
								squareHotList = gson.fromJson(res, type);
							} else {
								List<Comment> lists = new ArrayList<Comment>();
								lists = gson.fromJson(res, type);
								squareHotList.addAll(lists);
							}

							if (squareHotList == null || squareHotList.size() == 0) {
								// Utils.showNoMessage(stub, "暂无动态");
							}

							setAdapter();
						}

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
				// Utils.showNoMessage(stub, "网络异常");
				super.onFailure(t, errorNo, strMsg);
			}
		});
	}

	private void setAdapter() {
		if (0x1 == refresh) {
			Debuger.log_w(TAG, "new Adapter");
			adapter = new CommentAdapter(squareHotList, this);
			pullToRefreshListView.setAdapter(adapter);
		} else {
			Debuger.log_w(TAG, "adapter.notifyDataSetChanged");
			adapter.notifyDataSetChanged();
		}

	}

	@Override
	public void initView() {
		// topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);

		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		// topBarLayout布局
		initTopBarLayout();

		// progressBar
		bar = (ProgressBar) findViewById(R.id.progressBar);

		pullToRefreshListView = (PullToRefreshListView) findViewById(R.id.listviewComment);
	}

	@Override
	public void setLisener() {

	}

	@Override
	public void parseIntent() {

	}

	private void initTopBarLayout() {
		tvTopbarMiddle.setText(getResources().getString(R.string.commentTitle));

		ivTopbarleft.setImageResource(R.drawable.xiangyoubaise);
		llTopbarLeft.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				CommentActivity.this.finish();
			}
		});
	}

}
