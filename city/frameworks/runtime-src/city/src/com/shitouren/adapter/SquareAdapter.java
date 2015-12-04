package com.shitouren.adapter;

import java.util.List;

import com.shitouren.bean.SquareHot;
import com.shitouren.city.R;
import com.shitouren.view.CircularImage;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import net.tsz.afinal.FinalBitmap;

public class SquareAdapter extends BaseAdapter{

	private LayoutInflater inflater;
	private List<SquareHot> list;
	private Context context;
	private FinalBitmap bitmap;
	
	public SquareAdapter(Context context,List<SquareHot> list) {
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
	public View getView(int position, View convertView, ViewGroup parent) {
		final ViewHolder holder;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = inflater.inflate(R.layout.square_listview_item, null);
			//广场热门区域列表用户区域
			holder.rlUser = (RelativeLayout) convertView.findViewById(R.id.rlUserSquare);
			holder.imgHead = (CircularImage) convertView.findViewById(R.id.imgPersonSquare);
			holder.tvName = (TextView) convertView.findViewById(R.id.tvNameSquare);
			holder.tvTime = (TextView) convertView.findViewById(R.id.tvTimeSquare);
			//图片区域
			holder.rlPic = (RelativeLayout) convertView.findViewById(R.id.rlPicSquare);
			holder.tvTag = (TextView) convertView.findViewById(R.id.tvTagTextSquare);
			holder.tvCurPicIndex = (TextView) convertView.findViewById(R.id.tvCurPicNum);
			holder.tvPicSum = (TextView) convertView.findViewById(R.id.tvSumPicNum);
			//内容
			holder.tvContent = (TextView) convertView.findViewById(R.id.tvContentSquare);
			//定位
			holder.tvLocation = (TextView) convertView.findViewById(R.id.tvLocationSquare);
			//赞
			holder.llZan = (LinearLayout) convertView.findViewById(R.id.llZan);
			holder.imgZan  = (ImageView) convertView.findViewById(R.id.imgZanPic);
			holder.tvZan = (TextView) convertView.findViewById(R.id.tvZanNum);
			//评论
			holder.llComment = (LinearLayout) convertView.findViewById(R.id.llComment);
			holder.imgCmt  = (ImageView) convertView.findViewById(R.id.imgCmtPic);
			holder.tvCmt = (TextView) convertView.findViewById(R.id.tvCmtNum);
			//更多
			holder.llMore = (LinearLayout) convertView.findViewById(R.id.llMoreSquare);
			holder.imgMore = (ImageView) convertView.findViewById(R.id.imgMoreSquare);
			convertView.setTag(holder);
		}else{
			holder = (ViewHolder) convertView.getTag();
		}
		
		bitmap.display(holder.imgHead, list.get(position).getUser().getImglink(), R.drawable.tou,R.drawable.tou);
		
		holder.tvName.setText(list.get(position).getUser().getName());
		holder.tvTime.setText(list.get(position).getCtime());
		
		if(list.get(position).getImglink().size()>0){
			bitmap.display(holder.rlPic, list.get(position).getImglink().get(0));
			StringBuilder builder = new StringBuilder();
			for(String s: list.get(position).getTags()){
				builder.append(s);
				builder.append(" ");
			}
			holder.tvTag.setText(builder.toString());
			
			holder.tvCurPicIndex.setText("1");
			holder.tvPicSum.setText(list.get(position).getImglink().size()+"");
		}
		
		holder.tvContent.setText(list.get(position).getContent());
		
		if(list.get(position).getPlace().size()>0){
			holder.tvLocation.setText(list.get(position).getPlace().get(0));
		}
		
		if(0!=list.get(position).getLiked()){
			holder.imgZan.setImageResource(R.drawable.zan_selected);
		}else{
			holder.imgZan.setImageResource(R.drawable.zan_normal);
		}
		
		holder.tvZan.setText(list.get(position).getLikecount()+"");
		
		if(0!=list.get(position).getCommented()){
			holder.imgCmt.setImageResource(R.drawable.comment_selected);
		}else{
			holder.imgCmt.setImageResource(R.drawable.comment_normal);
		}
		
		holder.tvCmt.setText(list.get(position).getCommentscount()+"");
		
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
		return convertView;
	}
	
	class ViewHolder{
		RelativeLayout rlUser;
		CircularImage imgHead;
		TextView tvName;
		TextView tvTime;
		
		RelativeLayout rlPic;
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
