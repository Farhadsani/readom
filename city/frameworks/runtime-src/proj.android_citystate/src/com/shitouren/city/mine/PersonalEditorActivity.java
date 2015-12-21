package com.shitouren.city.mine;

import java.util.ArrayList;
import java.util.List;

import com.shitouren.citystate.R;
import com.shitouren.inter.IActivity;
import com.shitouren.view.CircularImage;

import android.R.integer;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

public class PersonalEditorActivity extends Activity implements IActivity{

	
	CircularImage imgPersonalEditor;
	TextView tvPersonalEditorName,tvPersonalEditordec;
	ListView lvPersonalEditor;
	LinearLayout llPersonalEditorBackground;
	int []imagerpersonal = {R.drawable.xingbie,R.drawable.xingquxiang,
			R.drawable.qingganzhuangkuang,R.drawable.huangdaoshiergong,R.drawable.fankui};
	String [] before = {"性别","性取向","情感状况","黄道十二宫","本人个性签名"};
	private List<Integer> imageList;
	private List<String> beforeList;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_personal_editor_avtivity);
		imageList = new ArrayList<Integer>();
		beforeList = new ArrayList<String>();
		for (int i = 0; i < imagerpersonal.length; i++) {
			imageList.add(imagerpersonal[i]);
		}
		for (int i = 0; i < before.length; i++) {
			beforeList.add(before[i]);
		}
		initView();
	}

	@Override
	public void initTestData() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void initData() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void initView() {
		// TODO Auto-generated method stub
		imgPersonalEditor = (CircularImage) findViewById(R.id.imgPersonalEditor);
		tvPersonalEditorName = (TextView) findViewById(R.id.tvPersonalEditorName);
		tvPersonalEditordec = (TextView) findViewById(R.id.tvPersonalEditordec);
		lvPersonalEditor = (ListView) findViewById(R.id.lvPersonalEditor);
		llPersonalEditorBackground = (LinearLayout) findViewById(R.id.llPersonalEditorBackground);
		
		lvPersonalEditor.setAdapter(new PersonalEditorListviewAdapter());
	}

	@Override
	public void setLisener() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void parseIntent() {
		// TODO Auto-generated method stub
		
	}
	
	class PersonalEditorListviewAdapter extends BaseAdapter{

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return imageList.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			ViewHolder holder = null;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = View.inflate(getApplicationContext(), R.layout.mine_personal_editor_item, null);
				holder.ivPersonalEditorBeforePic = (ImageView) convertView.findViewById(R.id.ivPersonalEditorBeforePic);
				holder.ivPersonalEditorGo = (ImageView) convertView.findViewById(R.id.ivPersonalEditorGo);
				holder.tvPersonalEditorName =  (TextView) convertView.findViewById(R.id.tvPersonalEditorName);
				holder.tvPersonalEditorSex =  (TextView) convertView.findViewById(R.id.tvPersonalEditorSex);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			holder.ivPersonalEditorBeforePic.setImageResource(imageList.get(position));
			holder.tvPersonalEditorSex.setText(beforeList.get(position));
			holder.ivPersonalEditorGo.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					
				}
			});
			return convertView;
		}

	}
	class ViewHolder{
		ImageView ivPersonalEditorBeforePic;
		ImageView ivPersonalEditorGo;
		TextView tvPersonalEditorName;
		TextView tvPersonalEditorSex;
	}
	
}

