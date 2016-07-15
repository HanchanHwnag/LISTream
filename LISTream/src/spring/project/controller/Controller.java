package spring.project.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import spring.project.db.Dao;
import spring.project.db.GenreVO;
import spring.project.db.MusicVO;
import spring.project.db.Page;
import spring.project.db.UserVO;

@org.springframework.stereotype.Controller
public class Controller {
	private Dao dao;
	private Page page;
	
	public Dao getDao() { return dao; }
	public void setDao(Dao dao) { this.dao = dao; }
	public Page getPage() { return page; }
	public void setPage(Page page) { this.page = page; }
	
	// 로그인
	@RequestMapping("login/login.do")
	public ModelAndView login(UserVO vo){
		
		boolean flag = false;
		UserVO result = dao.selectOne(vo);
		if(result != null)
			if(result.getId().equals(vo.getId()) && result.getPwd().equals(vo.getPwd()))
				flag = true;
		
		ModelAndView mv;
		if(flag){
			mv = new ModelAndView("login/login");
			mv.addObject("vo", vo);
		} else {
			mv = new ModelAndView("login/login_form");
			mv.addObject("result", "fail");
		}
		
		return mv;
	}
	// 회원가입 화면
	@RequestMapping("login/register_view.do")
	public ModelAndView register_view(){
		ModelAndView mv = new ModelAndView("login/user_register_user");
		List<UserVO> list = dao.selectAll();
		
		mv.addObject("list", list);
		return mv;
	}
	// 회원 가입
	@RequestMapping("login/register_ok.do")
	public ModelAndView register_ok(UserVO vo){
		dao.insertOne(vo);
		return new ModelAndView("login/login_form");
	}
	// 장르 데이터
	@RequestMapping(value="login/genre.do", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	public ModelAndView genre_ok(HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView("login/genre_list");
		List<GenreVO> genre = dao.selectGenre();
		String result = "";
		
		response.setContentType("text/html; charset=utf-8");
		
		for(int i=0; i<genre.size(); i++){
			result += genre.get(i).getGenre_code() + ",";
			result += genre.get(i).getGenre_name();
			
			if(i != genre.size() -1)
				result += "/";
		}
		
		mv.addObject("result", result);
		return mv;
	}
	@RequestMapping("login/music_view.do")
	public ModelAndView music_view(){
		return new ModelAndView("admin/admin_register_music");
	}
	// 음악 등록
	@RequestMapping("login/register_music.do")
	public ModelAndView register_music(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		final String filePath = "/upload/";
		System.out.println(filePath);
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
		Iterator<String> itr = multipartHttpServletRequest.getFileNames();
		
		MultipartFile multipartFile = null;
		String fileName = null;
		File file = null;
		MusicVO mvo = null;
		
		while(itr.hasNext()){
			multipartFile = multipartHttpServletRequest.getFile(itr.next());
			
			mvo = new MusicVO();
			
			if(multipartFile.isEmpty() == false){
				fileName = multipartFile.getOriginalFilename();
				file = new File(filePath + fileName);
				multipartFile.transferTo(file); // 파일 업로드
				
				mvo.setArtist(multipartHttpServletRequest.getParameter("artist"));
				mvo.setMusic_title(multipartHttpServletRequest.getParameter("music_title"));
				mvo.setPath(filePath + fileName);
				mvo.setGenre_code(multipartHttpServletRequest.getParameter("genre_code"));		
				
				dao.insertMusic(mvo);
			}
		}
		
		return new ModelAndView("admin/admin_register_music");
	}
	// 회원 관리 페이지
	@RequestMapping("login/user_list_view.do")
	public ModelAndView user_list(HttpServletRequest request) throws Exception{
		request.setCharacterEncoding("utf-8");
		ModelAndView mv = new ModelAndView("admin/admin_manage_user");
		
		List<UserVO> list = null;
		String cPage = request.getParameter("cPage");
		String id = request.getParameter("id");
		if(cPage != null)
			page.setNowPage(Integer.parseInt(cPage));
		
		if(id != null && !id.trim().equals("")){
			list = dao.searchUser(id);
			page.setTotalRecord(list.size());
			page.setTotalPage();
		} else {
			page.setTotalRecord(dao.userTotalCount());
			page.setTotalPage();
		}
		
		page.setBegin((page.getNowPage()-1)*page.getNumPerPage() + 1);
		page.setEnd(page.getBegin() + page.getNumPerPage() - 1);
		if(page.getEnd() > page.getTotalRecord())
			page.setEnd(page.getTotalRecord());
		
		page.setBeginPage((page.getNowPage()-1)/page.getPagePerBlock()*page.getPagePerBlock() + 1);
		page.setEndPage(page.getBeginPage() + page.getPagePerBlock() - 1);
		if(page.getEndPage() > page.getTotalPage())
			page.setEndPage(page.getTotalPage());
		
		Map<String, Integer> map = new HashMap<>();
		map.put("begin", page.getBegin());
		map.put("end", page.getEnd());
		
		if(list == null)
			list = dao.selectUser(map);

		mv.addObject("page", page);
		mv.addObject("list", list);
		return mv; 
	}
	// 유저 삭제
	@RequestMapping(value="login/delete_user.do", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String delete_user(HttpServletRequest request){
		String[] str = request.getParameterValues("del_arr[]");
		for(String k : str)
			dao.deleteUser(k);
		
		int totalCount = dao.userTotalCount();
		String res = "null";
		if(totalCount != 0 && totalCount % page.getNumPerPage() == 0){
			res = "true";
		}

		return res;
	}
	/*---------------------------------------------------------------------------------------------*/
	// 음악 검색
	@RequestMapping(value="search_music.do", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public ModelAndView search_music(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("music/music_list");
		String str = request.getParameter("search");
		
		List<MusicVO> list = dao.searchMusic(str);
		String result = "[";
		
		int idx = 0;
		for(MusicVO mvo : list){
			idx++;
			result += "{";
			result += "\"music_title\" : \"" + mvo.getMusic_title() + "\"";
			result += "}";
			if(idx != list.size())
				result += ",";
		}
		
		result += "]";
		
		mv.addObject("result", result);
		
		return mv;
	}
}
