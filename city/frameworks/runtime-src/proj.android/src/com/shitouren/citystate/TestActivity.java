package com.shitouren.citystate;

import java.io.Serializable;
import java.security.PublicKey;
import java.util.ArrayList;
import java.util.List;

import com.shitouren.bean.PublishTest;
import com.shitouren.entity.Contacts;
import com.shitouren.photo.PhotoWallActivity;
import com.shitouren.tagview.Tag;
import com.shitouren.tagview.TagListView;
import com.shitouren.tagview.TagListView.OnTagClickListener;
import com.shitouren.tagview.TagView;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.PictureUtil;
import com.shitouren.view.PropertyGridView;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;
import net.tsz.afinal.FinalBitmap;
import com.shitouren.qmap.R;
public class TestActivity extends Activity {
	private static final String TAG = "TestActivity";
	
	//topBarLayout布局
	private LinearLayout llTopbarLeft;
	private ImageView ivTopbarleft;
	
	private TextView tvTopbarMiddle;
	
	private RelativeLayout rlTopbarRight;
	private TextView tvTopbarRight;
	//topBarLayout布局
	
	List<PublishTest> lists = new ArrayList<PublishTest>();
	PropertyGridView gridview_imgs;
	MyAdapter adapter;

	private static int click_position = -1;
	private int update_img_counts = Contacts.PUBLISH_PIC_NUM;
	private String img_file_path;

	private static final int RESULT_CAMERA = 0;
	private static final int RESULT_DELECT = 1;

	private boolean isdelete = false;

//	private EditText etTag;
	private TagListView lvTag;
	private List<Tag> listTag;
	private String tagStr;
	private EditText et;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.test_gridview);
		
		//topBarLayout布局
		llTopbarLeft = (LinearLayout) findViewById(R.id.llTopbarLeft);
		ivTopbarleft = (ImageView) findViewById(R.id.ivTopbarLeft);
		
		tvTopbarMiddle = (TextView) findViewById(R.id.tvTopbarMiddle);
		
		rlTopbarRight = (RelativeLayout) findViewById(R.id.rlTopbarRight);
		tvTopbarRight = (TextView) findViewById(R.id.tvTopbarRight);
		//topBarLayout布局
		
		initTopBarLayout();
		
		gridview_imgs = (PropertyGridView) findViewById(R.id.gridview_imgs);
		adapter = new MyAdapter(this);
		gridview_imgs.setAdapter(adapter);
		gridview_imgs.setOnItemClickListener(itemClickListener);
		
//		etTag = (EditText) findViewById(R.id.etTag);
		lvTag = (TagListView) findViewById(R.id.tagview);
		listTag = new ArrayList<Tag>();
		
		et = new EditText(TestActivity.this);
//		et.setBackground(null);
		et.setHint("标签描述");
		et.setImeOptions(EditorInfo.IME_ACTION_DONE);
		et.setInputType(EditorInfo.TYPE_CLASS_TEXT);
		et.setGravity(Gravity.CENTER_VERTICAL);
		
		lvTag.addView(et);
		
		lvTag.setOnTagClickListener(new OnTagClickListener() {
			
			@Override
			public void onTagClick(TagView tagView, Tag tag) {
				lvTag.removeTag(tag);
			}
		});
		
		et.setOnFocusChangeListener(new OnFocusChangeListener() {
			
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				InputMethodManager inputMethodManager=(InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);  
		        inputMethodManager.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS); 
			}
		});
		
		et.setOnEditorActionListener(editorActionListener);
		et.addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				Debuger.log_w(TAG, "etTag onTextChanged"+s.toString()+start+":"+before);
