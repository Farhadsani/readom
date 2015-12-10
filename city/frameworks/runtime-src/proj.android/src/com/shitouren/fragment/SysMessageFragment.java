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
import com.shitouren.adapter.SysMessageAdapter;
import com.shitouren.app.AppManager;
import com.shitouren.bean.MyMessage;
import com.shitouren.entity.Contacts;
import com.shitouren.listview.XListView;
import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

public class SysMessageFragment extends BaseFragment {

	private View view;
	private XListView my_listview;
	private ProgressBar my_pbar;
	
	private AjaxParams params;
	private FinalHttp finalhttp;
	private String url = Contacts.BASE_URL+Contacts.MY_MESSAGE;
	
	private List<MyMessage> myMessageList;
	private SysMessageAdapter sysMessageAdapter;
	@Override
	public void initData(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public View initView(LayoutInflater inflater) {
		// TODO Auto-generated method stub
		view = inflater.inflate(R.layout.message_mymessage, null);
		my_listview = (XListView) view.findViewById(R.id.my_listview);
		my_pbar = (ProgressBar) view.findViewById(R.id.my_pbar);
		params = new AjaxParams();
		finalhttp = AppManager.getFinalHttp(getActivity());
		initmymessagedata();
		return inflater.inflate(R.layout.message_sysmessage, null);
	}

	private void initmymessagedata() {
		// TODO Auto-generated method stub
		
	}


}
