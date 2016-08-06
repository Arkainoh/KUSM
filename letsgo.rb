require 'nokogiri'
require 'open-uri'


# time slot 뽑아내는 URL
# https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000

doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000"))
    # https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivList.do?siteId=reservation&deptSeq=7196&id=reservation_020300000000 -> 최근 달만 가져오기
puts doc.css('table/tbody/tr/td')[5].text.strip

#puts a.to_s



# "https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"
# doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"))


