package com.shitouren.fragment;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.adapter.IndexSocialAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.bean.IndexSocial;
import com.shitouren.bean.TagBean;
import com.shitouren.city.mine.MoreActivity;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.tagview.Tag;
import com.shitouren.tagview.TagListView;
import com.shitouren.utils.ActivityUtils;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.ProgressBar;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class IndexConsumFragment extends Fragment implements IActivity {
	private static final String TAG = "IndexConsumFragment";

	private Context ctx;

	private AjaxParams params;
	private FinalHttp http;

	private GridView gridView;
	private ProgressBar bar;

	private List<IndexSocial> socialLists;
	List<IndexSocial> majorLists;
	private List<IndexSocial> noneMajorLists;
	private IndexSocialAdapter adapter;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.index_consum_fragment, null);
		ctx = getActivity();

		params = new AjaxParams();
		http = AppManager.getFinalHttp(ctx);

		gridView = (GridView) view.findViewById(R.id.gvIndexConsum);
		bar = (ProgressBar) view.findViewById(R.id.progressBar);
		
		majorLists = new ArrayList<IndexSocial>();
		noneMajorLists = new ArrayList<IndexSocial>();

		socialLists = new ArrayList<IndexSocial>();
		IndexSocial indexSocial = new IndexSocial();
		indexSocial.setName("默认");
		indexSocial.setCname("Default");
		indexSocial.setImglink("1");
		indexSocial.setMajor(1);
		majorLists.add(indexSocial);

		params = HttpParamsUtil.getParams(ctx, params, 0, null);
		initData();
		setLisener();
		return view;
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {
		Debuger.log_w(TAG, "params:" + params.getParamString());
		http.post(Contacts.BASE_URL + Contacts.CONSUM_INDEX, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				super.onSuccess(t);
				Debuger.log_w(TAG, t);
				bar.setVisibility(View.GONE);
				JSONObject jsonObject;
				try {
					jsonObject = new JSONObject(t);
					if ("ok".equals(jsonObject.getString("msg"))) {
						String res = jsonObject.optString("res");
						Type type = new TypeToken<List<IndexSocial>>() {
						}.getType();
						Gson gson = new Gson();
						List<IndexSocial> lists = gson.fromJson(res, type);
						socialLists.addAll(lists);

						for (int i = 0; i < lists.size(); i++) {
							if (1 == lists.get(i).getMajor()) {
								majorLists.add(lists.get(i));
							}else{
								noneMajorLists.add(lists.get(i));
							}
						}

						IndexSocial indexSocial = new IndexSocial();
						indexSocial.setName("更多");
						indexSocial.setCname("More");
						indexSocial.setImglink("2");
						indexSocial.setMajor(1);
						majorLists.add(indexSocial);

						adapter = new IndexSocialAdapter(ctx, majorLists, true);
						gridView.setAdapter(adapter);

					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				super.onFailure(t, errorNo, strMsg);
				bar.setVisibility(View.GONE);
			}
		});
	}

	@Override
	public void initView() {

	}

	@Override
	public void setLisener() {
		gridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				if(position == (majorLists.size()-1)){
					Intent intent = new Intent(getActivity(),MoreActivity.class);
					intent.putExtra("list", (Serializable)noneMajorLists);
					startActivity(intent);
				}
			}
		});
	}

	@Override
	public void parseIntent() {

	}
}
