package spring.project.db;

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
	// 음악 전체 리스트 받기
	public List<MusicVO> selectAllMusic(){
		return template.selectList("selectAllMusic");
	}
	//플레이할 music list 받기
	public List<MusicVO> selectMusicsToPlay(String playlist_code){
		return template.selectList("selectMusicsToPlay", playlist_code);
	}
	
}
