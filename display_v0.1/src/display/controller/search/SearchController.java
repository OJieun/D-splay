package display.controller.search;

import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;


import display.dataLoader.DataLoader;
import display.view.AjaxResponseXMLView;

@Controller
public class SearchController {
	private String xmlView = "ajaxResponseXMLView";
	private AjaxResponseXMLView ajaxResponseXMLView;
	
	private DataLoader dataLoader;
	
	@Autowired
	public void setAjaxResponseXMLView(AjaxResponseXMLView ajaxResponseXMLView) {
		this.ajaxResponseXMLView = ajaxResponseXMLView;
	}
	 
	@Autowired
	public void DataLoader(DataLoader dataLoader) {
		this.dataLoader = dataLoader;
	}
	
	//전철역 위도 경도를 중심으로 2km 반경의 전시회 받아오기
	@RequestMapping("/search_by_location.do")
	public ModelAndView search_by_location(@RequestParam("longitude") String longitude, @RequestParam("latitude") String latitude, HttpServletRequest request) throws UnsupportedEncodingException{
		ModelAndView mav = new ModelAndView(xmlView);
		System.out.println("Controller-search_by_location.do 전철역 위도 경도 : "+latitude+","+longitude);
		Map<String, Number> map = dataLoader.calculate_distance(Double.parseDouble(latitude),Double.parseDouble(longitude));
		
		String searchBy = "publicperformancedisplays/realm";
		
		String parameter="";
		parameter+="&" + "sido="+URLEncoder.encode("서울", "UTF-8");
		parameter+="&" + "cPage=1";
		parameter+="&" + "rows=100";
		parameter+="&" + "gpsxfrom="+map.get("minLong"); //경도 하한
		parameter+="&" + "gpsyfrom="+map.get("minLat"); //위도 하한
		parameter+="&" + "gpsxto="+map.get("maxLong"); //경도 상한
		parameter+="&" + "gpsyto="+map.get("maxLat"); //위도 상한
		
		String data="";
		
		try {
			data = dataLoader.restClient(parameter, searchBy);
			System.out.println(data);
		} catch (Exception e) {
			System.out.println("search page-search by station error");
			e.printStackTrace();
		}
		request.setAttribute("data", data);
		return mav;
	}
	

	//전시회 이름을 기반으로 검색하여 전시회 받아오기
	@RequestMapping("/search_name.do")
	public ModelAndView searchName(@RequestParam("keyword") String key, HttpServletRequest request) throws Exception{
		ModelAndView mav = new ModelAndView(xmlView);
		System.out.println("Controller-search_name.do : "+key);
		
		String searchBy = "publicperformancedisplays/realm";
		String parameter="";
		parameter+="&" + "sido="+URLEncoder.encode("서울", "UTF-8");
		parameter+="&" + "cPage=1";
		parameter+="&" + "rows=100";
		parameter+="&" + "keyword="+URLEncoder.encode(key, "UTF-8");
		
		String data="";
		
		try {
			data = dataLoader.restClient(parameter, searchBy);
			System.out.println(data);
		} catch (Exception e) {
			System.out.println("search page-search by name error");
			e.printStackTrace();
		}
		request.setAttribute("data", data);
		return mav;
	}
	
	@RequestMapping("/search.do")
	public ModelAndView searchPage(HttpServletRequest request){
		ModelAndView mav = new ModelAndView("/view/search.jsp");
		return mav;
	}
	

	
	@RequestMapping("/place.do")
	public ModelAndView placePopup(HttpServletRequest request){
		ModelAndView mav = new ModelAndView("/view/place.jsp");
		String seq = request.getParameter("seq");
		String searchBy = "publicperformancedisplays/d/";
		String parameter="";
		parameter += "&"+"seq="+seq;
		
		Document doc = null;
		
		String data="";
		try {
			data = dataLoader.restClient(parameter, searchBy);
			System.out.println(data);
			
			StringReader sr = new StringReader(data);
			InputSource is = new InputSource(sr);
			
			//xml 구조
/*			<response>
				<msgBody>
					<perforInfo>
						<placeUrl></placeUrl>
						<placeAddr></placeUrl>
						<gpsX></gpsX>
						<gpsY></gpsY>
					</perforInfo>
				</msgBody>
			</response>*/
			
			doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
			NodeList nodeList = doc.getElementsByTagName("msgBody");

			for(int i=0; i<nodeList.getLength(); i++){
				for(Node node = nodeList.item(i).getFirstChild(); node!=null; node=node.getNextSibling()){
					if(node.getNodeName().equals("perforInfo")){
						for(Node node2 = node.getFirstChild(); node2 != null; node2=node2.getNextSibling()){
							if(node2.getNodeName().equals("placeUrl")){
								mav.addObject("placeUrl", node2.getTextContent());
							}else if(node2.getNodeName().equals("placeAddr")){
								mav.addObject("placeAddr", node2.getTextContent());
							}else if(node2.getNodeName().equals("gpsX")){
								mav.addObject("gpsX", node2.getTextContent());
							}else if(node2.getNodeName().equals("gpsY")){
								mav.addObject("gpsY", node2.getTextContent());
							}else if(node2.getNodeName().equals("title")){
								mav.addObject("title", node2.getTextContent());
							}else if(node2.getNodeName().equals("place")){
								mav.addObject("place", node2.getTextContent());
							}
						}
					}
				}
			}
			
		sr.close();
			
		} catch (Exception e) {
			System.out.println("place pop-up window Data Load error");
			e.printStackTrace();
		}

		return mav;
	}
	
}