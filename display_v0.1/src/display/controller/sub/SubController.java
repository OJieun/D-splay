package display.controller.sub;

import java.io.StringReader;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import display.dataLoader.DataLoader;
import display.model.main.MainService;
import display.model.main.PerformInfoVO;
import display.view.AjaxResponseXMLView;

@Controller
public class SubController {
	private String xmlView = "ajaxResponseXMLView";
	private AjaxResponseXMLView ajaxResponseXMLView;

	private MainService mService;
	private DataLoader dataLoader;

	@Autowired
	public void setAjaxResponseXMLView(AjaxResponseXMLView ajaxResponseXMLView) {
		this.ajaxResponseXMLView = ajaxResponseXMLView;
	}

	@Autowired
	public void DataLoader(DataLoader dataLoader) {
		this.dataLoader = dataLoader;
	}
	
	@Autowired
	public SubController(MainService mService) {
		this.mService = mService;
	}

	@RequestMapping("/list.do")
	public ModelAndView list(HttpServletRequest request) throws Exception {
		ModelAndView mv = null;

		String genre = request.getParameter("select_genre");
		String subway = request.getParameter("station_search_key");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String longitude = request.getParameter("longitude");
		String latitude = request.getParameter("latitude");

		System.out.println(genre + " " + subway + " " + startDate + " "
				+ endDate + " " + longitude + " " + latitude);

		// 전철역 위경도를 기반으로 반경 2km의 위경도 정보 받아오기
		Map<String, Number> map = dataLoader.calculate_distance(Double.parseDouble(latitude), Double.parseDouble(longitude));

		String temp = null;

		if (genre.equals("연극"))
			temp = "A000";
		if (genre.equals("음악"))
			temp = "B000";
		if (genre.equals("무용"))
			temp = "C000";
		if (genre.equals("미술"))
			temp = "D000";
		if (genre.equals("뮤지컬"))
			temp = "M000";
		if (genre.equals("기타"))
			temp = "L000";

		System.out.println(genre + temp);

		String parameter = "";
		parameter += "&" + "sido=" + URLEncoder.encode("서울", "UTF-8");
		parameter += "&" + "cPage=1";
		parameter += "&" + "rows=50";
		parameter += "&" + "from=" + URLEncoder.encode(startDate, "UTF-8"); // 시작기간
		parameter += "&" + "to=" + URLEncoder.encode(endDate, "UTF-8"); // 종료기간
		parameter += "&" + "realmCode=" + temp; // 분류코드
		parameter += "&" + "gpsxfrom=" + map.get("minLong"); // 경도 하한
		parameter += "&" + "gpsyfrom=" + map.get("minLat"); // 위도 하한
		parameter += "&" + "gpsxto=" + map.get("maxLong"); // 경도 상한
		parameter += "&" + "gpsyto=" + map.get("maxLat"); // 위도 상한

		String data = "";
		String searchBy = "publicperformancedisplays/realm";

		try {
			data = dataLoader.restClient(parameter, searchBy);
			mv = parsingXml(data);
			System.out.println(data);
		} catch (Exception e) {
			System.out.println("list page-search by name error");
			e.printStackTrace();
		}
		request.setAttribute("data", data);

		mv.addObject("genre", genre);

		return mv;
	}

