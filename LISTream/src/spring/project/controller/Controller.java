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

import javax.jws.WebParam.Mode;
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
import org.springframework.util.SystemPropertyUtils;
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
import spring.project.db.FavoriteVO;
import spring.project.db.GenreVO;
import spring.project.db.MusicVO;
import spring.project.db.Page;
import spring.project.db.PlayListVO;
import spring.project.db.ReplyVO;
import spring.project.db.ThemeVO;
import spring.project.db.UserVO;


//start
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
	@RequestMapping(value={"login/login.do","playerTest/login.do"})
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
			session_id = result.getId();
			session_code = result.getUser_info_code();
		} else {
			mv = new ModelAndView("login/login_form");
			mv.addObject("result", "fail");
		}

		return mv;
	}
	
	//로그아웃
	@RequestMapping(value={"login/logout.do","playerTest/logout.do","admin/logout.do"})
	public ModelAndView logout(HttpSession session){
		session.invalidate();
		session_id=null;
		session_code=null;
		
		
		ModelAndView mv = new ModelAndView("login/login_form");
		
		
		
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
	@RequestMapping(value={"/login/genre.do","/music/genre.do"}, produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	public ModelAndView genre_ok(HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView("login/genre_list");
		List<GenreVO> genre = dao.selectGenre();
		String result = "";

		response.setContentType("text/html; charset=utf-8");

		for (int i = 0; i < genre.size(); i++) {
			result += genre.get(i).getGenre_code() + ",";
			result += genre.get(i).getGenre_name();

			if (i != genre.size() - 1)
				result += "/";
		}
		
		mv.addObject("result", result);
		return mv;
	}

	@RequestMapping("login/music_view.do")
	public ModelAndView music_view() {
		return new ModelAndView("admin/admin_register_music");
	}
	// multiple 음악 자동 등록
	@RequestMapping("login/register_music.do")
	public ModelAndView register_music(HttpServletRequest request) throws Exception {
		List<MusicVO> musicList = dao.selectAllMusic();

		request.setCharacterEncoding("utf-8");
		final String filePath = request.getServletContext().getRealPath("/musics/");
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		List<MultipartFile> multiList =multipartHttpServletRequest.getFiles("files[]");

//		MultipartFile multipartFile = null;
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
					mvo.setPath("../musics/" + fileName);
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
		//해당 플레이리스트의 음악리스트 가져오기
				@RequestMapping(value = "playerTest/select_musics_to_play.do",produces = "text/html;charset=UTF-8", method = RequestMethod.GET)
				@ResponseBody
				public String selectMusicsToPlay(HttpServletRequest request, HttpServletResponse response){
					System.out.println("Controller in");
					String playlist_code = request.getParameter("playlist_code");
					System.out.println("playerlist_code : "+playlist_code);
					List<MusicVO> list =dao.selectMusicsToPlay(playlist_code);
					String result="<div id='listContainer' class='playlistContainer'><ul id='playListContainer'>";
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
					result+="</ul></div><div class='containerPlayer'><div id='playerContainer'><ul class='controls'><div class='audioDetails'><span class='songPlay'></span> <span data-attr='timer' class='audioTime'></span></div><li><a href='#' class='shuffle shuffleActive' data-attr='shuffled'></a></li><li><a href='#' class='left' data-attr='prevAudio'></a></li><li><a href='#' id='playPause' class='play' data-attr='playPauseAudio'></a></li><li><a href='#' class='right' data-attr='nextAudio'></a></li><li><a href='#' class='repeat' data-attr='repeatSong'></a></li><li style = 'float:right'><a class='nowplay' onclick='show()'></a></li><div class='volumeControl'><div class='volume volume1'></div><input class='bar' data-attr='rangeVolume' type='range' min='0' max='1' step='0.1' value='0.7' /></div></ul><div class='progress'><div data-attr='seekableTrack' class='seekableTrack'></div><div class='updateProgress'></div></div></div></div>";
					return result;
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
			System.out.println("session_code : " + session_code);
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
		
		
		@RequestMapping("/mymusic/mymusic.do")
		public ModelAndView myMusic(
				@RequestParam(value="user_info_code" ,required = true, defaultValue="2") String user_info_code){		
			
			ModelAndView mv = new ModelAndView("mymusic/playlist");		
		
			Map<String,String> map =new HashMap<>(); 	
			map.put("user_info_code", user_info_code);
			
			List<PlayListVO> list=dao.getPlayList(map);			
			String playlists="<playlists>";		
			for (PlayListVO k : list) {
				playlists+="<playlist>";
				playlists+="<playlist_code>"+k.getPlaylist_code()+"</playlist_code>";
				playlists+="<playlist_title>"+k.getPlaylist_title()+"</playlist_title>";
				playlists+="</playlist>";		
			}			
			
			playlists+="</playlists>";			
			mv.addObject("playlist",playlists);			
			return mv;
		}	
		
		

		@RequestMapping(value={"/mymusic/musiclist.do","/login/getMusiclist.do","/playerTest/getMusiclist.do"})	
		public ModelAndView getMusicList(				
				@RequestParam(value="playlist_code") String playlist_code){
			System.out.println(playlist_code);
		
			Map<String,String> map = new HashMap<>();
		/*	map.put("user_info_code", user_info_code);*/
			map.put("user_info_code", session_code);
			map.put("playlist_code", playlist_code);
			
		
			
			List<MusicVO> list=dao.getMusicList(map);
			System.out.println(list.size());
			String musiclist="<musiclist>";		
			for (MusicVO k : list) {
				musiclist+="<music>";			
				musiclist+="<musiclist_code>"+k.getMusiclist_code()+"</musiclist_code>";
				musiclist+="<music_code>"+k.getMusic_code()+"</music_code>";
				musiclist+="<artist>"+k.getArtist()+"</artist>";
				musiclist+="<music_title>"+k.getMusic_title()+"</music_title>";
				musiclist+="</music>";		
			}		
			musiclist+="</musiclist>";		
			ModelAndView mv=new ModelAndView("mymusic/musiclist");
			mv.addObject("musiclist",musiclist);		
			return mv;
		}
		
		@RequestMapping("/mymusic/getTheme.do")
		public ModelAndView getTheme(){
			List<ThemeVO>list =dao.getThemeList();
			ModelAndView mv=new ModelAndView("mymusic/themelist");
			
			String themelist="<themelist>";
			for (ThemeVO k : list) {
				themelist+="<theme>";
				themelist+="<theme_code>"+k.getTheme_code()+"</theme_code>"; 
				themelist+="<theme_name>"+k.getTheme_name()+"</theme_name>"; 
				themelist+="</theme>";
			}
			themelist+="</themelist>";
			
			mv.addObject("themelist",themelist);	
			return mv;		
		}
		
		@RequestMapping("/mymusic/makePlaylist.do")
		@ResponseBody
		public String makePlaylist(String playlist_title, String theme_code,String user_info_code){
			
			
			/*int result=dao.makePlaylist(user_info_code, playlist_title,theme_code);*/
			int result=dao.makePlaylist(session_code, playlist_title,theme_code);
			String result1=String.valueOf(result);
			
			return result1;
		}
		
		@RequestMapping("/mymusic/deletePlaylist.do")
		@ResponseBody
		public String deletePlaylist(String playlist_code,String user_info_code){
			
		
			Map<String,String> map = new HashMap<>();
			map.put("playlist_code", playlist_code);
			/*map.put("user_info_code", user_info_code);*/
			map.put("user_info_code", session_code);
			int result=dao.deletePlaylist(map);
			String result1=String.valueOf(result);
			return result1;
		}
		
		@RequestMapping("/mymusic/deleteMusiclist.do")
		@ResponseBody
		public String deleteMusic(HttpServletRequest request){
			
			String[] musiclist_codes=request.getParameterValues("musiclist_codes[]");		
			String playlist_code=request.getParameter("playlist_code");
			String user_info_code=request.getParameter("user_info_code");
			
			Map<String,String> map = new HashMap<>();
			map.put("playlist_code", playlist_code);
			map.put("user_info_code", user_info_code);
			int result=0;
			for (int i = 0; i < musiclist_codes.length; i++) {			
			
				map.put("musiclist_code", musiclist_codes[i]);				
				result=dao.deleteMusiclist(map);			
				map.remove("musiclist_code");
			}
			String result1=String.valueOf(result);	
		
			
		/*	ModelAndView mav = new ModelAndView("redirect:musiclist.do?playlist_code="+playlist_code);*/
			return result1;
			}
				
	
	
	
	
		@RequestMapping("/mymusic/getPlaylist.do")
		public ModelAndView getPlaylist(
				@RequestParam(value="user_info_code" ,required = true, defaultValue="2") String user_info_code,
				@RequestParam(value="cPage",required=true,defaultValue="1") String cPage
				){		
			
			
			//////페이징////
			page.setTotalRecord(dao.getTotalPlaylistCount(user_info_code));
			page.setTotalPage();
			page.setBegin((page.getNowPage()-1)*page.getNumPerPage() + 1);
			page.setEnd(page.getBegin() + page.getNumPerPage() - 1);
			if(page.getEnd() > page.getTotalRecord())
				page.setEnd(page.getTotalRecord());		

			page.setBeginPage((page.getNowPage()-1)/page.getPagePerBlock()*page.getPagePerBlock() + 1);
			page.setEndPage(page.getBeginPage() + page.getPagePerBlock() - 1);
			if(page.getEndPage() > page.getTotalPage())
				page.setEndPage(page.getTotalPage());

			//////////페이징	
			
			
			Map<String,String> map = new HashMap<>();
			
			map.put("begin", String.valueOf(page.getBegin()));
			map.put("end", String.valueOf(page.getEnd()));					
			map.put("user_info_code", user_info_code);
			
			
			
			List<PlayListVO> list=dao.getPlayListPaging(map);			
			String playlists="<playlists>";		
			for (PlayListVO k : list) {
				playlists+="<playlist>";
				playlists+="<playlist_code>"+k.getPlaylist_code()+"</playlist_code>";
				playlists+="<playlist_title>"+k.getPlaylist_title()+"</playlist_title>";
				playlists+="</playlist>";		
			}			
			////페이징
			playlists+="<page>";
			playlists+="<beginpage>"+page.getBeginPage()+"</beginpage>";
			playlists+="<endpage>"+page.getEndPage()+"</endpage>";
			playlists+="<pageperblock>"+page.getPagePerBlock()+"</pageperblock>";
			playlists+="<nowpage>"+page.getNowPage()+"</nowpage>";
			playlists+="<totalpage>"+page.getTotalPage()+"</totalpage>";		
			playlists+="</page>";
			////페이징		
			
			playlists+="</playlists>";
			
		
			
			ModelAndView mv = new ModelAndView("mymusic/playlist");	
			mv.addObject("playlist",playlists);			
			return mv;
		}	
		
		//favorite
		

		@RequestMapping(value={"/playerTest/favorite.do","/favorite/favorite.do"})
		public ModelAndView getFavorite(
				@RequestParam(value="user_info_code",required=false,defaultValue="2") String user_info_code,
				@RequestParam(value="cPage", required=false,defaultValue="1") String cPage){
			
			Map<String, String> map = new HashMap<>();
		
			
			page.setNowPage(Integer.parseInt(cPage));		
			page.setTotalRecord(dao.getFavoriteCount(session_code));
			
			page.setTotalPage();
			page.setBegin((page.getNowPage()-1)*page.getNumPerPage() + 1);
			page.setEnd(page.getBegin() + page.getNumPerPage() - 1);
			if(page.getEnd() > page.getTotalRecord())
				page.setEnd(page.getTotalRecord());
			
			page.setBeginPage((page.getNowPage()-1)/page.getPagePerBlock()*page.getPagePerBlock() + 1);
			page.setEndPage(page.getBeginPage() + page.getPagePerBlock() - 1);
			if(page.getEndPage() > page.getTotalPage())
				page.setEndPage(page.getTotalPage());	
			
			map.put("user_info_code", session_code);
			map.put("begin", String.valueOf(page.getBegin()));
			map.put("end", String.valueOf(page.getEnd()));

			List<FavoriteVO> list=dao.getFavorite(map);
			/*
			for (FavoriteVO k : list) {
				System.out.println(k.getFavorite_code());
				System.out.println(k.getName());
				System.out.println(k.getPlaylist_code());
				System.out.println(k.getR_num());
				System.out.println(k.getUser_info_code());
			}	
		 	*/
			
			ModelAndView mv = new ModelAndView("favorite/favorite");
			mv.addObject("favorite",list);
			mv.addObject("page",page);
			return mv;
			
		}

		/* ---------------------------PLAYLIST SEARCH------------------------------ */
		// THEME
		@RequestMapping(value={"playlist/theme.do", "login/theme.do","playerTest/theme.do"})
		public ModelAndView theme_ok(){
			ModelAndView mv = new ModelAndView("playlist/theme_list");
			
			List<ThemeVO> theme = dao.selectTheme();
			
			String result = "[";
			
			int idx = 0;
			for(ThemeVO tvo : theme){
				idx ++;
				result += "{\"theme_code\" : \"" + tvo.getTheme_code() + "\",";
				result += "\"theme_name\" : \"" + tvo.getTheme_name() + "\"}";
				
				if(idx != theme.size())
					result += ",";
			}
			
			result += "]";
			
			mv.addObject("result", result);
			return mv;
		}
		
		@RequestMapping(value={"playlist/searchPlayListView.do", "login/searchPlayListView.do","playerTest/searchPlayListView.do"})
		public ModelAndView searchPlayList(@RequestParam(value="theme",required=false,defaultValue="0") String theme,
											@RequestParam(value="cPage",required=false,defaultValue="1") String cPage){
			ModelAndView mv = new ModelAndView("playlist/search_playlist");
			
			page.setNowPage(Integer.parseInt(cPage));
			System.out.println(cPage);

			Map<String, String> map = new HashMap<>();
			map.put("theme_code", theme);
			
			int totalRecord = dao.selectPlayListByThemeTotalCount(map);
			
			page.setTotalRecord(totalRecord);
			page.setTotalPage();
			
			page.setBegin((page.getNowPage()-1)*page.getNumPerPage() + 1);
			page.setEnd(page.getBegin() + page.getNumPerPage() - 1);
			if(page.getEnd() > page.getTotalRecord())
				page.setEnd(page.getTotalRecord());
			
			page.setBeginPage((page.getNowPage()-1)/page.getPagePerBlock()*page.getPagePerBlock() + 1);
			page.setEndPage(page.getBeginPage() + page.getPagePerBlock() - 1);
			if(page.getEndPage() > page.getTotalPage())
				page.setEndPage(page.getTotalPage());
			
			map.put("begin", String.valueOf(page.getBegin()));
			map.put("end", String.valueOf(page.getEnd()));
			
			List<PlayListVO> list = dao.selectPlayListByTheme(map);
			mv.addObject("theme", theme);
			mv.addObject("page", page);
			mv.addObject("list", list);
			
			return mv;
		}
		// 즐겨찾기에 추가
		@RequestMapping(value={"playlist/favorite_insert.do","login/favorite_insert.do","playerTest/favorite_insert.do"})
		@ResponseBody
		public String favorite_insert(HttpServletRequest request){
			String[] playlist_codes = request.getParameterValues("arr_checked[]");
			String result = "success";

			Map<String, String> map = new HashMap<>();
			for(int i=0; i<playlist_codes.length; i++){
				map.put("playlist_code", playlist_codes[i]);
				map.put("user_info_code", session_code);
				
				dao.insertPlayListInFavorite(map);
			}

			return result;
		}
		
		// 플레이리스트 상세내용
		@RequestMapping(value={"playlist/playlist_detail.do", "login/playlist_detail.do","playerTest/playlist_detail.do"})
		public ModelAndView playlist_detail(@RequestParam(value="playlist_code", required=true) String playlist_code) {
			ModelAndView mv = new ModelAndView("playlist/playlist_detail");
			
			Map<String, String> map = new HashMap<>();
			map.put("playlist_code", playlist_code);
			
			List<MusicVO> list = dao.selectPlayListDetail(map);
			String result = "[";
			
			int idx = 0;
			for(MusicVO mvo : list){
				idx++;
				
				result += "{\"r_num\" : \"" + mvo.getR_num() + "\",";
				result += "\"artist\" : \"" + mvo.getArtist() + "\",";
				result += "\"music_title\" : \"" + mvo.getMusic_title() + "\",";
				result += "\"music_hit\" : \"" + mvo.getMusic_hit() + "\"}";
				
				if(idx != list.size())
					result += ",";
			}
			
			result += "]";
			mv.addObject("result", result);
			
			return mv;
		}
		@RequestMapping("/playerTest/deleteFavorite.do")
		public ModelAndView deleteFavorite(String favorite_code,String cPage,String playlist_code){
			
			Map<String,String> map =new HashMap<>();
			map.put("favorite_code", favorite_code);
			map.put("user_info_code", session_code);
			map.put("playlist_code", playlist_code);
			
			
			dao.deleteFavorite(map);
			
			int totalCount=dao.getFavoriteCount(session_code);
			
			String res = "null";
			String url="redirect:/playerTest/favorite.do?cPage=";
			if (totalCount != 0 && totalCount % page.getNumPerPage() == 0) {
				res = "true";
			}
			if(res.equals("true")){
				 url+=(Integer.parseInt(cPage)-1);
			}else{
				url+=cPage;
			}
			
			ModelAndView mv = new ModelAndView(url);
			return mv;
		}
		/* 댓글 검색 */
		@RequestMapping(value={"login/reply.do", "playlist/reply.do", "playerTest/reply.do"})
		public ModelAndView selectReply(HttpServletRequest request, @RequestParam(value="playlist_code", required=true) String playlist_code) throws Exception{
			request.setCharacterEncoding("utf-8");
			ModelAndView mv = new ModelAndView("playlist/reply_list");
			
			Map<String, String> map = new HashMap<>();
			map.put("playlist_code", playlist_code);

			mv.addObject("result", reply_body(map));
			
			return mv;
		}
		
		@RequestMapping(value={"playlist/reply_write.do", "login/reply_write.do", "playerTest/reply_write.do"})
		public ModelAndView insertReply(HttpServletRequest request) throws Exception{
			request.setCharacterEncoding("utf-8");
			ModelAndView mv = new ModelAndView("playlist/reply_list");
			
			Map<String, String> map = new HashMap<>();
			String content = request.getParameter("content");
			String playlist_code = request.getParameter("playlist_code"); 
			
			System.out.println(content);

			map.put("content", content);
			map.put("playlist_code", playlist_code);
			// 임의
			map.put("user_info_code", session_code);
			dao.insertReply(map);
			
			mv.addObject("result", reply_body(map));
			
			return mv;
		}
		
		@RequestMapping(value={"login/reply_delete.do", "playlist/reply_delete.do","playerTest/reply_delete.do"})
		public ModelAndView deleteReply(HttpServletRequest request) throws Exception {
			request.setCharacterEncoding("utf-8");
			ModelAndView mv = new ModelAndView("playlist/reply_list");
			
			String reply_code = request.getParameter("reply_code");
			String playlist_code = request.getParameter("playlist_code");
			Map<String, String> map = new HashMap<>();
			
			map.put("reply_code", reply_code);
			map.put("playlist_code", playlist_code);
			dao.deleteReply(map);
			
			mv.addObject("result", reply_body(map));
			
			return mv;
		}
		
		public String reply_body(Map<String, String> map){
			List<ReplyVO> list = dao.selectReply(map);
			String result = "[";
			
			ReplyVO rvo;
			for(int i=0; i<list.size(); i++){
				rvo = list.get(i);
				result += "{\"id\" : \"" + rvo.getId() + "\",";
				result += "\"reply_code\" : \"" + rvo.getReply_code() + "\",";
				result += "\"content\" : \"" + rvo.getContent() + "\"}";
				if(i != list.size()-1)
					result += ",";
			}
			result += "]";
			return result;
		}
		
	
}
