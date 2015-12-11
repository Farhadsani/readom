package com.shitouren.adapter;

import java.io.Serializable;
import java.util.List;

import com.shitouren.citystate.ImageDetailActivity;
import com.shitouren.citystate.R;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import net.tsz.afinal.FinalBitmap;

public class ImageAdapter extends BaseAdapter {
	private List<String> views ;
	private LayoutInflater inflater;
	private FinalBitmap bitmap = null;
	private Context context;

	public ImageAdapter(List<String> views,Context context) {
		this.views = views;
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		bitmap = FinalBitmap.create(context);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = inflater.inflate(R.layout.gallery_image_item, null);
			viewHolder.iv = (ImageView) convertView.findViewById(R.id.imgGyItem);
		}else{
			viewHolder = (ViewHolder) convertView.getTag();
		}
		
		viewHolder.iv.setScaleType(ImageView.ScaleType.FIT_XY);
		
		
//		convertView.setOnClickListener(new OnClickListener() {
//			
//			@Override
//			public void onClick(View v) {
//				Debuger.log_w("xyz:", "convertView.setOnClickListener");
//				Intent intent = new Intent(context,ImageDetailActivity.class);
//				intent.putExtra("links", (Serializable)views);
//				context.startActivity(intent);
//			}
//		});
		
		if(views.size()>0){
			bitmap.display(viewHolder.iv, views.get(position),Utils.windowXY(context)[0],Utils.dip2px(context, 220));
		}
		
//		if(!TextUtils.isEmpty(data.get(position).getImg())){
//			bitmap.display(iv, data.get(position).getImg(),DensityUtil.dip2px(context, 180),DensityUtil.dip2px(context, 120),bs,bs);
//		}else{
//			iv.setBackgroundResource(R.drawable.local_car);
//		}
		return convertView;
	}

	@Override
	public int getCount() {
		return views.size();
	}

	@Override
	public Object getItem(int position) {
		return position;

	}

	@Override
	public long getItemId(int position) {
		return position;
	}
	
	class ViewHolder{
		ImageView iv;
	}
}
