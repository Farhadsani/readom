package com.shitouren.city;


import com.shitouren.fragment.MyHelpFragment;
import com.shitouren.fragment.MyMessageFragment;
import com.shitouren.fragment.PetMessageFragment;
import com.shitouren.fragment.SysMessageFragment;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RadioGroup;
import android.widget.TextView;

public class MessageActivity extends FragmentActivity implements OnClickListener {
	

	/**
	 * 四个导航
	 */
	RadioGroup rg_menu;
	private TextView tv_my_message;
	private TextView tv_pet_message;
	private TextView tv_my_help;
	private TextView tv_sys_message;
	
	/** 
     * 页面
     */  
    Fragment myMessage;
    Fragment petMessage;
    Fragment myHelp;
    Fragment sysMessage;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.message_activity);
		//初始化
		initview();
	}


	private void initview() {
		tv_my_message = (TextView) findViewById(R.id.tv_my_message);
		tv_pet_message = (TextView) findViewById(R.id.tv_pet_message);
		tv_my_help = (TextView) findViewById(R.id.tv_my_help);
		tv_sys_message = (TextView) findViewById(R.id.tv_sys_message);
		
		
		tv_my_message.setOnClickListener(this);
		tv_pet_message.setOnClickListener(this);
		tv_my_help.setOnClickListener(this);
		tv_sys_message.setOnClickListener(this);
		//默认的message
		myMessage = new MyMessageFragment();
		getSupportFragmentManager().beginTransaction().replace(R.id.message_content, myMessage).commit();
	}


	//点击进入相应的message
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.tv_my_message:
			myMessage = new MyMessageFragment();
			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, myMessage).commit();
			break;
		case R.id.tv_pet_message:
			petMessage = new PetMessageFragment();
			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, petMessage).commit();
			break;
		case R.id.tv_my_help:
			myHelp = new MyHelpFragment();
			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, myHelp).commit();
			break;
		case R.id.tv_sys_message:
			sysMessage = new SysMessageFragment();
			getSupportFragmentManager().beginTransaction().replace(R.id.message_content, sysMessage).commit();
			break;

		default:
			break;
		}
		
	}



}
