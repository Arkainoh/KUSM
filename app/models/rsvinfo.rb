require 'nokogiri'
require 'open-uri'
require 'json'
class Rsvinfo < ActiveRecord::Base
    has_many :posts
    def self.updateDB arg_year, arg_month
      
      # time slot 뽑아내기
      # timeInfo = params[:timeInfo].split('_')
      timeYear = arg_year.to_s
      timeMonth = arg_month.to_s
      if timeMonth.length < 2
        timeMonth = "0" + timeMonth
      end
      
      haha = Rsvinfo.where("resDay like '#{timeYear}-#{timeMonth}%'").take
      if haha != nil
        # records already exist so it does not need to be updated...
        puts("Data already exists")
        # redirect_to "/home/index"
        return 0
        
      elsif
        # records does not exist so DB will be updated...
        
        doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&id=reservation_020300000000&deptSeq=7196&year=#{arg_year}&month=#{arg_month}&facilitySeq=21641"))
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
                # y["teamName"]
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
                  tuple.teamName = y["groupName"].delete('0-9').delete('!@#$%^&*')
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
        # redirect_to "/home/index"
        RsvDate.updateDate
        return 1
      end
      
    end
    
    def self.teamNames
        @groupNames = []
        Rsvinfo.all.each do |x|
         @groupNames << x.groupName
        end
        
        @groupNames.uniq!
        
        @groupNames.each do |x|
          x.delete!('0-9')
          x.delete!(' ')
          x.downcase!()
          x.delete!('!@#$%^&*')
          x.delete!('fc')
        end
        
        @groupNames.uniq!
        @groupNames.sort!
        
        maxNum = @groupNames.count
        results = [] 
    
        for i in 0..maxNum-1
            if i < maxNum-1
                #다른 문자열과의 비교를 수행한다.
                
                thisName = @groupNames[i]
                otherName = @groupNames[i+1]
                
                thisLength = thisName.length
                otherLength = otherName.length
                minLength = (thisLength > otherLength)? otherLength : thisLength
                
                sameCount = 0
                sameStr = ""
                
                for k in 0.. minLength - 1
                    if thisName[k] == otherName[k]
                        sameCount = sameCount + 1
                        sameStr = sameStr << thisName[k].to_s
                    else break
                    end
                end
                if sameCount >= 2
                    results << sameStr
                end
                
            end
        end
        
        @groupNames.each do |x|
            matches = false
            results.each do |y|
               if x.include? y
                   matches = true
                   break
               end
            end
            
            unless matches
                results << x
            end
        end
        results.uniq!
        return results
    end
    
    def self.updateTeamNames candidateArr
        Rsvinfo.all.each do |x|
            temp1 = x.groupName.downcase.delete(' ')
            candidateArr.each do |y|
                temp2 = y.downcase.delete(' ')
                if temp1.include? temp2
                    x.teamName = y.upcase
                    x.save
                    break
                
                end
                
            end
        end
    
    end
    
    def getRes_year
        fullStr = self.resDay
        splitedStr = fullStr.split('-')
        return splitedStr[0]
    end
    
    def getRes_month
        fullStr = self.resDay
        splitedStr = fullStr.split('-')
        if splitedStr[1].starts_with? '0'
            return splitedStr[1][1..-1] #get substring starting form index 1
        else
            return splitedStr[1]
        end
    end
    
    def getRes_day
        fullStr = self.resDay
        splitedStr = fullStr.split('-')
        if splitedStr[1].starts_with? '0'
            return splitedStr[2][1..-1] #get substring starting form index 1   
        else
            return splitedStr[2]
        end
    end

    def getRes_startTime
        fullStr = self.hourStr
        splitedStr = fullStr.split('~')
        splitedStr[0].delete!(' ')
        
        splitedStr[0].delete!(':00')
        return splitedStr[0] #아직 앞의 0은 없애지 않음 ex) 09:00 -> 09
    end    
end
