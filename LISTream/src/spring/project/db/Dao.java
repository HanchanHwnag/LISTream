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
	
	public UserVO selectOne(UserVO vo){
		return template.selectOne("selectOne", vo.getId());
	}
	
	public void insertOne(UserVO vo){
		template.insert("insertOne", vo);
	}
	
	public List<GenreVO> selectGenre(){
		return template.selectList("selectGenre");
	}
	
	public void insertMusic(MusicVO mvo){
		template.insert("insertMusic", mvo);
	}
	
	public int userTotalCount(){
		return template.selectOne("userTotalCount");
	}
	
	public List<UserVO> selectUser(Map<String, Integer> map){
		return template.selectList("selectUser", map);
	}
	
	public void deleteUser(String str){
		template.delete("deleteUser", str);
	}
}
