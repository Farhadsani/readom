package com.shitouren.parser;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.view.View;

public abstract class BaseParser<T> {

	public abstract T parseJSON(String paramString,Context ctx) throws JSONException;

	/**
	 * 
	 * @param res
	 * @throws JSONException
	 */
	public boolean checkResponse(String paramString) throws JSONException {
		if (paramString == null) {
			return false;
		} else {
			JSONObject jsonObject = new JSONObject(paramString);
			String result = jsonObject.getString("msg");
			if (result != null && !result.equals("ok")) {
				return false;
			} else {
				return true;
			}

		}
	}
}
