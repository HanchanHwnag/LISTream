package spring.project.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class Dao {
	private SqlSessionTemplate template;

	public SqlSessionTemplate getTemplate() {
		return template;
	}
	public void setTemplate(SqlSessionTemplate template) {
		this.template = template;
	}
	
	// 유저 데이터 모두 가져오기
	public List<UserVO> selectAll(){
		return template.selectList("selectAll");
	}
	// 유저 하나 읽어오기
	public UserVO selectOne(UserVO vo){
		return template.selectOne("selectOne", vo.getId());
	}
	// 유저 하나 삽입
	public void insertOne(UserVO vo){
		template.insert("insertOne", vo);
	}
	// 장르 가져오기
	public List<GenreVO> selectGenre(){
		return template.selectList("selectGenre");
	}
	// 음악 삽입
	public void insertMusic(MusicVO mvo){
		template.insert("insertMusic", mvo);
	}
	// 총 유저수
	public int userTotalCount(){
		return template.selectOne("userTotalCount");
	}
	// 해당 유저 검색
	public List<UserVO> selectUser(Map<String, Integer> map){
		return template.selectList("selectUser", map);
	}
	// 유저 삭제
	public void deleteUser(String str){
		template.delete("deleteUser", str);
	}
	// 유저 검색
	public List<UserVO> searchUser(String id){
		return template.selectList("searchUser", id);
	}
	/*---------------------------------------------------------*/
	// 전체 검색
	public int selectMusicCount(){
		return template.selectOne("selectMusicTotalCount");
	}
	public List<MusicVO> selectMusic(Map<String, String> search_map){
		return template.selectList("selectMusic", search_map);
	}
	// ajax 검색(전체 검색, 7개 아래로 검색)
	public List<MusicVO> searchMusic(Map<String, String> search_map){
		return template.selectList("searchMusic", search_map);
	}
	// ajax 검색(전체 검색, 7개 아래로 검색), Genre가 있는 경우
			public List<MusicVO> searchMusicAddGenre(Map<String, String> search_map){
				return template.selectList("searchMusicAddGenre", search_map);
			}
		// 검색어를 이용한 검색
		public int selectMusicByTitleCount(Map<String, String> search_map){
			return template.selectOne("selectMusicByTitleTotalCount", search_map);
		}
		public List<MusicVO> selectMusicByTitle(Map<String, String> search_map){
			return template.selectList("selectMusicByTitle", search_map);
		}
		// 장르를 이용한 검색
		public int selectMusicByGenreCount(Map<String, String> search_map){
			return template.selectOne("selectMusicByGenreTotalCount", search_map);
		}
		public List<MusicVO> selectMusicByGenre(Map<String, String> search_map){
			return template.selectList("selectMusicByGenre", search_map);
		}
		// 장르와 검색어 모두를 이용한 검색
		public int selectMusicByGenreAndTitleCount(Map<String, String> search_map){
			return template.selectOne("selectMusicByGenreAndTitleTotalCount", search_map);
		}
		public List<MusicVO> selectMusicByGenreAndTitle(Map<String, String> search_map){
			return template.selectList("selectMusicByGenreAndTitle", search_map);
		}
		// 플레이리스트_리스트 출력
		public List<PlayListVO> selectPlayList(String user_info_code){
			return template.selectList("selectPlayListList", user_info_code);
		}
		// 플레이리스트_음악 출력
		public List<MusicVO> selectPlayListMusic(Map<String, String> map){
			return template.selectList("selectPlayListMusic", map);
		}
		// 플레이리스트_음악 삽입
		public void insertMusicInPlayList(Map<String, String> map){
			template.insert("insertMusicInPlayList", map);
		}
	// 음악 전체 리스트 받기
	public List<MusicVO> selectAllMusic(){
		return template.selectList("selectAllMusic");
	}
	//플레이할 music list 받기
	public List<MusicVO> selectMusicsToPlay(String playlist_code){
		return template.selectList("selectMusicsToPlay", playlist_code);
	}

	//플레이리스트목록
	public List<PlayListVO> getPlayList(Map<String,String> map){
		List<PlayListVO> list =template.selectList("getPlayList",map);
		return list;
		
	}
	
	//플레이리스트 갯수
	public int getTotalPlaylistCount(String user_info_code){
		int result = template.selectOne("getTotalPlaylistCount",user_info_code);
		return result;
	}

	//플레이리스트당 뮤직리스트
	public List<MusicVO> getMusicList(Map<String,String> map){
		List<MusicVO> list=template.selectList("getMusicList",map);
		return list;
	}
	
	//플레이리스트 만들기
	public int makePlaylist(String user_info_code,String playlist_title,String theme_code){
		Map<String,String> map= new HashMap<>();
		map.put("user_info_code", user_info_code);
		map.put("playlist_title",playlist_title);
		map.put("theme_code", theme_code);
		int result=template.insert("makePlaylist",map);
		return result;
	}
	
	//테마목록가져오기
	public List<ThemeVO> getThemeList(){
		List<ThemeVO> list=template.selectList("getThemeList");
		return list;
	}
	
	//플레이리스트 한개 삭제
	public int deletePlaylist(Map<String, String> map){
		int result=template.delete("deletePlaylist",map);
		return result;
	}
	
	//뮤직삭제
	public int deleteMusiclist(Map<String, String> map){
		int result=template.delete("deleteMusiclist",map);
		return result;
	}
	
	//
	public  List<PlayListVO> getPlayListPaging(Map<String,String> map){
		List<PlayListVO> list = template.selectList("getPlayListPaging",map);
		return list;
	}
	
	//favorite
	public List<FavoriteVO> getFavorite(Map<String,String> map){
		List<FavoriteVO> list=template.selectList("getFavorite",map);
		return list;
	}
	
	public int getFavoriteCount(String user_info_code){
		int result=template.selectOne("getFavoriteCount",user_info_code);
		return result;
	}
	public void deleteFavorite(Map<String,String> map){
		template.delete("deleteFavorite",map);
	}
	//favorite end
	
	/*----------------------------PlayList-----------------------------*/
	// 테마를 검색
	public List<ThemeVO> selectTheme(){
		return template.selectList("selectTheme");
	}
	// 플레이리스트 수 검색
	public int selectPlayListByThemeTotalCount(Map<String, String> map){
		return template.selectOne("selectPlayListByThemeTotalCount", map);
	}
	// 플레이리스트 검색
	public List<PlayListVO> selectPlayListByTheme(Map<String, String> map){
		return template.selectList("selectPlayListByTheme", map);
	}
	// 즐겨찾기에 플레이리스트 삽입
	public void insertPlayListInFavorite(Map<String, String> map){
		template.insert("insertPlayListInFavorite", map);
	}
	// 플레이리스트 상세 내용
	public List<MusicVO> selectPlayListDetail(Map<String, String> map){
		return template.selectList("selectPlayListDetail", map);
	}
	
	
	// Reply 뽑아오기
		public List<ReplyVO> selectReply(Map<String, String> map){
			return template.selectList("selectReply", map);
		}
		// Reply 삽입
		public void insertReply(Map<String, String> map){
			template.insert("insertReply", map);
		}
		// Reply 삭제
		public void deleteReply(Map<String, String> map){
			template.delete("deleteReply", map);
		}
	
}
