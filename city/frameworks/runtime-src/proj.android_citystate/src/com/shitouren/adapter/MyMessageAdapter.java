package com.shitouren.adapter;

import java.util.List;

import net.tsz.afinal.FinalBitmap;

import com.shitouren.bean.MyMessage;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.R;
import com.shitouren.utils.Debuger;

import android.content.Context;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class MyMessageAdapter extends BaseAdapter{
	
	private LayoutInflater inflater;
	private List<MyMessage> myMessageList;
	private Context context;
	private FinalBitmap bitmap;

	public MyMessageAdapter(FragmentActivity activity,
			List<MyMessage> myMessageList) {
		// TODO Auto-generated constructor stub
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		this.myMessageList = myMessageList;
		bitmap = FinalBitmap.create(context);
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return myMessageList.size();
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		ViewHolder holder;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = inflater.inflate(R.layout.message_mymessage_item, null);
			//时间
			holder.tv_my_message_time = (TextView) convertView.findViewById(R.id.tv_my_message_time);
			//用户名
			holder.tv_my_message_name = (TextView) convertView.findViewById(R.id.tv_my_message_name);
			//用户消息
			holder.tv_my_message_info = (TextView) convertView.findViewById(R.id.tv_my_message_info);
			//头像
			holder.iv_my_message_head = (ImageView) convertView.findViewById(R.id.iv_my_message_head);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.tv_my_message_name.setText(myMessageList.get(position).getUser().getName());
		return convertView;
	}
	
	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}
	
	static class ViewHolder{
		TextView tv_my_message_time;
		TextView tv_my_message_name;
		TextView tv_my_message_info;
		ImageView iv_my_message_head;
	}

}
