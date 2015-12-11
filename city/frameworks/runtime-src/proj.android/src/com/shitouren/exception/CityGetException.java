package com.shitouren.exception;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.Thread.UncaughtExceptionHandler;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;


/**
 * 
 * @author king
 * 
 */
public class CityGetException implements UncaughtExceptionHandler {
	private static CityGetException ihomeGetException = new CityGetException();

	private CityGetException() {
	};

	public static CityGetException getInstance() {
		return ihomeGetException;
	}

	private Map<String, String> map = new HashMap<String, String>();
	private Context mcontext;
	private Thread.UncaughtExceptionHandler defaultHandler;
	private Handler handler = null;

	public void init(Context context) {
		this.mcontext = context;
		this.handler = new Handler();
		defaultHandler = Thread.getDefaultUncaughtExceptionHandler();
		Thread.setDefaultUncaughtExceptionHandler(this);
	}

	@Override
	public void uncaughtException(Thread thread, Throwable e) {
		if (!handlerException(e) && defaultHandler != null) {
			defaultHandler.uncaughtException(thread, e);
		} else {
			try {
				Thread.sleep(5000);
			} catch (InterruptedException e1) {
				e1.printStackTrace();
			}
			//杀掉出异常的线程
			android.os.Process.killProcess(android.os.Process.myPid());
			System.exit(0);
		}
	}

	private boolean handlerException(Throwable e) {
		if (e == null) {
			return false;
		} else {
			collectDeviceMessage(mcontext);
			exceptionfile = saveExceptionInfoFile(e);
			new Thread() {
				public void run() {
					Looper.prepare();
					if (handler != null) {
						if (exceptionfile != null) {
							handler.post(runnable);
						}
					}
					Looper.loop();
				};
			}.start();
			return true;
		}
	}
	/**
	 */
	Runnable runnable = new Runnable() {
		
		@Override
		public void run() {
			sendBug(exceptionfile);
		}
	};
	private File exceptionfile;
	/**
	 * 
	 * @param context
	 */
	private void collectDeviceMessage(Context context) {
		PackageManager packageManager = context.getPackageManager();
		try {
			PackageInfo packageInfo = packageManager.getPackageInfo(
					context.getPackageName(), PackageManager.GET_ACTIVITIES);
			if (packageInfo != null) {
				String versionName = packageInfo.versionName == null ? "null"
						: packageInfo.versionName;
				String versionCode = packageInfo.versionCode + "";
				map.put("versionName", versionName);
				map.put("versionCode", versionCode);
			}
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		Field[] declaredFields = Build.class.getDeclaredFields();
		for (Field field : declaredFields) {
			field.setAccessible(true);
			try {
				map.put(field.getName(), field.get("").toString());
				System.out.println(field.getName() + "---:---"
						+ field.get("").toString() + "------");
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
	}

	//保存异常信息到文件
	private File saveExceptionInfoFile(Throwable e) {
		StringBuffer sb = new StringBuffer();
		for (Map.Entry<String, String> entry : map.entrySet()) {
			String key = entry.getKey();
			String value = entry.getValue();
			sb.append(key + "=" + value + "\r\n");
		}

		StringWriter stringWriter = new StringWriter();
		PrintWriter printWriter = new PrintWriter(stringWriter);
		e.printStackTrace(printWriter);
		Throwable cause = e.getCause();
		while (cause != null) {
			cause.printStackTrace(printWriter);
			cause = cause.getCause();
		}
		printWriter.close();
		String result = stringWriter.toString();
		sb.append(result);
		
		long time = System.currentTimeMillis();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
		String date = format.format(new Date());
		String filename = "crash-" + date + "-" + time + ".log";
		if (Environment.getExternalStorageState().equals(
				Environment.MEDIA_MOUNTED)) {
			File file = new File(Environment.getExternalStorageDirectory()
					+ "/city/");
			if (!file.exists()) {
				file.mkdirs();
			}
			File filecash = new File(file, "crash/");
			if (!filecash.exists()) {
				filecash.mkdirs();
			} else {
				delteDirectory(filecash);
				filecash.delete();
				filecash.mkdirs();
			}
			File fileName = new File(filecash, filename);
			try {
				FileOutputStream out = new FileOutputStream(fileName);
				out.write(sb.toString().getBytes());
				out.flush();
				out.close();
				return fileName;
			} catch (FileNotFoundException e1) {
				e1.printStackTrace();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
		return null;
	}

	//发送异常信息到服务器
	private void sendBug(File file) {
		if (file != null) {
			FileInputStream input;
			try {
				input = new FileInputStream(file);
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				int len = 0;
				byte[] buffer = new byte[1024];
				try {
					while ((len = input.read(buffer)) != -1) {
						baos.write(buffer, 0, len);
					}
					input.close();
					baos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
				byte[] result = baos.toByteArray();
				String temp = new String(result);
				AjaxParams params = new AjaxParams();
				params.put("bug", new ByteArrayInputStream(result));
				FinalHttp http = new FinalHttp();
				http.post("城邦异常接口", params,
						new AjaxCallBack<Object>() {
						});
			} catch (FileNotFoundException e1) {
				e1.printStackTrace();
			}
		}
	}

	/**
	 */
	private void delteDirectory(File file) {
		if (file.exists()) {
			if (file.isDirectory()) {
				File[] files = file.listFiles();
				if (files.length > 0) {
					for (File fileitem : files) {
						fileitem.delete();
					}
				}
			}
		}
	}
}
