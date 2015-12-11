package net.tsz.afinal;

import android.util.Log;

public class Debuger {
	public final static boolean Debug = true;

	public static void logV(String tag, String msg) {
		if (Debug) {
			Log.v(tag, msg);
		}
	}

	public static void logD(String tag, String msg) {
		if (Debug) {
			Log.d(tag, msg);
		}
	}

	public static void logI(String tag, String msg) {
		if (Debug) {
			Log.i(tag, msg);
		}
	}

	public static void logW(String tag, String msg) {
		if (Debug) {
			Log.w(tag, msg);
		}
	}

	public static void logE(String tag, String msg) {
		if (Debug) {
			Log.e(tag, msg);
		}
	}

	public static void logS( String msg) {
		if (Debug) {
			System.out.println(msg);
		}
	}
	
	public static void print(Object o){
		if(Debug){
			System.out.println(o.toString());
		}
	}
}
