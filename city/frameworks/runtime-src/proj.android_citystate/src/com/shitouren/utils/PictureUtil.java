package com.shitouren.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Base64;

public class PictureUtil {
	/**
	 * // ͼƬ·��
	 */
	public static String mCurrentPhotoPath;// ͼƬ·��
	public static String mCurrentPhotoPath1;// ͼƬ·��
	public static String mCurrentCarPhotoPath;// ����λ��ͼƬ·��
	public static String mCurrentCarPicPhotoPath;// ����ͼƬ·��

	/**
	 * ��bitmapת����String
	 * 
	 * @param filePath
	 * @return
	 */
	public static String bitmapToString(String filePath) {

		Bitmap bm = getSmallBitmap(filePath);

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		bm.compress(Bitmap.CompressFormat.JPEG, 40, baos);
		byte[] b = baos.toByteArray();

		return Base64.encodeToString(b, Base64.DEFAULT);

	}

	/**
	 * ����ͼƬ������ֵ
	 * 
	 * @param options
	 * @param reqWidth
	 * @param reqHeight
	 * @return
	 */
	public static int calculateInSampleSize(BitmapFactory.Options options,
			int reqWidth, int reqHeight) {
		// Raw height and width of image
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (height > reqHeight || width > reqWidth) {

			// Calculate ratios of height and width to requested height and
			// width
			final int heightRatio = Math.round((float) height
					/ (float) reqHeight);
			final int widthRatio = Math.round((float) width / (float) reqWidth);

			// Choose the smallest ratio as inSampleSize value, this will
			// guarantee
			// a final image with both dimensions larger than or equal to the
			// requested height and width.
			inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
		}

		return inSampleSize;
	}

	/**
	 * ����·�����ͻ�Ʋ�ѹ������bitmap������ʾ
	 * 
	 * @param imagesrc
	 * @return
	 */
	public static Bitmap getSmallBitmap(String filePath) {
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		options.inPreferredConfig = Bitmap.Config.RGB_565;
		options.inPurgeable = true;
		options.inInputShareable = true;
		BitmapFactory.decodeFile(filePath, options);

		// Calculate inSampleSize
		options.inSampleSize = calculateInSampleSize(options, 240, 320);

		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;

		return BitmapFactory.decodeFile(filePath, options);
	}

	/**
	 * ����·��ɾ��ͼƬ
	 * 
	 * @param path
	 */
	public static void deleteTempFile(String path) {
		File file = new File(path);
		if (file.exists()) {
			file.delete();
		}
	}

	/**
	 * ��ӵ�ͼ��
	 */
	public static void galleryAddPic(Context context, String path) {
		Intent mediaScanIntent = new Intent(
				Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
		File f = new File(path);
		if (!f.exists()) {
			f.mkdirs();
		}
		Uri contentUri = Uri.fromFile(f);
		mediaScanIntent.setData(contentUri);
		context.sendBroadcast(mediaScanIntent);
	}

	/**
	 * ��ȡ����ͼƬ��Ŀ¼
	 * 
	 * @return
	 */
	public static File getAlbumDir() {
		// Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)��������Ϊ�գ����ص�·���п��ܲ����ڣ���ѰFile.mkdirs
		File externalStoragePublicDirectory = Environment
				.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
		if (!externalStoragePublicDirectory.exists()) {
			externalStoragePublicDirectory.mkdirs();
		}
		File dir = new File(externalStoragePublicDirectory, getAlbumName());
		if (!dir.exists()) {
			dir.mkdirs();
		}
		return dir;
	}

	/**
	 * ��ȡ���� ��������ͼƬ�ļ�������
	 * 
	 * @return
	 */
	public static String getAlbumName() {
		String fileNAME = "/ihome86/picture";
		return "ihome86";
	}

	/**
	 * �ѳ����������Ƭ�ŵ� SD���� PicturesĿ¼�� sheguantong �ļ�����
	 * ��Ƭ����������Ϊ��sheqing_20130125_173729.jpg
	 * 
	 * @return
	 * @throws IOException
	 */
	@SuppressLint("SimpleDateFormat")
	public static File createImageFile() throws IOException {

		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String timeStamp = format.format(new Date());
		String imageFileName = "sheqing_" + timeStamp + ".jpg";
		File image = new File(PictureUtil.getAlbumDir(), imageFileName);
		mCurrentPhotoPath = image.getAbsolutePath();
		return image;
	}
	public static File createImageFile1() throws IOException {

		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String timeStamp = format.format(new Date());
		String imageFileName = "sheqing1_" + timeStamp + ".jpg";
		File image = new File(PictureUtil.getAlbumDir(), imageFileName);
		mCurrentPhotoPath1 = image.getAbsolutePath();
		return image;
	}
/*
 *  �ֻ����յ���Ƭ���浽�ֻ���
 */
	@SuppressLint("SimpleDateFormat")
	public static File createCarImageFile() throws IOException {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String timeStamp = format.format(new Date());
		String imageFileName = "car_" + timeStamp + ".jpg";
		File image = new File(PictureUtil.getAlbumDir(), imageFileName);
		mCurrentCarPhotoPath = image.getAbsolutePath();
		return image;
	}
	@SuppressLint("SimpleDateFormat")
	public static File createCarPicImageFile() throws IOException {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String timeStamp = format.format(new Date());
		String imageFileName = "carpic_" + timeStamp + ".jpg";
		File image = new File(PictureUtil.getAlbumDir(), imageFileName);
		mCurrentCarPicPhotoPath = image.getAbsolutePath();
		return image;
	}

	/**
	 * ����ͷ���Բ��
	 * 
	 * @param bitmap
	 * @param roundPx
	 * @return
	 */
	public static Bitmap getRoundedCornerBitmap(Bitmap bitmap, float roundPx) {

		Bitmap output = Bitmap.createBitmap(bitmap.getWidth(),
				bitmap.getHeight(), Config.ARGB_8888);
		Canvas canvas = new Canvas(output);

		final int color = 0xff424242;
		final Paint paint = new Paint();
		final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		final RectF rectF = new RectF(rect);

		paint.setAntiAlias(true);
		canvas.drawARGB(0, 0, 0, 0);
		paint.setColor(color);
		canvas.drawRoundRect(rectF, roundPx, roundPx, paint);

		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);

		return output;
	}

}
