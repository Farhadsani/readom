package com.shitouren.citystate;

import com.shitouren.qmap.R;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.PopupWindow;

public class IndexActivity extends Activity {
	private PopupWindow popupWindow;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.index_activity);

		findViewById(R.id.tv).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				pop_Input(); 
			}
		});
	}

	public void pop_Input() {
		View view = View.inflate(this, R.layout.pop_window, null);
		WindowManager window = (WindowManager) this.getSystemService(Context.WINDOW_SERVICE);
		int screenwith = window.getDefaultDisplay().getWidth();
		int screenHeight = window.getDefaultDisplay().getHeight();

		popupWindow = new PopupWindow(view, screenwith, screenHeight * 4 / 5);
		popupWindow.setFocusable(true);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
	}

}
