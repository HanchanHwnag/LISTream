package com.one.db;

import org.springframework.jdbc.core.JdbcTemplate;

public class DAO {
	private JdbcTemplate template;

	public JdbcTemplate getTemplate() {
		return template;
	}

	public void setTemplate(JdbcTemplate template) {
		this.template = template;
	}
}
