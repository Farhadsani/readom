package com.shitouren.citystate;

import com.shitouren.qmap.R;
import com.shitouren.utils.Debuger;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

public class PubishActivity extends Activity {
	private static final String TAG = "PubishActivity";
	private int FROM_TAG_ID = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.publish_activity);
		Debuger.log_w(TAG, "onCreate");
		
		findViewById(R.id.tvBack).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				MainActivity.setTabItem(FROM_TAG_ID);
			}
		});

	}

	@Override
	protected void onStart() {
		
		Debuger.log_w(TAG, "onStart");
		
		super.onStart();
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		Debuger.log_w(TAG, "onResume");
		Intent intent = getIntent();
		FROM_TAG_ID = intent.getIntExtra("tagid", 0);
		super.onResume();
	}

	@Override
	protected void onRestart() {
		// TODO Auto-generated method stub
		Debuger.log_w(TAG, "onRestart");
		super.onRestart();
	}
	@Override
	protected void onNewIntent(Intent intent) {
		// TODO Auto-generated method stub
		Debuger.log_w(TAG, "onNewIntent");
		super.onNewIntent(intent);
	}

}
