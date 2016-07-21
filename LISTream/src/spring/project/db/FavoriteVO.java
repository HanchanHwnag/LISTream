package spring.project.db;

public class FavoriteVO {
	private String r_num,favorite_code,user_info_code,playlist_code,playlist_title,name;

	public String getR_num() {
		return r_num;
	}

	public void setR_num(String r_num) {
		this.r_num = r_num;
	}

	public String getFavorite_code() {
		return favorite_code;
	}

	public void setFavorite_code(String favorite_code) {
		this.favorite_code = favorite_code;
	}

	public String getUser_info_code() {
		return user_info_code;
	}

	public void setUser_info_code(String user_info_code) {
		this.user_info_code = user_info_code;
	}

	public String getPlaylist_code() {
		return playlist_code;
	}

	public void setPlaylist_code(String playlist_code) {
		this.playlist_code = playlist_code;
	}

	public String getPlaylist_title() {
		return playlist_title;
	}

	public void setPlaylist_title(String playlist_title) {
		this.playlist_title = playlist_title;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
