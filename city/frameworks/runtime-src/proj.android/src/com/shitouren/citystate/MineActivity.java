package com.shitouren.citystate;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import com.shitouren.qmap.R;
public class MineActivity extends Activity implements OnClickListener {
	
	private ImageButton ib_login;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_activity);
		ib_login = (ImageButton) findViewById(R.id.ib_login);
		ib_login.setOnClickListener(this);
	}
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.ib_login:
			startActivity(new Intent(MineActivity.this, LoginActivity.class));
			break;

		default:
			break;
		}
		
	}

}
