package com.shitouren.parser;

import java.lang.reflect.Type;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.bean.SquareHot;
import com.shitouren.utils.Debuger;
import com.shitouren.qmap.R;
import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewStub;
import android.widget.TextView;

public class SquareParser extends BaseParser<List<SquareHot>> {

	@Override
	public List<SquareHot> parseJSON(String paramString, Context ctx) throws JSONException {
		JSONObject jsonObject = new JSONObject(paramString);
		boolean result = this.checkResponse(paramString);
		if (!result && !TextUtils.isEmpty(jsonObject.getString("msg"))) {
			Debuger.showToastShort(ctx, jsonObject.getString("msg"));
		}

		String res = jsonObject.optString("res");
		Type type = new TypeToken<List<SquareHot>>() {
		}.getType();
		Gson gson = new Gson();
		List<SquareHot> squareHotList = gson.fromJson(res, type);
		return squareHotList;
	}

}
