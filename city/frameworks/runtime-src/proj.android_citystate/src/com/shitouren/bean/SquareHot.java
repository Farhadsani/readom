package com.shitouren.bean;

import java.util.List;

public class SquareHot {
	private String areaid;
	private String ctime;
	private List<String> imglink;
	private List<String> tags;
	private Integer liked;
	private Integer userid;
	private Integer feedid;
	private Integer likecount;
	private String content;
	private List<String> place;
	private User user;
	private Integer commented;
	private Integer commentscount;
	private boolean isLoad;
	
	public SquareHot(boolean isLoad) {
		this.isLoad = isLoad;
	}

	public boolean isLoad() {
		return isLoad;
	}

	public void setLoad(boolean isLoad) {
		this.isLoad = isLoad;
	}

	public String getAreaid() {
		return areaid;
	}

	public void setAreaid(String areaid) {
		this.areaid = areaid;
	}

	public String getCtime() {
		return ctime;
	}

	public void setCtime(String ctime) {
		this.ctime = ctime;
	}

	public List<String> getImglink() {
		return imglink;
	}

	public void setImglink(List<String> imglink) {
		this.imglink = imglink;
	}

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}

	public Integer getLiked() {
		return liked;
	}

	public void setLiked(Integer liked) {
		this.liked = liked;
	}

	public Integer getUserid() {
		return userid;
	}

	public void setUserid(Integer userid) {
		this.userid = userid;
	}

	public Integer getFeedid() {
		return feedid;
	}

	public void setFeedid(Integer feedid) {
		this.feedid = feedid;
	}

	public Integer getLikecount() {
		return likecount;
	}

	public void setLikecount(Integer likecount) {
		this.likecount = likecount;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public List<String> getPlace() {
		return place;
	}

	public void setPlace(List<String> place) {
		this.place = place;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Integer getCommented() {
		return commented;
	}

	public void setCommented(Integer commented) {
		this.commented = commented;
	}

	public Integer getCommentscount() {
		return commentscount;
	}

	public void setCommentscount(Integer commentscount) {
		this.commentscount = commentscount;
	}

}
