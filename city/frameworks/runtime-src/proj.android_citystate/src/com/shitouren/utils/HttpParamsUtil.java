package com.shitouren.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import android.content.Context;
import net.tsz.afinal.http.AjaxParams;

public class HttpParamsUtil {
	public static final int LIMIT = 10;
	public static final int IDX = 1;
			
	public static int incrementLimit(int limit) {
		return limit+LIMIT;
	}
	
	public static int incrementIdx(int idx) {
		return idx+IDX;
	}
	
	//将参数的key和value封装在List<String>里，传进来Context和AjaxParams
	public static AjaxParams getParams(Context context,AjaxParams params,int idx,List<String> lists){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("idx", idx);
		map.put("ver", Utils.getApkVersionName(context));
		
		Map<String,Object> paramsMap = new HashMap<String,Object>();
		for(int i=0;i<lists.size();i = i+2){
			paramsMap.put(lists.get(i), lists.get(i+1));
		}
		JSONObject jsonObject = new JSONObject(paramsMap);
		map.put("params", jsonObject);
		
		JSONObject object = new JSONObject(map);
		
		params.put("postData", object.toString());
		
		return params;
	}
}
