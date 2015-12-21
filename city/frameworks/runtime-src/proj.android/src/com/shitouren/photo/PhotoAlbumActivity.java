package com.shitouren.photo;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;

import com.shitouren.qmap.R;import com.shitouren.utils.Debuger;
import com.shitouren.utils.Utils;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

/**
 * �����鿴SD������ͼƬ��
 * Created by hanj on 14-10-14.
 */
public class PhotoAlbumActivity extends Activity {
	private Class c;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.photo_album);

        if (!Utils.isSDcardOK()) {
        	Debuger.showToastShort(this, "SD卡没有安装");
            return;
        }

        Intent t = getIntent();
        if (!t.hasExtra("latest_count")) {
            return;
        }
        if (t.hasExtra("activity")) {
        	c = (Class) t.getSerializableExtra("activity");
        }
        TextView neighbor_photo_xiangce_add_img = (TextView) findViewById(R.id.neighbor_photo_xiangce_add_img);

        ListView listView = (ListView) findViewById(R.id.select_img_listView);

//        //��һ�ַ�ʽ��ʹ��file
//        File rootFile = new File(Utility.getSDcardRoot());
//        //����/mnt/sdcard/DCIM/.thumbnailsĿ¼
//        String ignorePath = rootFile + File.separator + "DCIM" + File.separator + ".thumbnails";
//        getImagePathsByFile(rootFile, ignorePath);

        //�ڶ��ַ�ʽ��ʹ��ContentProvider����Ч�ʸ��ߣ�       
        final ArrayList<PhotoAlbumLVItem> list = new ArrayList<PhotoAlbumLVItem>();
        //�������Ƭ��
        list.add(new PhotoAlbumLVItem("�����Ƭ",
                t.getIntExtra("latest_count", -1), t.getStringExtra("latest_first_img")));
        //���
        list.addAll(getImagePathsByContentProvider());

        PhotoAlbumLVAdapter adapter = new PhotoAlbumLVAdapter(this, list);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(PhotoAlbumActivity.this, PhotoWallActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);

                //��һ��Ϊ�������Ƭ��
                if (position == 0) {
                    intent.putExtra("code", 200);
                } else {
                    intent.putExtra("code", 100);
                    intent.putExtra("folderPath", list.get(position).getPathName());
                }
                intent.putExtra("activity", c);
                intent.putExtra("parent", "xiangce");
                startActivity(intent);
                overridePendingTransition(R.anim.left_in, R.anim.left_out);
                finish();
            }
        });

        neighbor_photo_xiangce_add_img.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //ȡ�����ص���ҳ��
                backAction();
            }
        });
    }

    /**
     * �������ʱ���ص����ҳ��
     */
    private void backAction() {
        Intent intent = new Intent(this,c);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
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
     * ��ȡĿ¼��ͼƬ�ĸ�����
     */
    private int getImageCount(File folder) {
        int count = 0;
        File[] files = folder.listFiles();
        for (File file : files) {
            if (Utils.isImage(file.getName())) {
                count++;
            }
        }

        return count;
    }

    /**
     *��ȡĿ¼�����µ�һ��ͼƬ�ľ���·����
     */
    private String getFirstImagePath(File folder) {
        File[] files = folder.listFiles();
        for (int i = files.length - 1; i >= 0; i--) {
            File file = files[i];
            if (Utils.isImage(file.getName())) {
                return file.getAbsolutePath();
            }
        }

        return null;
    }

    /**
     * ʹ��ContentProvider��ȡSD������ͼƬ��
     */
    private ArrayList<PhotoAlbumLVItem> getImagePathsByContentProvider() {
        Uri mImageUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

        String key_MIME_TYPE = MediaStore.Images.Media.MIME_TYPE;
        String key_DATA = MediaStore.Images.Media.DATA;

        ContentResolver mContentResolver = getContentResolver();

        //ֻ��ѯjpg��png��ͼƬ      
        Cursor cursor = mContentResolver.query(mImageUri, new String[]{key_DATA},
                key_MIME_TYPE + "=? or " + key_MIME_TYPE + "=? or " + key_MIME_TYPE + "=?",
                new String[]{"image/jpg", "image/jpeg", "image/png"},
                MediaStore.Images.Media.DATE_MODIFIED);

        ArrayList<PhotoAlbumLVItem> list = null;
        if (cursor != null) {
            if (cursor.moveToLast()) {
                //·�����棬��ֹ���ɨ��ͬһĿ¼              
            	HashSet<String> cachePath = new HashSet<String>();
                list = new ArrayList<PhotoAlbumLVItem>();

                while (true) {
                	// ��ȡͼƬ��·��                    
                	String imagePath = cursor.getString(0);
                    File parentFile = new File(imagePath).getParentFile();
                    String parentPath = parentFile.getAbsolutePath();

                    //��ɨ���ظ�·��                    
                    if (!cachePath.contains(parentPath)) {
                        list.add(new PhotoAlbumLVItem(parentPath, getImageCount(parentFile),
                                getFirstImagePath(parentFile)));
                        cachePath.add(parentPath);
                    }

                    if (!cursor.moveToPrevious()) {
                        break;
                    }
                }
            }

            cursor.close();
        }

        return list;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        //����
        overridePendingTransition(R.anim.right_in, R.anim.right_out);
    }

    //    /**
//     * ʹ��File��ȡSD������ͼƬ��
//     */
//    private void getImagePathsByFile(File file, String ignorePath) {
//        if (file.isFile()) {
//            File parentFile = file.getParentFile();
//            String parentFilePath = parentFile.getAbsolutePath();
//
//            if (cachePath.contains(parentFilePath)) {
//                return;
//            }
//
//            if (isImage(file.getName())) {
//                list.add(new SelectImgGVItem(parentFilePath, getImageCount(parentFile),
//                        getFirstImagePath(parentFile)));
//                cachePath.add(parentFilePath);
//            }
//        } else {
//            String absolutePath = file.getAbsolutePath();
//            //�����ļ���
//            if (absolutePath.equals(ignorePath)) {
//                return;
//            }
//
//            //����ȡ����ͼ
//            if (absolutePath.contains("thumb")) {
//                return;
//            }
//
//            //����ȡ�㼶����5��
//            if (Utility.countMatches(absolutePath, File.separator) > 5) {
//                return;
//            }
//
//            //����ȡ·������.�ĺ������ļ�
//            if (file.getName().contains(".")) {
//                return;
//            }
//
//            File[] childFiles = file.listFiles();
//            if (childFiles != null) {
//                for (File childFile : childFiles) {
//                    getImagePathsByFile(childFile, ignorePath);
//                }
//            }
//        }
//    }
}
