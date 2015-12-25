package com.shitouren.utils;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class Debuger {
	public static final boolean Debug = true;

	public static void log_e(String msg) {
		if (Debug)
			Log.e("tag", msg);
	}

	public static void log_e(String tag, String msg) {
		if (Debug)
			Log.e(tag, msg);
	}

	public static void log_v(String msg) {
		if (Debug)
			Log.v("tag", msg);
	}

	public static void log_v(String tag, String msg) {
		if (Debug)
			Log.v(tag, msg);
	}

	public static void log_d(String msg) {
		if (Debug)
			Log.d("tag", msg);
	}

	public static void log_d(String tag, String msg) {
		if (Debug)
			Log.e(tag, msg);
	}

	public static void log_i(String msg) {
		if (Debug)
			Log.i("tag", msg);
	}

	public static void log_i(String tag, String msg) {
		if (Debug)
			Log.i(tag, msg);
	}

	public static void log_w(String msg) {
		if (Debug)
			Log.w("tag", msg);
	}

	public static void log_w(String tag, String msg) {
		if (Debug)
			Log.w(tag, msg);
	}

	public static void log_w(String tag, String... params) {
		if (Debug)
			for (String s : params)
				Log.w(tag, s+",");
	}

	public static void showToastLong(Context ctx, String msg) {
		if (Debug)
			Toast.makeText(ctx, msg, Toast.LENGTH_LONG).show();
	}

	public static void showToastShort(Context ctx, String msg) {
		if (Debug)
			Toast.makeText(ctx, msg, Toast.LENGTH_SHORT).show();
	}

}
