package display.dataLoader;

import java.io.InputStream;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.cxf.helpers.IOUtils;
import org.apache.cxf.io.CachedOutputStream;
import org.springframework.stereotype.Component;

@Component
public class DataLoader {
	//공공DB 요청하는 함수
	public String restClient(String parameter, String searchBy) throws Exception{
		String addr = "http://www.culture.go.kr/openapi/rest/"+searchBy+"?ServiceKey=";
		String serviceKey = "YEBGcqUGfFP56s3e2ZfYG38ssoK5pKZ36SfXjz/UVJghXjtpCmm0yPDN+vJVLzd4r8uZtzl1F7vRmiBG5nW0Hg==";
		
		//인증키(서비스키) url인코딩
		serviceKey = URLEncoder.encode(serviceKey, "UTF-8");
		
		//parameter setting
		addr = addr + serviceKey + parameter;
		
		URL url = new URL(addr);
		InputStream in = url.openStream(); 
		CachedOutputStream bos = new CachedOutputStream();
		IOUtils.copy(in, bos);
		in.close();
		bos.close();

		return bos.getOut().toString();
	}
	
	//전철역 위도 경도를 중심으로 반경 2km의 위도 경도 받아오는 함수
	//sLat : station Latitude(전철역 위도) 
	//sLong : station Longitude(전철역 경도)
	public Map<String, Number> calculate_distance(double sLat, double sLong){
		//station 위도 도,분,초
		int slatRad = (int)sLat;
		double slatMin = (int)((sLat-slatRad)*60);
		double slatSec = ((sLat-slatRad)*60-slatMin)*60;
		
		//station 경도 도,분,초
		int slongRad = (int)sLong;
		double slongMin = (int)((sLong-slongRad)*60);
		double slongSec = ((sLong-slongRad)*60-slongMin)*60;
		
		//원하는 위도의 상한 하한 도
		double maxLatMin =  slatMin+1;
		double minLatMin = slatMin-1;
		
		//원하는 경도의 상한 하한 도
		double maxLongMin =  slongMin+1;
		double minLongMin = slongMin-1;
		
		//원하는 위도의 도,분,초를 표기 변경
		double maxLat = slatRad + (maxLatMin/60) + (slatSec/3600);
		double minLat = slatRad + (minLatMin/60) + (slatSec/3600);
		
		//원하는 경도의 도,분,초를 표기 변경
		double maxLong = slongRad + (maxLongMin/60) + (slongSec/3600);
		double minLong = slongRad + (minLongMin/60) + (slongSec/3600);
		
		System.out.println("위도 하한 : "+minLat+", 위도 상한 : "+maxLat+", 경도 하한 : "+ minLong +", 경도 상한 : "+maxLong);
		
		Map<String, Number> map = new HashMap<String, Number>();
		map.put("minLat", minLat); //위도 하한
		map.put("maxLat", maxLat); //위도 상한
		map.put("minLong", minLong); //경도 하한
		map.put("maxLong", maxLong); //경도 상한
		
		return map;
	}
}
