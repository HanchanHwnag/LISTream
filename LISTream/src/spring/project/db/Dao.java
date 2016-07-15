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
	public List<MusicVO> searchMusic(String music_title){
		return template.selectList("searchMusic", music_title);
	}
	public List<MusicVO> selectMusic(String music_title){
		return template.selectList("selectMusic", music_title);
	}
}
