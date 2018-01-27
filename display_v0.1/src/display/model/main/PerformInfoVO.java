package display.model.main;

public class PerformInfoVO {
	private String title, startDate, endDate, place, thumbnail;
	private int seq;

	public PerformInfoVO(){};
	
	public PerformInfoVO(int seq, String title, String startDate,
			String endDate, String place, String thumbnail) {
		this.seq = seq;
		this.title = title;
		this.startDate = startDate;
		this.endDate = endDate;
		this.place = place;
		this.thumbnail = thumbnail;
	}

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}
	
	
}
