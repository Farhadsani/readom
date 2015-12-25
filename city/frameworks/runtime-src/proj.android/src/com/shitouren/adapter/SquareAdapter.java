package com.shitouren.adapter;

import java.io.Serializable;
import java.util.List;

import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.ImageDetailActivity;
import com.shitouren.utils.Debuger;
import com.shitouren.qmap.R;
import com.shitouren.utils.Utils;
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

public class SquareAdapter extends BaseAdapter {

	private LayoutInflater inflater;
	private List<SquareHot> list;
	private Context context;
	private FinalBitmap bitmap;

	public SquareAdapter(Context context, List<SquareHot> list) {
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		this.list = list;
		bitmap = FinalBitmap.create(context);
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
			convertView = inflater.inflate(R.layout.square_listview_item, null);
			// 广场热门区域列表用户区域
			holder.rlUser = (LinearLayout) convertView.findViewById(R.id.rlUserSquare);
			holder.imgHead = (CircularImage) convertView.findViewById(R.id.imgPersonSquare);
			holder.tvName = (TextView) convertView.findViewById(R.id.tvNameSquare);
			holder.tvTime = (TextView) convertView.findViewById(R.id.tvTimeSquare);
			// 图片区域
			holder.rlPic = (RelativeLayout) convertView.findViewById(R.id.rlPicSquare);
			holder.gyPic = (MyGallery) convertView.findViewById(R.id.gySquareHot);
			holder.tvTag = (TextView) convertView.findViewById(R.id.tvTagTextSquare);
			holder.tvCurPicIndex = (TextView) convertView.findViewById(R.id.tvCurPicNum);
			holder.tvPicSum = (TextView) convertView.findViewById(R.id.tvSumPicNum);
			// 内容
			holder.tvContent = (TextView) convertView.findViewById(R.id.tvContentSquare);
			// 定位
			holder.tvLocation = (TextView) convertView.findViewById(R.id.tvLocationSquare);
			// 赞
			holder.llZan = (LinearLayout) convertView.findViewById(R.id.llZan);
			holder.imgZan = (ImageView) convertView.findViewById(R.id.imgZanPic);
			holder.tvZan = (TextView) convertView.findViewById(R.id.tvZanNum);
			// 评论
			holder.llComment = (LinearLayout) convertView.findViewById(R.id.llComment);
			holder.imgCmt = (ImageView) convertView.findViewById(R.id.imgCmtPic);
			holder.tvCmt = (TextView) convertView.findViewById(R.id.tvCmtNum);
			// 更多
			holder.llMore = (LinearLayout) convertView.findViewById(R.id.llMoreSquare);
			holder.imgMore = (ImageView) convertView.findViewById(R.id.imgMoreSquare);
			
			holder.gyPic.setOnItemSelectedListener(new OnItemSelectedListener() {

				@Override
				public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
					Debuger.log_w("xyz:", "onItemSelected");
					holder.tvCurPicIndex.setText(position+1+"");
				}

				@Override
				public void onNothingSelected(AdapterView<?> parent) {
					Debuger.log_w("xyz:", "onNothingSelected");
				}
			});
			
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.llMore.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Utils.pop_Input(context,3);
			}
		});
		
		holder.gyPic.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int arg0, long id) {
				Debuger.log_w("setOnItemClickListener:", "position:"+position);
				
				Intent intent = new Intent(context,ImageDetailActivity.class);
				intent.putExtra("links", (Serializable)list.get(position).getImglink());
				intent.putExtra("id", arg0);
				context.startActivity(intent);
			}
		});
		
		if ((1 == list.size()) && !list.get(position).isLoad()) {

		} else {
			bitmap.display(holder.imgHead, list.get(position).getUser().getImglink(), R.drawable.tou, R.drawable.tou);

			holder.tvName.setText(list.get(position).getUser().getName());
			holder.tvTime.setText(list.get(position).getCtime());

			if (list.get(position).getImglink().size() > 0) {
				holder.rlPic.setVisibility(View.VISIBLE);
				
				ImageAdapter adapter = new ImageAdapter(list.get(position).getImglink(),context);
				holder.gyPic.setAdapter(adapter);
				StringBuilder builder = new StringBuilder();
				for (String s : list.get(position).getTags()) {
					builder.append(s);
					builder.append(" ");
				}
				if(holder.tvTag == null || builder == null){
					Debuger.log_w("holder.tvTag|builder is null");
				}else{
					holder.tvTag.setText(builder.toString());
				}
				

				holder.tvCurPicIndex.setText("1");
				holder.tvPicSum.setText(list.get(position).getImglink().size() + "");
			} else {
				holder.rlPic.setVisibility(View.GONE);
			}
			
			holder.tvContent.setText(list.get(position).getContent());

			if (list.get(position).getPlace().size() > 0) {
				holder.tvLocation.setText(list.get(position).getPlace().get(0));
			}

			if (0 != list.get(position).getLiked()) {
				holder.imgZan.setImageResource(R.drawable.zan_selected);
			} else {
				holder.imgZan.setImageResource(R.drawable.zan_normal);
			}

			holder.tvZan.setText(list.get(position).getLikecount() + "");

			if (0 != list.get(position).getCommented()) {
				holder.imgCmt.setImageResource(R.drawable.comment_selected);
			} else {
				holder.imgCmt.setImageResource(R.drawable.comment_normal);
			}

			holder.tvCmt.setText(list.get(position).getCommentscount() + "");

			switch (list.get(position).getUser().getType()) {
			case 0:

				break;
			case 1:

				break;
			case 2:

				break;
			case 3:

				break;
			case -1:
				holder.imgMore.setImageResource(R.drawable.more_normal);
				break;
			}
		}

		return convertView;
	}

	class ViewHolder {
		LinearLayout rlUser;
		CircularImage imgHead;
		TextView tvName;
		TextView tvTime;

		RelativeLayout rlPic;
		MyGallery gyPic;
		TextView tvTag;
		TextView tvCurPicIndex;
		TextView tvPicSum;

		TextView tvContent;

		TextView tvLocation;

		LinearLayout llZan;
		ImageView imgZan;
		TextView tvZan;

		LinearLayout llComment;
		ImageView imgCmt;
		TextView tvCmt;

		LinearLayout llMore;
		ImageView imgMore;
	}

}
