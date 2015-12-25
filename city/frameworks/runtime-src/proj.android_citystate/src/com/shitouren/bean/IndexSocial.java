package com.shitouren.bean;

import java.io.Serializable;

public class IndexSocial implements Serializable {
	private int major;
	private String cname;
	private String hlimglink;
	private String name;
	private String imglink;
	private String type;
	private int categoryid;
	private int headerid;

	public int getHeaderid() {
		return headerid;
	}

	public void setHeaderid(int headerid) {
		this.headerid = headerid;
	}

	public int getMajor() {
		return major;
	}

	public void setMajor(int major) {
		this.major = major;
	}

	public String getCname() {
		return cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getHlimglink() {
		return hlimglink;
	}

	public void setHlimglink(String hlimglink) {
		this.hlimglink = hlimglink;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getImglink() {
		return imglink;
	}

	public void setImglink(String imglink) {
		this.imglink = imglink;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getCategoryid() {
		return categoryid;
	}

	public void setCategoryid(int categoryid) {
		this.categoryid = categoryid;
	}

}
