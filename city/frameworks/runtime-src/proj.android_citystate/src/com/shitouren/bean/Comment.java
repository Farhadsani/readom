package com.shitouren.bean;

public class Comment {
	private User user;
	private String commentid;
	private String ctime;
	private String comment;
	private Integer userid;
	private Integer feedid;

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

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getCommentid() {
		return commentid;
	}

	public void setCommentid(String commentid) {
		this.commentid = commentid;
	}

	public String getCtime() {
		return ctime;
	}

	public void setCtime(String ctime) {
		this.ctime = ctime;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

}
