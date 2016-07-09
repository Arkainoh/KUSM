require 'nokogiri'
require 'open-uri'
require 'json'

# time slot 뽑아내는 URL
# https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000

doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&id=reservation_020300000000&deptSeq=7196&year=#{ARGV[0]}&month=#{ARGV[1]}&facilitySeq=21641"))
    # https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000 -> 최근 달만 가져오기
doc.css(".bg_yeyak5//a").each do |x|
	# puts x.inner_text if x.inner_text.include?("GIF")
	# puts x.inner_text
	sampleString = x.attr("onclick") 
    # 여기에 regex 추가!
    
    sampleString = sampleString.sub!(/^jf_resView\('/,"")
    sampleString = sampleString.sub!(/','N'\);$/,"")
    
    extractedDataArr = sampleString.split('_')
    
    year_info = extractedDataArr[0]
    month_info = extractedDataArr[1]
    day_info = extractedDataArr[2]
    hourSeq_info = extractedDataArr[3]
    # sample data:
    # jf_resView('2016_7_7_28471','N');
    # jf_resView('2016_7_8_28462','N');
    
    
    data = JSON.load(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=#{year_info}&month=#{month_info}&day=#{day_info}&hourSeq=#{hourSeq_info}"))
    
    data.each do |y|
        # puts y["groupName"] if y["status"] == "OK"
        # sample data
        # "userSeq":667320,"userId":"kimjw0703","userName":"김재원","groupName":"데몽재원","resDay":"2016-07-08","hourStr":"12:00 ~ 13:00","preNum":"0","totalNum":"0","monthCnt":"1","regDate":"2016-06-21 16:14","status":"OK"
        
        # attr list
        
        # y["userId"]
        # y["userName"]
        # y["groupName"]
        # y["resDay"]
        # y["hourStr"]
        # y["preNum"]
        # y["totalNum"]
        # y["monthCnt"]
        # y["regDate"]
        # y["status"]
        
        # 모델에 저장하는 부분
=begin
        if y["status"]=="OK"
              
              tuple = Rsvinfo.new
              tuple.userId = y["userId"]
              tuple.userName = y["userName"]
              tuple.groupName = y["groupName"]
              tuple.resDay = y["resDay"]
              tuple.hourStr = y["hourStr"]
              tuple.preNum = y["preNum"]
              tuple.totalNum = y["totalNum"]
              tuple.monthCnt = y["monthCnt"]
              tuple.regDate = y["regDate"]
              tuple.status = y["status"]
              tuple.save
              puts tuple
        end
=end
        puts y
    end
    
end




# "https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"
# doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"))


