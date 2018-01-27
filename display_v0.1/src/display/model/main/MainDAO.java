package display.model.main;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.stereotype.Repository;


@Repository
public class MainDAO {
	private SqlMapClientTemplate ibatisTemplate;
	
	@Autowired
	public void setIbatisTemplate(SqlMapClientTemplate ibatisTemplate) {
		this.ibatisTemplate = ibatisTemplate;
	}

	public void update_hit(int seq) {
		ibatisTemplate.update("updateHit", seq);
	}

	public PerformInfoVO getHitInfo(int seq) {
		return (PerformInfoVO) ibatisTemplate.queryForObject("getHitInfo", seq);
	}

	public void insert_hit(PerformInfoVO vo) {
		ibatisTemplate.insert("insertHit", vo);
	}
}
