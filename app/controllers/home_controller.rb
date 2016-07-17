require 'nokogiri'
require 'open-uri'
require 'json'

class HomeController < ApplicationController
  def index
     @yeyak = Rsvinfo.all
     
     first_day = Rsvinfo.all.first #DB table 첫번째 row
     @last_day = Rsvinfo.all.last.resDay.split('-')[2] # DB table 에서 마지막 row의 resDay에서 'day' 부분을 가져옴
     
     @t = first_day.resDay.split('-') #t => ex) ["2016", "07", "01"]
     @now = Time.new.localtime("+09:00") #현재시간 구하기
     
  end
  

  def showDB
    @tuple = Rsvinfo.all
  end
  
  def updateDB
      
      # time slot 뽑아내기
      timeInfo = params[:timeInfo].split('_')
      timeYear = timeInfo[0]
      timeMonth = timeInfo[1]
      if timeMonth.length < 2
        timeMonth = "0" + timeMonth
      end
      
      haha = Rsvinfo.where("resDay like '#{timeYear}-#{timeMonth}%'").take
      if haha != nil
        # records already exist so it does not need to be updated...
        redirect_to "/home/index"
        
      elsif
        # records does not exist so DB will be updated...
          
        doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&id=reservation_020300000000&deptSeq=7196&year=#{timeInfo[0]}&month=#{timeInfo[1]}&facilitySeq=21641"))
        # https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000 -> 최근 달만 가져오기
        doc.css(".bg_yeyak5//a").each do |x|
        	# puts x.inner_text if x.inner_text.include?("GIF")
        	sampleString = x.attr("onclick") 
            
            sampleString = sampleString.sub!(/^jf_resView\('/,"")
            sampleString = sampleString.sub!(/','N'\);$/,"")
            
            extractedDataArr = sampleString.split('_')
            
            year_info = extractedDataArr[0]
            month_info = extractedDataArr[1]
            day_info = extractedDataArr[2]
            hourSeq_info = extractedDataArr[3]
            
            # sample data:
            # jf_resView('2016_7_7_28471','N');
            
            data = JSON.load(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=#{year_info}&month=#{month_info}&day=#{day_info}&hourSeq=#{hourSeq_info}"))
            
            data.each do |y|
                # puts y["groupName"] if y["status"] == "OK"
                
                # sample data
                # "userSeq":667320,"userId":"kimjw0703","userName":"김재원","groupName":"데몽재원","resDay":"2016-07-08","hourStr":"12:00 ~ 13:00","preNum":"0","totalNum":"0","monthCnt":"1","regDate":"2016-06-21 16:14","status":"OK"
                
                # =attr list=
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
                # ============
                
                # Fill the DB
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
    
                end
            end
        end
        puts("updateDB - complete")
        redirect_to "/home/index"
      end
      
  end

  
end