//				if(" ".equals(s.subSequence(start, s.length()).toString())){
//					Tag tag = new Tag();
//					tag.setTitle(tagStr);
//					listTag.add(tag);
//					lvTag.setTags(listTag);
//					lvTag.addView(et);
//					et.requestFocus();
//					s = "";
//				}
			}
			
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				Debuger.log_w(TAG, "etTag beforeTextChanged"+s.toString());
			}
			
			@Override
			public void afterTextChanged(Editable s) {
				Debuger.log_w(TAG, "etTag afterTextChanged"+":"+s.toString());
				tagStr = s.toString();
			}
		});
		
		Intent intent = getIntent();
		if (intent != null) {
			Debuger.log_w(TAG, "intent is not null");
			Debuger.log_w("xyz:", "lists"+lists.size());
			setMessages(intent);
		} else {
			Debuger.log_w(TAG, "intent is null");
			initdate();
		}
	}
	
	private void initTopBarLayout(){
		tvTopbarMiddle.setText(getResources().getString(R.string.publishTitle));
		
		ivTopbarleft.setImageResource(R.drawable.xiangyoubaise);
		llTopbarLeft.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				TestActivity.this.finish();
			}
		});
		
		tvTopbarRight.setVisibility(View.VISIBLE);
		tvTopbarRight.setText(getResources().getString(R.string.publishRight));
		rlTopbarRight.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
			}
		});
	}
	
	public OnEditorActionListener editorActionListener = new OnEditorActionListener() {		
		@Override
		public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
			if(actionId == EditorInfo.IME_ACTION_DONE)
			{
				Tag tag = new Tag();
				tag.setTitle(tagStr);
				listTag.add(tag);
				lvTag.setTags(listTag);
				lvTag.addView(et);
				et.requestFocus();
				v.setText("");
			}
			return false;
		}

	};

	private void setMessages(Intent intent) {
		if (intent.hasExtra("code") && intent.hasExtra("paths")) {
			int code = 0;
			ArrayList<String> paths = new ArrayList<String>();
			code = intent.getIntExtra("code", 0);
			paths = intent.getStringArrayListExtra("paths");
			boolean hasUpdate = false;
			if (code != 100) {
				return;
			}
			boolean isadd = false;
			if (paths != null && paths.size() > 0) {
				if (lists != null) {
					if (lists.size() > 0) {
						Debuger.log_w(TAG, "xyzlists.size="+lists.size());
						for (String path : paths) {
							for (int i = 0; i < lists.size(); i++) {
								if (!lists.get(i).getImagePath().equals(path)) {
									isadd = true;
								}
							}
							if (isadd) {
								if (lists.size() == update_img_counts) {
									Debuger.showToastShort(this, "aaaaaaaa");
									break;
								}
								PublishTest info = new PublishTest();
								info.setImagePath(path);
								info.setDelete(false);
								lists.add(info);
								hasUpdate = true;
								isadd = false;
							}
						}
					} else {
						for (String path : paths) {
							if (lists.size() == update_img_counts) {
								Debuger.showToastShort(this, "bbbbbb");
								break;
							}
							PublishTest info = new PublishTest();
							info.setImagePath(path);
							info.setDelete(false);
							lists.add(info);
							hasUpdate = true;
						}
					}
				}
				if (lists.size() > 0 && lists.size() < update_img_counts) {
					lists.add(null);
				}
				if (hasUpdate) {
					adapter.notifyDataSetChanged();
				}
			}
		} else {
			initdate();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == RESULT_CAMERA) {
			if (resultCode == Activity.RESULT_OK) {
				PictureUtil.galleryAddPic(this, PictureUtil.mCurrentPhotoPath);
				img_file_path = PictureUtil.mCurrentPhotoPath;
				initdate();
			} else {
				PictureUtil.deleteTempFile(PictureUtil.mCurrentPhotoPath);
			}
		} else if (requestCode == RESULT_DELECT && data != null) {
			Log.i("TT", resultCode + "====resultCode  ...." + data);
			if (data.getExtras().get("delete").equals("delete")) {
				deleteImg();
			}
		}
	}

	private void deleteImg() {

		if (lists.size() == update_img_counts && lists.get(update_img_counts-1) != null) {
			lists.remove(click_position);
			lists.add(null);
		} else {
			lists.remove(click_position);
		}
		gridview_imgs.setAdapter(adapter);
	}

	private void initdate() {
		if (lists.size() > 0 && lists.size() < update_img_counts) {
			
			Debuger.log_w(TAG, "lists.size():"+lists.size());
			PublishTest commit_imagePathsInfo = new PublishTest();
			commit_imagePathsInfo.setImagePath(img_file_path);
			lists.set(lists.size() - 1, commit_imagePathsInfo);
			lists.add(null);
		} else if (lists.size() == 0) {
			Debuger.log_w(TAG, "lists.size() = 0");
			lists.add(null);
			Debuger.log_w(TAG, "lists.size()"+lists.size());
		} else if (lists.size() == update_img_counts) {
			Debuger.log_w(TAG, "lists.size() = "+update_img_counts);
			PublishTest commit_imagePathsInfo = new PublishTest();
			commit_imagePathsInfo.setImagePath(img_file_path);
			lists.set(lists.size() - 1, commit_imagePathsInfo);
		}
		gridview_imgs.setAdapter(adapter);
	}

	private class MyAdapter extends BaseAdapter {
		private LayoutInflater img_inflater;
		private Context imgs_Context;
		private FinalBitmap loader;

		public MyAdapter(Context context) {
			this.imgs_Context = context;
			this.img_inflater = LayoutInflater.from(imgs_Context);
			loader = FinalBitmap.create(context);
		}

		@Override
		public int getCount() {
			return lists.size();
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
			Img_Holder holder = null;
			if (convertView == null) {
				holder = new Img_Holder();
				convertView = img_inflater.inflate(R.layout.caa_gridview_item, null);
				holder.imageView = (ImageView) convertView.findViewById(R.id.advice_img);
				holder.add_delete_image = (ImageView) convertView.findViewById(R.id.add_delete_image);
				holder.tvAddPic = (TextView) convertView.findViewById(R.id.tvAddPic);
				convertView.setTag(holder);
			} else {
				holder = (Img_Holder) convertView.getTag();
			}
			
			if(lists.size()>1){
				holder.tvAddPic.setVisibility(View.GONE);
			}
			
			if (lists.get(position) != null) {
				if (lists.get(position).isDelete()) {
					holder.add_delete_image.setVisibility(View.GONE);
				} else {
					holder.add_delete_image.setVisibility(View.VISIBLE);
				}
				// holder.imageView.setImageBitmap(PictureUtil
				// .getSmallBitmap(img_filePaths.get(position).getImagePath()));
				String imagePath = lists.get(position).getImagePath();
				holder.imageView.setTag(imagePath);
				loader.display(holder.imageView, imagePath);
			}
			return convertView;
		}

	}

	private class Img_Holder {
		private ImageView imageView;
		private ImageView add_delete_image;
		private TextView tvAddPic;
	}

	OnItemClickListener itemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			click_position = position;
			if (position == lists.size() - 1 && lists.get(position) == null) {
				Intent intent = new Intent(TestActivity.this, PhotoWallActivity.class);
				intent.putExtra("activity", TestActivity.class);
				intent.putExtra("hasimagelist", (Serializable) lists);
				startActivity(intent);
			}
//			else if (lists.get(position).isDelete()) {
//				if (isdelete) {
//					deleteImg();
//				}
//			}
			else {
				deleteImg();
			}
		}
	};
}
