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

import javax.jws.WebParam.Mode;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;

import org.springframework.ui.Model;
import org.springframework.util.SystemPropertyUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import spring.project.db.Dao;
import spring.project.db.GenreVO;
import spring.project.db.MusicVO;
import spring.project.db.Page;
import spring.project.db.PlayListVO;
import spring.project.db.UserVO;

@org.springframework.stereotype.Controller
@SessionAttributes("login_vo")
public class Controller {
	private String session_id;
	private String session_code;
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
			mv.addObject("login_vo", result);
			session_id = result.getId();
			session_code = result.getUser_info_code();
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
	@RequestMapping(value={"/login/genre.do","/music/genre.do"}, produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
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
		final String filePath = request.getServletContext().getRealPath("/upload/");
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
	@RequestMapping(value={"music/search_music.do","login/search_music.do"}, produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	public ModelAndView search_music(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("music/music_list");
		
		String search_text = request.getParameter("search");
		String field = request.getParameter("field");
		String genre = request.getParameter("genre");
		List<MusicVO> list = null;
		
		String result = "[";
		if(search_text != null && search_text.trim() != ""){
			Map<String, String> search_map = new HashMap<>();
			search_map.put("search_text", search_text);
			search_map.put("field", field);
			if(!genre.equals("0")){
				search_map.put("genre", genre);
				list = dao.searchMusicAddGenre(search_map);
			} else {
				list = dao.searchMusic(search_map);
			}
			
			int idx = 0;
			for(MusicVO mvo : list){
				idx++;
				result += "{";
				if(field.equals("music_title"))
					result += "\"search_text\" : \"" + mvo.getMusic_title() + "\"";
				else
					result += "\"search_text\" : \"" + mvo.getArtist() + "\"";
				result += "}";
				if(idx != list.size())
					result += ",";
			}
		}
		result += "]";

		mv.addObject("result", result);
		return mv;
	}
	
	@RequestMapping(value={"music/search_music_view.do", "login/search_music_view.do"})
	public ModelAndView select_music(HttpServletRequest request){
		try {
			request.setCharacterEncoding("utf-8");
		} catch (Exception e) {}
		
		ModelAndView mv = new ModelAndView("music/search_music");
		
		int kind = -1;
		String search_text = request.getParameter("search_text");
		String genre = request.getParameter("genre"); // 필수
		String type = request.getParameter("type"); // 필수
		String cPage = request.getParameter("cPage");
		String playlist_code = request.getParameter("playlist_code");
		if(cPage != null)
			page.setNowPage(Integer.parseInt(cPage));
		else
			page.setNowPage(1);
		
		List<MusicVO> list = null;
		
		Map<String, String> search_map = new HashMap<>();
		search_map.put("field", type);
		
		// search_text O
		if(search_text != null && search_text.trim() != ""){
			search_map.put("search_text", search_text);
			// genre 나머지
			if(genre != null && !genre.trim().equals("0")){
				search_map.put("genre", genre);
				page.setTotalRecord(dao.selectMusicByGenreAndTitleCount(search_map));
				kind = 0;
			} else {
				// genre 전체보기
				page.setTotalRecord(dao.selectMusicByTitleCount(search_map));
				kind = 1;
			}
		} else {
			// search_text X
			if(genre != null && !genre.trim().equals("0")){
				search_map.put("genre", genre);
				page.setTotalRecord(dao.selectMusicByGenreCount(search_map));
				kind = 2;
			} else {
				page.setTotalRecord(dao.selectMusicCount());
				kind = 3;
			}
		}
		page.setTotalPage();
		
		page.setBegin((page.getNowPage()-1)*page.getNumPerPage() + 1);
		page.setEnd(page.getBegin() + page.getNumPerPage() - 1);
		if(page.getEnd() > page.getTotalRecord())
			page.setEnd(page.getTotalRecord());
		
		page.setBeginPage((page.getNowPage()-1)/page.getPagePerBlock()*page.getPagePerBlock() + 1);
		page.setEndPage(page.getBeginPage() + page.getPagePerBlock() - 1);
		if(page.getEndPage() > page.getTotalPage())
			page.setEndPage(page.getTotalPage());
		
		search_map.put("begin", String.valueOf(page.getBegin()));
		search_map.put("end", String.valueOf(page.getEnd()));
		
		switch(kind){
		case 0:
			list = dao.selectMusicByGenreAndTitle(search_map);
			break;
		case 1:
			list = dao.selectMusicByTitle(search_map);
			break;
		case 2:
			list = dao.selectMusicByGenre(search_map);
			break;
		case 3:
			list = dao.selectMusic(search_map);
			break;
		}

		mv.addObject("page", page);
		mv.addObject("list", list);
		mv.addObject("search_text", search_text);
		mv.addObject("genre", genre);
		mv.addObject("type", type);
		mv.addObject("playlist_code", playlist_code);
		return mv;
	}
	
	// 플레이 리스트
	@RequestMapping(value={"music/playlist.do","login/playlist.do"})
	public ModelAndView select_playlist(){
		ModelAndView mv = new ModelAndView("music/playlist_list");
		
		// 임의(수정)
		List<PlayListVO> list = dao.selectPlayList(session_code);
		String result = "[";
		
		int idx = 0;
		for(PlayListVO pvo : list){
			idx++;
			result += "{";
			result += "\"playlist_code\" : \"" + pvo.getPlaylist_code() + "\",";
			result += "\"playlist_title\" : \"" + pvo.getPlaylist_title() + "\",";
			result += "\"user_info_code\" : \"" + pvo.getUser_info_code() + "\",";
			result += "\"hit\" : \"" + pvo.getHit() + "\"";
			result += "}";
			if(idx != list.size())
				result += ",";
		}
		result += "]";
		
		mv.addObject("result", result);
		return mv;
	}
	
	// 플레이리스트 음악 출력
	@RequestMapping(value={"music/playlist_music.do","login/playlist_music.do"})
	public ModelAndView select_musiclist(String playlist_code){
		ModelAndView mv = new ModelAndView("music/playlist_music_list");
		
		Map<String, String> map = new HashMap<>();
		map.put("playlist_code", playlist_code);
		map.put("user_info_code", session_code);
		
		List<MusicVO> list = dao.selectPlayListMusic(map);
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
	
	// MusicList에 삽입 
	@RequestMapping(value={"music/music_insert.do","login/music_insert.do"})
	@ResponseBody
	public String music_insert(HttpServletRequest request){
		String[] music_codes = request.getParameterValues("arr_checked[]");
		String playlist_code = request.getParameter("playlist_code");
		String search_text = request.getParameter("search_text");
		String type = request.getParameter("type");
		String genre = request.getParameter("genre");
		String result = "";

		Map<String, String> map = new HashMap<>();
		for(int i=0; i<music_codes.length; i++){
			map.put("music_code", music_codes[i]);
			map.put("playlist_code", playlist_code);
			
			dao.insertMusicInPlayList(map);
		}
		
		result += "[";
		result += "{\"search_text\":\"" + search_text + "\",";
		result += "\"type\":\"" + type + "\",";
		result += "\"genre\":\"" + genre + "\",";
		result += "\"playlist_code\":\"" + playlist_code + "\"}";
		result += "]";
		
		return result;
	}
}

