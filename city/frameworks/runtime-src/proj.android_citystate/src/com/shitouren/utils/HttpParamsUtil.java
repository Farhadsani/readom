package com.shitouren.utils;

public class HttpParamsUtil {
	public static final int LIMIT = 10;
	public static final int IDX = 1;
			
	public static int incrementLimit(int limit) {
		return limit+LIMIT;
	}
	
	public static int incrementIdx(int idx) {
		return idx+IDX;
	}
}
