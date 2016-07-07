# For test
# require 'nokogiri'
require 'open-uri'
require 'json'

# "https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"
#doc = Nokogiri::HTML(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"))

data = JSON.load(open("https://yeyak.korea.ac.kr/cop/facilityUniv/facilityUnivUserResView.do?siteId=reservation&facilitySeq=21641&year=2016&month=7&day=9&hourSeq=28463"))

data.each do |x|
    puts x["groupName"] if x["status"] == "OK"
end
