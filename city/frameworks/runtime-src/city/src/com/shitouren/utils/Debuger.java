package com.shitouren.utils;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class Debuger {
public static final boolean Debug = true;
	public static void log_e(String msg){
		Log.e("tag", msg);
	}
	
	public static void log_e(String tag,String msg){
		Log.e(tag, msg);
	}
	
	public static void log_v(String msg){
		Log.v("tag", msg);
	}
	
	public static void log_v(String tag,String msg){
		Log.v(tag, msg);
	}
	
	public static void log_d(String msg){
		Log.d("tag", msg);
	}
	
	public static void log_d(String tag,String msg){
		Log.e(tag, msg);
	}
	
	public static void log_i(String msg){
		Log.i("tag", msg);
	}
	
	public static void log_i(String tag,String msg){
		Log.i(tag, msg);
	}
	
	public static void log_w(String msg){
		Log.w("tag", msg);
	}
	
	public static void log_w(String tag,String msg){
		Log.w(tag, msg);
	}
	
	
	public static void showToast(Context ctx,String msg){
		Toast.makeText(ctx, msg, 3000).show();
	}
	
}
