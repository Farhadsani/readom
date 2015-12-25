package com.shitouren.adapter;

import java.io.Serializable;
import java.util.List;

import com.shitouren.bean.IndexIntroduction;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.ImageDetailActivity;
import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;
import com.shitouren.view.AlignTextView;
import com.shitouren.view.AlignTextView.Align;
import com.shitouren.view.CircularImage;
import com.shitouren.view.MyGallery;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import net.tsz.afinal.FinalBitmap;

public class IndexIntroductionAdapter extends BaseAdapter {

	private LayoutInflater inflater;
	private List<IndexIntroduction> list;
	private Context context;

	public IndexIntroductionAdapter(Context context, List<IndexIntroduction> list) {
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		this.list = list;
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {

		return position;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		final ViewHolder holder;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = inflater.inflate(R.layout.index_introduction_item, null);
			
			holder.ivTag = (ImageView) convertView.findViewById(R.id.ivTagIndexIntroduction);
			holder.tvTag = (TextView) convertView.findViewById(R.id.tvTagIndexIntroduction);
			holder.tvTagContent = (AlignTextView) convertView.findViewById(R.id.tvTagContentIndexIntroduction);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		
		if(1 == holder.tvTagContent.getLineCount()){
			holder.tvTagContent.setAlign(Align.ALIGN_RIGHT);
		}else{
			holder.tvTagContent.setAlign(Align.ALIGN_LEFT);
		}
		

		return convertView;
	}

	class ViewHolder {
		ImageView ivTag;
		TextView tvTag;
		AlignTextView tvTagContent;
	}

}
