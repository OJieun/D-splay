package display.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.AbstractView;

@Component
public class AjaxResponseXMLView extends AbstractView {

	@Override
	protected void renderMergedOutputModel(Map map, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		
		//Controller에서 request 객체에 "data"라는 이름으로 attribute를 넘겨주면 그것을 다시 받아 response 객체로 반환
		String data = (String) request.getAttribute("data");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print(data);
	}

}
