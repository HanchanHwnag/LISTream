package com.one.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.one.db.DAO;
import com.one.db.UserInfoVO;

@Controller
public class MyController {
	private DAO dao;

	public DAO getDao() {
		return dao;
	}

	public void setDao(DAO dao) {
		this.dao = dao;
	}
	
	@RequestMapping("userList.do")
	public ModelAndView list(){
		List<UserInfoVO> list = dao.getUserList();
		ModelAndView mv = new ModelAndView();
		mv.addObject("list", list);
		return mv;
	}
}
