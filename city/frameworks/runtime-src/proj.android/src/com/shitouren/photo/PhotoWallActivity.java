package com.shitouren.photo;

import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.shitouren.bean.PublishTest;
import com.shitouren.citystate.ImageDetailActivity;
import com.shitouren.utils.Utils;
import com.shitouren.qmap.R;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.SparseBooleanArray;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class PhotoWallActivity extends Activity {
    private TextView titleTV;

    private ArrayList<String> list;
    private GridView mPhotoWall;
    private PhotoWallAdapter adapter;

    private String currentFolder = null;
    private boolean isLatest = true;

    
    private boolean firstIn = true;

   	private RelativeLayout neighbor_photo_back_layout;

   	private TextView neighbor_photo_add_img;

   	private Button neighbor_photo_yulan;

   	private Button neighbor_photo_finish;

   	private List<PublishTest> hasimagelist;

   	private Class c;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.photo_wall);

        neighbor_photo_back_layout = (RelativeLayout) findViewById(R.id.neighbor_photo_back_layout);
        
        neighbor_photo_add_img = (TextView) findViewById(R.id.neighbor_photo_add_img);
        
        neighbor_photo_yulan = (Button) findViewById(R.id.neighbor_photo_yulan);
        
        neighbor_photo_finish = (Button) findViewById(R.id.neighbor_photo_finish);
        
        mPhotoWall = (GridView) findViewById(R.id.photo_wall_grid);
        list = getLatestImagePaths(100);
        
        Intent intent = getIntent();
        if (intent.hasExtra("hasimagelist")) {
        	hasimagelist = (List<PublishTest>) intent.getSerializableExtra("hasimagelist");
        }
        if (intent.hasExtra("activity")) {
        	c = (Class) intent.getSerializableExtra("activity");
        }
        adapter = new PhotoWallAdapter(this, list,hasimagelist);
        mPhotoWall.setAdapter(adapter);

        if (intent.hasExtra("parent")) {
			String string = intent.getStringExtra("parent");
			if ("xiangce".equals(string)) {
				refresh(intent);
			}
		}
        
        neighbor_photo_finish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ArrayList<String> paths = getSelectImagePaths();
                if (paths != null && paths.size() > 0) {
                	Intent intent = new Intent(PhotoWallActivity.this, c);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    intent.putExtra("code", paths != null ? 100 : 101);
                    intent.putStringArrayListExtra("paths", paths);
                    startActivity(intent);
                    overridePendingTransition(R.anim.right_in, R.anim.right_out);
                    finish();
				}
            }
        });

        //������أ��ص�ѡ�����ҳ��      
        neighbor_photo_back_layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                backAction();
            }
        });
        neighbor_photo_add_img.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();
				overridePendingTransition(R.anim.right_in, R.anim.right_out);
			}
		});
        neighbor_photo_yulan.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				ArrayList<String> paths = getSelectImagePaths();
				if (paths != null) {
					Intent intent = new Intent();
					intent.setClass(PhotoWallActivity.this, ImageDetailActivity.class);
					Bundle bundle = new Bundle();
					bundle.putSerializable("list", (Serializable) paths);
					bundle.putInt("position", 0);
					bundle.putString("type", "localimage");
					intent.putExtras(bundle);
					startActivity(intent);
				}
			}
		});
    }

    /**
     * ��һ����ת�����ҳ��ʱ������������Ƭ��Ϣ
     */
   

    /**
     * �������ʱ����ת�����ҳ��    
     */
    private void backAction() {
        Intent intent = new Intent(this, PhotoAlbumActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);

        //���ݡ������Ƭ��������Ϣ
        if (firstIn) {
            if (list != null && list.size() > 0) {
                intent.putExtra("latest_count", list.size());
                intent.putExtra("latest_first_img", list.get(0));
            }
            firstIn = false;
        }
        intent.putExtra("activity", c);
        startActivity(intent);
        //����
        overridePendingTransition(R.anim.right_in, R.anim.right_out);
        finish();
    }

    //��д���ؼ�   
    @Override
    public boolean onKeyDown(int keyCode,KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            backAction();
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    /**
     * ����ͼƬ�����ļ���·����ˢ��ҳ��
     */
    private void updateView(int code, String folderPath) {
        list.clear();
        adapter.clearSelectionMap();
        adapter.notifyDataSetChanged();

        if (code == 100) {   //ĳ�����
            int lastSeparator = folderPath.lastIndexOf(File.separator);
            String folderName = folderPath.substring(lastSeparator + 1);
            list.addAll(getAllImagePathsByFolder(folderPath));
        } else if (code == 200) {  //�����Ƭ
            list.addAll(getLatestImagePaths(100));
        }

        adapter.notifyDataSetChanged();
        if (list.size() > 0) {
        	//����������           
        	mPhotoWall.smoothScrollToPosition(0);
        }
    }


    /**
     * ��ȡָ��·���µ�����ͼƬ�ļ���     
     */
    private ArrayList<String> getAllImagePathsByFolder(String folderPath) {
        File folder = new File(folderPath);
        String[] allFileNames = folder.list();
        if (allFileNames == null || allFileNames.length == 0) {
            return null;
        }

        ArrayList<String> imageFilePaths = new ArrayList<String>();
        for (int i = allFileNames.length - 1; i >= 0; i--) {
            if (Utils.isImage(allFileNames[i])) {
                imageFilePaths.add(folderPath + File.separator + allFileNames[i]);
            }
        }

        return imageFilePaths;
    }
    
    /**
     * 获取最近的图片
     */
    private ArrayList<String> getLatestImagePaths(int maxCount) {
        Uri mImageUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

        String key_MIME_TYPE = MediaStore.Images.Media.MIME_TYPE;
        String key_DATA = MediaStore.Images.Media.DATA;

        ContentResolver mContentResolver = getContentResolver();

        Cursor cursor = mContentResolver.query(mImageUri, new String[]{key_DATA},
                key_MIME_TYPE + "=? or " + key_MIME_TYPE + "=? or " + key_MIME_TYPE + "=?",
                new String[]{"image/jpg", "image/jpeg", "image/png"},
                MediaStore.Images.Media.DATE_MODIFIED);

        ArrayList<String> latestImagePaths = null;
        if (cursor != null) {
            if (cursor.moveToLast()) {
                latestImagePaths = new ArrayList<String>();
                while (true) {
                	String path = cursor.getString(0);
                    latestImagePaths.add(path);

                    if (latestImagePaths.size() >= maxCount || !cursor.moveToPrevious()) {
                        break;
                    }
                }
            }
            cursor.close();
        }

        return latestImagePaths;
    }

    //��ȡ��ѡ���ͼƬ·��
    private ArrayList<String> getSelectImagePaths() {
        SparseBooleanArray map = adapter.getSelectionMap();
        if (map.size() == 0) {
            return null;
        }

        ArrayList<String> selectedImageList = new ArrayList<String>();

        for (int i = 0; i < list.size(); i++) {
            if (map.get(i)) {
                selectedImageList.add(list.get(i));
            }
        }

        return selectedImageList;
    }

  //�����ҳ����ת����ҳ
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

//      //����
//        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
        
    }
    private void refresh(Intent intent){
    	int code = intent.getIntExtra("code", -1);
        if (code == 100) {
        	//ĳ�����
            String folderPath = intent.getStringExtra("folderPath");
            if (isLatest || (folderPath != null && !folderPath.equals(currentFolder))) {
                currentFolder = folderPath;
                updateView(100, currentFolder);
                isLatest = false;
            }
        } else if (code == 200) {
        	//�������Ƭ��
            if (!isLatest) {
                updateView(200, null);
                isLatest = true;
            }
        }
    }
}
