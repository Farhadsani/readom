package com.shitouren.city.mine;

import com.shitouren.citystate.LoginActivity;
import com.shitouren.citystate.R;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.TextView;

public class MineActivity extends Activity implements OnClickListener {
	
	private ImageButton ib_login;
	TextView ibWithChengBang,ibWithFriend,ibWithPersonalDynamic,ibWithPersonalEditor,
	ibWithBaseData,ibWithFriendTrends,ibWithPropaganda;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mine_activity);
		ib_login = (ImageButton) findViewById(R.id.ib_login);
		ibWithChengBang = (TextView) findViewById(R.id.ibWithChengBang);
		ibWithFriend = (TextView) findViewById(R.id.ibWithFriend);
		ibWithPersonalDynamic = (TextView) findViewById(R.id.ibWithPersonalDynamic);
		ibWithPersonalEditor = (TextView) findViewById(R.id.ibWithPersonalEditor);
		ibWithBaseData = (TextView) findViewById(R.id.ibWithBaseData);
		ibWithFriendTrends = (TextView) findViewById(R.id.ibWithFriendTrends);
		ibWithPropaganda = (TextView) findViewById(R.id.ibWithPropaganda);
		
		
		
		
		ib_login.setOnClickListener(this);
		ibWithChengBang.setOnClickListener(this);
		ibWithFriend.setOnClickListener(this);
		ibWithPersonalDynamic.setOnClickListener(this);
		ibWithPersonalEditor.setOnClickListener(this);
		ibWithBaseData.setOnClickListener(this);
		ibWithFriendTrends.setOnClickListener(this);
		ibWithPropaganda.setOnClickListener(this);
	}
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.ib_login:
			startActivity(new Intent(MineActivity.this, LoginActivity.class));
			break;
		case R.id.ibWithChengBang:
			startActivity(new Intent(MineActivity.this, WithCityActivity.class));
			break;
		case R.id.ibWithFriend:
			startActivity(new Intent(MineActivity.this, WithGoodFriendActivity.class));
			
			break;
		case R.id.ibWithPersonalDynamic:
			startActivity(new Intent(MineActivity.this, PersonalDynamicActivity.class));
			break;
		case R.id.ibWithPersonalEditor:
			startActivity(new Intent(MineActivity.this, PersonalEditorActivity.class));
			break;
		case R.id.ibWithBaseData:
			startActivity(new Intent(MineActivity.this, BaseDataActivity.class));
			break;
		case R.id.ibWithFriendTrends:
			
			break;
		case R.id.ibWithPropaganda:
			
			break;

		default:
			break;
		}
		
	}

}
