package display.model.main;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class MainService {
	private MainDAO dao;
	
	@Autowired
	public void setDao(MainDAO dao) {
		this.dao = dao;
	}
	
	public void update_hit(PerformInfoVO vo){
		PerformInfoVO vo2 = dao.getHitInfo(vo.getSeq());
		if(vo2 == null){ //조횟수 테이블에 해당 공연전시 정보가 없을 경우
			//새 row 입력, 조횟수 1
			dao.insert_hit(vo);
			
		}else{//이미 존재할 경우 조횟수 +1
			dao.update_hit(vo.getSeq());
		}
	}
}
