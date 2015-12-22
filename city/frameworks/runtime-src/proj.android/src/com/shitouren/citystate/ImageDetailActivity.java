package com.shitouren.citystate;

import java.util.List;

import com.polites.android.GestureImageView;
import com.shitouren.utils.Debuger;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import net.tsz.afinal.FinalBitmap;
import com.shitouren.qmap.R;
public class ImageDetailActivity extends Activity {

	private ViewPager pager;
	private TextView tvText;

	private List<String> list;
	private FinalBitmap bitmap;
	
	private int curPosition = 0;
	private long beginTime = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.picture_activity);

		pager = (ViewPager) findViewById(R.id.pagerPicture);
		tvText = (TextView) findViewById(R.id.tvTextPicture);

		Intent intent = getIntent();
		list = intent.getStringArrayListExtra("links");
		curPosition = intent.getIntExtra("id", 0);
		
		Debuger.log_w("ImageDetail:", list.size()+"");
		
		bitmap = FinalBitmap.create(this);
		
		pager.setAdapter(new ImagePagerAdapter());
		pager.setCurrentItem(curPosition);
		pager.setOnPageChangeListener(pageChangeListener);

		tvText.setText(curPosition+"/"+list.size());
	}

	private class ImagePagerAdapter extends PagerAdapter {

		private LayoutInflater inflater;

		ImagePagerAdapter() {
			inflater = getLayoutInflater();
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			((ViewPager) container).removeView((View) object);
		}

		@Override
		public void finishUpdate(View container) {
		}

		@Override
		public int getCount() {
			return list.size();
		}

		@Override
		public Object instantiateItem(ViewGroup view, final int position) {

			View imageLayout = inflater.inflate(R.layout.gallery_detail_image_item, view, false);
			GestureImageView imageView = (GestureImageView) imageLayout.findViewById(R.id.showsinglepicture_image);
			bitmap.display(imageView, list.get(position));
//			imageView.setOnTouchListener(new OnTouchListener() {
//
//				@Override
//				public boolean onTouch(View v, MotionEvent event) {
//					switch (event.getAction()) {
//					case MotionEvent.ACTION_DOWN:
//						beginTime = System.currentTimeMillis();
//						break;
//					case MotionEvent.ACTION_MOVE:
//						break;
//					case MotionEvent.ACTION_UP:
//						long endTime = System.currentTimeMillis();
//						if (endTime - beginTime < 200) {
//							ImageDetailActivity.this.finish();
//						} else {
////							Message message = Message.obtain();
////							message.what = SHOW_SAVE_BUTTON;
////							Bundle bundle = new Bundle();
////							bundle.putString("image_url", pictures_list.get(position));
////							message.setData(bundle);
////							handler.sendMessage(message);
//						}
//						break;
//					}
//					return true;
//				}
//			});
//			String image = pictures_list.get(position);
//			if ("localimage".equals(type)) {
//				image = "file://" + image;
//			}
//
//			imageLoader.displayImage(image, imageView, new SimpleImageLoadingListener() {
//
//				@Override
//				public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
//					spinner.setVisibility(View.GONE);
//					super.onLoadingComplete(imageUri, view, loadedImage);
//				}
//
//				@Override
//				public void onLoadingStarted(String imageUri, View view) {
//					spinner.setVisibility(View.VISIBLE);
//					super.onLoadingStarted(imageUri, view);
//				}
//
//			});
			((ViewPager) view).addView(imageLayout, 0);
			return imageLayout;
		}

		@Override
		public boolean isViewFromObject(View view, Object object) {
			return view.equals(object);
		}

		@Override
		public void restoreState(Parcelable state, ClassLoader loader) {
		}

		@Override
		public Parcelable saveState() {
			return null;
		}

		@Override
		public void startUpdate(View container) {
		}
	}

	OnPageChangeListener pageChangeListener = new OnPageChangeListener() {

		@Override
		public void onPageSelected(int arg0) {
			if (list.size() > 1) {
				tvText.setText(arg0 + 1 + "/" + list.size());
			}
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
			// TODO Auto-generated method stub

		}

		@Override
		public void onPageScrollStateChanged(int arg0) {
			// TODO Auto-generated method stub
		}
	};

}
