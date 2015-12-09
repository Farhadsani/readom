package com.shitouren.citystate.wxapi;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shitouren.app.AppManager;
import com.shitouren.bean.WXToken;
import com.shitouren.citystate.LoginActivity;
import com.shitouren.citystate.R;
import com.shitouren.entity.Contacts;
import com.shitouren.utils.ActivityUtils;
import com.shitouren.utils.Debuger;
import com.shitouren.utils.HttpParamsUtil;
import com.shitouren.utils.Utils;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.ShowMessageFromWX;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;
import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import net.tsz.afinal.http.AjaxParams;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {
	private static final String TAG = "WXEntryActivity";

	IWXAPI api;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (api == null) {
			api = WXAPIFactory.createWXAPI(this, Contacts.APP_ID, false);
		}
		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		api.handleIntent(intent, this);
	}

//	@Override
//	public void onReq(BaseReq req) {
//		switch (req.getType()) {
//		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
//			goToGetMsg();
//			break;
//		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
//			goToShowMsg((ShowMessageFromWX.Req) req);
//			break;
//		default:
//			break;
//		}
//	}

//	@Override
//	public void onResp(BaseResp resp) {
//		int result = 0;
//
//		switch (resp.errCode) {
//		case BaseResp.ErrCode.ERR_OK:
//			result = R.string.errcode_success;
//			SendAuth.Resp r = (SendAuth.Resp)resp;//这里做一下转型就是
//		    String code = r.code;//这样就拿到了，就可以进行下一步了。
//			SendAuth.Resp rp = (Resp) resp;
////			String code = ((SendAuth.Resp) resp).resultUrl;
//			Debuger.log_w(TAG, rp.resultUrl,rp.expireDate+"",rp.state,rp.token,rp.userName);
//			break;
//		case BaseResp.ErrCode.ERR_USER_CANCEL:
//			result = R.string.errcode_cancel;
//			break;
//		case BaseResp.ErrCode.ERR_AUTH_DENIED:
//			result = R.string.errcode_deny;
//			break;
//		default:
//			result = R.string.errcode_unknown;
//			break;
//		}
//
//		Toast.makeText(this, result, Toast.LENGTH_LONG).show();
//	}

	private void goToGetMsg() {
		// Intent intent = new Intent(this, GetFromWXActivity.class);
		// intent.putExtras(getIntent());
		// startActivity(intent);
		// finish();
		Debuger.showToastLong(this, "goToGetMsg");
	}

	private void goToShowMsg(ShowMessageFromWX.Req showReq) {
		Debuger.showToastLong(this, "goToShowMsg");
		// WXMediaMessage wxMsg = showReq.message;
		// WXAppExtendObject obj = (WXAppExtendObject) wxMsg.mediaObject;
		//
		// StringBuffer msg = new StringBuffer(); // ��֯һ������ʾ����Ϣ����
		// msg.append("description: ");
		// msg.append(wxMsg.description);
		// msg.append("\n");
		// msg.append("extInfo: ");
		// msg.append(obj.extInfo);
		// msg.append("\n");
		// msg.append("filePath: ");
		// msg.append(obj.filePath);
		//
		// Intent intent = new Intent(this, ShowFromWXActivity.class);
		// intent.putExtra(Constants.ShowMsgActivity.STitle, wxMsg.title);
		// intent.putExtra(Constants.ShowMsgActivity.SMessage, msg.toString());
		// intent.putExtra(Constants.ShowMsgActivity.BAThumbData,
		// wxMsg.thumbData);
		// startActivity(intent);
		// finish();
	}

	@Override
	public void onReq(BaseReq arg0) {
		switch (arg0.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			goToGetMsg();
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			goToShowMsg((ShowMessageFromWX.Req) arg0);
			break;
		default:
			break;
		}		
	}

	@Override
	public void onResp(BaseResp arg0) {
		int result = 0;

		switch (arg0.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			result = R.string.errcode_success;
			SendAuth.Resp r = (SendAuth.Resp)arg0;//这里做一下转型就是
		    String code = r.code;//这样就拿到了，就可以进行下一步了。
		    Debuger.log_w(TAG, code);
		    ActivityUtils.startActivityForData(WXEntryActivity.this, LoginActivity.class,code);
		    WXEntryActivity.this.finish();
//		    getAccessTokenAndOpenId(code);
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			result = R.string.errcode_cancel;
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			result = R.string.errcode_deny;
			break;
		default:
			result = R.string.errcode_unknown;
			break;
		}

		Toast.makeText(this, result, Toast.LENGTH_LONG).show();		
	}
	
}