package com.shitouren.city.mine;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

import com.shitouren.bean.IndexSocial;
import com.shitouren.citystate.IndexSocialActivity;
import com.shitouren.citystate.R;
import com.shitouren.inter.IActivity;
import com.shitouren.utils.Debuger;
import com.shitouren.view.expandgridview.StickyGridHeadersBaseAdapter;
import com.shitouren.view.expandgridview.StickyGridHeadersGridView;
import com.shitouren.view.expandgridview.StickyGridHeadersSimpleAdapter;

import android.app.Activity;
import android.database.DataSetObserver;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MoreActivity extends Activity implements IActivity {
	private static final String TAG = "MoreActivity";

	// topBarLayout布局
	private LinearLayout llTopbarLeft;
	private ImageView ivTopbarleft;

	private TextView tvTopbarMiddle;
	// topBarLayout布局

	private StickyGridHeadersGridView gv;
	private List<IndexSocial> lists;

	private Map<String, String> titleMap;
	private List<String> titleList;
	private List<Integer> contentCountList;

	MyAdapter adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.more_activity);

		if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}

		gv = (StickyGridHeadersGridView) findViewById(R.id.gvMoreActivity);

		// topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);

		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		// topBarLayout布局
		initTopBarLayout();

		lists = (List<IndexSocial>) getIntent().getSerializableExtra("list");

		if (lists != null && lists.size() > 0) {
			Debuger.log_w(TAG, "lists is not null" + lists.size());
			for (int i = 0; i < lists.size(); i++) {
				Debuger.log_w(TAG, "lists:" + lists.get(i).getCname());
			}
		} else {
			Debuger.log_w(TAG, "lists is null");
		}
//		titleMap = new HashMap<String, String>();
//		titleList = new ArrayList<String>();
//		contentCountList = new ArrayList<Integer>();
//		// for (int i = 0; i < lists.size(); i++) {
//		// titleMap.put(lists.get(i).getType(), lists.get(i).getType());
//		// }
//		// for (String str : titleMap.keySet()) {
//		// titleList.add(str);
//		// }
//		for (int i = 0; i < contentCountList.size(); i++) {
//			Debuger.log_w("contentCountList", contentCountList.get(i) + "");
//		}
//		for (int i = 0; i < titleList.size(); i++) {
//			Debuger.log_w("titleList", titleList.get(i));
//		}
//		for (String str : titleMap.keySet()) {
//			Debuger.log_w("titleMap", str);
//		}
//		Debuger.log_w(TAG, "sss:" + titleMap.size() + ":" + titleList.size() + ":" + contentCountList.size());
//		initData();

		lists = generateHeaderId(lists);

		adapter = new MyAdapter();

		gv.setAdapter(adapter);
	}

	private void initTopBarLayout() {
		tvTopbarMiddle.setText(getResources().getString(R.string.moreTitle));

		ivTopbarleft.setImageResource(R.drawable.xiangyoubaise);
		llTopbarLeft.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				MoreActivity.this.finish();
			}
		});
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {

	}

	@Override
	public void initView() {

	}

	@Override
	public void setLisener() {

	}

	@Override
	public void parseIntent() {

	}

	// 获取统计的方法
	public void getCount(List<IndexSocial> list) {
		Map map = new TreeMap();
		for (int i = 0; i < list.size(); i++) {
			Integer value = (Integer) map.get(list.get(i).getType());
			int count = 1;
			if (value != null) {
				count = value + 1;
			}
			map.put(list.get(i).getType(), count);
		}

		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Entry en = (Entry) it.next();
			String str = (String) en.getKey();
			int value = (Integer) en.getValue();
			contentCountList.add(value);
			titleList.add(str);
		}

	}

	private List<IndexSocial> generateHeaderId(List<IndexSocial> nonHeaderIdList) {
		Map<String, Integer> mHeaderIdMap = new HashMap<String, Integer>();
		int mHeaderId = 1;
		List<IndexSocial> hasHeaderIdList;

		for (ListIterator<IndexSocial> it = nonHeaderIdList.listIterator(); it.hasNext();) {
			IndexSocial indexSocial = it.next();
			String type = indexSocial.getType();
			if (!mHeaderIdMap.containsKey(type)) {
				indexSocial.setHeaderid(mHeaderId);
				mHeaderIdMap.put(type, mHeaderId);
				mHeaderId++;
			} else {
				indexSocial.setHeaderid(mHeaderIdMap.get(type));
			}
		}
		hasHeaderIdList = nonHeaderIdList;

		return hasHeaderIdList;
	}

	class MyAdapter extends BaseAdapter implements StickyGridHeadersSimpleAdapter {
		public MyAdapter() {
		}

		@Override
		public int getCount() {
			return lists.size();
		}

		@Override
		public Object getItem(int position) {
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = LayoutInflater.from(MoreActivity.this).inflate(R.layout.more_item, null);
				holder.tvText = (TextView) convertView.findViewById(R.id.tvText);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}

			Debuger.log_w(TAG, position + "");
			holder.tvText.setText(lists.get(position).getCname());

			return convertView;
		}

		@Override
		public long getHeaderId(int position) {
			return lists.get(position).getHeaderid();
		}

		@Override
		public View getHeaderView(int position, View convertView, ViewGroup parent) {
			HeaderViewHolder holder;
			if (convertView == null) {
				holder = new HeaderViewHolder();
				convertView = LayoutInflater.from(MoreActivity.this).inflate(R.layout.more_title_item, parent,false);
				holder.tvTitle = (TextView) convertView.findViewById(R.id.tvTitleMore);
				convertView.setTag(holder);
			} else {
				holder = (HeaderViewHolder) convertView.getTag();
			}

			Debuger.log_w(TAG, position + "");
			holder.tvTitle.setText(lists.get(position).getType());

			return convertView;
		}

		class ViewHolder {
			TextView tvText;
		}
		
		class HeaderViewHolder {
			TextView tvTitle;
		}

	}

}
