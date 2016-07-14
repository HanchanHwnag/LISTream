package com.one.db;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class DAO {
	private JdbcTemplate template;

	public JdbcTemplate getTemplate() {
		return template;
	}

	public void setTemplate(JdbcTemplate template) {
		this.template = template;
	}
	
	public List<UserInfoVO> getUserList(){
		
	String sql="select * from user_info order by user_info_code";
	return template.query(sql, new RowMapper<UserInfoVO>(){

		@Override
		public UserInfoVO mapRow(ResultSet rs, int rownum) throws SQLException {
			UserInfoVO userVO = new UserInfoVO(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5));
			return userVO;
		}
		
	});
	}
}