	public ModelAndView parsingXml(String data) {
		ModelAndView mav = new ModelAndView("/view/list.jsp");
		Document doc = null;
		StringReader sr = new StringReader(data);
		InputSource is = new InputSource(sr);

		List<PerformInfoVO> voList = new ArrayList<PerformInfoVO>();

		int totalCount = 0;
		int count = 0;
		// xml 구조
		/*
		 * <response> <msgBody> <totalCount></totalCount> <perforInfo>
		 * <seq></seq> <title></title> <startDate></startDate>
		 * <endDate></endDate> <place></place> <thumbnail></thumbnail>
		 * </perforInfo> </msgBody> </response>
		 */

		try {
			doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
			NodeList nodeList = doc.getElementsByTagName("msgBody");

			for (int i = 0; i < nodeList.getLength(); i++) {
				for (Node node = nodeList.item(i).getFirstChild(); node != null; node = node.getNextSibling()) {

					// 검색된 전시회 갯수 저장
					if (node.getNodeName().equals("totalCount")) {
						totalCount = Integer.parseInt(node.getTextContent());
					}

					// 각 전시회에 대한 정보
					if (node.getNodeName().equals("perforList")) {
						String seq = null;
						String title = null;
						String startDate = null;
						String endDate = null;
						String place = null;
						String imgUrl = null;
						String realmName = null;
						String area = null;
						for (Node node2 = node.getFirstChild(); node2 != null; node2 = node2.getNextSibling()) {
							if (node2.getNodeName().equals("seq")) {
								System.out.println("1" + node2.getTextContent());
								seq = node2.getTextContent();
							} else if (node2.getNodeName().equals("title")) {
								System.out.println("2" + node2.getTextContent());
								title = node2.getTextContent();
							} else if (node2.getNodeName().equals("startDate")) {
								System.out.println("3" + node2.getTextContent());
								startDate = node2.getTextContent();
							} else if (node2.getNodeName().equals("endDate")) {
								System.out.println("4" + node2.getTextContent());
								endDate = node2.getTextContent();
							} else if (node2.getNodeName().equals("place")) {
								System.out.println("5" + node2.getTextContent());
								place = node2.getTextContent();
							} else if (node2.getNodeName().equals("imgUrl")) {
								System.out.println("6" + node2.getTextContent());
								imgUrl = node2.getTextContent();
							} else if(node2.getNodeName().equals("realmName")){
								System.out.println("7" + node2.getTextContent());
								realmName = node2.getTextContent();
							} else if(node2.getNodeName().equals("area")){
								System.out.println("8" + node2.getTextContent());
								area = node2.getTextContent();

								PerformInfoVO vo = new PerformInfoVO();
								vo.setSeq(Integer.parseInt(seq));
								vo.setTitle(title);
								vo.setEndDate(endDate);
								vo.setStartDate(startDate);
								vo.setPlace(place);
								vo.setThumbnail(imgUrl);
								voList.add(count, vo);
								count++;
							}
						}// node2 for문 끝
					}
				}// node for문 끝
			}// 바깥 for문 끝
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 검색된 전시회 list 저장
		mav.addObject("list", voList);
		mav.addObject("totalCount", totalCount);
		sr.close();

		return mav;
	}

	
	@RequestMapping("/toView.do")
	public ModelAndView toView(@RequestParam("seq") String seq, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView(xmlView);
		String searchBy = "publicperformancedisplays/d/";
		
		String parameter = "";
		parameter += "&" + "seq=" + seq;
		
		try {
			String data = "";
			data = dataLoader.restClient(parameter, searchBy);
			System.out.println(data);
			request.setAttribute("data", data);
		} catch (Exception e) {
			System.out.println("error");
			e.printStackTrace();
		}
		return mv;
	}
	
	@RequestMapping("/view.do")
	public ModelAndView view(@RequestParam("seq") String seq, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("/view/view.jsp");
		
		//request.getRemoteAddr() 사용시 IP가 0:0:0:0:0:0:0:1 로 찍히는문제 - 윈도우 7에서 IPV6값을 리턴.
		//메뉴의 Run -> Run Configurations -> Arguments 탭 -> -Djava.net.preferIPv4Stack=true 추가
		String remoteAdd = request.getRemoteAddr();
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(60);
		Object userInfo =  session.getAttribute("user-"+remoteAdd);
		
		if(userInfo !=null){ //이미 저장된 ip일 때
			if(session.getAttribute("page-"+seq)!=null){ //해당 페이지를 이미 방문했을 때
				mv.addObject("user", "visited");
				System.out.println("저장된 유저, 해당 페이지를 1분 내에 방문하였음.");
			}else{ //해당 페이지는 처음 방문할 때
				session.setAttribute("page-"+seq, "saved");
				session.setAttribute("user-"+remoteAdd, "saved");
				System.out.println("저장된 유저, 해당 페이지를 1분 내 최초 방문.");
				mv.addObject("user", "stranger");
			}	
		}else{ //저장되지 않은 ip일 때
			//해당 ip를 세션에 저장하고 1분간 유지시킨다.
			session.setAttribute("page-"+seq, "saved");
			session.setAttribute("user-"+remoteAdd, "saved");
			System.out.println("저장되지 않은 유저. 해당 페이지 첫 방문");
			mv.addObject("user", "stranger");
		}
		
		String searchBy = "publicperformancedisplays/d/";
		
		String parameter = "";
		parameter += "&" + "seq=" + seq;
		
		try {
			String data = "";
			data = dataLoader.restClient(parameter, searchBy);
			System.out.println(data);
			request.setAttribute("data", data);
		} catch (Exception e) {
			System.out.println("error");
			e.printStackTrace();
		}
		return mv;
	}

	@RequestMapping(value="update_hit.do",method=RequestMethod.POST)
	public ModelAndView update_hit(PerformInfoVO vo, HttpServletRequest request){
		ModelAndView mav = new ModelAndView("jsonView");
		mService.update_hit(vo);
		
		return mav;
	}
}
