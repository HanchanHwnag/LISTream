package spring.project.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.UnsupportedAudioFileException;
import javax.sound.sampled.spi.AudioFileReader;

import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.parser.mp3.LyricsHandler;
import org.apache.tika.parser.mp3.Mp3Parser;
import org.apache.tika.sax.BodyContentHandler;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
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
@SessionAttributes("login_vo")
public class Controller {
	private Dao dao;
	private Page page;

	public Dao getDao() {
		return dao;
	}

	public void setDao(Dao dao) {
		this.dao = dao;
	}

	public Page getPage() {
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
	}

	// 로그인
	@RequestMapping("login/login.do")
	public ModelAndView login(UserVO vo) throws Exception{

		boolean flag = false;
		UserVO result = dao.selectOne(vo);
		
		
		if (result != null)
			if (result.getId().equals(vo.getId()) && result.getPwd().equals(vo.getPwd()))
				flag = true;

		ModelAndView mv;
		if (flag) {
			mv = new ModelAndView("login/login");
			mv.addObject("login_vo", result);
			/*mv.addObject("result", result);*/
			
			
		} else {
			mv = new ModelAndView("login/login_form");
			mv.addObject("result", "fail");
		}

		return mv;
	}

	// 회원가입 화면
	@RequestMapping("login/register_view.do")
	public ModelAndView register_view() {
		ModelAndView mv = new ModelAndView("login/user_register_user");
		List<UserVO> list = dao.selectAll();

		mv.addObject("list", list);
		return mv;
	}

	// 회원 가입
	@RequestMapping("login/register_ok.do")
	public ModelAndView register_ok(UserVO vo) {
		dao.insertOne(vo);
		return new ModelAndView("login/login_form");
	}

	// 장르 데이터
	@RequestMapping(value = "login/genre.do", produces = "text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String genre_ok(HttpServletResponse response) throws Exception {

		List<GenreVO> genre = dao.selectGenre();
		String result = "";

		response.setContentType("text/html; charset=utf-8");

		for (int i = 0; i < genre.size(); i++) {
			result += genre.get(i).getGenre_code() + ",";
			result += genre.get(i).getGenre_name();

			if (i != genre.size() - 1)
				result += "/";
		}

		return result;
	}

	@RequestMapping("login/music_view.do")
	public ModelAndView music_view() {
		return new ModelAndView("admin/admin_register_music");
	}

	// 음악 등록
	// @RequestMapping("login/register_music.do")
	// public ModelAndView register_music_jinwon(HttpServletRequest request)
	// throws Exception {
	// request.setCharacterEncoding("utf-8");
	// final String filePath =
	// request.getServletContext().getRealPath("/upload/");
	// MultipartHttpServletRequest multipartHttpServletRequest =
	// (MultipartHttpServletRequest)request;
	// Iterator<String> itr = multipartHttpServletRequest.getFileNames();
	//
	// MultipartFile multipartFile = null;
	// String fileName = null;
	// File file = null;
	// MusicVO mvo = null;
	//
	// while(itr.hasNext()){
	// multipartFile = multipartHttpServletRequest.getFile(itr.next());
	// mvo = new MusicVO();
	//
	// if(multipartFile.isEmpty() == false){
	// fileName = multipartFile.getOriginalFilename();
	// file = new File(filePath + fileName);
	// multipartFile.transferTo(file); // 파일 업로드
	//
	// mvo.setArtist(multipartHttpServletRequest.getParameter("artist"));
	// mvo.setMusic_title(multipartHttpServletRequest.getParameter("music_title"));
	// mvo.setPath(filePath + fileName);
	// mvo.setGenre_code(multipartHttpServletRequest.getParameter("genre_code"));
	//
	// dao.insertMusic(mvo);
	// }
	// }
	//
	// return new ModelAndView("admin/admin_register_music");
	// }
	
