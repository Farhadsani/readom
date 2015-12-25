package com.shitouren.adapter;

import java.util.List;

import com.shitouren.bean.Comment;
import com.shitouren.citystate.R;
import com.shitouren.view.CircularImage;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import net.tsz.afinal.FinalBitmap;

public class CommentAdapter extends BaseAdapter {
	private List<Comment> comments ;
	private LayoutInflater inflater;
	private FinalBitmap bitmap = null;
	private Context context;

	public CommentAdapter(List<Comment> comments,Context context) {
		this.comments = comments;
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		bitmap = FinalBitmap.create(context);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = inflater.inflate(R.layout.comment_item, null);
			viewHolder.iv = (CircularImage) convertView.findViewById(R.id.ivCommentHead);
			viewHolder.tvTitle = (TextView) convertView.findViewById(R.id.tvTitle);
			viewHolder.tvTime = (TextView) convertView.findViewById(R.id.tvTime);
			viewHolder.tvContent = (TextView) convertView.findViewById(R.id.tvContent);
			
			convertView.setTag(viewHolder);
		}else{
			viewHolder = (ViewHolder) convertView.getTag();
		}
		
		
		bitmap.display(viewHolder.iv, comments.get(position).getUser().getImglink());
		
		viewHolder.tvTitle.setText(comments.get(position).getUser().getIntro());
		viewHolder.tvTime.setText(comments.get(position).getCtime());
		viewHolder.tvContent.setText(comments.get(position).getComment());
		
		return convertView;
	}

	@Override
	public int getCount() {
		return comments.size();
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
		CircularImage iv;
		TextView tvTitle;
		TextView tvTime;
		TextView tvContent;
		
	}
}
