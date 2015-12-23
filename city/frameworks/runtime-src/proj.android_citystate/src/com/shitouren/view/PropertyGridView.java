package com.shitouren.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.GridView;

public class PropertyGridView extends GridView {
	
	public PropertyGridView(Context context) {
		super(context);
	}
	
	public PropertyGridView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}
	
	public PropertyGridView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}
	
	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
				MeasureSpec.AT_MOST);
		super.onMeasure(widthMeasureSpec, expandSpec);
	}
}
