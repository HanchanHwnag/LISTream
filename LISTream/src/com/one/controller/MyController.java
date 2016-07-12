package com.one.controller;

import org.springframework.stereotype.Controller;

import com.one.db.DAO;

@Controller
public class MyController {
	private DAO dao;

	public DAO getDao() {
		return dao;
	}

	public void setDao(DAO dao) {
		this.dao = dao;
	}
}
