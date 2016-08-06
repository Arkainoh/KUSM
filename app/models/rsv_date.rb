require 'nokogiri'
require 'open-uri'

class RsvDate < ActiveRecord::Base
    
    def self.getDate
        doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000"))
     #https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000 -> 최근 달만 가져오기
        return doc.css('table/tbody/tr/td')[5].text.strip
    end
    
    def self.updateDate
        if RsvDate.count >= 1
            RsvDate.delete_all
        end
        a = RsvDate.new
        a.timeStr = RsvDate.getDate
        a.save
    end
end
