package com.shitouren.app;

import org.apache.http.client.CookieStore;

import android.app.Application;

public class GlobleApplication extends Application {
	public static boolean first = true;
	public static String shitouren_check = "";
	public static String shitouren_verify = "";
	
	public static CookieStore cookieStore;
}
