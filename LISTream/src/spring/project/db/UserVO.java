package spring.project.db;

public class UserVO {
	private String user_info_code, id, pwd, name, email, r_num;

	public String getUser_info_code() {
		return user_info_code;
	}
	public void setUser_info_code(String user_info_code) {
		this.user_info_code = user_info_code;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getR_num() {
		return r_num;
	}
	public void setR_num(String r_num) {
		this.r_num = r_num;
	}
}
