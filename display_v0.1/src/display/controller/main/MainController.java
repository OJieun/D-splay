package display.controller.main;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MainController {
	@RequestMapping("/main.do")
	public ModelAndView main(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/view/main.jsp");
		return mav;
	}
}