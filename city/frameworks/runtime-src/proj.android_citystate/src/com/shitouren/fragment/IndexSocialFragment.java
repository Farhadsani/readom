package com.shitouren.fragment;

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
import com.shitouren.bean.SquareHot;
import com.shitouren.bean.TagBean;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.inter.IActivity;
import com.shitouren.tagview.Tag;
import com.shitouren.tagview.TagListView;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.widget.GridView;
import android.widget.ProgressBar;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class IndexSocialFragment extends Fragment implements IActivity {
	private static final String TAG = "IndexSocialFragment";

	private Context ctx;

	private AjaxParams params;
	private FinalHttp http;

	private GridView gridView;
	private TagListView tagListView;
	private ViewStub stub;
	private ProgressBar bar;

	private List<Tag> tagLists;
	private List<TagBean> tagBeanLists;

	private List<IndexSocial> socialLists;
	private IndexSocialAdapter adapter;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.index_social_fragment, null);
		ctx = getActivity();

		params = new AjaxParams();
		http = AppManager.getFinalHttp(ctx);

		gridView = (GridView) view.findViewById(R.id.gvIndexSocial);
		tagListView = (TagListView) view.findViewById(R.id.tagIndexSocial);
		stub = (ViewStub) view.findViewById(R.id.vsNoMessageIndexSocial);
		bar = (ProgressBar) view.findViewById(R.id.progressBar);

		socialLists = new ArrayList<IndexSocial>();
		IndexSocial indexSocial = new IndexSocial();
		indexSocial.setName("默认");
		indexSocial.setCname("Default");
		socialLists.add(indexSocial);
		
		tagLists = new ArrayList<Tag>();

		params = HttpParamsUtil.getParams(ctx, params, 0, null);
		initData();
		initTag();
		return view;
	}

	@Override
	public void initTestData() {

	}

	@Override
	public void initData() {
		Debuger.log_w(TAG, "params:" + params.getParamString());
		http.post(Contacts.BASE_URL + Contacts.SOCIAL_INDEX, params, new AjaxCallBack<String>() {
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
						if (socialLists == null || socialLists.size() == 0) {
							Utils.showNoMessage(stub, "暂无动态");
						}

						adapter = new IndexSocialAdapter(ctx, socialLists,false);
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

	private void initTag() {
		Debuger.log_w(TAG, "params:" + params.getParamString());
		http.post(Contacts.BASE_URL + Contacts.SOCIAL_INDEX_TAG, params, new AjaxCallBack<String>() {
			@Override
			public void onStart() {
				super.onStart();
			}

			@Override
			public void onSuccess(String t) {
				super.onSuccess(t);
				Debuger.log_w(TAG, t);
				JSONObject jsonObject;
				try {
					jsonObject = new JSONObject(t);
					if ("ok".equals(jsonObject.getString("msg"))) {
						String res = jsonObject.optString("res");
						Type type = new TypeToken<List<TagBean>>() {
						}.getType();
						Gson gson = new Gson();
						tagBeanLists = gson.fromJson(res, type);

						for(int i=0;i<tagBeanLists.size();i++){
							Tag tag = new Tag();
							tag.setTitle(tagBeanLists.get(i).getName());
							tagLists.add(tag);
						}
						
						tagListView.setTags(tagLists,true);
					}
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

	@Override
	public void initView() {

	}

	@Override
	public void setLisener() {

	}

	@Override
	public void parseIntent() {

	}
}
