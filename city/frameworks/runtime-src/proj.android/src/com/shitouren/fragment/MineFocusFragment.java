package com.shitouren.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

public class MineFocusFragment extends BaseFragment {

	@Override
	public View initView(LayoutInflater inflater) {
		// TODO Auto-generated method stub
		TextView textView = new TextView(getActivity());
		textView.setText("好友关注");
		return textView;
	}

	@Override
	public void initData(Bundle savedInstanceState) {
		// TODO Auto-generated method stub

	}

}
