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
	
	// ���� ������ ��� ��������
	public List<UserVO> selectAll(){
		return template.selectList("selectAll");
	}
	// ���� �ϳ� �о����
	public UserVO selectOne(UserVO vo){
		return template.selectOne("selectOne", vo.getId());
	}
	// ���� �ϳ� ����
	public void insertOne(UserVO vo){
		template.insert("insertOne", vo);
	}
	// �帣 ��������
	public List<GenreVO> selectGenre(){
		return template.selectList("selectGenre");
	}
	// ���� ����
	public void insertMusic(MusicVO mvo){
		template.insert("insertMusic", mvo);
	}
	// �� ������
	public int userTotalCount(){
		return template.selectOne("userTotalCount");
	}
	// �ش� ���� �˻�
	public List<UserVO> selectUser(Map<String, Integer> map){
		return template.selectList("selectUser", map);
	}
	// ���� ����
	public void deleteUser(String str){
		template.delete("deleteUser", str);
	}
	// ���� �˻�
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
	public MusicListVO getInsert(MusicListVO mlvo) {
		try {
		int result = template.insert("insertMusicList", mlvo);
		if(result > 0){
			template.commit();
		}else{
			template.rollback();
		}
	} catch (Exception e) {
		
	}
	return mlvo;
	}
}