	// multiple 음악 자동 등록
	@RequestMapping("login/register_music.do")
	public ModelAndView register_music(HttpServletRequest request) throws Exception {
		List<MusicVO> musicList = dao.selectAllMusic();

		request.setCharacterEncoding("utf-8");
		final String filePath = request.getServletContext().getRealPath("/upload/");
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		List<MultipartFile> multiList =multipartHttpServletRequest.getFiles("files[]");

		MultipartFile multipartFile = null;
		String fileName = null;
		File file = null;
		MusicVO mvo = null;
		String genre_code=multipartHttpServletRequest.getParameter("genre_code");
		
		

			chk:
		for (MultipartFile multiFile : multiList) {
				for (MusicVO musicVO : musicList) {
					if ((filePath + multiFile.getOriginalFilename()).equals(musicVO.getPath())) {	//등록하려는 파일이 기존에 등록된 파일인지 확인
						System.out.println(musicVO.getPath());
						continue chk;
					}
				}
				if (!multiFile.isEmpty()) {		//등록할 파일이 있는지 확인
					mvo = new MusicVO();
					fileName = multiFile.getOriginalFilename();
					file = new File(filePath + fileName);
					System.out.println(filePath+fileName);
					// 파일 업로드
					multiFile.transferTo(file);

					// Get meta data
					BodyContentHandler handler = new BodyContentHandler();
					Metadata metadata = new Metadata();
					FileInputStream inputstream = new FileInputStream(file);
					ParseContext pcontext = new ParseContext();

					// Mp3 parser
					Mp3Parser Mp3Parser = new Mp3Parser();
					Mp3Parser.parse(inputstream, handler, metadata, pcontext);
					LyricsHandler lyrics = new LyricsHandler(inputstream, handler);

					System.out.println("lyric" + lyrics.toString());

					mvo.setArtist(metadata.get("xmpDM:artist"));
					mvo.setMusic_title(metadata.get("title"));
					mvo.setPlaytime(metadata.get("xmpDM:duration"));
					mvo.setPath(filePath + fileName);
					mvo.setGenre_code(genre_code);
					System.out.println(mvo.getArtist()+" "+mvo.getMusic_title()+" "+mvo.getPlaytime()+" "+mvo.getPath()+" "+mvo.getGenre_code()+" ");
					dao.insertMusic(mvo);
				
			}
				
		} 	//End of while:chk

		return new ModelAndView("admin/admin_register_music");
	}

	// 회원 관리 페이지
	@RequestMapping("login/user_list_view.do")
	public ModelAndView user_list(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		ModelAndView mv = new ModelAndView("admin/admin_manage_user");

		List<UserVO> list = null;
		String cPage = request.getParameter("cPage");
		String id = request.getParameter("id");
		if (cPage != null)
			page.setNowPage(Integer.parseInt(cPage));

		if (id != null && !id.trim().equals("")) {
			list = dao.searchUser(id);
			page.setTotalRecord(list.size());
			page.setTotalPage();
		} else {
			page.setTotalRecord(dao.userTotalCount());
			page.setTotalPage();
		}

		page.setBegin((page.getNowPage() - 1) * page.getNumPerPage() + 1);
		page.setEnd(page.getBegin() + page.getNumPerPage() - 1);
		if (page.getEnd() > page.getTotalRecord())
			page.setEnd(page.getTotalRecord());

		page.setBeginPage((page.getNowPage() - 1) / page.getPagePerBlock() * page.getPagePerBlock() + 1);
		page.setEndPage(page.getBeginPage() + page.getPagePerBlock() - 1);
		if (page.getEndPage() > page.getTotalPage())
			page.setEndPage(page.getTotalPage());

		Map<String, Integer> map = new HashMap<>();
		map.put("begin", page.getBegin());
		map.put("end", page.getEnd());

		if (list == null)
			list = dao.selectUser(map);

		mv.addObject("page", page);
		mv.addObject("list", list);
		return mv;
	}

	// 유저 삭제
	@RequestMapping(value = "login/delete_user.do", produces = "text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String delete_user(HttpServletRequest request) {
		String[] str = request.getParameterValues("del_arr[]");
		for (String k : str)
			dao.deleteUser(k);

		int totalCount = dao.userTotalCount();
		String res = "null";
		if (totalCount != 0 && totalCount % page.getNumPerPage() == 0) {
			res = "true";
		}

		return res;
	}

	/*---------------------------------------------------------------------------------------------*/
	// 음악 검색
	@RequestMapping(value = "search_music.do", produces = "text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String search_music(HttpServletRequest request) {
		String str = request.getParameter("search");

		List<MusicVO> list = dao.searchMusic(str);
		String result = "[";

		int idx = 0;
		for (MusicVO mvo : list) {
			idx++;
			result += "{";
			result += "\"music_title\" : \"" + mvo.getMusic_title() + "\"";
			result += "}";
			if (idx != list.size())
				result += ",";
		}

		result += "]";

		return result;
	}
	
	@RequestMapping(value = "playerTest/select_musics_to_play.do",produces = "text/html;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String selectMusicsToPlay(HttpServletRequest request, HttpServletResponse response){
	/*	System.out.println("Controller in");*/
		String playlist_code = request.getParameter("playlist_code");
		List<MusicVO> list =dao.selectMusicsToPlay(playlist_code);
		/*System.out.println("1");*/
		String result="";
		if(list.size()==0||list==null){
			result+="<li data-src='"+"'>재생할 음악이 없습니다</li>";
		}else{
			for (MusicVO k : list) {
				result+="<li data-src='"
						+k.getPath()
						+"'><a href='#'>"
						+k.getMusic_title()
						+"</a></li>";
			}
		}
		System.out.println(result);
		return result;
	}
}


//List<GenreVO> genre = dao.selectGenre();
//String result = "";
//
//response.setContentType("text/html; charset=utf-8");
//
//for (int i = 0; i < genre.size(); i++) {
//	result += genre.get(i).getGenre_code() + ",";
//	result += genre.get(i).getGenre_name();
//
//	if (i != genre.size() - 1)
//		result += "/";
//}
//
//return result;