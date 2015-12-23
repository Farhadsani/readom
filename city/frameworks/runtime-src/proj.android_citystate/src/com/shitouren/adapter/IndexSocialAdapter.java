package com.shitouren.adapter;

import java.io.Serializable;
import java.util.List;

import com.shitouren.bean.IndexIntroduction;
import com.shitouren.bean.IndexSocial;
import com.shitouren.bean.SquareHot;
import com.shitouren.citystate.ImageDetailActivity;
import com.shitouren.citystate.R;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;
import com.shitouren.view.AlignTextView;
import com.shitouren.view.AlignTextView.Align;
import com.shitouren.view.CircularImage;
import com.shitouren.view.MyGallery;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.text.TextUtils;
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

public class IndexSocialAdapter extends BaseAdapter {

	private LayoutInflater inflater;
	private List<IndexSocial> list;
	private Context context;
	private FinalBitmap bitmap;
	private Bitmap bp;
	private boolean flag = false;

	public IndexSocialAdapter(Context context, List<IndexSocial> list, boolean flag) {
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		this.list = list;
		bitmap = FinalBitmap.create(context);
		bp = BitmapFactory.decodeResource(context.getResources(), R.drawable.default_);
		this.flag = flag;
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
			convertView = inflater.inflate(R.layout.index_social_item, null);

			holder.ivTag = (ImageView) convertView.findViewById(R.id.ivIndexSocialItem);
			holder.tvTitle = (TextView) convertView.findViewById(R.id.tvTitleIndexSocialItem);
			holder.tvContent = (TextView) convertView.findViewById(R.id.tvContentIndexSocialItem);
			holder.viewSelector = convertView.findViewById(R.id.viewSelector);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		if (position % 2 != 0) {
			holder.viewSelector.setVisibility(View.GONE);
		}
		if (flag) {
			if (1 == list.get(position).getMajor()) {
				if (!TextUtils.isEmpty(list.get(position).getImglink())) {
					if("1".equals(list.get(position).getImglink())){
						holder.ivTag.setImageBitmap(bp);
					}else if("2".equals(list.get(position).getImglink())){
						holder.ivTag.setImageBitmap(bp);
					}else{
						bitmap.display(holder.ivTag, list.get(position).getImglink());
					}
				} else {
					holder.ivTag.setImageBitmap(bp);
				}
			}
			holder.tvTitle.setText(list.get(position).getCname());
			holder.tvContent.setText(list.get(position).getName());
		} else {
			if (!TextUtils.isEmpty(list.get(position).getImglink())) {
				bitmap.display(holder.ivTag, list.get(position).getImglink());
			} else {
				holder.ivTag.setImageBitmap(bp);
			}
			holder.tvTitle.setText(list.get(position).getName());
			holder.tvContent.setText(list.get(position).getCname());
		}

		return convertView;
	}

	class ViewHolder {
		ImageView ivTag;
		TextView tvTitle;
		TextView tvContent;
		View viewSelector;
	}

}
