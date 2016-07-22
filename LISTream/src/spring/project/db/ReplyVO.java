package spring.project.db;

public class ReplyVO {
	private String id, user_info_code, reply_code, content, regdate, playlist_code;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUser_info_code() {
		return user_info_code;
	}
	public void setUser_info_code(String user_info_code) {
		this.user_info_code = user_info_code;
	}
	public String getReply_code() {
		return reply_code;
	}
	public void setReply_code(String reply_code) {
		this.reply_code = reply_code;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getPlaylist_code() {
		return playlist_code;
	}
	public void setPlaylist_code(String playlist_code) {
		this.playlist_code = playlist_code;
	}
}
