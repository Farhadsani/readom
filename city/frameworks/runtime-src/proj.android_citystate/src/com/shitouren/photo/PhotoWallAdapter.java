package com.shitouren.photo;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.graphics.Color;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.Toast;
import net.tsz.afinal.FinalBitmap;

import com.shitouren.bean.PublishTest;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;

/**
 * PhotoWall��GridView��������
 *
 * @author hanj
 */

public class PhotoWallAdapter extends BaseAdapter {
	private Context context;
	private ArrayList<String> imagePathList = null;

	private FinalBitmap loader;
	// ��¼�Ƿ�ѡ��
	private SparseBooleanArray selectionMap;
	private List<PublishTest> myhasimagelist;

	private int max_image = 0;

	public PhotoWallAdapter(Context context, ArrayList<String> imagePathList, List<PublishTest> hasimagelist) {
		this.context = context;
		this.imagePathList = imagePathList;
		this.myhasimagelist = hasimagelist;
		loader = FinalBitmap.create(context);
		selectionMap = new SparseBooleanArray();
		if (hasimagelist != null && hasimagelist.size() > 0) {
			max_image = hasimagelist.size() - 1;
		}
	}

	@Override
	public int getCount() {
		return imagePathList == null ? 0 : imagePathList.size();
	}

	@Override
	public Object getItem(int position) {
		return imagePathList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		String filePath = (String) getItem(position);

		final ViewHolder holder;
		if (convertView == null) {
			convertView = LayoutInflater.from(context).inflate(R.layout.photo_wall_item, null);
			holder = new ViewHolder();

			holder.imageView = (ImageView) convertView.findViewById(R.id.photo_wall_item_photo);
			holder.checkBox = (CheckBox) convertView.findViewById(R.id.photo_wall_item_cb);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.checkBox.setTag(R.id.tag_first, position);
		holder.checkBox.setTag(R.id.tag_second, holder.imageView);
		Integer p = (Integer) holder.checkBox.getTag(R.id.tag_first);
		ImageView image = (ImageView) holder.checkBox.getTag(R.id.tag_second);
		if (myhasimagelist != null && myhasimagelist.size() > 0) {
			for (int i = 0; i < myhasimagelist.size(); i++) {
				if (myhasimagelist.get(i) != null) {
					if (filePath.equals(myhasimagelist.get(i).getImagePath())) {
						selectionMap.put(p, true);
					}
				}
			}
		}
		boolean b = selectionMap.get(p);
		if (b) {
			image.setColorFilter(Color.argb(0x99, 0x00, 0x00, 0x00));
			holder.checkBox.setBackgroundResource(R.drawable.duigou);
		} else {
			holder.checkBox.setBackgroundColor(Color.TRANSPARENT);
			image.setColorFilter(null);
		}
		holder.imageView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Integer position = (Integer) holder.checkBox.getTag(R.id.tag_first);
				ImageView image = (ImageView) holder.checkBox.getTag(R.id.tag_second);
				boolean b = selectionMap.get(position);
				if (b) {
					if (image.getColorFilter() != null) {
						max_image -= 1;
					}
					selectionMap.put(position, false);
					image.setColorFilter(null);
					holder.checkBox.setBackgroundColor(Color.TRANSPARENT);
				} else {
					if (max_image < Contacts.PUBLISH_PIC_NUM) {
						selectionMap.put(position, true);
						image.setColorFilter(context.getResources().getColor(R.color.image_checked_bg));
						holder.checkBox.setBackgroundResource(R.drawable.duigou);
						max_image += 1;
					}
				}
			}
		});
		holder.checkBox.setChecked(selectionMap.get(position));
		holder.imageView.setTag(filePath);
		loader.display(holder.imageView, filePath);
		return convertView;
	}

	private class ViewHolder {
		ImageView imageView;
		CheckBox checkBox;
	}

	public SparseBooleanArray getSelectionMap() {
		return selectionMap;
	}

	public void clearSelectionMap() {
		selectionMap.clear();
	}
}
