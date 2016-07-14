package com.one.db;

public class UserInfoVO {
	private String user_info_code,id,pwd,name,email;

	public UserInfoVO(){}
	
	public UserInfoVO(String user_info_code, String id, String pwd, String name, String email) {
		super();
		this.user_info_code = user_info_code;
		this.id = id;
		this.pwd = pwd;
		this.name = name;
		this.email = email;
	}

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
}
